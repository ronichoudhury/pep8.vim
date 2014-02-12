" This plugin requires pep8 in your path.  To install it, make sure pip is
" installed and invoke the following command:
"
"   pip install pep8
"
" To run the Pep8 service, simply do ":Pep8".

" Get a handle to the pep8 program
if !exists("g:pep8prg")
    let g:pep8prg="pep8"
endif

function! s:Pep8(cmd)
    redraw

    " Process the current file.
    let l:fileargs = expand("%")

    " Save the current grep settings.
    let grepprg_bak=&grepprg
    let grepformat_bak=&grepformat

    " Perform the pep8 operation.
    try
        " Set the appropriate grep options.
        let &grepprg=g:pep8prg
        let &grepformat="%f:%l:%c: %m"

        " Construct the execution line.
        let cmdline = [a:cmd]
        call add(cmdline, l:fileargs)

        " Execute the command.
        silent execute join(cmdline)
    "finally
        " Restore the old grep settings.
        "let &grepprg=grepprg_bak
        "let &grepformat=grepformat_bak
    endtry

    " Open the quickfix window and display the errors, if there were any;
    " otherwise, just display a happy message.
    if len(getqflist()) > 0
        botright copen

        exec "nnoremap <silent> <buffer> q :ccl<CR>"

        redraw!
    else
        cclose
        redraw!

        echo "Pep8: " . l:fileargs . " is OK"
    endif
endfunction

" Create the vim command.
command! -bang -nargs=* -complete=file Pep8 call s:Pep8('grep<bang>')
