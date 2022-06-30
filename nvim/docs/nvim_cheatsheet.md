# Neovim Cheatsheet

## Nicer interfaces:

https://github.com/stevearc/dressing.nvim (Can I use this to print a message large in center?)

## DEBUGGING

https://wincent.com/wiki/Lua_development_in_Neovim
`vim.inspect()`

`vim.pretty_print({})` -- will print a table etc much better than `print()` will which shows the mem location


## Path magic
:h filename-modifiers
`vim.fn.expand("%:t")`

## Clearing screen

:mode

## Modifying ranges programatically

`:'<,'>luado return string.upper(line)`
`'<,'>` means current visual selection

`'<,'>luado return string.upper(line)` -- Lua operation (here string->uppercase) to run on current selection

From https://www.davekuhlman.org/nvim-lua-info-notes.html

## Search/Replace

`.s/\./$/g` . at the start here means only current line. `.->$`

Range is shown via [start],[end]. Can be line numbers or marks
`'<,'>` - means get location of `<` mark and `>` mark and use that as our range (gets stored when you leave visual selection mode)

`'<,'>d` - delete the visual range (like an op prefix)
`'<,'>s/find/replace/g` - find replace all things on those lines
`'<,'>s/\%Vfind/replace/g` - find replace all things withing visual selection (`\%V` limits it to current visual selection)

`4d` - delete line 4
`4,5d` - delete 4-5
`10,$d` - delete L10 -> eof
`:h range`

Can I fake setting the selection by manually setting `<` and `>` marks?
Do I need to?

Set mark manually so it can be used in a range.
`nvim_buf_set_mark({buffer}, {name}, {line}, {col}, {opts})`
similar to this motion: `mN` (sets a mark at a spot (instead of just at cursor))

## Q: What about colums in the ranges?

By default ranges are line based. Seems like the only way to include the column is to set marks and then use the marks as range points.
This is exactly what `'<,'>` does (these are the marks set when you leave visual mode).

https://github.com/winston0410/range-highlight.nvim

## Replacing ranges programatically

`nvim_buf_set_text({buffer}, {start_row}, {start_col}, {end_row}, {end_col}, {replacement})`
https://neovim.io/doc/user/api.html#nvim_buf_set_text()

## Operators

https://www.barbarianmeetscoding.com/boost-your-coding-fu-with-vscode-and-vim/editing-like-magic-with-vim-operators/
AMAZING ^

{Operator}{count?}{motion}
d2w
Delete 2 Words

da"
Delete around " (deletes around a word, including the quotes)
da[
da(

i = INNER
a = AROUND

dab = da(
daB = da{ NICE
dib/diB (work too)

op mappings:
:help omap-info

## Interesting Motions

2$ End of Nth next line
https://neovim.io/doc/user/motion.html

## User commands

Vim-style command line
`vim.api.nvim_set_keymap("o", 's"\'', ":SurroundAndReplace \" '<CR>", {noremap = true})`

or lua-style command line
`vim.api.nvim_set_keymap("o", 's"\'', ":lua SurroundAndReplace(\",')<CR>", {noremap = true})`

```
function SurroundAndReplace(arguments)
	local char = arguments.fargs[1] -- arrays in lua start at 1
	local replacement = arguments.fargs[2]

	vim.cmd("f" .. char .. "r" .. replacement) -- find start of char to replace and swap it
	vim.cmd("F" .. char .. "r" .. replacement) -- find end of char to replace and swap it
end

vim.api.nvim_create_user_command("SurroundAndReplace", SurroundAndReplace, {nargs = "*"})
vim.api.nvim_set_keymap("o", 's"\'', ":SurroundAndReplace \" '<CR>", {noremap = true})
```

With named args (MUCH BETTER)

`vim.api.nvim_set_keymap("o", 's"\'', ":SurroundAndReplace {find: \", replace: '}<CR>", {noremap = true})`

## Key Mappings

:h index -- default mappings with meaning
:h language-mapping (mapping command line stuff?)
Mapping operators! https://learnvimscriptthehardway.stevelosh.com/chapters/15.html

When mapping order matters. Try going BROAD to NARROW. If something is overriding something else, swap the order and/or make the first more narrow/wide

### Weird mapping gotchas

If you want some behavior for 2 modes but not a third you'd assume its, map a, then map b.

This doesn't do what you'd expect. All 3 modes will be mapped to whatever was set last (so weird)

```lua
-- map is my special map function
map("vx", "c", "yl") -- copy single letter in visual mode. In normal mode we want it to stay the CHANGE op
map("n", "c", "c")  -- CHANGE operator. Keep this as original meaning.
```

Instead you have to do this. This maps it for all 3 modes, then UN-MAPS it for normal mode (back to prior -- mapping? or initial mapping?)
Q: Is this related to noremap? What if we set noremap to false instead of true?

```lua
-- map is my special map function
map("vx", "c", "yl") -- copy single letter in visual mode. In normal mode we want it to stay the CHANGE op
unMap("n", "c")  -- CHANGE operator. Keep this as original meaning. Needs to be before other C mappings
```
