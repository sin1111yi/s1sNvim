# ADR-002: Neovim 配置迁移 lazy.nvim

**Status**: Proposed（待用户确认 → 陆川实施）
**Author**: 沈墨轩 (Architect, 字云深)
**Date**: 2026-08-07
**Supersedes**: vim.pack 插件管理架构（`lua/config/plugins.lua` + `lua/config/loader.lua` + `nvim-pack-lock.json`，Neovim 0.12 内建）
**Stakeholders**: 用户（决策人）, 陆川 (Coder), 秦镜 (Reviewer), 章验 (Tester)
**任务级别**: IV 级（方案确认后拉陆川实施）

---

## 1. 现状摘要

### 1.1 当前架构（vim.pack 时代）

`~/.config/nvim`（git main 分支）以 Neovim 0.12 内建 `vim.pack` 管理 **29 个插件**（27 远程 + 2 本地），启动链：

```
init.lua
 ├─ vim.loader.enable()
 ├─ require('config.plugins')   # vim.pack.add() 声明 29 插件（gh() 拼 GitHub URL + local_plugins 本地源）
 ├─ require('config.util')      # try_load / set_colorscheme 辅助
 ├─ require('config.options')   # 编辑器选项 + VimEnter 目录检测（g:opened_with_dir）
 ├─ require('config.keymaps')   # 非 Leader 键位（jk/kj、nzzzv、<Esc> nohlsearch）
 ├─ require('config.loader')    # UIEnter/BufReadPost/InsertEnter/FileType 统一懒加载（packadd + require plugins/*.lua）
 └─ require('config.autocmds')  # 通用 autocmd（光标归位、yank 高亮、自动保存等）
```

插件配置位于 `lua/plugins/*.lua`（22 个文件，`try_load` 包装 + setup），键位集中声明于 `lua/plugins/custom/plugin-keymaps.lua`，机制模块在 `lua/plugins/custom/utils/`（lsp/cmp/snacks-picker/tree-root/git-head）。`nvim-pack-lock.json` 锁定 29 个插件的 commit（**不入库**，`.gitignore` 忽略，即"版本不追踪"策略）。

### 1.2 决策前提（用户 2026-08-07 已确认）

- 切 lazy.nvim，**不装别的管理器**（就 lazy.nvim）。
- 用户偏好 folke 系 + mini 系（lazy.nvim 即 folke 出品，与偏好一致）。
- **两个本地插件已发布 GitHub，本次迁移必须改为 GitHub 安装**：
  - `https://github.com/sin1111yi/wokamark.nvim`（本地源 `~/projects/wokamark.nvim` 退役）
  - `https://github.com/sin1111yi/trigger-help.nvim`（同上）
  - 两仓库本地 HEAD 与 origin/main 完全一致（已核实：`ba84137` / `c4505de`），工作区干净。
- 现有配置**零功能丢失**：d/c/l 组已删、r 组六 toggle、x 组增强（含 `<leader>xh` TriggerHelp）、w/b/f/e/q 组、surround 五件套、Tab/S-Tab、nvim-tree 30 列、vscode 风格目录打开、key-help 已退役。

### 1.3 迁移范围

| 项 | 数量 | 说明 |
|----|------|------|
| 远程插件 | 27 | catppuccin、treesitter、which-key、devicons、mini.icons、dressing、bufferline、nvim-tree、snacks、illuminate、mini.pairs、mini.surround、conform、trouble、toggleterm、flash、lspconfig、mason、mason-lspconfig、cmp、cmp-nvim-lsp、cmp-buffer、cmp-path、LuaSnip、lualine、gitsigns、Comment |
| 本地插件 | 2 | wokamark.nvim、trigger-help.nvim（改 GitHub 安装） |
| 管理器 | 1 | lazy.nvim（folke/lazy.nvim，bootstrap 克隆） |
| **合计** | **30** | 29 插件 + lazy.nvim 自身 |

### 1.4 关键事实核查（本方案依据，均已实锤）

1. **lazy.nvim `import` 不递归**（源码 `lua/lazy/core/util.lua` `M.lsmod` + `M.ls` 单层 scandir 核实）：`spec = { import = 'plugins' }` 只加载 `lua/plugins/*.lua` 顶层文件；子目录（如 `lua/plugins/custom/`）**不会被 import**，除非含 `init.lua`。→ `plugins/custom/`（plugin-keymaps + utils）**无需搬移**，仅被 spec 的 config 函数显式 `require`。
2. **wokamark 依赖 trigger-help**（源码 `lua/wokamark/init.lua` 核实）：`setup()` 内 `pcall(require, 'trigger_help')` + `register_doc({ id='wokamark', name={en,zh}, text={en,zh} })` 双语 cheatsheet。trigger-help 未加载时静默跳过（best-effort）——lazy 下用 `dependencies` 声明保证顺序。
3. **wokamark 的 VimEnter 钩子在 `plugin/wokamark.lua`**（runtime 插件脚本，随 rtp 自动 source）：`auto_restore` 挂 `VimEnter`，`auto_mark` 挂 `BufReadPost/InsertLeave/BufWritePost`，另有 `CursorHold` 钩子。→ **wokamark 必须 eager 加载**（无 lazy 触发），保证 `plugin/` 目录在 VimEnter 前上 rtp；若用 VeryLazy（UIEnter 之后）会错过 VimEnter 恢复。
4. **nvim-tree vscode 风格目录打开**：`options.lua` 在 VimEnter 早期捕获 `g:opened_with_dir`（插件会在 UIEnter 后改写 argv），nvim-tree config 在 UIEnter 后读取并补空编辑区 + `vertical resize 30`。该时序 lazy 迁移后不变（options.lua 保留在启动链，nvim-tree 走 VeryLazy）。
5. **which-key v3 stable-8 headless 验证限制**：headless 下 `wk.add` 映射延迟注册（vim.schedule），`maparg` 全 false——键位回归须用真实 UI 手测（详见第 8 决策点）。
6. **两本地插件无 `plugin/` 目录的是 trigger-help**（命令在 `setup()` 里创建），故 trigger-help 可纯命令触发；但作为 wokamark 的 dep 实际启动即载，体积小（6 个模块），eager 无成本。

