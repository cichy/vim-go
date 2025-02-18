" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

func! Test_run_fmt() abort
  let actual_file = tempname()
  call writefile(readfile("test-fixtures/fmt/hello.gno"), actual_file)

  let expected = join(readfile("test-fixtures/fmt/hello_golden.gno"), "\n")

  " run our code
  call go#fmt#run("gofmt", actual_file, "test-fixtures/fmt/hello.gno")

  " this should now contain the formatted code
  let actual = join(readfile(actual_file), "\n")

  call assert_equal(expected, actual)
endfunc

func! Test_update_file() abort
  let expected = join(readfile("test-fixtures/fmt/hello_golden.gno"), "\n")
  let source_file = tempname()
  call writefile(readfile("test-fixtures/fmt/hello_golden.gno"), source_file)

  let target_file = tempname()
  call writefile([""], target_file)

  " update_file now
  call go#fmt#update_file(source_file, target_file)

  " this should now contain the formatted code
  let actual = join(readfile(target_file), "\n")

  call assert_equal(expected, actual)
endfunc

func! Test_goimports() abort
  let $GOPATH = printf('%s/%s', fnamemodify(getcwd(), ':p'), 'test-fixtures/fmt')
  let actual_file = tempname()
  call writefile(readfile("test-fixtures/fmt/src/imports/goimports.gno"), actual_file)

  let expected = join(readfile("test-fixtures/fmt/src/imports/goimports_golden.gno"), "\n")

  " run our code
  call go#fmt#run("goimports", actual_file, "test-fixtures/fmt/src/imports/goimports.gno")

  " this should now contain the formatted code
  let actual = join(readfile(actual_file), "\n")

  call assert_equal(expected, actual)
endfunc

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
