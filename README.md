# s1sNvim

**A lazy.nvim-powered Neovim configuration**
**基于 lazy.nvim 的 Neovim 配置**

Personal, modular Neovim config (formerly vim.pack — migrated to lazy.nvim in 2026-08, ADR-002). Built around folke-ecosystem plugins (which-key / snacks / trouble / bufferline) and echasnovski mini plugins, with wokamark owning the startup layout and trigger-help as the documentation browser.

个人模块化 Neovim 配置（原 vim.pack 管理，2026-08 迁移 lazy.nvim）。以 folke 系（which-key / snacks / trouble / bufferline）与 mini 系插件为核心，启动布局由 wokamark 统一管理，trigger-help 作为文档浏览器。

---

## Features / 特性

- **lazy.nvim** — 30 plugins, lazy-loaded by event / key / cmd / ft (lazy-lock.json tracked)
- **Startup layout / 启动布局** — `nvim <dir>` opens the tree left (30 cols) + a No Name edit buffer; marked workspaces restore their wokamark session (tree + content); bare `nvim` shows no tree
- **wokamark integration / 集成 wokamark** — per-directory workspace session save & restore, auto-marked on quit (`<leader>qq`), tree open/close decisions owned by wokamark
- **trigger-help integration / 集成 trigger-help** — `<leader>xh` opens a help panel; wokamark registers its command cheatsheet automatically (bilingual)
- **Bilingual keymap help / 双语键位说明** — trigger-help panels render locale-aware docs (LC_ALL > LC_MESSAGES > LANG)
- **Leader = Space / 空格为 Leader** — `mapleader`/`maplocalleader` set before lazy bootstrap
- **nvim-tree** — 30-col left tree, no netrw hijacking, hidden files shown (greyed via Comment), `q` in edit windows closes the BUFFER (split preserved)

---

## Structure / 目录结构

```
~/.config/nvim/
├── init.lua                    # load order: options → lazy → keymaps → autocmds
├── lua/
│   ├── config/
│   │   ├── options.lua         # editor options + startup globals (leaders, netrw)
│   │   ├── lazy.lua            # lazy bootstrap + setup (dev mode for sin1111yi/*)
│   │   ├── keymaps.lua         # non-Leader mappings
│   │   └── autocmds.lua        # general autocommands
│   └── plugins/                # one file per plugin (lazy specs)
│       ├── custom/             # plugin-keymaps (Leader groups), tree-root, cmp/lsp extras
│       ├── nvim-tree.lua       # tree + startup layout cooperation with wokamark
│       ├── wokamark.lua        # eager: wokamark (GitHub, dev-mode capable)
│       ├── trigger-help.lua    # eager: trigger-help docs (content md + height)
│       └── ...                 # 24 more specs
├── docs/adr/                   # architecture decision records (ADR-002 lazy migration)
├── lazy-lock.json              # locked plugin versions (tracked)
└── LICENSE                     # GPLv3
```

---

## Keymaps / 键位

Leader is `<Space>`. Groups:

| Group / 组 | Description / 说明 |
|------------|--------------------|
| `<leader>w` | window ops: split / quit / resize |
| `<leader>b` | buffer ops: next / prev / close / delete |
| `<leader>f` | find: files / buffers / grep |
| `<leader>e` | explorer: toggle tree / open dir / tree root to initial |
| `<leader>q` | quit: save-all-and-quit (`<leader>qq`) |
| `<leader>r` | settings toggles: relative line / wrap / hlsearch / colorcolumn / spell / keyword |
| `<leader>x` | trouble: quickfix / loclist; trigger-help (`<leader>xh`); diagnostics |
| `<leader>u` | undo tree |
| `<leader>t` | terminal (toggleterm) |
| surround | `(` + 5-piece surround set; `g` prefix reserved (never which-key) |
| Tab / S-Tab | alternate buffer / next buffer |
| `q` (edit window) | close current BUFFER (window stays, shows next / No Name) |

Non-Leader mappings live in `lua/config/keymaps.lua`; Leader groups in `lua/plugins/custom/plugin-keymaps.lua`.

---

## Startup behavior / 启动行为

```
nvim <new dir>      → tree (left, 30 cols) + No Name edit buffer
nvim <marked path>  → wokamark restores the workspace session (tree + content)
bare nvim           → no tree; wokamark restores its own layout if matched
edit window q       → closes the buffer, split preserved
```

The tree never decides for itself: wokamark owns `should_open_tree()` (uses `g:startup_argc` captured at VimEnter — a session restore runs `%argdel`, so live argc is unreliable).

---

## Requirements / 依赖

- Neovim **0.12+** (built-in `vim.pack` era fully retired; netrw disabled at startup)
- lazy.nvim (bootstrapped on first run)
- `$NVIM_LOCAL_PLUGINS` optional: points at local copies of `~/projects/{wokamark,trigger-help}.nvim`

---

## Plugins / 插件清单 (30)

lazy.nvim spec per plugin under `lua/plugins/`:
which-key · bufferline · snacks · trouble · toggleterm · flash · nvim-tree · lualine · catppuccin · treesitter · mason · lspconfig (nvim-lspconfig) · cmp (+ LuaSnip, cmp-buffer/path/nvim-lsp) · conform · gitsigns · comment · dressing · devicons · illuminate · mini.icons · mini.pairs · mini.surround · wokamark.nvim · trigger-help.nvim · + lazy itself

## Related / 相关仓库

- [wokamark.nvim](https://github.com/sin1111yi/wokamark.nvim) — workspace session manager (GPLv3)
- [trigger-help.nvim](https://github.com/sin1111yi/trigger-help.nvim) — help panel + register_doc API (GPLv3)

---

## License / 许可证

GPLv3 — see [LICENSE](LICENSE).
