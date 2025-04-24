local M = {}
local credentials = require("ai.credentials")
local http = require("ai.http")

-- Message type for chat history
---@class Message
---@field role string "user" | "assistant" | "system"
---@field content string
---@field tool_calls? table[] Optional tool calls made by the assistant
---@field tool_results? table[] Optional results from tool calls

-- Provider implementations
local providers = {
    openai = {
        chat = function(messages, opts)
            local creds, err = credentials.get_credential("openai")
            if err then
                return nil, err
            end

            -- TODO: Implement OpenAI API call
            error("OpenAI implementation pending")
        end
    },
    gemini = {
        chat = function(messages, opts)
            local creds, err = credentials.get_credential("gemini")
            if err then
                return nil, err
            end

            -- Convert messages to Gemini format
            local system_instruction = {}
            local contents = {}
            for _, msg in ipairs(messages) do
                if msg.role == "system" then
                    table.insert(system_instruction, {
                        text = msg.content,
                    })
                else
                    table.insert(contents, {
                        role = msg.role,
                        parts = {{ text = msg.content }},
                    })
                end
            end

            -- Prepare request
            local url = string.format(
                "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent?key=%s",
                opts.model,
                creds.api_key
            )

            local headers = {
                ["Content-Type"] = "application/json"
            }

            local body = vim.json.encode({
                system_instruction = {
                    parts = system_instruction,
                },
                contents = contents,
                generationConfig = {
                    temperature = opts.temperature,
                    maxOutputTokens = opts.max_tokens,
                    topP = opts.top_p or 0.8,
                    topK = opts.top_k or 40
                }
            })

            -- Make request
            local response, err = http.post(url, headers, body)
            if err then
                return nil, "Gemini API request failed: " .. err
            end

            -- Handle potential errors in response
            if response.error then
                return nil, "Gemini API error: " .. vim.inspect(response.error)
            end

            -- Extract the generated text
            if not response.candidates or #response.candidates == 0 then
                return nil, "No completion candidates returned"
            end

            local candidate = response.candidates[1]
            if not candidate.content or #candidate.content.parts == 0 then
                return nil, "Invalid response format"
            end

            return candidate.content.parts[1].text, nil
        end
    },
    anthropic = {
        chat = function(messages, opts)
            local creds, err = credentials.get_credential("anthropic")
            if err then
                return nil, err
            end

            -- TODO: Implement Claude API call
            error("Claude implementation pending")
        end
    }
}

-- Configuration
M.config = {
    default_provider = "anthropic",
    credentials_path = nil,  -- Will use default path if not set
    providers = {
        openai = {
            model = "gpt-4-turbo-preview",
            temperature = 0.7,
            max_tokens = 2000,
        },
        gemini = {
            model = "gemini-pro",
            temperature = 0.7,
            max_tokens = 2000,
            top_p = 0.8,
            top_k = 40,
        },
        anthropic = {
            model = "claude-3-opus-20240229",
            temperature = 0.7,
            max_tokens = 2000,
        }
    }
}

-- Initialize the completion module
function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})
    
    -- Load credentials
    local ok, err = credentials.load_credentials(M.config.credentials_path)
    if not ok then
        error("Failed to load AI credentials: " .. err)
    end
end

-- Legacy completion function for backward compatibility
function M.complete(prompt, opts)
    return M.chat_complete({{role = "user", content = prompt}}, opts)
end

-- New chat completion function that supports back-and-forth
---@param messages Message[] List of messages in the conversation
---@param opts table Optional configuration overrides
---@return string|nil response The AI's response
---@return string|nil error Error message if something went wrong
function M.chat_complete(messages, opts)
    opts = opts or {}
    local provider = opts.provider or M.config.default_provider

    if not providers[provider] then
        return nil, "Unknown provider: " .. provider
    end

    -- Merge provider-specific config with opts
    local provider_opts = vim.tbl_deep_extend(
        "force",
        M.config.providers[provider],
        opts
    )

    return providers[provider].chat(messages, provider_opts)
end

return M 