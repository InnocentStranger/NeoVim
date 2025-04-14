local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })
-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })
map('i', 'jk', '<Esc>', { noremap = true, silent = true })

-- Move line up
vim.keymap.set('n', '<C-A-k>', ":m .-2<CR>==", { silent = true })

-- Move line down
vim.keymap.set('n', '<C-A-j>', ":m .+1<CR>==", { silent = true })

-- Move selected lines up
vim.keymap.set('x', '<C-A-k>', ":m '<-2<CR>gv=gv", { silent = true })

-- Move selected lines down
vim.keymap.set('x', '<C-A-j>', ":m '>+1<CR>gv=gv", { silent = true })

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

-- Function to copy diagnostic message to clipboard
local function copy_diagnostic_to_clipboard()
    -- Get the current diagnostic at the cursor position
    local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
    if #diagnostics > 0 then
        -- Create an empty table to store all the diagnostic messages
        local messages = {}

        -- Loop through all diagnostics and collect the messages
        for _, diagnostic in ipairs(diagnostics) do
            table.insert(messages, diagnostic.message)
        end

        -- Join all messages into a single string with a newline separator
        local msg = table.concat(messages, "\n")

        -- Copy it to the clipboard using the '+' register
        vim.fn.setreg('+', msg)

        -- Provide feedback to the user
        print("Diagnostic messages copied to clipboard!")
    else
        print("No diagnostic messages found under the cursor.")
    end
end

-- Create a custom command to copy the diagnostic message
vim.api.nvim_create_user_command('CopyDiagnostic', copy_diagnostic_to_clipboard, {})

-- Map a key to trigger the CopyDiagnostic command
vim.api.nvim_set_keymap('n', '<leader>cd', ':CopyDiagnostic<CR>', { noremap = true, silent = true })