---

## 2. 目标架构

### 2.1 目录树

```
~/.config/nvim/
├── init.lua                          # 入口：vim.loader.enable() → lazy bootstrap（首行）→ 核心配置
├── .gitignore                        # 删 nvim-pack-lock.json 条目；lazy-lock.json 提交入库
├── lazy-lock.json                    # lazy.nvim 自动生成，提交（替代 nvim-pack-lock.json）
├── docs/
│   ├── adr/002-lazy-migration.md     # 本文档
│   └── trigger-help.nvim/*.md        # 保留（用户手写内容文档，路径 stdpath('config') 引用不变）
└── lua/
    ├── config/
    │   ├── lazy.lua                  # 【新增】lazy.nvim bootstrap + setup opts（dev/install/checker）
    │   ├── options.lua               # 【保留】编辑器选项 + VimEnter 目录检测（g:opened_with_dir）
    │   ├── keymaps.lua               # 【保留】非 Leader 键位（jk/kj、nzzzv、<Esc> nohlsearch）
    │   ├── autocmds.lua              # 【保留】通用 autocmd（零插件依赖）
    │   ├── plugins.lua               # 【删除】vim.pack 声明
    │   ├── loader.lua                # 【删除】UIEnter 统一懒加载（lazy 原生接管）
    │   └── util.lua                  # 【删除】try_load/set_colorscheme（lazy 保证加载时序，不再需要）
    ├── plugins/                      # 【改造】每插件一个 lazy spec 文件（import 'plugins' 顶层扫描）
    │   ├── bufferline.lua            #    bufferline.nvim（deps: nvim-web-devicons）
    │   ├── catppuccin.lua            #    catppuccin/nvim
    │   ├── comment.lua               #    Comment.nvim
    │   ├── conform.lua               #    conform.nvim
    │   ├── cmp.lua                   #    nvim-cmp + LuaSnip + cmp-buffer + cmp-path + cmp-nvim-lsp（spec 列表）
    │   ├── devicons.lua              #    nvim-web-devicons
    │   ├── dressing.lua              #    dressing.nvim
    │   ├── flash.lua                 #    flash.nvim
    │   ├── gitsigns.lua              #    gitsigns.nvim
    │   ├── illuminate.lua            #    vim-illuminate
    │   ├── lsp.lua                   #    nvim-lspconfig（deps: mason, mason-lspconfig, cmp-nvim-lsp）
    │   ├── lualine.lua               #    lualine.nvim
    │   ├── mason.lua                 #    mason.nvim + mason-lspconfig.nvim（spec 列表）
    │   ├── mini-icons.lua            #    mini.icons
    │   ├── mini-pairs.lua            #    mini.pairs
    │   ├── mini-surround.lua         #    mini.surround
    │   ├── nvim-tree.lua             #    nvim-tree.lua
    │   ├── snacks.lua                #    snacks.nvim
    │   ├── toggleterm.lua            #    toggleterm.nvim（cmd = 'ToggleTerm'）
    │   ├── treesitter.lua            #    nvim-treesitter（build = ':TSUpdate'）
    │   ├── trigger-help.lua          #    sin1111yi/trigger-help.nvim（GitHub 安装，eager）
    │   ├── trouble.lua               #    trouble.nvim
    │   ├── which-key.lua             #    which-key.nvim（config 内注册全部键位组）
    │   └── wokamark.lua              #    sin1111yi/wokamark.nvim（deps: trigger-help.nvim，eager）
    └── plugins/custom/               # 【保留原位】不被 import 递归（已核实），仅被 config 显式 require
        ├── plugin-keymaps.lua        #    wk.add 全部键位组 + Tab/S-Tab + cmp_map（内容零改动）
        └── utils/
            ├── lsp.lua               #    LspAttach 键位应用器
            ├── cmp.lua               #    cmp mapping builder
            ├── snacks-picker.lua     #    picker 入口包装
            ├── tree-root.lua         #    nvim-tree root 助手
            └── git-head.lua          #    bufferline offset 的 git 头缓存
```

### 2.2 文件职责

| 文件 | 职责 | 变化 |
|------|------|------|
| `init.lua` | 入口。`vim.loader.enable()` → `require('config.lazy')`（首行，lazy 先于一切）→ `config.options` / `config.keymaps` / `config.autocmds` | 重写（从"plugins 声明先行"改为"lazy bootstrap 先行"） |
| `lua/config/lazy.lua` | bootstrap：克隆 lazy.nvim 到 `stdpath('data')/lazy/lazy.nvim` → prepend rtp → `lazy.setup({ spec = { import = 'plugins' }, dev = {...}, install = {...}, checker = {...} })` | 新增 |
| `lua/plugins/*.lua`（24 个） | 每个文件返回一个 lazy spec（表或列表），config 字段 = 现 `plugins/*.lua` 的 setup 体原样搬入 | 改造（try_load 包装 → spec 表） |
| `lua/plugins/custom/*` | 键位注册 + 机制模块，由 which-key/cmp/gitsigns/bufferline 等 config 显式 require | 保留（零改动） |
| `lua/config/*` | options/keymaps/autocmds 三件套无插件依赖，原样保留 | 保留 |
| `lazy-lock.json` | 29 插件 commit 锁（lazy 自动维护），**提交入库** | 新增 |
| `nvim-pack-lock.json` | vim.pack 锁文件 | 验证通过后删除 |
| `~/.local/share/nvim/site/pack/` | vim.pack 安装目录（opt/ 下 29 个克隆） | 验证通过后删除（回滚期内保留） |

