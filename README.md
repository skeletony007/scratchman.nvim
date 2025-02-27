### Scratchman

Basic scratch buffer manager for neovim. (see `:help scratch-buffer`)

### Instalation

Using [lazy.nvim]

```lua
return {
    "skeletony007/scratchman.nvim",

    config = true,
}
```

### Usage

`:Scratch` Opens a new (blank) scratch buffer

`:ScratchFork` Opens a new scratch buffer forked from the current buffer lines

[lazy.nvim]: https://github.com/folke/lazy.nvim

Inspiration: <https://github.com/folke/trouble.nvim/blob/85bedb7eb7fa331a2ccbecb9202d8abba64d37b3/lua/trouble/view/preview.lua#L48-L62>
