#!/bin/bash

cd ~/.local/share/nvim/site/pack/plugins/start




rm -rf ~/.local/share/nvim/site/pack/plugins/start/nvim-comment
git clone https://github.com/terrortylor/nvim-comment.git ~/.local/share/nvim/site/pack/plugins/start/nvim-comment



rm -rf ~/.local/share/nvim/site/pack/plugins/start/indent-blankline.nvim
git clone https://github.com/lukas-reineke/indent-blankline.nvim.git ~/.local/share/nvim/site/pack/plugins/start/indent-blankline.nvim


rm -rf ~/.local/share/nvim/site/pack/plugins/start/fzf-lua
git clone https://github.com/ibhagwan/fzf-lua.git ~/.local/share/nvim/site/pack/plugins/start/fzf-lua


rm -rf ~/.local/share/nvim/site/pack/plugins/start/nvim-web-devicons
git clone https://github.com/nvim-tree/nvim-web-devicons.git ~/.local/share/nvim/site/pack/plugins/start/nvim-web-devicons