### 2.3 启动时序（lazy 化后）

```
init.lua
 └─ require('config.lazy')
     ├─ git clone lazy.nvim（首次）→ rtp prepend
     └─ lazy.setup({ spec = { import 'plugins' } })
         ├─ 解析 24 个 spec 文件（modname 字母序处理，加载按事件）
         ├─ eager 插件同步加载：wokamark（deps 先载 trigger-help → 其 config 先跑 → wokamark setup
         │   → require('trigger_help').register_doc 双语成功）
         │   ※ wokamark 的 plugin/wokamark.lua 随之 source → 注册 VimEnter/BufReadPost/CursorHold 钩子
         └─ 事件就绪（VeryLazy/cmd/event 触发器挂好）
 ├─ require('config.options')   # VimEnter 目录检测注册（g:opened_with_dir 捕获点）
 ├─ require('config.keymaps')   # mapleader 设置（which-key VeryLazy 时才读，时序安全）
 └─ require('config.autocmds')
        │
 VimEnter ──▶ wokamark.auto_restore（路径哈希匹配恢复）+ options 目录检测（argv[0] 是目录 → cd + opened_with_dir）
        │
 UIEnter ──▶ lazy VeryLazy 批次：catppuccin 配色 → lualine/dressing/bufferline/snacks/trouble/conform/
        │    flash/mini.*/illuminate/which-key（→ 注册全部键位组）/nvim-tree（argc>0 自动开树，读 opened_with_dir）
        │
 首次输入 ──▶ InsertEnter → nvim-cmp（deps 先载 which-key/LuaSnip/cmp-*）
 首个文件 ──▶ BufReadPost/BufNewFile → treesitter / gitsigns / Comment
 首个 BufReadPre ──▶ lspconfig（deps 先载 mason/mason-lspconfig/cmp-nvim-lsp）
 :ToggleTerm ──▶ cmd 触发 toggleterm
```

**与现状的时序差异**（均无感/等价）：

| 项 | 现状（vim.pack） | 目标（lazy.nvim） | 影响 |
|----|------------------|-------------------|------|
| 配色 | UIEnter | VeryLazy（UIEnter 后一个 idle 周期） | 无感（毫秒级） |
| nvim-tree 开树 | UIEnter | VeryLazy | 无感；`g:opened_with_dir` 读取时序不变 |
| wokamark 恢复 | 启动 packadd + VimEnter 钩子 | eager 加载 + 同一 VimEnter 钩子 | **完全等价**（关键约束） |
| cmp | InsertEnter once | InsertEnter + deps | 等价（首次进插入模式即载） |
| treesitter/gitsigns/Comment | BufReadPost once | BufReadPost/BufNewFile | 等价（多覆盖 BufNewFile，更完整） |
| LSP | FileType 首匹配 | BufReadPre/BufNewFile | 略早于现状（更标准），无感知 |

---

## 3. 决策记录（8 决策点逐项定案）

### D-001 目录结构：保留 `lua/plugins/` 骨架 + `lua/config/lazy.lua` bootstrap

**选择**：`lua/plugins/*.lua` 每插件一文件（spec 表）+ `lua/config/lazy.lua`（bootstrap + setup opts），`lua/plugins/custom/` **保留原位**。

**理由**：
- 与用户 SRP 偏好一致（wokamark/trigger-help 刚拆完模块）；每插件一文件 = 一个职责单元。
- 现有 22 个 `lua/plugins/*.lua` 文件名与插件一一对应，**骨架零搬移**，只改每个文件的"壳"（try_load 包装 → spec 表），setup 体原样保留——迁移 diff 最小、审查最易。
- `import 'plugins'` 顶层扫描已从 lazy.nvim 源码核实（`M.lsmod`/`M.ls` 单层 scandir），`custom/` 子目录不会被当作 spec 解析（否则 `plugin-keymaps.lua` 返回的 `{ cmp_map = ... }` 会被误判为 spec 报"No URL"）。custom/ 仅由 spec 的 config 函数显式 require——职责清晰：**spec 目录 = 插件声明，custom/ = 键位与机制**。
- bootstrap 独立成 `config/lazy.lua`：init.lua 保持 5 行入口，dev/install/checker 等 setup opts 集中一处。

**备选被否**：
- ❌ 单文件 `lua/plugins.lua` 塞 30 个 spec：违反 SRP，与用户刚完成的模块化方向背道而驰，diff 大、冲突面大。
- ❌ `custom/` 移出 plugins/（如 `lua/custom/`）：需要同步改 8 处 `require('plugins.custom...')` 路径（plugin-keymaps、cmp、gitsigns、bufferline、nvim-tree 等），纯机械 churn，且实测 import 不递归后**没有必要**。

### D-002 spec 来源：保留现有 `plugins/` 文件改造，迁移期 commit 锁版本

**选择**：不新建、不推倒重写——**改造现有 22 个文件 + 新增 2 个**（wokamark.lua、mason.lua）；每个 spec 初始带 `commit = '<nvim-pack-lock.json 里的 rev>'`（29 个全部锁当前版本），**验证通过后移除全部 commit 字段**，交 lazy-lock.json 管理。

