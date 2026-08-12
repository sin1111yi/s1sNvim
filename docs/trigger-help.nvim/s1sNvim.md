# s1sNvim 配置速查（详细版）

基于 lazy.nvim 的 Neovim 配置。Leader 键 = 空格。
启动布局由 wokamark 管理，文档浏览用 trigger-help（本面板）。

## 一、Leader 键位全表（<Space> + 分组）

### w — 窗口

    <Space>wh   窗口左移        <Space>wj   窗口下移
    <Space>wk   窗口上移        <Space>wl   窗口右移
    <Space>ws   水平分屏        <Space>wv   垂直分屏
    <Space>wc   关闭窗口        <Space>wq   退出窗口
    <Space>wo   只留当前窗口    <Space>w=   均分窗口
    <Space>w+   增高            <Space>w-   降低
    <Space>w>   加宽            <Space>w<   减宽

### b — Buffer

    <Space>bn   下一个 buffer   <Space>bp   上一个 buffer
    <Space>bd   删除 buffer     <Space>bo   关闭其他 buffer
    <Space>bl   选择 buffer（picker）
    Tab / S-Tab  下一个 / 上一个 buffer（bufferline 循环）

### f — 查找（snacks picker）

    <Space>ff   查找文件
    <Space>fb   查找 buffer
    <Space>fg   全文 grep

### e — 文件树（nvim-tree）

    <Space>e    切换文件树
    <Space>ed   打开目录（输入路径，cd + 开树）
    <Space>er   树根回到启动目录（恢复初始根）

### q — 退出

    <Space>q    退出当前窗口
    <Space>qq   全部保存并退出（:wqa）

### r — 设置开关（六 toggle）

    <Space>rn   相对行号开关      <Space>rw   自动换行开关
    <Space>rh   搜索高亮开关      <Space>rc   不可见字符开关
    <Space>rs   忽略大小写开关    <Space>rk   彩色列（80）开关

### x — 增强工具

    <Space>xg   lazygit          <Space>xl   git log
    <Space>xf   格式化（conform）  <Space>xx   诊断（trouble，无则提示）
    <Space>xq   quickfix 列表     <Space>xL   loclist 列表
    <Space>xh   trigger-help 帮助面板（本面板）
    <Space>xz   打开 Lazy（插件管理）
    <Space>xu   更新配置（git pull 终端实时显示 + 完成后通知）

### u — 不常用（标签页）

    <Space>utn  新标签页         <Space>utc  关闭标签页
    <Space>uto  只留当前标签页

### t — 终端（toggleterm）

    <Space>tt   切换终端（水平）  <Space>tv   垂直终端
    <Space>tf   浮动终端

## 二、非 Leader 键位

    插入模式:   jk / kj = Esc
    查找后:     n / N / * / # 自动居中（zz）
    <Esc>       清除搜索高亮（nohlsearch）
    Tab/S-Tab   循环 buffer（normal）
    q（编辑区） 关闭当前 buffer（窗口保持，显示下一个 / No Name）

## 三、surround 五件套（mini.surround，以 ( 开头）

    (s   添加配对包裹（surround）      (d   删除配对
    (r   替换配对                      (f   查找右侧配对
    (F   查找左侧配对
    示例: (s 然后输入 ( 或 [ 或 " 等——包裹选中文本

## 四、nvim-tree 内键位

    j / k         下 / 上移动
    h / l          折叠 / 展开目录（l 在文件上 = 打开；路径节点忽略）
    <CR>          打开（目录展开 / 文件编辑）
    < / >          展开 / 折叠当前目录
    a / d / r      新建 / 删除 / 重命名
    R             刷新
    x / y          剪切 / 复制文件名
    <C-]>          CD 到光标节点（改树根）
    q             关闭树
    g?            树内帮助

## 五、启动行为

    nvim <目录>      树（左 30 列）+ 空编辑区（No Name）
    nvim <标记路径>  wokamark 恢复工作区（树 + 上次的 buffer 布局）
    裸 nvim          无树；wokamark 恢复自带布局（如有匹配）
    细节: 目录参数启动 → VimEnter 记录 startup_dir → 树根锚定该目录
          切换窗口不会让树漂移；树开关由 wokamark 决策

## 六、常用命令

    :TriggerHelp [名称]     帮助面板（无参 = selector / 关面板）
    :Lazy                    插件管理（install/update/sync/build）
    :WokaMarkCurrent         标记当前目录为工作区
    :WokaMarkOpen            选择器恢复工作区
    :WokaMarkManage          管理（d 删 / r 改名 / a 添加 / i 详情）
    :TSUpdate                更新 treesitter parsers
    :NvimTreeToggle          切换文件树
    :ToggleTerm [direction]  终端

## 七、插件清单（30 个）

    folke 系:  which-key · snacks · trouble · toggleterm · flash · bufferline
    mini 系:   mini.pairs · mini.surround · mini.icons
    编辑:      nvim-tree · treesitter · lspconfig · mason · cmp · conform
    界面:      lualine · catppuccin · dressing · devicons
    其他:      gitsigns · comment · illuminate
    自研:      wokamark.nvim（工作区会话）· trigger-help.nvim（帮助面板）

## 八、配置结构

    init.lua                 入口（加载顺序 options → lazy → keymaps → autocmds）
    lua/config/options.lua   编辑器选项 + leader + 启动记录（startup_dir/argc）
    lua/config/lazy.lua      lazy bootstrap（dev ~/Development 自研插件）
    lua/config/keymaps.lua   非 Leader 映射
    lua/config/autocmds.lua  通用 autocmd
    lua/plugins/             每插件一个 lazy spec（24 个 + custom/）
    lua/plugins/custom/      键位分组（plugin-keymaps）+ 扩展（tree-root/cmp/lsp）
    docs/trigger-help.nvim/  帮助文档（本文件所在，4 份）
    docs/adr/                架构决策记录
    lazy-lock.json           本地插件版本锁（不跟踪 git）

## 九、日常工作流

    打开项目:   nvim <项目目录> 或 <Space>e → <Space>ed 输入路径
    切换 buffer: Tab / S-Tab 或 <Space>bl
    查找:        <Space>ff（文件）/ <Space>fg（grep）
    格式化:      <Space>xf
    诊断:        <Space>xx（trouble 面板）
    Git:         <Space>xg（lazygit）
    标记工作区:  <Space>e 打开后 :WokaMarkCurrent → 下次自动恢复
    查帮助:      <Space>xh → 选择（本面板含本文件）
    更新配置:    <Space>xu（git pull + 通知，重启生效）
    更新插件:    <Space>xz → :Lazy update

## 十、开发说明

    自研插件开发（dev 模式）:
      源码在 ~/Development/{wokamark,trigger-help}.nvim
      修改即生效（重启 nvim）；推送 GitHub 后其他设备 :Lazy update 拉取
      trigger-help 的 register_doc: 插件可注册双语文档进帮助面板
