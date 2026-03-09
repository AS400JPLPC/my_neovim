#!/bin/bash

# Chemins
GIT_DIR="$HOME/GIT/my_neovim/nvim/"


# 1. Nettoyage des anciens plugins (si nécessaire)
echo "Nettoyage des anciennes version..."
if [ -d "$GIT_DIR" ]; then
    rm -rf "$GIT_DIR"
fi

# Créez un dossier pour votre configuration
mkdir -p ~/GIT/my_neovim/nvim



# Copiez votre fichier de configuration principal
cp ~/.config/nvim/init.lua ~/GIT/my_neovim/nvim/
cp ~/nvim_sav.sh ~/GIT/my_neovim/nvim/
cp ~/nvim_insatll.sh ~/GIT/my_neovim/nvim/
cp ~/.config/nvim/Neovim.png ~/GIT/my_neovim/nvim/
cp ~/.config/nvim/Tree.png ~/GIT/my_neovim/nvim/
cp ~/.config/nvim/fonction.odt ~/GIT/my_neovim/nvim/

# Sauvegardez les plugins (optionnel, car ils ne changent pas)
mkdir -p ~/GIT/my_neovim/nvim/plugins
cp -r ~/.local/share/nvim/site/pack/plugins/start/nvim-comment ~/GIT/my_neovim/nvim/plugins/
cp -r ~/.local/share/nvim/site/pack/plugins/start/ibl ~/GIT/my_neovim/nvim/plugins/
cp -r ~/.local/share/nvim/site/pack/plugins/start/nvim-lspconfig ~/GIT/my_neovim/nvim/plugins/
cp -r ~/.local/share/nvim/site/pack/plugins/start/fzf-lua ~/GIT/my_neovim/nvim/plugins/


# Script pour archiver les plugins Neovim (à placer dans ~/bin/archive_plugins)

PLUGINS_DIR="$HOME/GIT/my_neovim/nvim/plugins"
OUTPUT_DIR="$HOME/GIT/my_neovim/nvim/plugins_zip"

# Crée le dossier de sortie s’il n’existe pas
mkdir -p "$OUTPUT_DIR"

# Archive chaque plugin
tar -czvf "$OUTPUT_DIR/ibl.tar.gz" -C "$PLUGINS_DIR" ibl/
tar -czvf "$OUTPUT_DIR/nvim-comment.tar.gz" -C "$PLUGINS_DIR" nvim-comment/
tar -czvf "$OUTPUT_DIR/nvim-lspconfig.tar.gz" -C "$PLUGINS_DIR" nvim-lspconfig/
tar -czvf "$OUTPUT_DIR/fzf-lua.tar.gz" -C "$PLUGINS_DIR" fzf-lua/

echo "Archives créées dans $OUTPUT_DIR"