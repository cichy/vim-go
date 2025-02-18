" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

func! Test_fillstruct() abort
  try
    let g:go_fillstruct_mode = 'fillstruct'
    let l:tmp = gotest#write_file('a/a.gno', [
          \ 'package a',
          \ 'import "net/mail"',
          \ "var addr = mail.\x1fAddress{}"])

    call go#fillstruct#FillStruct()
    call gotest#assert_buffer(1, [
          \ 'var addr = mail.Address{',
          \ '\tName:    "",',
          \ '\tAddress: "",',
          \ '}'])
  finally
    unlet g:go_fillstruct_mode
    call delete(l:tmp, 'rf')
  endtry
endfunc

func! Test_fillstruct_line() abort
  try
    let g:go_fillstruct_mode = 'fillstruct'
    let l:tmp = gotest#write_file('a/a.gno', [
          \ 'package a',
          \ 'import "net/mail"',
          \ "\x1f" . 'var addr = mail.Address{}'])

    call go#fillstruct#FillStruct()
    call gotest#assert_buffer(1, [
          \ 'var addr = mail.Address{',
          \ '\tName:    "",',
          \ '\tAddress: "",',
          \ '}'])
  finally
    unlet g:go_fillstruct_mode
    call delete(l:tmp, 'rf')
  endtry
endfunc

func! Test_fillstruct_two_line() abort
  try
    let g:go_fillstruct_mode = 'fillstruct'
    let l:tmp = gotest#write_file('a/a.gno', [
          \ 'package a',
          \ 'import (',
          \ '"fmt"',
          \ '"net/mail"',
          \ ')',
          \ "\x1f" . 'func x() { fmt.Println(mail.Address{}, mail.Address{}) }'])

    call go#fillstruct#FillStruct()
    call gotest#assert_buffer(1, [
          \ 'import (',
          \ '"fmt"',
          \ '"net/mail"',
          \ ')',
          \ 'func x() { fmt.Println(mail.Address{',
          \ '\tName:    "",',
          \ '\tAddress: "",',
          \ '}, mail.Address{',
          \ '\tName:    "",',
          \ '\tAddress: "",',
          \ '}) }'])
  finally
    unlet g:go_fillstruct_mode
    call delete(l:tmp, 'rf')
  endtry
endfunc

func! Test_fillstruct_two_cursor() abort
  try
    let g:go_fillstruct_mode = 'fillstruct'
    let l:tmp = gotest#write_file('a/a.gno', [
          \ 'package a',
          \ 'import (',
          \ '"fmt"',
          \ '"net/mail"',
          \ ')',
          \ "func x() { fmt.Println(mail.Address{}, mail.Ad\x1fdress{}) }"])

    call go#fillstruct#FillStruct()
    call gotest#assert_buffer(1, [
          \ 'import (',
          \ '"fmt"',
          \ '"net/mail"',
          \ ')',
          \ 'func x() { fmt.Println(mail.Address{}, mail.Address{',
          \ '\tName:    "",',
          \ '\tAddress: "",',
          \ '}) }'])
  finally
    unlet g:go_fillstruct_mode
    call delete(l:tmp, 'rf')
  endtry
endfunc

func! Test_gopls_fillstruct() abort
  try
    let g:go_fillstruct_mode = 'gopls'
    let l:tmp = gotest#write_file('a/a.gno', [
          \ 'package a',
          \ 'import "net/mail"',
          \ "var addr = mail.\x1fAddress{}"])

    call go#fillstruct#FillStruct()

    let start = reltime()
    while &modified == 0 && reltimefloat(reltime(start)) < 10
      sleep 100m
    endwhile

    call gotest#assert_buffer(1, [
          \ 'var addr = mail.Address{',
          \ '\tName:    "",',
          \ '\tAddress: "",',
          \ '}'])
  finally
    unlet g:go_fillstruct_mode
    call delete(l:tmp, 'rf')
  endtry
endfunc

func! Test_gopls_fillstruct_line() abort
  try
    let g:go_fillstruct_mode = 'gopls'
    let l:tmp = gotest#write_file('a/a.gno', [
          \ 'package a',
          \ 'import "net/mail"',
          \ "\x1f" . 'var addr = mail.Address{}'])

    call go#fillstruct#FillStruct()

    let start = reltime()
    while &modified == 0 && reltimefloat(reltime(start)) < 10
      sleep 100m
    endwhile

    call gotest#assert_buffer(1, [
          \ 'var addr = mail.Address{',
          \ '\tName:    "",',
          \ '\tAddress: "",',
          \ '}'])
  finally
    unlet g:go_fillstruct_mode
    call delete(l:tmp, 'rf')
  endtry
endfunc

func! Test_gopls_fillstruct_two_line() abort
  try
    let g:go_fillstruct_mode = 'gopls'
    let l:tmp = gotest#write_file('a/a.gno', [
          \ 'package a',
          \ 'import (',
          \ '"fmt"',
          \ '"net/mail"',
          \ ')',
          \ "\x1f" . 'func x() { fmt.Println(mail.Address{}, mail.Address{}) }'])

    call go#fillstruct#FillStruct()

    let start = reltime()
    while &modified == 0 && reltimefloat(reltime(start)) < 10
      sleep 100m
    endwhile

    " the fillstruct behavior of gopls is different than fillstruct; the
    " latter will not expand the struct when the cursor is not on a struct
    " when there is more than one struct literal on the line.
    call gotest#assert_buffer(1, [
          \ 'import (',
          \ '"fmt"',
          \ '"net/mail"',
          \ ')',
          \ 'func x() { fmt.Println(mail.Address{}, mail.Address{}) }'])
  finally
    unlet g:go_fillstruct_mode
    call delete(l:tmp, 'rf')
  endtry
endfunc

func! Test_gopls_fillstruct_two_cursor() abort
  try
    let g:go_fillstruct_mode = 'gopls'
    let l:tmp = gotest#write_file('a/a.gno', [
          \ 'package a',
          \ 'import (',
          \ '"fmt"',
          \ '"net/mail"',
          \ ')',
          \ "func x() { fmt.Println(mail.Address{}, mail.Ad\x1fdress{}) }"])

    call go#fillstruct#FillStruct()

    let start = reltime()
    while &modified == 0 && reltimefloat(reltime(start)) < 10
      sleep 100m
    endwhile

    call gotest#assert_buffer(1, [
          \ 'import (',
          \ '"fmt"',
          \ '"net/mail"',
          \ ')',
          \ 'func x() { fmt.Println(mail.Address{}, mail.Address{',
          \ '\tName:    "",',
          \ '\tAddress: "",',
          \ '}) }'])
  finally
    unlet g:go_fillstruct_mode
    call delete(l:tmp, 'rf')
  endtry
endfunc
" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
