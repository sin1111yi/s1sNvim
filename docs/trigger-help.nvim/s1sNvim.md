# s1sNvim 配置速查

## Leader 键位（空格 + 分组）

    <Space>w        窗口操作
        wv          垂直分屏
        ws          水平分屏
        wq          关闭窗口

    <Space>b        buffer 操作
        bn / bp     下一个 / 上一个
        bd          关闭 buffer
        bl          列表

    <Space>f        查找
        ff          查找文件
        fb          查找 buffer
        fg          grep 搜索

    <Space>e        文件树
        e           切换 nvim-tree
        ed          打开目录（输入路径）
        er          树根回到启动目录

    <Space>q        退出
        qq          全部保存并退出

    <Space>r        设置开关
        rn / rw / rh / rc / rs / rk
        （相对行号 / 自动换行 / 搜索高亮 / 彩色列 / 拼写 / 关键字）

    <Space>x        增强工具
        xg          lazygit
        xl          git log
        xf          格式化文件
        xx          诊断（trouble）
        xq / xL     quickfix / loclist
        xh          trigger-help 帮助面板
        xz          打开 Lazy（插件管理）
        xu          更新配置（git pull + 通知）

    <Space>u        undo 树
    <Space>t        终端（toggleterm）

## 其他键位

    q（编辑区）     关闭当前 buffer（窗口保持，显示下一个 / No Name）
    Tab / S-Tab     切换 buffer
    （ 开头        surround 五件套（配对包裹）

## 启动行为

    nvim <目录>      树（左 30 列）+ 空编辑区
    nvim <标记路径>  wokamark 恢复工作区（树 + 内容）
    裸 nvim         无树（wokamark 恢复自带布局）

## 常用命令

    :TriggerHelp           帮助面板（同 <Space>xh）
    :Lazy                  插件管理（同 <Space>xz）
    :WokaMarkCurrent       标记当前目录为工作区
    :WokaMarkOpen          选择工作区恢复
    :WokaMarkManage        管理工作区（d/r/a/i）
    :TSUpdate              更新 treesitter parsers
    :NvimTreeToggle        切换文件树

## 配置结构

    init.lua               加载顺序（options → lazy → keymaps → autocmds）
    lua/config/options.lua 编辑器选项 + leader + 启动记录
    lua/config/lazy.lua    lazy bootstrap + 配置
    lua/plugins/           每插件一个 lazy spec
    lua/plugins/custom/    键位分组 + 扩展逻辑
    docs/trigger-help.nvim/ 帮助文档（本文件所在）
