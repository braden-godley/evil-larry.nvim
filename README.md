# evil-larry.nvim

A Neovim plugin that [describe your plugin's purpose].

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "bgodley/evil-larry.nvim",
    config = function()
        require("evil-larry").setup()
    end
}
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
    "bgodley/evil-larry.nvim",
    config = function()
        require("evil-larry").setup()
    end
}
```

## Configuration

```lua
require("evil-larry").setup({
    -- your configuration options here
})
```

## License

MIT 