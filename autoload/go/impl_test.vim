" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

func! Test_impl() abort
  try
    let l:tmp = gotest#write_file('a/a.gno', [
          \ 'package a',
          \ '',
          \ ''])

    call go#impl#Impl('r', 'reader', 'io.Reader')
    call gotest#assert_buffer(1, [
          \ 'func (r reader) Read(p []byte) (n int, err error) {',
          \ '	panic("not implemented") // TODO: Implement',
          \ '}'])
  finally
    call delete(l:tmp, 'rf')
  endtry
endfunc

func! Test_impl_get() abort
  try
    let l:tmp = gotest#write_file('a/a.gno', [
          \ 'package a',
          \ '',
          \ 'type reader struct {}'])

    call go#impl#Impl('io.Reader')
    call gotest#assert_buffer(0, [
          \ 'package a',
          \ '',
          \ 'type reader struct {}',
          \ '',
          \ 'func (r *reader) Read(p []byte) (n int, err error) {',
          \ '	panic("not implemented") // TODO: Implement',
          \ '}'])
  finally
    call delete(l:tmp, 'rf')
  endtry
endfunc

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