**理由**：
- 现 setup 体（trouble 显式 mode、flash jump_labels、mini.surround 五件套映射、lualine auto 主题、nvim-tree 30 列 + vscode 打开逻辑、conform formatters、lsp 服务器配置、mason ensure_installed）**逐字保留**，只换外壳——这是"零功能丢失"的工程保证。
- 迁移期 commit 锁：29 个插件**同一批换安装机制**，若同时跳到最新版，27 个上游的任意破坏性变更都会混入"迁移"这一变量，无法定位回归来源。锁住现有 rev 后，唯一变量 = 管理器本身，回归清单的结论才有意义。
- 验证通过后解锁：长期 commit 锁 = 手动升级成本（每个插件每次升级都要改文件）；lazy-lock.json 是 lazy 的原生锁定机制（`:Lazy update` 原子更新全部 lock），与 `commit` 字段职责重复。解锁后 `lazy-lock.json` 记的就是当前装的 commit，可复现性不丢。
- 两本地插件同理锁 `ba84137`（wokamark）/ `c4505de`（trigger-help），恰好 == origin/main HEAD，解锁后即跟踪 GitHub 上游。

**备选被否**：
- ❌ 不锁直接装最新：27 个插件同时跳版本，回归无法归因（见上）。
- ❌ 长期 commit 锁：与 lazy-lock.json 机制重复，升级体验差；lazy 官方也建议 branch（默认 main）为主。

### D-003 懒加载策略：lazy 原生触发器替代 UIEnter 统一懒加载

**选择**：按插件实际调用方式选触发器，原则如下：

| 原则 | 适用 | 对应现状 |
|------|------|----------|
| **eager（无触发）** | 启动时必须就位、或 setup 期有跨插件 require 的插件 | packadd + setup 于启动 |
| **`event = 'VeryLazy'`** | 所有"UIEnter 加载、且被键位闭包 `require()` 调用"的 UI 插件 | UIEnter |
| **`cmd = '...'`** | 键位全是 `:命令` 形式、无闭包 require 的插件 | UIEnter（更懒，等价） |
| **`event = { 'BufReadPost', 'BufNewFile' }`** | 文件打开期插件 | BufReadPost once |
| **`event = 'InsertEnter'`** | 补全 | InsertEnter once |
| **`event = { 'BufReadPre', 'BufNewFile' }`** | LSP | FileType 首匹配 |
| **`dependencies`** | 跨插件 require 顺序（不设触发，随父加载） | loader 顺序约定 |

**29 插件触发器一览**：

| 插件 | 触发器 | 理由（对照现状） |
|------|--------|------------------|
| wokamark.nvim | **eager** + deps `trigger-help.nvim` | `plugin/wokamark.lua` 的 VimEnter 钩子必须在启动期上 rtp（见 1.4-3）；auto_restore/auto_mark 行为不变 |
| trigger-help.nvim | **eager**（无触发） | wokamark setup 的 `require('trigger_help').register_doc` 依赖（见 1.4-2）；:TriggerHelp 立即可用；体积小（6 模块） |
| which-key.nvim | `VeryLazy` | 等价 UIEnter；config 内 `wk.setup` + `require('plugins.custom.plugin-keymaps')`（全部键位组同一处注册，顺序 setup→add 不变） |
| catppuccin | `VeryLazy` | 等价 UIEnter；config 内 setup + `vim.cmd.colorscheme('catppuccin-mocha')` |
| lualine.nvim | `VeryLazy` | 等价 UIEnter（theme 'auto' 无竞态） |
| dressing.nvim | `VeryLazy` | 等价 UIEnter |
| bufferline.nvim | `VeryLazy` + deps `nvim-web-devicons` | 等价 UIEnter；offset 的 `get_element_icon` 需 devicons 在 rtp |
| nvim-web-devicons | `VeryLazy` | 等价 UIEnter（bufferline 走 deps，其余消费者 pcall 容忍） |
| mini.icons | `VeryLazy` | 等价 UIEnter（lazy by design，require 即够） |
| snacks.nvim | `VeryLazy` | 等价 UIEnter；`<leader>ff/fb/fg/xg/xl/bd` 闭包 `require('snacks.*')` 需 rtp 就位 |
| trouble.nvim | `VeryLazy` | 等价 UIEnter；`<leader>xx/xq/xL` 闭包 `require('trouble')`（lazy 的 keys 机制管不到已注册闭包，只能保证插件已载） |
| conform.nvim | `VeryLazy` | 等价 UIEnter；format_on_save 需在首次 BufWritePre 前就位 |
| flash.nvim | `VeryLazy` | 等价 UIEnter；保证 f/F/t/T 的 jump_labels 从启动即生效（若 keys='s' 触发，首次按 f 会退化为原生行为） |
| mini.pairs | `VeryLazy` | 等价 UIEnter；首次 InsertEnter 前已 setup，配对即刻生效 |
| mini.surround | `VeryLazy` | 等价 UIEnter（`(s/(d/(r/(f/(F` 五件套不变） |
| vim-illuminate | `VeryLazy` | 等价 UIEnter |
| nvim-tree.lua | `VeryLazy` | 等价 UIEnter；config 内 argc>0 自动开树 + `opened_with_dir` vscode 逻辑原样搬入 |
| nvim-treesitter | `event = { 'BufReadPost', 'BufNewFile' }` + `build = ':TSUpdate'` | 等价 BufReadPost once；build 保证首次安装即拉 parser（auto_install 保留） |
| gitsigns.nvim | `event = { 'BufReadPost', 'BufNewFile' }` | 等价 BufReadPost once；git 信息缓存/bufferline 联动代码原样 |
| Comment.nvim | `event = { 'BufReadPost', 'BufNewFile' }` | 等价 BufReadPost once |
| nvim-cmp | `event = 'InsertEnter'` + deps `{which-key, LuaSnip, cmp-buffer, cmp-path}` | 等价 InsertEnter once；deps 中 which-key 保证 `plugin-keymaps.cmp_map` 可 require（消除理论竞态） |
| LuaSnip | cmp 的 dep（随 cmp 载） | 现状同 |
| cmp-buffer / cmp-path | cmp 的 dep | 现状同 |
| cmp-nvim-lsp | lspconfig 的 dep | lsp.lua config 内 `require('cmp_nvim_lsp')` |
| nvim-lspconfig | `event = { 'BufReadPre', 'BufNewFile' }` + deps `{mason, mason-lspconfig, cmp-nvim-lsp}` | 等价 FileType 首匹配（略早，更标准）；config = 现 lsp.lua 主体 |
| mason.nvim | lspconfig 的 dep（随 LSP 载） | 现状同（ensure_installed 四项保留） |
| mason-lspconfig.nvim | lspconfig 的 dep | 现状同（automatic_installation 保留） |

