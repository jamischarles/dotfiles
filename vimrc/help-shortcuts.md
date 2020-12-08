# Keys & shortcuts & things I want to learn and remember (focus on use cases)
- where possible use native vim, and fix native vim mappins or map closely to
    work with colemak.

## General 
- `<l>i` add import for function under cursor
- `<l>h` help popup

## Terminal / iterm 
- `cmd ]` next pane 
- `cmd+sh+arrow` next mark (prompt) 
- `cmd+opt+a` set mark when prompt shows up

## Goodies I didn't realize worked
- `ctl-r-0` paste in insert mode
   `ctl-u` `ctr-h` delete backwards in insert mode  https://dalibornasevic.com/posts/43-12-vim-tips

## Copy / pasting
- Registers are useful to copy/paste outside of normal copy/paste history... `"c` reads/writes to c register
- Column paste: `"cc` copy to c register. `"cv` paste from c register. Needed to avoid system clipboard which breaks column paste. TODO: Make gist.column paste (from visual block copy) works if we don't use system clipboard https://advancedweb.hu/working-with-the-system-clipboard-in-vim/#:~:text=Set%20the%20%2B%20register%20as%20the,from%20it%20with%20%22%2Bp%20.
- TODO: read more about registers and why they might be useful
- `Xv` move line down one line. `C` copy whole line w/o selecting it
- `gb` - select pasted test
- Q: How do I paste a column in visual mode?
 https://stackoverflow.com/questions/9120552/how-do-i-paste-a-column-of-text-after-a-different-column-of-text-in-vim
- Read this to improve the exp? 
https://github.com/svermeulen/vim-yoink
http://vimcasts.org/blog/2013/11/registers-the-good-the-bad-and-the-ugly-parts/
https://vimawesome.com/plugin/copy-cut-paste-vim

## Editing multiple lines at once
- Use visual block mode and then S,T for append and Insert at beginning/end of
    line
- select and run macro (thx to visual macro in keys.vim)
- `:global/require/normal @w` run @w macro over each instance of require. WOW.
    Can be used for end of line etc too. WOW
- `%s/` or `<l>fr` - global find replace in file... append with `/c` for
     confirm on each
- `s/` will replace on current line (% means all lines)
- `s/` in current selection will replace in selection
- `%s/$/,` - add comma at end of each line. `%s/>$/` remove `>` at eol 

## Text manipulation
- Q: How to wrap a word with tags / chars? like `s`

## Git
- `Gvdiff` for vertical  diff for file
 TODO: look at this with current gutter plugin I use

## Execucing
- `:norm` will execute the command in normal mode (1 undo step)
