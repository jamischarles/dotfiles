
"" COMMANDS ###############################
" convert spaces to tabs
command! UseTabs set noet|retab!
command! ReTab set noet|retab!

" SEARCH conviences (FIXME: Remove the range error). Use <leader>ff
command! Search :call esearch#init()<CR>

" Window SIZING
" 'normal' allows us to type is just like on the command line (useful when
" there aren't any commands for a mapping)
command! WindowEq :exe "normal \<C-W>="
command! WindowMax :vertical resize
command! WindowMin :vertical resize 0
command! WindowVInc :vertical resize +20
command! WindowVDec :vertical resize -20

" Restore vim session
command! SessionSave :Obsession
command! SaveSession :Obsession

command! Mappings :map

" Find / replace commands
" -range=% means range is optional (you can use selection) - http://vimdoc.sourceforge.net/htmldoc/usr_40.html
command! -range=% ReplaceSingleQuoteWithDouble :<line1>,<line2>s/'/"/gi
" This is busted. Replaces all words, not just the unquoted ones...
" command! -range=% ReplaceWrapUnquotedWords :<line1>,<line2>s/\(\w\+\)/"\1"/gi

" JSON Pretty print
command! PrettyJSON %!python -m json.tool
command! -range=% PrettyJSONRange :<line1>,<line2>%!python -m json.tool

" XML pretty print
command! PrettyXML %!xmllint --format %

function! Dontopeninnerdtree(e)
  " if NERDTree has focus, go to next window
  if exists("b:NERDTree")
    " echo "Can't navigate on NERDTree"
    " Go to next window
    execute 'wincmd w'
  endif

  " Open selected file
  execute 'e ' a:e

endfunction


"" AU GROUPS #####################################

" Reading on auto-groups http://learnvimscriptthehardway.stevelosh.com/chapters/14.html
augroup vimrc
  autocmd!
  autocmd BufRead,BufNewFile .vimrc setfiletype vim
  autocmd BufEnter *.vimrc set foldmethod=expr
  autocmd BufEnter *.vimrc set foldexpr=GetVimFoldLevel()
augroup END

" Sets folding, and auto-wrap
augroup markdown
  autocmd!
  autocmd BufEnter *.md set foldmethod=expr
  autocmd BufEnter *.md set foldexpr=GetMarkdownLevel()
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80
augroup END

" Golang settings for Neoformat
augroup fmtgo
  autocmd!
  autocmd BufWritePre *.go undojoin | Neoformat
augroup END

" augroup fmtReasonMl
"   autocmd!
"   autocmd BufWritePre *.re ! refmt %
" augroup END

augroup json
	autocmd!
	autocmd BufRead,BufNewFile .*rc setfiletype json
augroup END

" set foldmethod=syntax " Set folding defaults. Fold by syntax (defined by js syntax)
" Only mark functions / outside level for folding
" FIXME: Read up on how to set augroups...
augroup javascript " just a name
  "clears it so we can source this file several times...
  autocmd!
  autocmd FileType javascript set foldlevel=0
  autocmd FileType javascript set foldmethod=syntax
  " " Only use fn (outside level)
  autocmd FileType javascript set foldnestmax=2
  autocmd BufWritePost *.js Neomake
  "Save with prettier
  autocmd BufWritePost *.js PrettierAsync
  " " Have them be open by default
  " autocmd FileType javascript set nofoldenable
  " au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
augroup END

augroup ejs " just a name
  autocmd!
  " set filetype of ejs files as jst so it doesn't mess up the highlighting
  autocmd BufRead,BufNewFile .ejs setfiletype jst
augroup END


augroup css
  autocmd!
  "Save with prettier
  autocmd BufWritePost *.css PrettierAsync
augroup END

augroup allFiles
	autocmd!
	" Strip whitespace on save for all files
	autocmd FileType * autocmd BufWritePre <buffer> call StripAllFilesButMarkdown()
	" INDENTATION
	autocmd FileType * set tabstop=4|set shiftwidth=4

	" Fix fugitive collision with colemak mappings causing y to stall.
	" https://github.com/jooize/vim-colemak#tpopevim-fugitive-keymap-collision
	autocmd BufEnter * silent! execute "nunmap <buffer> <silent> y<C-G>"

	if has("autocmd")
		if exists("g:autosave_on_blur")
			au FocusLost * silent! wall
		endif
	endif
augroup END

" GIT COMMIT defaults. This runs these commands on vim startup (for the gitcommit file type instead of in the editor)
autocmd Filetype gitcommit setlocal spell textwidth=72




""CUSTOM FUNCTIONS #####################################

" Don't strip whitespace in markdown files...
function! StripAllFilesButMarkdown()
  " If filetype is whitespace, don't do anything
  if &ft =~ 'markdown'
    return
  endif

  StripWhitespace

endfunction



