" eteSkeleton
" Autor: ellethee <ellethee@altervista.org>
" Version: 1.0.3
" License: MIT
" Last change: 2010 Dec 14
" Copyright (c) 2010 ellethee <ellethee@altervista.org>
" License: MIT license {{{
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.

" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.
"}}}

if exists("g:loaded_eteSkeleton")
    finish
endif
" Exit if in compatible mode
if &compatible
    echoerr g:eteSkeleton_err_compatibile
    finish
endif
let g:loaded_eteSkeleton = 103
" Set the skeleton path name
let s:ETES_SKELETONS = "skeleton"
" Retrieve the tag file
let s:ETES_TAGS = globpath(&rtp, s:ETES_SKELETONS . "/tags/eteSkeleton.tags")
" eteSkeleton base path
let s:ETES_PATH = expand('<sfile>:p:h:h')
" eteSkeleton base skeleton path for new skeletons
let s:ETES_BASE_SKELETON = s:ETES_PATH . '/' . s:ETES_SKELETONS
" title char
let g:eteSkeleton_titlemark_char = "="
" Localization defaults
let g:eteSkeleton_msg_skeleton_created = "Skeleton created in"
let g:eteSkeleton_err_compatibile = "eteSkeleton doesn't work in compatible mode"
let g:eteSkeleton_err_notags_file = "Can't find tags file"
let g:eteSkeleton_err_notags = "There are no tags"
let g:eteSkeleton_err_tag_dir_no_created = "Unable to create dir"
let g:eteSkeleton_err_noword = "No word under cursor"
let g:eteSkeleton_ask_tag_value = "Insert a value for tag"
let g:eteSkeleton_err_no_tag_value = "Missining value for tag, operation aborted"
let g:eteSkeleton_msg_tag_dir_created = "Tags dir Created"
let g:eteSkeleton_msg_tag_file_created = "Tags file Created"
" Localization try to load lang file.
let s:ETES_LANG_PATH = globpath(&rtp, "lang/eteSkeleton_" . v:lang . ".vim")
if len(s:ETES_LANG_PATH)
    execute 'source ' . fnameescape(s:ETES_LANG_PATH)
endif
" Save options
let s:save_cpo = &cpo
" let's reset options to vim's default
set cpo&vim
" loosefiletype settings
if !exists("g:EteSkeleton_loosefiletype")
    let g:EteSkeleton_loosefiletype = 0
endif
" loosefiletype enhanced settings
if !exists("g:EteSkeleton_loosefiletype_enanched")
    let g:EteSkeleton_loosefiletype_enanched = 1
endif
if !exists("g:eteSkeleton_autocreate_tags")
    let g:eteSkeleton_autocreate_tags = 1
endif
" missing tags warning
if empty(s:ETES_TAGS)
    " setup WarningMsg
    echoh WarningMsg
    echom g:eteSkeleton_err_notags_file . " " . s:ETES_SKELETONS . "/tags/eteSkeleton.tags"
    let s:tags = [
                \'ask=inputdialog(getline("."))',
                \'askversion=inputdialog("Vesrion", "0.0.1")',
                \'author=expand("$USER")',
                \'basename=expand("%t:r")',
                \'date=strftime("%d\\/%m\\/%Y")',
                \'filename=expand("%:.")',
                \'home=expand("$HOME")',
                \'parentname=expand("%:p:h:t")',
                \'timestamp=strftime("%Y-%m-%d")',
                \'title=substitute(expand("%t:r"), ''\(\w\)\(\w\+\)'', ''\u\1\L\2'', "g")',
                \'titlemark=repeat(g:eteSkeleton_titlemark_char, len(substitute(expand("%t:r"), ''\(\w\)\(\w\+\)'', ''\u\1\L\2'', "g")))',
                \'version="0.0.1"',
                \'wholetitle=substitute(expand("%:t:r"), ''\(\w\)\(\w\+\)'', ''\u\1\L\2'', "g") . " :mod:`" . expand("%:p:h:t") . "." . expand("%:t:r") . "`"'
                \'wholetitlemark=repeat(g:eteSkeleton_titlemark_char, len(substitute(expand("%:t:r"), ''\(\w\)\(\w\+\)'', ''\u\1\L\2'', "g") . " :mod:`" . expand("%:p:h:t") . "." . expand("%:t:r") . "`"))'
                \]
    "try to create path and set right filename if option is set
    if g:eteSkeleton_autocreate_tags
        let s:ETES_TAGS = s:ETES_BASE_SKELETON . "/tags"
        if !isdirectory(s:ETES_TAGS)
            if exists('*mkdir')
                call mkdir(s:ETES_TAGS)
                echom g:eteSkeleton_msg_tag_dir_created . " " . s:ETES_TAGS
            else
                unlet s:ETES_TAGS
                echom g:eteSkeleton_err_tag_dir_no_created . " " . s:ETES_TAGS
            endif
        endif
        if exists("s:ETES_TAGS")
            let s:ETES_TAGS = s:ETES_TAGS . "/eteSkeleton.tags"
            call writefile(s:tags, s:ETES_TAGS)
            echom g:eteSkeleton_msg_tag_file_created
        endif
    endif
    echoh None
endif

" set up some command
command! -nargs=0 EteSkeleton call s:eteSkeleton_get()
command! -nargs=0 EteSkelList call s:eteSkeleton_taglist()
command! -nargs=1 EteSkelAdd call s:eteSkeleton_add(<q-args>)
command! -nargs=0 EteSkelAddTag call s:eteSkeleton_addtag()
command! -nargs=1 EteSkelDel call s:eteSkeleton_del(<q-args>)
command! -nargs=? EteSkelMake call s:eteSkeleton_makeskel(<q-args>)

" key mapping
nmap <silent> <Leader>st    :EteSkelAddTag<Enter>

