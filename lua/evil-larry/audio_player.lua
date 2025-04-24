local AudioPlayer = {}

-- Function to get the appropriate play command based on OS
local function get_play_command()
    local os_name = package.config:sub(1,1) == '\\' and 'windows' or 'unix'
    
    if os_name == 'windows' then
        return 'powershell -c "(New-Object Media.SoundPlayer \'%s\').PlaySync()"'
    else
        -- Try to find mpg123 or another player
        local handle = io.popen('which mpg123')
        local mpg123_path = handle:read('*a')
        handle:close()
        
        if mpg123_path and mpg123_path ~= "" then
            return 'mpg123 "%s"'
        end
        
        -- Fallback to play command if available
        handle = io.popen('which play')
        local play_path = handle:read('*a')
        handle:close()
        
        if play_path and play_path ~= "" then
            return 'play "%s"'
        end
        
        error("No suitable audio player found. Please install mpg123 or sox.")
    end
end

-- Function to play MP3 from file path
-- @param file_path: string containing the path to the MP3 file
-- @return boolean: success status
-- @return string: error message if failed
function AudioPlayer.play_mp3(file_path)
    if not file_path then
        return false, "No file path provided"
    end

    -- Check if file exists
    local file = io.open(file_path, "r")
    if not file then
        return false, "File does not exist: " .. file_path
    end
    file:close()

    -- Get the appropriate command
    local command_template = get_play_command()
    local command = string.format(command_template, file_path)

    -- Start the process
    local success, err = pcall(function()
        vim.fn.jobstart(command)
    end)

    if not success then
        return false, "Failed to play audio: " .. tostring(err)
    end

    return true
end

return AudioPlayer 