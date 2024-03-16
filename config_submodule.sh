#!/bin/bash

# run this script to config submodule, or just ignore it

nvim_stdpath_config="$HOME/.config/nvim"

if [ -d "$nvim_stdpath_config" ]; then
    cd "$nvim_stdpath_config" || exit
fi

if [ -d "$nvim_stdpath_config/dependencies" ];then
    rm -rf "$nvim_stdpath_config/dependencies" 
fi

mkdir "$nvim_stdpath_config/dependencies"

git config --global core.sparseCheckout true

submodule_status=$(git submodule status)

if [ -z "$submodule_status" ];then
    git submodule init
fi

submodule_file="$nvim_stdpath_config/.gitmodules"

if [ -d "$submodule_file" ]; then
    submodule_lazyvim=$(grep "dependencies/lazyvim" "$submodule_file")
    if [ -n "$submodule_lazyvim" ]; then
        git submodule add https://github.com/LazyVim/LazyVim.git dependencies/lazyvim
    fi
fi

echo "lua/lazyvim/util" > ".git/modules/dependencies/lazyvim/info/sparse-checkout"
echo "lua/lazyvim/config" >> ".git/modules/dependencies/lazyvim/info/sparse-checkout"
git submodule update

if [ -d "$nvim_stdpath_config/lua/core/lazyvim" ];then
    rm -rf "$nvim_stdpath_config/lua/core/lazyvim"
fi

if [ -d "$nvim_stdpath_config/lua/lazyvim" ];then
    rm -rf "$nvim_stdpath_config/lua/lazyvim" 
fi
ln -sf "$nvim_stdpath_config/dependencies/lazyvim/lua/lazyvim" "$nvim_stdpath_config/lua/lazyvim"

