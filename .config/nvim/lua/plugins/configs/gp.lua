local GROQ_AUDIO = "https://api.groq.com/openai/v1/audio/transcriptions"
local GROQ_WHISPER_MODEL = "distil-whisper-large-v3-en"
local GROQ_KEY = { "bw", "get", "password", "GROQ_API_KEY" }
local GROQ_HOST = "https://api.groq.com/openai/v1/chat/completions"
local GROQ_MODEL = "llama-3.2-11b-text-preview"

return {
  -- openai_api_key = { "bw", "get", "password", "OAI_API_KEY" },
  -- default agent names set during startup, if nil last used agent is used
  default_command_agent = nil,
  default_chat_agent = nil,
  cmd_prefix = "Gp",

  providers = {
    ollama = {
      endpoint = "http://localhost:11434/v1/chat/completions",
      -- secret = "dummy_secret",
    },
    localai = {
      endpoint = "http://localhost:8080/v1/audio/transcriptions",
    },
    openai = {},
    azure = {},
    copilot = {},
    lmstudio = {},
    googleai = {},
    pplx = {},
    anthropic = {},
  },
  whisper = {
    -- local-ai models install localai@whisper-tiny
    -- local-ai run localai@whisper-tiny
    -- curl http://localhost:8080/v1/audio/transcriptions -H "Content-Type: multipart/form-data" -F file="@$PWD/gb1.ogg" -F model="whisper-tiny"
    -- https://localai.io/features/audio-to-text/
    endpoint = "http://localhost:8080/v1/audio/transcriptions",
    -- model = "whisper-tiny",
    model = "whisper-large-q5_0",
    language = "en",
    store_dir = vim.fn.stdpath "cache" .. "/gp_whisper",
    style_popup_border = "rounded",
    rec_cmd = { "sox", "-c", "1", "--buffer", "8192", "-d", "rec.wav", "trim", "0", "3600" },
  },
  agents = {
    {

      provider = "ollama",
      name = "ChatOllamaLlama3.1-8B",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = {
        model = "llama3.1",
        temperature = 0.6,
        top_p = 1,
        min_p = 0.05,
      },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "You are a general AI assistant.",
    },
    {
      provider = "ollama",
      name = "CodeOllamaLlama3.1-8B",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = {
        model = "llama3.1",
        temperature = 0.4,
        top_p = 1,
        min_p = 0.05,
      },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").code_system_prompt,
    },
    {
      provider = "ollama",
      name = "deepseek-coder-v2",
      chat = true,
      command = true,
      -- string with model name or table with model name and parameters
      model = {
        model = "deepseek-coder-v2",
        temperature = 0.6,
        top_p = 1,
        min_p = 0.05,
      },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "You are a general AI assistant.",
    },
  },
}