""" FocusMode
function! ToggleFocusMode()
  if (&foldcolumn != 42)
    set laststatus=0
    set numberwidth=10
    set foldcolumn=42
    set noruler
    hi FoldColumn ctermbg=none
    hi LineNr ctermfg=0 ctermbg=none
    hi NonText ctermfg=0
  else
    set laststatus=2
    set numberwidth=4
    set foldcolumn=0
    set ruler
    execute 'colorscheme ' . g:colors_name
  endif
endfunc
nnoremap <leader>F :call ToggleFocusMode()<cr>
command! ToggleFocusMode :call ToggleFocusMode()<CR>


function! s:getNumberOfOpenBuffers()
" This is how you run a command from a script...
" If there's one buffer open, and it's not a nerdtree buffer...
if exists("t:NERDTreeBufName")
  echo "HI"
  if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1 && bufwinnr(t:NERDTreeBufName) == -1
  endif

  " This block will ONLY be entered the very first time, when it normally
  " closes on it's own
else

  echo "NOT YET"
  " Focus on new window, then call the stuff.?
  " NERDTreeFind
endif
" return len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))

endfunction

" Q: Why do we use s: or caps?
function! GotoNextBuffer()
    " If currently focused on NERDtree, don't allow to change buffer
    " Instead change window, and then change buffer
    if exists("b:NERDTree")
      echo "Can't navigate on NERDTree"
      wincmd p
    endif

    if exists("b:tagbar_mapped_keys")
      echo "Can't navigate on Tagbar"
      " Go to next window
      wincmd p
    endif

    " Go to next
    :bn
endfunction

function! GotoPriorBuffer()
    " If currently focused on NERDtree, don't allow to change buffer
    " Instead change window, and then change buffer
    if exists("b:NERDTree")
      echo "Can't navigate on NERDTree"
      " Go to next window
      wincmd p
    endif

    " Go to next
    :bp
endfunction


" if line starts with 2 double quotes followed by space, it's fold level 1
" https://vi.stackexchange.com/questions/3512/how-to-fold-comments
function! GetVimFoldLevel()
  if getline(v:lnum) =~ '^"" .*$'
    return ">1"
  endif
  " TODO: Consider making it uppercase? REGEX: :help magic
  if getline(v:lnum) =~ '^" \w\+\s\?\w\+:\s' "  quote, space, one or two words followed by colon, followed by whitespace (removes urls)
    return ">2"
  endif
  return "="
endfunction

function! GetMarkdownLevel()
  if getline(v:lnum) =~ '^# .*$'
    return ">1"
  endif
  " TODO: Consider making it uppercase? REGEX: :help magic
  if getline(v:lnum) =~ '^## .*$' "  quote, space, one or two words followed by colon, followed by whitespace (removes urls)
    return ">2"
  endif
  return "="
endfunction


" http://gregsexton.org/2011/03/27/improving-the-text-displayed-in-a-vim-fold.html
function! CustomFoldText() abort
    let fs = v:foldstart
    while getline(fs) !~ '\w'
        let fs = nextnonblank(fs + 1)
    endwhile
    if fs > v:foldend
        let line = getline(v:foldstart)
    else
        let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
    endif

    let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
    let foldSize = 1 + v:foldend - v:foldstart
    let foldSizeStr = " " . foldSize . " lines "
    let foldLevelStr = repeat("  +  ", v:foldlevel)
    let lineCount = line("$")
    let foldPercentage = printf("[%.1f", (foldSize*1.0)/lineCount*100) . "%] "
    let expansionString = repeat(" ", w - strwidth(foldSizeStr.line.foldLevelStr))
    return line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
endfunction


function! NrBufs()
    let i = bufnr('$')
    let j = 0
    while i >= 1
        if buflisted(i)
            let j+=1
        endif
        let i-=1
    endwhile
    return j
endfunction


" Will close the window if there are more open than should be
function! CloseCurrentBufferOrWindow()
" If NerdTree is  open
  if exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) == 1
      " If NERDTree is open, there should be 2 open windows.
      let shouldBeOpen = 2
  else
      " If NERDTree is not open, there should be 1 open window.
      let shouldBeOpen = 1

  endif

  " Close buffer and go to prior buffer
  :bp
  :bd #

  " If number of open windows exceeds what it should, close the window
  if winnr() > shouldBeOpen
      :close
  endif

endfunction

func! GetNumberOfOpenBuffers()
  " This is how you run a command from a script...
  " If there's one buffer open, and it's not a nerdtree buffer...
  let buffer_count = NrBufs()
  echo buffer_count
  if buffer_count > 1
    " <BAR> is the | which is used to separate vim commands. SO you can use several
    :bd<CR>
  elseif
    :bd<CR>
  endif

    " This block will ONLY be entered the very first time, when it normally
    " closes on it's own

    " Focus on new window, then call the stuff.?
    " NERDTreeFind
  " return len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))

endfunction


  func! Backspace()
    if col('.') == 1
      if line('.')  != 1
        return  "\<ESC>kA\<Del>"
      else
        return ""
      endif
    else
      return "\<Left>\<Del>"
    endif
  endfunc

