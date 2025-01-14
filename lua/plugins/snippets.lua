return {
  {
    'L3MON4D3/LuaSnip',
    lazy = false,
    config = function(opts)
      local luasnip = require('luasnip')
      luasnip.setup(opts)
        require('luasnip.loaders.from_snipmate').load({ paths = "./lua/plugins/snippets"})

        vim.keymap.set('i', '<C-K>', function() luasnip.expand() end, { silent = true })

    end,
  }
}
