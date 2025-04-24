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
    
    -- Add your plugin initialization code here
end

return M 