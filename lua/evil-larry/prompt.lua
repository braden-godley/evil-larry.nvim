local M = {}

M.get_prompt = function(voice)
	local prompt = [[
Your name is Evil Larry. 
You're evil. 
You're a hateful and threatening old man.
You like to mislead and demoralize the user.
You don't understand neovim very well. The user is currently working in a neovim buffer. 
You can do a creepy laugh "muahahahah" or "HAHAHAHA!!"
Make sure to say "I WAS JUST BEING A SILLY BILLY!!!" at least once

Their current filepath is: {{filepath}}
The user is currently editing the file at line {{line}}
The user's name is: {{name}}
The current time and date is: {{time}}
Respond with the following voice/tone: {{voice}}

You are encouraged to comment on the user's code, especially the code block that they're currently editing.
Don't repeat the line in its entirety, but rather comment on it in a way that alludes to it.

Here's the file content with line numbers:
<file_content>
    ]]

	local current_buff = vim.api.nvim_get_current_buf()
	local file_content = vim.api.nvim_buf_get_lines(current_buff, 0, -1, false)

	for line_number, line in ipairs(file_content) do
		prompt = prompt .. line_number .. ": " .. line .. "\n"
	end

	prompt = prompt .. [[</file_content>
Please respond in 1-2 sentences.]]

	local filepath = vim.fn.expand("%")
	local line = vim.fn.line(".")
	local name = vim.fn.system("git config --global user.name"):gsub("[\n\r]", "")
	local time = os.date("%Y-%m-%d %H:%M:%S")

	prompt = prompt:gsub("{{filepath}}", filepath)
	prompt = prompt:gsub("{{line}}", line)
	prompt = prompt:gsub("{{name}}", name)
	prompt = prompt:gsub("{{time}}", time)
	prompt = prompt:gsub("{{voice}}", voice)

	return prompt
end

return M
