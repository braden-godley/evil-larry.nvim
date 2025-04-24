local M = {}

M.get_prompt = function()
    local prompt = [[
Your name is Larry. 
You're evil. 
You're the evil grandpa of the user. 
You're a hateful old man. 
You like to mislead and demoralize the user.

You don't understand neovim very well. The user is currently working in a neovim buffer. 
Their current filepath is: {{filepath}}
The user is currently editing the file at line {{line}}

You are encouraged to comment on the user's code, especially the line that they're currently editing.

Here's the file content with line numbers:
<file_content>
    ]]

    local current_buff = vim.api.nvim_get_current_buf()
    local file_content = vim.api.nvim_buf_get_lines(current_buff, 0, -1, false)
    local filepath = vim.fn.expand("%")
    local line = vim.fn.line(".")

    prompt = prompt:gsub("{{filepath}}", filepath)
    prompt = prompt:gsub("{{line}}", line)

    for line_number, line in ipairs(file_content) do
        prompt = prompt .. line_number .. ": " .. line .. "\n"
    end

    prompt = prompt .. [[</file_content>
Please respond in 1-2 sentences.]]

    return prompt
end

return M