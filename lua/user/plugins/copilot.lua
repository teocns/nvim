return {
  {
    "zbirenbaum/copilot.lua",
    -- dependencies = {
    --   {
    --     "github/copilot.vim",
    --     tag = "v1.41.0",
    --   },
    -- },
    -- Lazy load when event occurs. Events are triggeredcopi
    -- as mentioned in:
    enabled = true,
    -- https://vi.stackexchange.com/a/4495/20389
    event = "InsertEnter",
    -- You can also have it load at immediately at
    -- startup by commenting above and uncommenting below:
    -- lazy = false
    opts = {
      -- Possible configurable fields can be found on:
      -- https://github.com/zbirenbaum/copilot.lua#setup-and-configuration
      filetypes = {
        yaml = true,
        -- json = true,
        -- cpp = true,
        -- c = true,
        mardkown = true,
        -- mdx = true,
        md = true,
        -- ["*"] = true,

        -- yaml = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
      },
      suggestion = {
        auto_trigger = true,
        debounce = 125,
        keymap = {
          -- accept = "<Tab>",
          accept_word = "<C-e>",
          accept_line = "<C-f>",
        },
      },
      panel = {
        auto_refresh = true,
        enabled = true,
        layout = {
          position = "right",
          ratio = 0.4,
        },
      },
      -- "secret_key": A string field for entering a secret API key. This key could be used for identification and authorization purposes when connecting to GitHub Copilot. This field does not have a default value.
      --
      -- "length": An integer field specifying the maximum length of generated code in tokens. A 'token' in this case would be an individual component of the code, such as a keyword, identifier, operator, or punctuation mark. The default value is 500 tokens.
      --
      -- "temperature": A string field for adjusting the 'temperature' parameter in the AI's sampling function, which affects the randomness of the AI's output. Lower values make the output more deterministic, while higher values increase randomness. This field does not have a default value and ranges from 0.0 to 1.0.
      --
      -- "top_p": A numerical field setting the 'top_p' or nucleus sampling parameter, which specifies the cumulative probability threshold for token selection. By default, this value is set to 1, meaning that all tokens with non-zero probability could be considered for generation.
      --
      -- "stops": An object field that allows setting per-language stop sequences. These could be sequences of tokens that tell the AI to stop generating further code for a specific language.
      --
      -- "indentationMode": An object field for controlling indentation block termination on a per-language basis. For instance, you could set "python": false to disable automatic block termination for Python code.
      --
      -- "inlineSuggestCount": An integer field that determines the number of inline suggestions to fetch. By default, GitHub Copilot would fetch 3 inline suggestions.
      --
      -- "listCount": An integer field that sets the number of solutions to display in the GitHub Copilot interface. The default value is 10 solutions.
      --
      -- "debug.showScores": A boolean field controlling whether to show scores in the sorted solutions. By default, this feature is turned off.
      --
      -- "debug.overrideEngine": A string field for specifying an alternate engine name. This could be used for testing or debugging purposes and does not have a default value.
      --
      -- "debug.overrideProxyUrl" and "debug.testOverrideProxyUrl": These string fields allow you to specify alternate GitHub authentication proxy URLs. The former is for general use, and the latter is specifically for running tests. Both fields do not have default values.
      --
      -- "debug.filterLogCategories": An array field for specifying which log categories to display. If the array is empty, all log categories will be displayed.
      server_opts_overrides = {
        settings = {
          advanced = {
            temperature = "0.1",
            inlineSuggestCount = 3,
            listCount = 5,
          },
        },
      },
    },
  },
}
