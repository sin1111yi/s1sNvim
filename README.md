# s1sNvim

💡 Light, fast and pretty Neovim config for C series language development. Inspired by NvChad and LazyVim, high refer to LazyVim. And its profiles are also easy to understand for new vimers like me. So if you are new in neovim, I think you can also begin your neovim learning start from here.

👉 **Best regards for all the Neovim and Neovim plugins developers.**

⚠️ Issues and PRs are also welcome. Let's solve all the problems together!

## 👓 Preview

~~Coming soon~~

## ⚡️ Requirements

**I always use the lastest version of neovim and any other stuff.**

- Neovim
- Git
- a [Nerd Font](https://www.nerdfonts.com/) **_(Highly Recommanded)_**
- a **C** compiler for `nvim-treesitter`. See [here](https://github.com/nvim-treesitter/nvim-treesitter#requirements)
- **fd**, **ripgrep** for `telescope.nvim`
- `C/Cpp/Rust/...` compilers like `gcc`, `g++`, `clang`, `cargo` and so on. 

## 🚀 Installation

- Back up your own configs and datas, then clone this repo, lazy.nvim will download all the plugins for you.
- Config the option `core.sparseCheckout` with `true` of your git

```bash
cp -r ~/.config/nvim ~/.config/nvim.bak
git clone --branch ver.release https://github.com/sin1111yi/s1sNvim ~/.config/nvim

git config --global core.sparseCheckout true
```

- If your want to use the lastest but unstable version, clone branch `ver.dev` instead of `ver.release`

```bash
git clone --branch ver.dev https://github.com/sin1111yi/s1sNvim ~/.config/nvim
```

## 📖 Introduce

### 🫱 Beginning

In neovim configured by lua, neovim will load profiles begin from `init.lua` in `~/.config/nvim/`. But if you are using `$NVIM_APPNAME`, conditions are different, see [here](https://neovim.io/doc/user/starting.html).

Here are 2 folders in `~/.config/lua`, they are `core` and `plugins`.

In `core`, you can see 4 files `bootstrap.lua`, `options.lua`, `keymaps.lua`, `autocmds.lua` and 2 folders `plugins`, `util`

- Add or modify **options**, **keymaps**, **autocmds** in the corresponding files. All the profiles are loaded by `bootstrap.lua`. In this file, after lazy.nvim is installed, s1sNvim will begin to load other profiles and plugins.

- In `core/plugins/exapi.lua`, there are some APIs based on plugins to provide more functions.

- In `core/plugins/keymaps.lua`, there are some keymaps depend on plugins and exapi.

In `plugins`, there are several folders which contains different `.lua` files.

- Add or modify plugins and their options in `plugins/custom`. You can easily do that by following the same method with LazyVim. See [here](https://www.lazyvim.org/configuration/plugins). 
- You can edit `plugins/custom/custom.lua` in the way that you edit `LazyVim/starter`, see [here](https://github.com/LazyVim/starter/blob/main/lua/plugins/example.lua).

If you want to disable modules or plugins provided by s1sNvim, check `bootstrap.lua`. Here's the code, and each folder in `plugins` is a module.
 
```lua
---@class PluginsLoadOpts
local pluginsConf = {
    ---@type table<string, boolean>
    load_modules = {
        ["support"] = true,
        ["colorscheme"] = true,
        ["ui"] = true,
        ["coding"] = true,
        ["coding.support"] = true,
        ["custom"] = false,
    },

    ---@type string[]
    disbaled_plugins = {
        -- for example, uncomment this line to let lazy ignore neodev
        -- "folke/neodev.nvim",
    },

    ---@type table<string, boolean>
    extra_modules = {
        ["markdown"] = true,
        ["tree-sitter-extensions"] = true,
    }
}
}
```
For example, if you set `pluginsConf.load_modules["coding.support"]` to false, then all the `.lua` files in `plugins/coding/support` won't be loaded by lazy. If you want to disable a single plugin, just follow the comment in the above code. If you want to load extra modules like `markdown`, just add it in `extra_modules` in the way showed in above code.

### 🦾 Plugins

~~Coming soon~~

## 🏁 For Novice Developers
**_I suggest that you sholdn't use vim/nvim as you first editor, even vscode. Begin your early learning with IDE like vs or clion will makes your life better._**
