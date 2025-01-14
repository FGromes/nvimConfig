return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require('lspconfig')

            -- ##############################################################################
            -- Swift 
            -- ##############################################################################
            lspconfig.sourcekit.setup {
                capabilities = {
                    workspace = {
                        didChangeWatchedFiles = {
                            dynamicRegistration = true,
                        },
                    },
                },
            }




            local swift_lsp = vim.api.nvim_create_augroup("swift_lsp", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "swift" },
                callback = function()
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true })
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })

                    local root_dir = vim.fs.dirname(vim.fs.find({
                        "Package.swift",
                        ".git",
                    }, { upward = true })[1])
                    local client = vim.lsp.start({
                        name = "sourcekit-lsp",
                        cmd = { "sourcekit-lsp" },
                        root_dir = root_dir,
                    })
                    vim.lsp.buf_attach_client(0, client)
                end,
                group = swift_lsp,
            })

            -- ##############################################################################
            -- Lua 
            -- ##############################################################################
            lspconfig.lua_ls.setup {
                on_init = function(client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
                            return
                        end
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                        runtime = {
                            -- Tell the language server which version of Lua you're using
                            -- (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT'
                        },
                        -- Make the server aware of Neovim runtime files
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME
                                -- Depending on the usage, you might want to add additional paths here.
                                -- "${3rd}/luv/library"
                                -- "${3rd}/busted/library",
                            }
                            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                            -- library = vim.api.nvim_get_runtime_file("", true)
                        }
                    })
                end,
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = 'Replace',
                        },
                        diagnostics = {
                            disable = { 'missing-fields' }
                        },
                    }
                }
            }





            vim.api.nvim_create_autocmd('LspAttach', {
                desc = "LSP Actions",
                callback = function(args)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, {noremap = true, silent = true})
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {noremap = true, silent = true})
                end,
            })
        end,
    },
}
