" Leader key
unmap <Space>
let mapleader=" "

" Yank to system clipboard
set clipboard=unnamed

" Navigation (jumplist-like)
exmap back obcommand app:go-back
exmap forward obcommand app:go-forward
nmap <C-o> :back<CR>
nmap <C-i> :forward<CR>

" Search files
exmap searchFiles obcommand switcher:open
nmap <leader>sf :searchFiles<CR>
