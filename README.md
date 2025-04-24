# evil-larry.nvim

A Neovim plugin that adds Evil Larry to your neovim

## Installation

Make sure you have mpg123 and git installed and on your PATH

You have to have the following environment variables for API keys:
- GEMINI_API_KEY
- ELEVENLABS_API_KEY

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "braden-godley/evil-larry.nvim",
    config = function()
        require("evil-larry").setup()
    end
}
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
    "braden-godley/evil-larry.nvim",
    config = function()
        require("evil-larry").setup()
    end
}
```

## Configuration

```lua
require("evil-larry").setup()
```

## License

MIT 
