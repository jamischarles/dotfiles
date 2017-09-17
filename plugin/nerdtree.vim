" Nerdtree sugar pulled from janus... This ensures that it opens in current
" folder and remembers recent folder and other things that are awkward with
" basic nerdtree
"
" Q: Does this even work?
"if janus#is_plugin_enabled("nerdtree")
  let NERDTreeIgnore=['tags','^\.git$','\.vim$','\.DS_Store$', '\.pyc$', '\.pyo$', '\.rbc$', '\.rbo$', '\.class$', '\.o$', '\~$']

  " Default mapping, <leader>n
  map <leader>n :NERDTreeToggle<CR> :NERDTreeMirror<CR>

  " Remove 'e' as it is a colemak conflict
  let g:NERDTreeMapOpenExpl = ''
  let g:NERDTreeMapPreview = 'p'

  augroup AuNERDTreeCmd
  autocmd AuNERDTreeCmd VimEnter * call s:CdIfDirectory(expand("<amatch>"))
  "autocmd AuNERDTreeCmd FocusGained * call s:UpdateNERDTree()

  " If the parameter is a directory, cd into it
  function s:CdIfDirectory(directory)
    let explicitDirectory = isdirectory(a:directory)
    let directory = explicitDirectory || empty(a:directory)

    if explicitDirectory
      exe "cd " . fnameescape(a:directory)
    endif

    " Allows reading from stdin
    " ex: git diff | mvim -R -
    if strlen(a:directory) == 0
      return
    endif

    if directory
      NERDTree
      wincmd p
      bd
    endif

    if explicitDirectory
      wincmd p
    endif
  endfunction

  " NERDTree utility function
  function s:UpdateNERDTree(...)
    let stay = 0

    if(exists("a:1"))
      let stay = a:1
    end

    if exists("t:NERDTreeBufName")
      let nr = bufwinnr(t:NERDTreeBufName)
      if nr != -1
        exe nr . "wincmd w"
        exe substitute(mapcheck("R"), "<CR>", "", "")
        if !stay
          wincmd p
        end
      endif
    endif
  endfunction
"endif
