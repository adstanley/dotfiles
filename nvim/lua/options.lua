require "nvchad.options"

-- add yours here!

-- open nvim-tree on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      require("nvim-tree.api").tree.open()
    end
  end,
})

local o = vim.o

-- Indenting
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2

-- local o = vim.o
o.cursorlineopt ='both' -- to enable cursorline!
o.number = true

-- relative line numbers
vim.wo.relativenumber = true
vim.wo.number = true