**理由**（通用）：`VeryLazy` 是 lazy.nvim 对"UIEnter 后尽快"的官方语义，与现状 UIEnter 加载**行为等价**且无感；cmd 触发比 UIEnter 更懒（首按才载），对 toggleterm 这类纯命令插件是净收益；被闭包 `require` 的插件一律 VeryLazy——**lazy 的 keys/cmd 机制只在"映射本身由 spec 定义"时才能提前加载插件，管不到已注册闭包内的 require**，这是本决策的硬约束。

**备选被否**：
- ❌ 全部 VeryLazy 一刀切：treesitter/gitsigns/Comment/cmp/LSP 会拖到 UIEnter 后才载，丢失"文件打开期即就位"语义，且违背 lazy 事件模型。
- ❌ 全部 eager：29 个插件启动全载，lazy 的懒加载价值归零，启动时间劣于现状。
- ❌ trouble/toggleterm 用 `keys = { '<leader>xx' }` 之类：与 plugin-keymaps 已注册的映射重复/冲突，且闭包 require 语义下 keys 机制无效（见上）。

### D-004 本地插件：GitHub 安装为主，lazy dev 模式支持开发

**选择**：spec 直接写 GitHub 源（`'sin1111yi/wokamark.nvim'` / `'sin1111yi/trigger-help.nvim'`，SSH 与 HTTPS 均可，lazy 自动处理）；`config/lazy.lua` 声明 `dev = { path = '~/projects', patterns = { 'github.com/sin1111yi/' }, fallback = true }`，默认关闭，开发时 `:Lazy dev` 一键切换。

**理由**：
- 消费端走 GitHub：仓库干净（无本机路径依赖）、可复现（别人 clone 即用）、与"本地源退役"的迁移目标一致。
- `dev.patterns` 匹配机制已从源码核实（`plugin.url:find(pattern, 1, true)` 明文子串匹配），`github.com/sin1111yi/` 命中两插件；`dev.path .. '/' .. plugin.name` == `~/projects/wokamark.nvim`，**与现有开发目录完全吻合**，`fallback = true` 保证目录不存在时回退 GitHub 安装。
- 开发流：`:Lazy dev`（或 `lazy dev` 配置为 true）→ 插件直接加载 `~/projects/*` 源码，改完即生效（无需重新安装）；改完 push GitHub 后 `:Lazy dev` 关闭，消费端回到锁定的 lazy-lock 版本。`~/projects` 两仓库的 origin 已是 GitHub，`git pull` 即可同步。
- 行为约束：dev 模式下 lazy-lock.json **不追踪**该插件（锁的是 GitHub 安装的 commit）——文档化即可，无实际影响。

**备选被否**：
- ❌ 只走 GitHub、不配 dev：用户日常开发两插件，每次迭代都要 push 才能测，开发流断裂。
- ❌ 只走 `~/projects`（dev 常开）：他人 clone 配置即失效，违背"GitHub 安装"的迁移硬要求。
- ❌ 环境变量 `NVIM_LOCAL_PLUGINS` 继续生效：旧机制的残留，随 `plugins.lua` 一起退役。

### D-005 loader 退役：删三件套，custom/ 保留

**选择**：删除 `lua/config/plugins.lua`、`lua/config/loader.lua`、`lua/config/util.lua`（try_load/set_colorscheme 均被 lazy 加载保证取代）；`lua/plugins/custom/`（plugin-keymaps + utils）**保留原位、内容零改动**。

**理由**：
- `try_load` 的存在意义是"插件可能没装/没加载时优雅跳过"——lazy 保证 config 运行时插件必已加载，pcall 噪音消失；`set_colorscheme` 的 UIEnter 重试逻辑被 `install.colorscheme`（首次安装） + config 内直接 `colorscheme`（VeryLazy 时插件已就位）取代。
- loader 的 UIEnter 事件表整体映射为 lazy 触发器（D-003 表），职责移交；`packadd` 两行由 `dependencies` 取代。
- custom/ 保留的原因见 D-001：import 不递归 + 显式 require 契约。plugin-keymaps 是"全部键位组集中声明"的既定设计（用户刚定案的 SRP 形态），迁移不动它 = 键位回归面为零。

**备选被否**：
- ❌ plugin-keymaps 拆成 each-plugin 内联键位：推翻用户刚完成的集中式键位设计，29 个插件键位散落，审查/维护成本剧增。
- ❌ custom/ 移出 plugins/：纯 churn（见 D-001 备选）。

### D-006 启动顺序：lazy bootstrap 首行，VimEnter 时序不受影响

**选择**：init.lua 顺序为 `vim.loader.enable()` → `require('config.lazy')`（**首行**，内部 `lazy.setup`）→ `require('config.options')` → `require('config.keymaps')` → `require('config.autocmds')`。

**理由**：
- lazy 必须最先 setup：spec 解析、eager 插件加载、事件触发器注册都在此完成；options/keymaps/autocmds 三件套无插件依赖，放后面安全。
- **VimEnter 时序逐项核对（零破坏）**：
  - `options.lua` 目录检测：init.lua 全程在 VimEnter 前执行完，autocmd 注册必然及时；`g:opened_with_dir` 捕获点不变。
  - wokamark `auto_restore`：eager 加载 → `plugin/wokamark.lua` 在 startup 期 source → VimEnter 钩子注册于事件前（见 2.3 时序图）。**这是"wokamark 行为不变"的关键路径**，故 wokamark 不用 VeryLazy（VeryLazy 在 UIEnter 后，会错过 VimEnter）。
  - nvim-tree `opened_with_dir`：读取发生在 VeryLazy（UIEnter 后），`g:opened_with_dir` 早在 VimEnter 已设，无竞态。
  - lazy.nvim 自身不改写 argv、不碰 VimEnter 目录语义（它只挂自己的 UIEnter 用于 VeryLazy 调度）。
- `keymaps.lua` 的 `mapleader` 在 lazy 之后设置无碍：which-key 的 setup 在 VeryLazy 才执行，读到的必是最终值。

**备选被否**：
- ❌ 三件套放 lazy 之前：无实际收益，且任何插件若在 eager 期读选项（如 nvim-tree 的 netrw 变量虽然自身会设，但作为通用约束不可靠）存在理论时序依赖；lazy 官方模板即"bootstrap 先行"。

### D-007 版本管理：lazy-lock.json 入库，替代 nvim-pack-lock.json

**选择**：`lazy-lock.json` **提交入 git**（现 `.gitignore` 删掉 `nvim-pack-lock.json` 条目，lazy-lock 默认不忽略）；`nvim-pack-lock.json` 在验证通过后删除。

**理由**：
- 现"锁文件不入库"是 vim.pack 时代的策略（`.gitignore` 注释明言）；切 lazy 后改为**锁版本并入库**：29 插件 + 迁移后的配置形成可复现快照，多机/回滚/他人 clone 行为一致。
- lazy-lock.json 是 lazy 原生机制：`require('lazy').lock()` 在每次 install/update 后自动重写，零手工维护；回滚 = `git checkout 旧 lock` + `:Lazy restore`。
- 更新节奏与用户偏好一致：`checker.enabled = false`（关掉每周自动检查提醒），**显式 `:Lazy update` 才升级**，升级前可先看 lazy-lock diff 决定。

**备选被否**：
- ❌ 继续不追踪锁文件：多机/回滚不可复现，与 lazy 生态惯例（官方推荐提交 lock）相悖。
- ❌ 继续用 nvim-pack-lock.json：vim.pack 已退役，双锁文件混乱。

### D-008 验证：headless 启动链 + 29 插件加载计数 + 键位/行为回归清单

**选择**：章验执行三层验证——（1）headless 启动链零报错；（2）30 插件加载计数与关键模块断言；（3）真实 UI 键位与行为回归清单（含 wokamark/trigger-help 双插件行为）。

**理由**：迁移的验收标准是"零功能丢失"，而 vim.pack→lazy 的本质风险在**加载时机与顺序**，故验证必须同时覆盖"机制层（能加载）"与"行为层（不退化）"。

**验证方案**：

```
① headless 启动链（退出码 + 无报错）:
   nvim --headless -c 'qa'                    # exit 0
   nvim --headless +'Lazy! sync' +qa          # 首次安装 29+1 插件（非交互）

② 30 插件加载断言（脚本化）:
   nvim --headless +"lua
     local s = require('lazy').stats()
     print('loaded=' .. s.loaded .. ' installed=' .. s.installed)  -- 期望 30/30
     -- package.loaded 逐插件断言：wokamark / trigger_help / cmp / lspconfig /
     --   mason / mason-lspconfig / cmp_nvim_lsp / luasnip / which-key / snacks /
     --   nvim-tree / trouble / toggleterm / conform / flash / mini.pairs /
     --   mini.surround / mini.icons / nvim-web-devicons / bufferline / lualine /
     --   gitsigns / Comment / illuminate / catppuccin / nvim-treesitter.configs
     -- 关键状态：vim.g.trigger_help_loaded（trigger-help setup 幂等标记）、
     --   vim.g.colors_name == 'catppuccin-mocha'（VeryLazy 后）
   " +qa
   nvim --headless +"lua vim.defer_fn(function() vim.cmd('qa') end, 1500)"  # 等 VeryLazy 批次

③ VimEnter/UIEnter 链（脚本化）:
   nvim --headless +"lua vim.defer_fn(function()
     print(vim.g.opened_with_dir)  -- 目录打开时为 true
     vim.cmd('qa') end, 800)" ~/some/dir          # vscode 风格：树 + 空编辑区 + 30 列
   nvim --headless +"lua vim.defer_fn(function()
     print(vim.fn.exists(':TriggerHelp'))         -- 3
     print(vim.fn.exists(':NvimTreeToggle'))      -- 2（cmd 触发类在 headless 可查）
     vim.cmd('qa') end, 800)"
   # wokamark auto_restore：在已标记 workspace 内 headless 打开，断言恢复（buffer 集/标志位）

④ 真实 UI 手测清单（which-key v3 stable-8 headless 下 maparg 全 false——
   见 1.4-5，wk 注册键位只能真实 UI 验证）:
   - [ ] w/b/f/e/q 全部组、r 组六 toggle（rn/rw/rh/rc/rs/rk）
   - [ ] x 组：xf 格式化、xx/xq/xL trouble 三件（空列表守卫 notify）、xh TriggerHelp
   - [ ] t 组：tt/tv/tf 三方向 toggleterm
   - [ ] Tab / S-Tab bufferline 循环
   - [ ] surround 五件套：(s/(d/(r/(f/(F
   - [ ] flash：f/F/t/T 标签跳转（jump_labels）
   - [ ] nvim-tree：30 列、dotfiles 显示、j/k/h/l/CR 导航、<leader>ed/er
   - [ ] `nvim <dir>`：树 + 空编辑区 + 焦点在编辑区（vscode 风格）
   - [ ] cmp：Tab/S-Tab 选择、CR 确认、luasnip 展开
   - [ ] wokamark：自动标记、WokaMark 命令组、恢复后 buffer 布局
   - [ ] trigger-help：:TriggerHelp toggle/picker、:TriggerHelp <name> 直开、
   -     wokamark cheatsheet 双语（zh/en）出现在 picker（register_doc 生效证明）

⑤ 启动耗时对照: nvim --headless --startuptime /tmp/before.log +qa 与迁移后 after.log 对比
```

