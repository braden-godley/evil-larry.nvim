local M = {}

-- Default configuration
local default_config = {
    -- Add your default configuration options here
}

-- Plugin state
M.config = {}

-- Initialize the plugin with user config
function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", default_config, opts or {})

    vim.api.nvim_create_user_command("TTS", function(args)
        local tts = require("evil-larry.tts")
        tts.tts(args.args)
    end, { nargs = "*" })
    
end

return M 