#!/bin/bash

# Script pour extraire et installer les plugins Neovim
# Usage: ./extract_plugins

# Chemins
ORIGINE_DIR="$HOME/GIT/my_neovim/nvim/plugins_zip/"
PLUGINS_DIR="$HOME/GIT/my_neovim/nvim/plugins"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
NVIM_PLUGINS_DIR="$HOME/.local/share/nvim/site/pack/plugins/start"

# 1. Nettoyage des anciens plugins (si nécessaire)
echo "Nettoyage des anciens plugins..."
if [ -d "$PLUGINS_DIR" ]; then
    rm -rf "$PLUGINS_DIR"
fi
mkdir -p "$PLUGINS_DIR"

# 2. Extraction des plugins depuis les archives
echo "Extraction des plugins..."
if [ -f "$ORIGINE_DIR/ibl.tar.gz" ]; then
    tar -xzf "$ORIGINE_DIR/ibl.tar.gz" -C "$PLUGINS_DIR"
else
    echo "⚠️ Fichier $ORIGINE_DIR/ibl.tar.gz introuvable."
fi

if [ -f "$ORIGINE_DIR/nvim-comment.tar.gz" ]; then
    tar -xzf "$ORIGINE_DIR/nvim-comment.tar.gz" -C "$PLUGINS_DIR"
else
    echo "⚠️ Fichier $ORIGINE_DIR/nvim-comment.tar.gz introuvable."
fi

# 3. Création des dossiers de configuration Neovim
echo "Configuration des dossiers Neovim..."
mkdir -p "$NVIM_CONFIG_DIR"
mkdir -p "$NVIM_PLUGINS_DIR"

# 4. Copie de la configuration et des plugins
echo "Copie de la configuration et des plugins..."
if [ -f "$HOME/GIT/my_neovim/nvim/init.lua" ]; then
    cp "$HOME/GIT/my_neovim/nvim/init.lua" "$NVIM_CONFIG_DIR/"
else
    echo "⚠️ Fichier init.lua introuvable."
fi

if [ -d "$PLUGINS_DIR/ibl" ]; then
    cp -r "$PLUGINS_DIR/ibl" "$NVIM_PLUGINS_DIR/"
else
    echo "⚠️ Dossier ibl introuvable."
fi

if [ -d "$PLUGINS_DIR/nvim-comment" ]; then
    cp -r "$PLUGINS_DIR/nvim-comment" "$NVIM_PLUGINS_DIR/"
else
    echo "⚠️ Dossier nvim-comment introuvable."
fi

echo "✅ Installation terminée."
