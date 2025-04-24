local M = {}

M.http = require("evil-larry.http")

--[[
curl -X POST "https://api.elevenlabs.io/v1/text-to-speech/JBFqnCBsd6RMkjVDRZzb?output_format=mp3_44100_128" \
     -H "xi-api-key: <apiKey>" \
     -H "Content-Type: application/json" \
     -d '{
  "text": "The first move is what sets everything in motion.",
  "model_id": "eleven_multilingual_v2"
}'

]]

M.get_tts_data = function(text)
    local voice_id = "NOpBlnGInO9m6vDvFkFC"
    local url = "https://api.elevenlabs.io/v1/text-to-speech/" .. voice_id .. "?output_format=mp3_44100_128"
    local api_key = os.getenv("ELEVENLABS_API_KEY")
    local headers = {
        ["xi-api-key"] = api_key,
        ["Content-Type"] = "application/json"
    }
    local body = vim.json.encode({
        text = text,
        model_id = "eleven_multilingual_v2"
    })

    local response, err = M.http.post(url, headers, body, false)

    if err then
        vim.notify(err, vim.log.levels.ERROR)
        return nil, err
    end

    return response
end

M.tts = function(text)
    local response = M.get_tts_data(text)

    local file_path = "/home/bgodley/git/evil-larry.nvim/tts.mp3"

    local file = io.open(file_path, "w")
    if not file then
        vim.notify("Failed to create file", vim.log.levels.ERROR)
        return false, "Failed to create file"
    end

    file:write(response)
    file:close()

    local audio_player = require("evil-larry.audio_player")
    return audio_player.play_mp3(file_path)
end

return M