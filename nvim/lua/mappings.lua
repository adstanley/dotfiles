require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- Enter Command Mode
map("n", ";", ":", { desc = "CMD enter command mode" })

-- Exit Insert mode
map("i", "jk", "<ESC>")

-- Move lines up/down in Normal mode
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })

-- Move lines up/down in Visual mode
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })

-- Save file in Normal, Insert, and Visual modes
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- comment/uncomment lines in Normal and Visual modes
map("n", "<C-_>", "<cmd> lua require('Comment.api').toggle.linewise.current() <cr>", { desc = "Toggle comment line" })
map("v", "<C-_>", "<esc><cmd> lua require('Comment.api').toggle.linewise(vim.fn.visualmode()) <cr>", { desc = "Toggle comment selection" })
