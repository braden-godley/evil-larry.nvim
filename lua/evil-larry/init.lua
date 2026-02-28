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

	vim.api.nvim_create_user_command("TTS", function(opts)
		local tts = require("evil-larry.tts")
		tts.tts(opts.args)
	end, { nargs = "*" })

	vim.api.nvim_create_user_command("Evil", function(opts)
		local voice = opts.fargs[1] or "evil-larry"
		M.evil(voice)
	end, { nargs = "*" })

	vim.api.nvim_create_user_command("Voices", function()
		local tts = require("evil-larry.tts")
		tts.get_voice_list()
	end)
end

function M.evil(voice)
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
		tts.tts(response, voice)
	end)
end

return M
