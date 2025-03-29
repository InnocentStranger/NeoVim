local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })
-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })
map('i', 'jk', '<Esc>', { noremap = true, silent = true })

-- Move line up
vim.keymap.set('n', '<A-k>', ":m .-2<CR>==", { silent = true })

-- Move line down
vim.keymap.set('n', '<A-j>', ":m .+1<CR>==", { silent = true })

-- Move selected lines up
vim.keymap.set('x', '<A-k>', ":m '<-2<CR>gv=gv", { silent = true })

-- Move selected lines down
vim.keymap.set('x', '<A-j>', ":m '>+1<CR>gv=gv", { silent = true })

-- Move to Begin & End of Line
map("n", "<C-e>", "<End>", { desc = "move end of line" })
map("n", "<C-b>", "<Home>", { desc = "move beginning of line" })

-- Copy to system clipboard in normal mode
vim.keymap.set('n', '<Leader>y', '"+y', { silent = true })

-- Copy to system clipboard in visual mode
vim.keymap.set('x', '<Leader>y', '"+y', { silent = true })

-- Paste from system clipboard in normal mode
vim.keymap.set('n', '<Leader>p', '"+p', { silent = true })

-- Paste from system clipboard in visual mode
vim.keymap.set('x', '<Leader>p', '"+p', { silent = true })


