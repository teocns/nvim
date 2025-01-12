if vim.g.vscode then
    -- Prevent loading of AstroNvim's lazy configuration
    vim.g.loaded_astronvim = true
    
    -- Basic options that should be set before loading vscode config
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "
    
    -- Load only VSCode-specific configuration
    require("vscode-config")
else
    -- Load full AstroNvim config
    if vim.loader and vim.fn.has "nvim-0.9.1" == 1 then vim.loader.enable() end

    if os.getenv "VANILLA" then vim.g.vanilla = 1 end

    local sources = {
        "astronvim.bootstrap",
        "astronvim.options",
        "astronvim.lazy",
        "astronvim.autocmds",
        "astronvim.mappings",
    }

    for _, source in ipairs(sources) do
        local status_ok, fault = pcall(require, source)
        if not status_ok then 
            vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) 
        end
    end

    if astronvim.default_colorscheme then
        if not pcall(vim.cmd.colorscheme, astronvim.default_colorscheme) then
            require("astronvim.utils").notify(
                ("Error setting up colorscheme: `%s`"):format(astronvim.default_colorscheme),
                vim.log.levels.ERROR
            )
        end
    end

    vim.g.neovide_input_ime = true
    vim.g.neovide_input_macos_option_key_is_meta = "both"

    require("astronvim.utils").conditional_func(astronvim.user_opts("polish", nil, false), true)
end

vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

