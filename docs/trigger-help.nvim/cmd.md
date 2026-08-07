# : 命令模式

## 保存 / 退出

    :w              保存
    :wq             保存并退出
    :q              退出
    :q!             强制退出
    :wqa            全部保存退出
    :e!             放弃改动重新加载

## 编辑

    :e <file>       打开文件
    :tabnew         新标签页
    :vsp / :sp      垂直 / 水平分屏
    :bn / :bp       下一个 / 上一个 buffer

## 替换

    :s/foo/bar/     当前行第一个
    :s/foo/bar/g    当前行全部
    :%s/foo/bar/g   整个文件
    :%s/foo/bar/gc  逐个确认
    :'<,'>s/foo/bar/g  选中区域（可视模式自动带）

## 目录

    :cd <dir>       切换目录
    :pwd            显示当前目录

## 查找

    :grep foo **/*.rs   搜索进 quickfix
    :vimgrep /pat/ **/* 同上（vim 内置）
    :cfdo %s/a/b/gc | update   quickfix 批量替换

## 列表

    :copen / :cclose   quickfix 开 / 关
    :lopen / :lclose   location 开 / 关
    :messages        消息历史
    :registers       寄存器内容
    :marks           标记列表

## 设置

    :set nu!        行号切换
    :set wrap!      换行切换
    :set list!      隐藏字符切换
    :set spell!     拼写检查
    :set <opt>?     查看选项当前值

## 执行 / 终端

    :!ls            执行 shell（结果回显）
    :term           打开内置终端
    :make           运行 make（错误进 quickfix）

## 补全

    :<Tab>          命令补全
    :<C-d>          列出候选
    :↑ / ↓          命令历史
