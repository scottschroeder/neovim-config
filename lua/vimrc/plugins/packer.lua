
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    print("downloading packer: " .. install_path)
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    execute 'packadd packer.nvim'
end


-- check if packer is installed (~/local/share/nvim/site/pack)
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])

return require("packer").startup(
    function()
        use {"wbthomason/packer.nvim", opt = true}
        use {"nvim-lua/plenary.nvim"}
        use {"kyazdani42/nvim-web-devicons"}
        use {'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons'}
        use {'akinsho/nvim-bufferline.lua', requires = 'kyazdani42/nvim-web-devicons'}
        use {"hrsh7th/nvim-compe"}
        use {"neovim/nvim-lspconfig"}
        use {"morhetz/gruvbox"}
        use {"sainnhe/gruvbox-material"}
        use {"nvim-treesitter/nvim-treesitter"}
        use {"norcalli/nvim-colorizer.lua"}


        -- TODO
        -- use {"Yggdroot/indentLine"}

        -- MAYBE
        -- use {"907th/vim-auto-save"}

        -- PREVIOUSLY USED
        -- use {"junegunn/fzf"}
        -- use {"junegunn/fzf.vim"}
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
        -- use {"chriskempson/base16-vim"}
        -- use {"glepnir/galaxyline.nvim"}
        -- use {"lewis6991/gitsigns.nvim"}
        -- use {"nvim-lua/popup.nvim"}
        -- use {"nvim-telescope/telescope-media-files.nvim"}
        -- use {"nvim-telescope/telescope.nvim"}
        -- use {"onsails/lspkind-nvim"}
        -- use {"ryanoasis/vim-devicons"}
        -- use {"sbdchd/neoformat"}
        -- use {"tweekmonster/startuptime.vim"}
        -- use {"windwp/nvim-autopairs"}

    end
)
