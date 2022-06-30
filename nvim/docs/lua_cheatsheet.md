# Lua Cheatsheet (esp as it pertains to neovim)

TODO:

- fix the indenting or make this yaml or .txt instead. Hate the auto-space under titles I really just want a rich file.

## Other good lists and resources

http://lua-users.org/wiki/StringTrim

https://www.2n.pl/blog/how-to-write-neovim-plugins-in-lua

## Run shell command

vim.fn.system('ls') --
vim.fn.systemlist('ls') -- command and return result as list

## Syntax

if not condition -- like !condition in JS

## Spread array params
`local nums = {1, 2}`

```lua
function add(a, b)
  return a+b
end

add(unpack(nums)) -- like js spread op ...nums
```
