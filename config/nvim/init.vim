" NEOVIM CONFIG - MODERN FUNCTIONALITY WITH SHORTCUTS (v0.9.5) ===========================
let g:java_highlight_markdown = 0
autocmd VimEnter * call feedkeys("\<CR>")
let g:polyglot_disabled = ['java','c++','cpp','c', 'markdown', 'auto-pairs']
" <CR> stands for Carriage Return (Enter)
nnoremap <key> :Command<CR>
call plug#begin('~/.local/share/nvim/plugged')

" Fuzzy Finder
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mistricky/codesnap.nvim', { 'tag': 'v1.3.0', 'do': 'make' }
" File tree
Plug 'preservim/nerdtree'

" Auto pairs / braces
Plug 'jiangmiao/auto-pairs'
Plug 'windwp/nvim-autopairs'
Plug 'andweeb/presence.nvim'
" Comment/uncomment lines easily
Plug 'tpope/vim-commentary'

" Treesitter for syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim' 

" Avante AI plugin
Plug 'yetone/avante.nvim'

" Colorschemes
Plug 'folke/tokyonight.nvim'
Plug 'catppuccin/nvim', {'as': 'catppuccin'}
Plug 'mattn/emmet-vim'

" LSP Support
Plug 'neovim/nvim-lspconfig'             " Core LSP plugin
Plug 'williamboman/mason.nvim'           " Installs servers (like Java's jdtls)
Plug 'williamboman/mason-lspconfig.nvim' " Connects Mason to lspconfig

" Autocompletion (Keep these if you have them, add if missing)
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
" Autocompletion
Plug 'hrsh7th/cmp-nvim-lsp'

" Optional: snippets
Plug 'L3MON4D3/LuaSnip'
call plug#end()

set termguicolors
colorscheme tokyonight


" --- Basic Settings ---
set number
set relativenumber
set hlsearch
set clipboard=unnamedplus
syntax on

" --- Key Mappings ---
" Insert mode
inoremap kj <Esc>
inoremap <C-s> <Esc>:w<CR>a
imap <leader>e <C-y>,
" Normal mode
nnoremap <C-s> :w<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> :C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <A-Up> :resize +2<CR>
nnoremap <A-Down> :resize -2<CR>
nnoremap <A-Left> :vertical resize -2<CR>
nnoremap <A-Right> :vertical resize +2<CR>
nnoremap ; `

nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
vnoremap <leader>cc :CodeSnap<CR>
vnoremap <leader>cs :CodeSnapSave<CR>
nnoremap <leader>q :q!<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>wq :wq<CR>


" fuzzy search inside the current buffer immediately
nnoremap \l :BLines<CR>

" fuzzy find files (current directory)
nnoremap \z :Files<CR>

" Toggle comments for selected lines
vnoremap <leader>c gc

" Map Alt+v to Visual Block mode
nnoremap <M-v> <C-v>

" --- Terminal Splits ---
nnoremap <S-x> :rightbelow vsplit<Bar>terminal<CR>
nnoremap <S-h> :belowright split<Bar>terminal<CR>
autocmd TermOpen * startinsert
tnoremap <Esc> <C-\><C-n>

" --- Plugin Shortcuts ---
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :Helptags<CR>

" --- coc.nvim settings ---
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

" Additional coc.nvim shortcuts
nnoremap <silent> gd :call CocActionAsync('jumpDefinition')<CR>
nnoremap <silent> K :call CocActionAsync('doHover')<CR>
nnoremap <leader>r :call CocActionAsync('rename')<CR>
nnoremap <leader>F :call CocActionAsync('format')<CR>

" Map Alt+e to go to the end of the current line
nnoremap <M-e> $

" Close current buffer with Shift+Esc
nnoremap <S-Esc> :bd<CR>

autocmd FileType cpp setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
" --- Load Lua plugin configs ---
lua require('plugins.autopairs')
lua << EOF
local status_ok, codesnap = pcall(require, "codesnap")
if status_ok then
  codesnap.setup({
    save_path = vim.fn.expand("~/Pictures"), 
    has_extension = true,
    watermark = "",
    -- Note: in v0.0.11, 'code_theme' might be 'theme' 
    -- If it still errors, try changing 'code_theme' to 'theme' below
    code_theme = "tokyonight", 
  })
end
EOF
lua << EOF
require("codesnap").setup({
  save_path = vim.fn.expand("~/Pictures/Codesnap"),
  has_extension = true,
  watermark = "",
  -- In v1.x, the theme key is often just 'theme'
  code_theme = "tokyonight", 
})
EOF
" Accept full suggestion with Ctrl+F
imap <script><silent><nowait><expr> <C-f> codeium#Accept()

" Accept next word or line
imap <script><silent><nowait><expr> <C-h> codeium#AcceptNextWord()
imap <script><silent><nowait><expr> <C-j> codeium#AcceptNextLine()

" Cycle completions
imap <C-;>   <Cmd>call codeium#CycleCompletions(1)<CR>
imap <C-,>   <Cmd>call codeium#CycleCompletions(-1)<CR>

" Clear suggestion
imap <C-x>   <Cmd>call codeium#Clear()<CR>

hi Normal guibg=NONE ctermbg=NONE
hi NormalNC guibg=NONE ctermbg=NONE
hi VertSplit guibg=NONE
hi StatusLine guibg=NONE
hi StatusLineNC guibg=NONE
hi LineNr guibg=NONE
hi NonText guibg=NONE
hi SignColumn guibg=NONE
hi Pmenu guibg=NONE
hi PmenuSel guibg=NONE

" --- Avante AI Panel ---
" Open floating AI popup
nnoremap <silent> \t :lua require('avante').ask_popup()<CR>

" Close popup
nnoremap <silent> \qa :lua require('avante').close_popup()<CR>
" In your init.vim
lua << EOF
-- suppress lspconfig deprecation warnings
vim.notify = (function(orig_notify)
  return function(msg, ...)
    if type(msg) == "string" and msg:match("require%(\'lspconfig\'%)") then
      return
    end
    orig_notify(msg, ...)
  end
end)(vim.notify)
EOF

" ========================
" LSP + Completion Setup
" ========================

lua << EOF
-- 1. Setup Mason (MUST RUN FIRST)
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "jdtls", "pyright", "gopls", "clangd" },
    automatic_installation = true,
})

-- 2. Setup Completion (nvim-cmp)
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    })
})

-- 3. Setup LSP Servers
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
end

-- Python
lspconfig.pyright.setup({ capabilities = capabilities, on_attach = on_attach })

-- C++
lspconfig.clangd.setup({ capabilities = capabilities, on_attach = on_attach })

-- Go
lspconfig.gopls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
        },
    },
})

-- === JAVA FIX (JDTLS) ===
-- Get the current project name to create a unique workspace folder
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"

lspconfig.jdtls.setup({
    -- Important: We pass the -data flag so JDTLS knows where to save project info
    cmd = { mason_bin, "-data", workspace_dir },
    root_dir = lspconfig.util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle"),
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        java = {
            errors = { incompleteClasspath = { severity = "ignore" } },
        }
    }
})
EOF
" Set global indentation to 2 spaces
set expandtab       " Use spaces instead of tabs
set shiftwidth=2    " Size of an indent
set softtabstop=2   " Number of spaces in tab when editing
set tabstop=2       " Number of spaces that a <Tab> counts for

