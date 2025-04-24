local M = {}

-- Check if curl is available
local function check_curl()
    local handle = io.popen("curl --version")
    if not handle then
        return false
    end
    local result = handle:read("*a")
    handle:close()
    return result ~= nil and result:match("curl") ~= nil
end

-- Ensure curl is available on system
if not check_curl() then
    error("curl is required but not found on the system")
end

-- Execute a curl command and return the response
local function execute_curl(cmd)
    local handle = io.popen(cmd)
    if not handle then
        return nil, "Failed to execute curl command"
    end
    
    local result = handle:read("*a")
    local success, _, code = handle:close()
    
    if not success then
        return nil, "HTTP request failed with exit code: " .. (code or "unknown")
    end
    
    return result
end

-- Make a POST request
function M.post(url, headers, body, decode_json)
    if decode_json == nil then
        decode_json = true
    end

    -- Build headers string
    local header_args = ""
    for k, v in pairs(headers) do
        header_args = header_args .. string.format(" -H '%s: %s'", k, v)
    end

    -- Build curl command
    local cmd = string.format(
        "curl -s -X POST%s -d '%s' '%s'",
        header_args,
        body:gsub("'", "'\\''"), -- Escape single quotes
        url
    )

    local response, err = execute_curl(cmd)
    if err then
        return nil, err
    end

    if not decode_json then
        return response
    end

    -- Parse JSON response
    local ok, decoded = pcall(vim.json.decode, response)
    if not ok then
        return nil, "Failed to parse JSON response: " .. decoded
    end

    return decoded
end

return M 