" Create a new skeleton from file.
fu! s:eteSkeleton_makeskel(...)
    " filetype or extension.
    let l:ftype = &l:filetype != "" ? &l:filetype : expand("%:e")
    " use passed name if any
    if len(a:1)
        let l:name = a:1
        " else create one based on the actual filename
    else
        if g:EteSkeleton_loosefiletype_enanched
            let l:name = expand("%:t:r") . "." . l:ftype
        else
            let l:name = substitute(expand("%:r"), "type", l:ftype, "")
        endif
    endif
    " write the new skeleton
    exec ":w! " . s:ETES_BASE_SKELETON . "/" . l:name
    " edit the new skeleton
    exec ":e! " . s:ETES_BASE_SKELETON . "/" . l:name
    echom g:eteSkeleton_msg_skeleton_created . " " . s:ETES_BASE_SKELETON . "/" . l:name
endfu

" A sort function
fu! s:msort(l1, l2)
    return len(a:l2) - len(a:l1)
endfu

" A tag list
fu! s:eteSkeleton_taglist()
    " If we have tags
    if exists("s:ETES_TAGS")
        " wirite tags line by line
        for line in readfile(s:ETES_TAGS)
            echo line
        endfor
    else
        echo g:eteSkeleton_err_notags
    endif
endfu

" Add a new tag in the tag list
fu! s:eteSkeleton_addtag()
    if exists("s:ETES_TAGS")
        " get the word under the cursor
        let l:cword = expand("<cWORD>")
        if len(l:cword)
            " use it to create a tag
            call s:eteSkeleton_add(l:cword)
        else
            " no word under cursor. error
            echoerr g:eteSkeleton_err_noword
        endif
    else
        echoerr g:eteSkeleton_err_notags_file
    endif
endfu
" add effectivly
fu! s:eteSkeleton_add(tag)
    " split tag in key, value pair
    let l:vals = split(a:tag, "=")
    " remove tags delimiter
    let l:vals[0]= substitute(substitute(l:vals[0], "{", "", ""), "}", "", "")
    " If value is missing will ask for it.
    if len(l:vals) < 2
        let l:vtag =  input(g:eteSkeleton_ask_tag_value . " " . l:vals[0] . ": ")
        if len(l:vtag)
            call add(l:vals, l:vtag)
        else
            echoerr g:eteSkeleton_err_no_tag_value
            return
        endif
    endif
    echo l:vals
    let l:lista = readfile(s:ETES_TAGS)
    call filter(l:lista, 'v:val !~ "^' . l:vals[0] . '="')
    call add(l:lista, l:vals[0] . "=" . l:vals[1] )
    call writefile(l:lista, s:ETES_TAGS)
endfu
fu! s:eteSkeleton_del(tag)
    if exists("s:ETES_TAGS")
        let l:tag = substitute(substitute(a:tag, "{", "", ""), "}", "", "")
        let l:lista = readfile(s:ETES_TAGS)
        call filter(l:lista, 'v:val !~ "^' . l:tag . '="')
        call writefile(l:lista, s:ETES_TAGS)
    endif
endfu
fu! s:eteSkeleton_replace()
    for l:riga in readfile(s:ETES_TAGS)
        if l:riga[0] != '"' && len(l:riga[0]) != 0
            let l:vals = split(l:riga, "=")
            for l:idx in range(1, line("$"))
                if getline(l:idx) =~ "{" . l:vals[0] . "}"
                    silent! exec l:idx . "s#{" . l:vals[0] . "}#" . eval(l:vals[1]) . "#g"
                endif
            endfor
        endif
    endfor
endfu
fu! s:eteSkeleton_get()
    let l:ftype = &l:filetype != "" ? &l:filetype : expand("%:e")
    if g:EteSkeleton_loosefiletype
        let l:fname = expand("%:t:r") . "_" . l:ftype
    else
        let l:fname = expand("%:t:r")
    endif
    let l:rlist = sort(map(split(globpath(&rtp, s:ETES_SKELETONS . "/*" . l:ftype . "*"), "\n"), 'fnamemodify(v:val, ":t")'), "s:msort")
    for l:item in l:rlist
        if g:EteSkeleton_loosefiletype_enanched
            let l:titem = join(split(l:item, '\.')[:-2], '.')
            if l:titem != ""
                let l:titem = '\.' . l:titem . '$'
            endif
        else
            let l:titem = ""
        endif
        if join([l:fname, l:ftype], '.') == l:item
                    \|| l:fname =~ substitute(l:item, l:ftype, '\\w\\+', "")
                    \|| l:ftype == l:item
                    \|| (l:titem != "" && l:fname =~ l:titem)
            let l:pfile = split(globpath(&rtp, s:ETES_SKELETONS . "/" . l:item))
            if len(l:pfile)
                silent keepalt 0 read `=join(l:pfile)`
                if exists("s:ETES_TAGS")
                    if l:titem != ''
                        let l:newname = expand("%:p:h") . "/" . substitute(l:fname, l:titem, '', '') . "." . expand("%:e")
                        echom l:newname
                        execute "file " . l:newname
                    endif
                    call s:eteSkeleton_replace()
                endif
            endif
            break
        endif
    endfor
    return
endfu
fu! s:eteSkeleton_check()
    let l:ftype = &l:filetype != "" ? &l:filetype : expand("%:e")
    if l:ftype != ""
        execute "EteSkeleton"
    endif
    return
endfu
augroup plugin-eteSkeleton
    autocmd BufNewFile * call s:eteSkeleton_check()
    autocmd BufNewFile, BufRead eteSkeleton.tags :set ft=vim
augroup END

let &cpo= s:save_cpo
unlet s:save_cpo

" vim:fdm=marker tw=4 sw=4:
