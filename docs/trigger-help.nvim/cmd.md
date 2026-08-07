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

    :s/foo/bar/         当前行第一个
    :s/foo/bar/g        当前行全部
    :%s/foo/bar/g       整个文件
    :%s/foo/bar/gc      逐个确认
    :5,10s/foo/bar/g    指定行范围
    :'<,'>s/foo/bar/g   选中区域（可视模式自动带）

### 标志

    g    一行内全部（默认只替换每行第一个）
    c    每个匹配确认（y=是 n=否 a=全部 q=退出 l=本次并结束）
    i    忽略大小写        I   严格大小写
    e    无匹配不报错

### 特殊字符

    \1 \2...   正则分组引用（\(foo\)bar → \1）
    &          整个匹配本身
    \r         换行（:s 里 \n 是空字符）
    \t         Tab

### 分组与大小写

    :%s/\(foo\)\(bar\)/\2\1/   交换分组
    :%s/foo/\U&/               转大写
    :%s/foo/\L&/               转小写
    \u \U \l \L \e             局部/整体大小写控制

### 分隔符可换

    :s#foo#bar#     / 冲突时换 # 或 @

### 跨文件替换

    :bufdo %s/foo/bar/gc | update   所有 buffer
    :argdo %s/foo/bar/gc | update   参数列表文件
    :cfdo %s/foo/bar/gc | update    quickfix 列表文件（先 :grep）

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
