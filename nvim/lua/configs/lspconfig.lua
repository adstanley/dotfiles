require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "basedpyright", "bashls", "clangd", "perlnavigator" }
vim.lsp.enable(servers)

vim.lsp.config('*', {
          root_markers = { '.git' },
        })

-- clangd config
vim.lsp.config.clangd = {
            cmd = {
            'clangd',
            '--clang-tidy',
            '--background-index',
            '--offset-encoding=utf-8',
          },
          root_markers = { '.git', '.clangd', 'compile_commands.json' },
          filetypes = { 'c', 'cpp' },
        }

-- read :h vim.lsp.config for changing options of lsp servers 
