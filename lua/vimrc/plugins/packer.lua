local log = require("vimrc.log")
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  log.info("downloading packer:", install_path)
  execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
  execute "packadd packer.nvim"
end

-- check if packer is installed (~/local/share/nvim/site/pack)
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])

return require("packer").startup(
        function()
          -- Package Management
          use { "wbthomason/packer.nvim", opt = true }

          -- Git
          use { "tpope/vim-fugitive" }
          use {"sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" }
          use { 'ruifm/gitlinker.nvim', requires = 'nvim-lua/plenary.nvim', }

          -- This just causes too many errors right now to be useful / trusted
          -- not sure where the problem is.
          use { 'pwntester/octo.nvim',
            disable = true,
            requires = {
              'nvim-lua/plenary.nvim',
              'nvim-telescope/telescope.nvim',
              'nvim-tree/nvim-web-devicons',
            },
            config = function ()
              require("vimrc.plugins.octo")
            end
          }

          -- Lib Extensions
          use { "nvim-lua/plenary.nvim" }
          use { "nvim-treesitter/nvim-treesitter" }

          -- LSP Core
          use { "nvim-lua/lsp_extensions.nvim" }
          -- use {"nvim-lua/lsp-status.nvim"} -- repo requires updates
          use { "j-hui/fidget.nvim" } -- display lsp status updates
          use { "williamboman/mason.nvim" }
          use { "williamboman/mason-lspconfig.nvim" }
          use { "neovim/nvim-lspconfig" }
          use { "kosayoda/nvim-lightbulb" }
          use { "onsails/lspkind-nvim" }
          use { "RishabhRD/nvim-lsputils", requires = "RishabhRD/popfix" }
          use { 'simrat39/inlay-hints.nvim' }

          -- Cosmetic
          use { 'goolord/alpha-nvim' }
          use { "kyazdani42/nvim-web-devicons" }
          -- use {"nanozuki/tabby.nvim"}
          -- use {"akinsho/nvim-bufferline.lua", requires = "kyazdani42/nvim-web-devicons"}
          -- use {"NTBBloodbath/galaxyline.nvim", branch = "main", requires = {"kyazdani42/nvim-web-devicons", opt = true} }
          -- use {"windwp/windline.nvim"}
          use { "rebelot/heirline.nvim" }
          use { "morhetz/gruvbox" }
          use { "sainnhe/gruvbox-material" }
          use { "NLKNguyen/papercolor-theme" }
          use { "rakr/vim-one" }
          use { "norcalli/nvim-colorizer.lua" }
          use { "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } }

          -- Editor
          use { "ggandor/lightspeed.nvim", requires = "tpope/vim-repeat" }
          use { "kyazdani42/nvim-tree.lua", requires = "kyazdani42/nvim-web-devicons" }
          use { "b3nj5m1n/kommentary" }
          -- use { "907th/vim-auto-save" } -- deprecated and broken with dap ui
          use { "Pocco81/auto-save.nvim" } -- this is the main repo, but has an issue that causes autosave failures whenever a ui buffer closes
          -- use { "yyk/simply-auto-save.nvim", commit = "f44defab145821f6f954aa05e3b0b9be87313eb9", as = "auto-save.nvim" }
          -- use {"junegunn/fzf"}
          -- use {"junegunn/fzf.vim"}
          use { 'kevinhwang91/nvim-bqf' } -- quickfix
          use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/plenary.nvim' } } }
          use { 'nvim-telescope/telescope-ui-select.nvim' } -- vim.ui.select will default everything to telescope
          use { 'stevearc/dressing.nvim' } -- appearance of the vim.ui.select & vim.ui.input modals
          use { "SmiteshP/nvim-navic", requires = "neovim/nvim-lspconfig" }
          use { "m4xshen/autoclose.nvim" }
          use { "folke/which-key.nvim" }
          use { "stevearc/oil.nvim" }

          -- Completion
          use { "hrsh7th/nvim-cmp" }
          use { "hrsh7th/cmp-buffer" }
          use { "hrsh7th/cmp-path" }
          -- use {"hrsh7th/cmp-cmdline"}
          use { "hrsh7th/cmp-nvim-lua" }
          use { "hrsh7th/cmp-nvim-lsp" }
          use { "hrsh7th/cmp-nvim-lsp-document-symbol" }
          use {"petertriho/cmp-git", requires = "nvim-lua/plenary.nvim"}


          -- Snips
          use { 'L3MON4D3/LuaSnip', tag = "v1.2.*", run = "make install_jsregexp" }
          use { 'saadparwaiz1/cmp_luasnip' }


          -- Rust
          -- use {"simrat39/rust-tools.nvim", branch = "modularize_and_inlay_rewrite"}
          use { "simrat39/rust-tools.nvim", branch = "master" }
          use { 'pest-parser/pest.vim' } -- (non-lua) syntax highligting for pest grammers

          -- Terraform (non-lua)
          use { 'hashivim/vim-terraform' }

          -- Ledger
          -- use { 'ledger/vim-ledger' }

          -- Debugging
          use { 'mfussenegger/nvim-dap' }
          use { 'leoluz/nvim-dap-go' }
          use { 'rcarriga/nvim-dap-ui' }
          use { 'theHamsta/nvim-dap-virtual-text' }
          use { 'nvim-telescope/telescope-dap.nvim' }

          -- AI
          -- Must be lazy loaded because it's very slow
          use {
            "zbirenbaum/copilot.lua",
            cmd = "Copilot",
            event = "InsertEnter",
            config = function()
              require("vimrc.plugins.copilot").setup()
            end,
          }
          use {
            "zbirenbaum/copilot-cmp",
            after = { "copilot.lua" },
            config = function ()
              require("vimrc.plugins.copilot_cmp").setup()
            end
          }

          -- MAYBE

          -- PREVIOUSLY USED
          -- use {"xolox/vim-misc"}
          -- use {"xolox/vim-lua-ftplugin"}
          -- use {"itchyny/lightline.vim"}
          -- use {"scrooloose/nerdtree"}
          -- use {"neomake/neomake"}
          -- use {"bronson/vim-trailing-whitespace"}
          -- use {"tpope/vim-commentary"}
          -- use {"tpope/vim-surround"}
          -- use {"airblade/vim-rooter"}


          -- USED BY A CONFIG I LIKED https://github.com/siduck76/neovim-dots
          -- use {"alvan/vim-closetag"}
          -- use {"nvim-lua/popup.nvim"}
          -- use {"nvim-telescope/telescope-media-files.nvim"}
          -- use {"nvim-telescope/telescope.nvim"}
          -- use {"sbdchd/neoformat"}
          -- use {"tweekmonster/startuptime.vim"}
          -- use {"windwp/nvim-autopairs"}
          -- eye candy
          -- use {"onsails/lspkind-nvim"}
          -- use {"ryanoasis/vim-devicons"}
        end
    )
