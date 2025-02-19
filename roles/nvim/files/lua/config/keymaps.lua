-- [[ Basic Keymaps ]]
-- See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Remap <Space> to <Nop> to avoid conflicts with leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>")

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Automatically center the cursor when moving up or down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Windows
vim.keymap.set("n", "<Up>", "<C-w>k")
vim.keymap.set("n", "<Down>", "<C-w>j")
vim.keymap.set("n", "<Left>", "<C-w>h")
vim.keymap.set("n", "<Right>", "<C-w>l")

-- Tabs
vim.keymap.set("n", "<C-T>", "<cmd>tabnew<cr>")
vim.keymap.set("n", "<C-N>", "<cmd>tabnext<cr>")
vim.keymap.set("n", "<C-P>", "<cmd>tabprevious<cr>")
vim.keymap.set("n", "<C-X>", "<cmd>tabclose<cr>")

-- Buffers
vim.keymap.set("n", "<leader>bd", "<cmd>bd!<cr>", { desc = "[B]uffer [D]elete" })

-- Paste over without replacing default register
vim.keymap.set({ "x", "v" }, "<leader>p", '"_dP')

-- Stay in visual mode while indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Move selected line / block of text in visual mode
-- See: https://vim.fandom.com/wiki/Moving_lines_up_or_down#Mappings_to_move_lines
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")

-- Edit file under cursor
vim.keymap.set("n", "<leader>e", "gF", { desc = "[E]dit file under cursor" })

-- Execute command in new split
vim.keymap.set("n", "<leader>x", ":new | %! <C-r>=getline('.')<CR><CR>", { desc = "E[x]ecute Command" })

-- Convert word under cursor between base64 and plain text
vim.keymap.set("n", "<leader>atob", ':normal! ciW<C-r>=system("echo -n " . expand("<cWORD>") . " | base64 -d")<CR><CR>')
vim.keymap.set("n", "<leader>btoa", ':normal! ciW<C-r>=system("echo -n " . expand("<cWORD>") . " | base64 -w 0")<CR><CR>')

-- Search & Replace
vim.keymap.set("n", "<C-S>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "[S]earch & [R]eplace" })

-- Convert from one case to another
vim.keymap.set("v", "<leader>crc", [[:s/\%V_\([a-zA-Z]\)/\u\1/g]], { desc = "[C]onvert to [C]amel Case" })
vim.keymap.set("v", "<leader>crs", [[:s/\%V[a-z]\@<=[A-Z]/_\l\0/g]], { desc = "[C]onvert to [S]nake Case" })

-- Diagnostic mappings
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open buffer diagnostic list" })
vim.keymap.set("n", "<leader>Q", vim.diagnostic.setqflist, { desc = "Open diagnostics list" })

vim.keymap.set("n", "<leader>vt", function()
    vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
end, { desc = "Toggle diagnostic virtual text" })

vim.keymap.set("n", "<leader>vl", function()
    vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })
end, { desc = "Toggle diagnostic virtual lines" })

-- Shorthand to launch Git pane
vim.keymap.set("n", "<leader>gp", "<cmd>0Git<cr>", { desc = "[G]it [P]ane" })

-- Quickly open the news file
vim.keymap.set("n", "<leader>N", "<cmd>edit $VIMRUNTIME/doc/news.txt<cr>", { desc = "[N]ews" })

-- Shorthand to insert \(.*\) in command mode
vim.keymap.set("c", "<F1>", [[\(.*\)]], { noremap = true, silent = true })

-- Exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Open/Close Terminal
vim.keymap.set("n", "<leader>tt", function()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buftype == "terminal" then
            vim.api.nvim_set_current_win(win)
            vim.cmd.startinsert()
            return
        end
    end

    vim.cmd("botright terminal")
end)

-- Open/Close Quicklist
vim.keymap.set("n", "<leader>co", function()
    if vim.fn.getqflist({ winid = 0 }).winid == 0 then
        vim.cmd.copen()
    else
        vim.cmd.cclose()
    end
end)