**备选被否**：
- ❌ 只做 headless 脚本验证：which-key v3 的 maparg 限制（1.4-5）决定了键位层必须真实 UI 手测，脚本化会给出"全 false"的假阴性。
- ❌ 只做手测：29 插件加载计数、启动链退出码这类机制层问题脚本化更可靠、可复现。

---

## 4. 迁移步骤（分阶段实施）

> 实施人：陆川；每阶段完成即编译/启动验证（`nvim --headless -c 'qa'` 零报错）；秦镜审查通过才进下一阶段。

### Phase 0 准备（工作量 ~0.5h）

1. `git checkout -b feat/lazy-migration`（独立分支，main 不受影响）。
2. 导出 `nvim-pack-lock.json` 29 个 rev 到迁移对照清单（spec 的 commit pin 抄写源）。
3. 确认网络可克隆 lazy.nvim（`git ls-remote https://github.com/folke/lazy.nvim`）。

### Phase 1 bootstrap（工作量 ~0.5h）

1. 新建 `lua/config/lazy.lua`（标准 bootstrap 片段）：
   ```lua
   local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
   if not vim.uv.fs_stat(lazypath) then
     vim.fn.system({ 'git', 'clone', '--filter=blob:none',
       'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath })
   end
   vim.opt.rtp:prepend(lazypath)
   require('lazy').setup({
     spec = { { import = 'plugins' } },
     dev = { path = '~/projects', patterns = { 'github.com/sin1111yi/' }, fallback = true },
     install = { colorscheme = { 'catppuccin-mocha' } },  -- 首次安装 UI 不闪默认主题
     checker = { enabled = false },                        -- 显式 :Lazy update 才升级（D-007）
     change_detection = { notify = false },
   })
   ```
2. `init.lua` 改为：`vim.loader.enable()` → `require('config.lazy')` → options/keymaps/autocmds（loader/plugins/util 的 require 先注释掉）。
3. 验证：`nvim` 能进（空 spec 下 lazy 面板可用，`<leader>` 未绑定无碍）。

### Phase 2 spec 重写（工作量 ~4h，主体）

1. 按 D-002 对照清单，将 22 个 `lua/plugins/*.lua` 从 try_load 包装改为 spec 表；setup 体原样搬入 `config` 字段；`commit = '<rev>'` 逐个落 pin。
2. 新增 `lua/plugins/wokamark.lua`（eager + deps trigger-help + `auto_mark = true` setup）与 `lua/plugins/mason.lua`（mason + mason-lspconfig spec 列表）。
3. `cmp.lua` 返回 spec 列表（nvim-cmp + LuaSnip + cmp-buffer + cmp-path + cmp-nvim-lsp），按 D-003 表配 deps。
4. `lsp.lua` 精简为 lspconfig spec（mason 部分移入 mason.lua，config 内 `require('cmp_nvim_lsp')` 由 deps 保证）。
5. `which-key.lua` spec 的 config 内：`wk.setup(现配置)` + `require('plugins.custom.plugin-keymaps')`（键位注册入口不变）。
6. 验证：`nvim --headless +'Lazy! sync' +qa` 装齐 30 个；`nvim --headless -c 'qa'` 零报错；`nvim` 起真实 UI 冒烟。

### Phase 3 loader 退役（工作量 ~0.5h）

1. 删除 `lua/config/plugins.lua`、`lua/config/loader.lua`、`lua/config/util.lua`；init.lua 同步清理注释掉的 require。
2. `.gitignore` 删 `nvim-pack-lock.json` 条目（lazy-lock.json 提交）。
3. `nvim-pack-lock.json` **暂不删**；`~/.local/share/nvim/site/pack/core/opt/` **暂不删**（回滚保险，见 §5）。
4. 验证：重复 D-008 ①②，确认无 `require('config.loader')` / `config.util` 残留引用（`grep -rn "config.loader\|config.util\|config.plugins" lua/` 为空）。

### Phase 4 验证与解锁（工作量 ~2h，章验主导）

1. 章验执行 D-008 全清单（headless 链 + 30 插件断言 + VimEnter 链 + 真实 UI 手测 + 启动耗时）。
2. 全部通过 → 移除 29 个 spec 的 `commit` 字段；`:Lazy sync` 确认 lazy-lock.json 记录当前 commit；提交 lazy-lock.json。
3. 清理：删除 `nvim-pack-lock.json` + `~/.local/share/nvim/site/pack/`（vim.pack 残留）。
4. 秦镜审查通过 → 合并 main，用户验收。

### Phase 5 收尾（工作量 ~0.5h）

1. 更新 `neovim-config` skill（vim.pack 文档 → lazy.nvim 架构，含本迁移的坑位沉淀）。
2. 复盘（评估校准 + 知识沉淀），按 liuchu 流程。

**Commit 拆分**（每 commit 独立可构建，遵循工作室 Git 规范）：
1. `feat(nvim): add lazy.nvim bootstrap (config/lazy.lua + init.lua)` — Phase 1
2. `feat(nvim): rewrite 24 plugin specs for lazy.nvim with pinned commits` — Phase 2
3. `refactor(nvim): retire vim.pack loader (plugins.lua/loader.lua/util.lua)` — Phase 3
4. `chore(nvim): commit lazy-lock.json, drop commit pins, remove vim.pack artifacts` — Phase 4
5. `docs(nvim): ADR-002 lazy.nvim migration` — 本文档随迁移落地

