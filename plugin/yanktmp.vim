" yanktmp.vim - Yank string write to tmpfile and read from tmpfile
" Author:      secondlife <hotchpotch@NOSPAM@gmail.com> 
" Modified By: rtakasuke
"
" DESCRIPTION:
"  This plugin enables vim to yank and paste through the multi processes.
"
"  If :call YanktmpYank(), yank string write to tmpfile.
"  And :call YanktmpPaste_p() or YanktmpPaste_P(), paste string from tmpfile.
"  
"  Default tmp file is '/tmp/vimyanktmp' and '/tmp/vimyanktmp_mode'
"  If you want to change tmp file.
"  let g:yanktmp_file      = '/tmp/example_tmp_file'
"  let g:yanktmp_mode_file = '/tmp/vimyanktmp_mode'
"
" ==================== file yanktmp.vimrc ====================
" NeoBundle 'rtakasuke/yanktmp.vim'
" map <silent> sy :call YanktmpYank()<CR>
" map <silent> sp :call YanktmpPaste_p()<CR>
" map <silent> sP :call YanktmpPaste_P()<CR>
" ==================== end: yanktmp.vimrc ====================

if v:version < 700 || (exists('g:loaded_yanktmp') && g:loaded_yanktmp || &cp)
    finish
endif
let g:loaded_yanktmp = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:yanktmp_file')
    let g:yanktmp_file = '/tmp/vimyanktmp'
endif

if !exists('g:yanktmp_mode_file')
    let g:yanktmp_mode_file = '/tmp/vimyanktmp_mode'
endif

function! YanktmpYank() range
    let tmp = @@
    silent normal gvy
    let selectedString=split(@@, "\n")
    let @@ = tmp
    call writefile(selectedString, g:yanktmp_file, 'b')
    " check and record yank mode
    if getline(a:firstline) == selectedString[0] && getline(a:lastline) == selectedString[-1]
        call writefile(['LINE_MODE'], g:yanktmp_mode_file)
    else
        call writefile(['STRING_MODE'], g:yanktmp_mode_file)
    endif
endfunction

function! YanktmpPaste_p() range
    if call('IsStringMode', [])
        " STRING_MODE
        let pos = getpos('.')
        let targetStrings = readfile(g:yanktmp_file, "b")
        let tmp = @a
        let @a = join(targetStrings, "\n")
        execute ':normal "ap'
        let @a = tmp
        call setpos('.', [0, pos[1], pos[2] + 1, 0])
    else
        " LINE_MODE
        let pos = getpos('.')
        call append(a:firstline, readfile(g:yanktmp_file, "b"))
        call setpos('.', [0, pos[1] + 1, 1, 0])
    endif
endfunction

function! YanktmpPaste_P() range
    if call('IsStringMode', [])
        " STRING_MODE
        let pos = getpos('.')
        let targetStrings = readfile(g:yanktmp_file, "b")
        let tmp = @a
        let @a = join(targetStrings, "\n")
        execute ':normal "aP'
        let @a = tmp
        call setpos('.', [0, pos[1], 1, 0])
    else
        " LINE_MODE
        let pos = getpos('.')
        call append(a:firstline - 1, readfile(g:yanktmp_file, "b"))
        call setpos('.', [0, pos[1], 1, 0])
    endif
endfunction

function! IsStringMode()
    let mode = readfile(g:yanktmp_mode_file)[0]
    return mode ==# "STRING_MODE"
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
