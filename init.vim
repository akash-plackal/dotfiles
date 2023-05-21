
call plug#begin('~/.config/nvim/plugged')

Plug 'preservim/nerdtree'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'navarasu/onedark.nvim'
Plug 'tpope/vim-commentary'
Plug 'ggandor/leap.nvim'
Plug 'jackMort/ChatGPT.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'MunifTanjim/nui.nvim'

call plug#end()

let g:onedark_config = {
    \ 'style': 'darker',
\}
colorscheme onedark

lua require('leap').add_default_mappings()

lua << EOF
require('chatgpt').setup({})
EOF


syntax on
set noswapfile 
set hlsearch
set incsearch 
set number relativenumber
set clipboard+=unnamedplus
set wrap
set shellcmdflag=-ic
set scrolloff=999
set ignorecase
set smartcase

nnoremap k kzz
nnoremap j jzz

let mapleader = " "
let @b = 'border="3px solid red"'
let @f =  'T=ci{Plda{'
let @m = "^f=lC{isMobile ? : pa}F:i'' hha"


" tab shortcut
ca tn tabnew
ca th tabp
ca tl tabn

nnoremap <C-Left> :tabprevious<CR>                                                                            
nnoremap <C-Right> :tabnext<CR>
nnoremap <C-j> :tabprevious<CR>                                                                            
nnoremap <C-k> :tabnext<CR>

" Find files using Telescope command-line sugar.
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Nerdtree
nnoremap <leader>e :NERDTreeToggle<CR>

" Keybinding for commenting & uncommenting lines using vim.commantry
nmap <leader>/ gcc
vmap <leader>/ gc


nnoremap <leader>h :noh <CR>
nnoremap <leader>s :!send % <CR>

