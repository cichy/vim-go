" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

scriptencoding utf-8

function! Test_GetSimpleTextPosition()
    call s:getinfo('lsp text position should align with cursor position after ascii only', 'ascii')
endfunction

function! Test_GetMultiByteTextPosition()
    call s:getinfo('lsp text position should align with cursor position after two place of interest symbols ⌘⌘', 'multi-byte')
endfunction

function! Test_GetMultipleCodeUnitTextPosition()
    call s:getinfo('lsp text position should align with cursor position after Deseret Capital Letter Long I 𐐀', 'multi-code-units')
endfunction

function! s:getinfo(str, name)
  if !go#util#has_job()
    return
  endif

  try
    let g:go_info_mode = 'gopls'

    let l:tmp = gotest#write_file(a:name . '/position/position.gno', [
          \ 'package position',
          \ '',
          \ 'func Example() {',
          \ "\tid := " . '"foo"',
          \ "\tprintln(" .'"' . a:str . '", id)',
          \ '}',
          \ ] )

    let l:expected = 'var id string'
    let l:actual = go#lsp#GetInfo()
    call assert_equal(l:expected, l:actual)
  finally
    call delete(l:tmp, 'rf')
    unlet g:go_info_mode
  endtry
endfunction

func! Test_Format() abort
  try
    let expected = join(readfile("test-fixtures/lsp/fmt/format_golden.gno"), "\n")
    let l:tmp = gotest#load_fixture('lsp/fmt/format.gno')

    call go#lsp#Format()

    " this should now contain the formatted code
    let actual = join(go#util#GetLines(), "\n")

    call assert_equal(expected, actual)
  finally
    call delete(l:tmp, 'rf')
  endtry
endfunc

func! Test_Format_SingleNewline() abort
  try
    let expected = join(readfile("test-fixtures/lsp/fmt/format_golden.gno"), "\n")
    let l:tmp = gotest#load_fixture('lsp/fmt/newline.gno')

    call go#lsp#Format()

    " this should now contain the formatted code
    let actual = join(go#util#GetLines(), "\n")

    call assert_equal(expected, actual)
  finally
    call delete(l:tmp, 'rf')
  endtry
endfunc

func! Test_Imports() abort
  try
    let expected = join(readfile("test-fixtures/lsp/imports/imports_golden.gno"), "\n")
    let l:tmp = gotest#load_fixture('lsp/imports/imports.gno')

    call go#lsp#Imports()

    " this should now contain the expected imports code
    let actual = join(go#util#GetLines(), "\n")

    call assert_equal(expected, actual)
  finally
    call delete(l:tmp, 'rf')
  endtry
endfunc

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
