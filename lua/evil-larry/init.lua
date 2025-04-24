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

    -- Create autocmd for running function on save
    vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup("EvilLarryOnSave", { clear = true }),
        callback = function(ev)
            vim.schedule(function()
                local prompt = require("evil-larry.prompt")
                local prompt_text = prompt.get_prompt()

                local completions = require("evil-larry.completion")
                local response, err = completions.complete(prompt_text)
                if err then
                    vim.notify(err, vim.log.levels.ERROR)
                    return
                end

                local tts = require("evil-larry.tts")
                tts.tts(response)
            end)
        end,
    })
end

return M 