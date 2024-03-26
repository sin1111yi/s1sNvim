#!/bin/bash

nvim_config_path=$1

if [ -z "$nvim_config_path" ]; then
    nvim_config_path="$HOME/.config/nvim"
fi

dependencies_path="$nvim_config_path/dependencies"

if [ ! -d "$dependencies_path/LazyVim" ]; then
 
    mkdir -p "$dependencies_path/LazyVim" && cd "$dependencies_path/LazyVim" || exit
    
    git init
    git remote add origin https://github.com/LazyVim/LazyVim.git
    git branch -m main

    git config core.sparsecheckout true
    echo "lua/lazyvim" > ".git/info/sparse-checkout"
    
    git pull origin main && wait
    
    ln -sf "$dependencies_path/LazyVim/lua/lazyvim" "$nvim_config_path/lua/lazyvim"
else
    cd "$dependencies_path/LazyVim" || exit
    git pull origin main && wait
fi