---

## 5. 风险与回滚

### 5.1 风险矩阵

| 风险 | 概率 | 影响 | 缓解 |
|------|------|------|------|
| 29 插件同批跳版本引入上游破坏 | 中 | 高 | Phase 2 全部 commit pin（D-002），验证期唯一变量 = 管理器本身；解锁后 lazy-lock diff 可见 |
| wokamark 错过 VimEnter（auto_restore 失效） | 低 | 高 | wokamark/trigger-help eager + deps 声明（D-003），Phase 4 专项断言 + 手测恢复 |
| trigger-help register_doc 静默跳过（cheatsheet 消失） | 低 | 中 | wokamark deps 强制加载顺序；手测 `:TriggerHelp wokamark` 双语出现 |
| VeryLazy 与 UIEnter 语义差异 | 低 | 低 | 仅配色/开树晚一个 idle 周期，无感；时序核对表见 §2.3 |
| which-key v3 headless maparg 假阴性 | 确定 | 中 | D-008 明确键位层走真实 UI 手测，脚本层不查 wk 键位 |
| 闭包 require 的插件未载导致按键报错 | 低 | 高 | D-003 硬约束：闭包 require 插件一律 VeryLazy（trouble/snacks/conform/tree-root 等） |
| cmp 在 which-key 前触发（cmp_map require 失败） | 极低 | 中 | cmp deps 显式含 which-key（D-003），竞态消除 |
| dev 模式误开导致消费端加载 ~/projects 旧码 | 低 | 低 | dev 默认 false；`:Lazy dev` 显式切换；文档化 |
| lazy 首次 clone 失败（网络） | 低 | 中 | bootstrap 标准片段 + Phase 0 网络预检 |
| 旧 vim.pack 目录残留占盘 | 确定 | 低 | Phase 4 验证后统一清理（回滚期内故意保留） |

### 5.2 回滚策略（两阶段窗口）

- **验证期（Phase 4 通过前）**：`nvim-pack-lock.json` 与 `~/.local/share/nvim/site/pack/core/opt/` **原样保留**。回滚 = `git checkout main`（迁移分支未合并，main 本就是 vim.pack 版）→ vim.pack 生态（声明、lock、安装目录）完整可用，**秒级回滚、零损失**。
- **验证通过、清理完成后**：回滚 = `git revert` 迁移 commit（或 checkout 旧 commit）+ `:Lazy restore`（按 lazy-lock.json 恢复插件 commit）。此时 vim.pack 残留已清，若需彻底回退 vim.pack 需重跑 `vim.pack.update()` 重装（可接受，属灾难级回退）。
- lazy-lock.json 入库后，任何时刻的插件级回退 = `git checkout <旧> -- lazy-lock.json` + `:Lazy restore`。

---

## 6. Decision Log

| ID | 决策 | 理由 |
|----|------|------|
| D-001 | `lua/plugins/*.lua` 每插件一 spec + `config/lazy.lua` bootstrap；custom/ 原位保留 | SRP 一致；import 顶层扫描已核实；迁移 diff 最小 |
| D-002 | 改造现有文件；迁移期 commit pin（抄 nvim-pack-lock.json），验证后解锁交 lazy-lock | 唯一变量原则；长期 commit 锁与 lock 机制重复 |
| D-003 | 原生触发器替换 UIEnter：eager（wokamark/trigger-help）/ VeryLazy（UI 系 15）/ cmd（toggleterm）/ event（treesitter 系/LSP）/ InsertEnter（cmp）/ deps（依赖组） | 行为等价优先；闭包 require 插件必须 VeryLazy 的硬约束 |
| D-004 | GitHub 安装 + `dev = { path='~/projects', patterns={'github.com/sin1111yi/'} }` + `:Lazy dev` | 消费端可复现、开发端即时生效，两不误 |
| D-005 | 删 plugins.lua/loader.lua/util.lua；custom/ 保留零改动 | try_load 被 lazy 加载保证取代；键位回归面为零 |
| D-006 | lazy bootstrap 首行；VimEnter 时序逐项核对（wokamark eager 是关键） | 目录检测/auto_restore/opened_with_dir 零破坏 |
| D-007 | lazy-lock.json 入库；nvim-pack-lock.json 验证后删；checker 关闭、显式 update | 可复现快照；与用户受控升级偏好一致 |
| D-008 | 三层验证：headless 链 + 30 插件断言 + 真实 UI 回归清单 | which-key headless maparg 限制决定键位层必须手测 |

---

## 7. References

- lazy.nvim 源码（2026-08-07 main 分支核验）：`folke/lazy.nvim` `lua/lazy/core/util.lua`（`M.lsmod`/`M.ls`/`M.find_root`，import 顶层扫描不递归）、`lua/lazy/core/plugin.lua`（`Spec:import`）、`lua/lazy/core/meta.lua`（dev 模式 patterns 明文匹配）
- 本地插件源码：`~/projects/wokamark.nvim`（`lua/wokamark/init.lua` register_doc 依赖、`plugin/wokamark.lua` VimEnter 钩子）、`~/projects/trigger-help.nvim`（`lua/trigger_help/init.lua` setup/register_doc）
- [neovim-config skill](../../../.hermes/skills/software-development/neovim-config/SKILL.md)（vim.pack 时代文档，Phase 5 同步更新）
- [neovim-config skill: local-plugins-and-pitfalls.md](../../../.hermes/skills/software-development/neovim-config/references/local-plugins-and-pitfalls.md)（vim.pack lock 残留死循环、which-key headless maparg 限制、nvim <dir> vscode 打开等坑位）
- 现有配置：`~/.config/nvim`（init.lua、lua/config/*、lua/plugins/*、nvim-pack-lock.json）
