--
-- 模版lua-resty-template API使用
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/5
-- Time: 11:42
-- To change this template use File | Settings | File Templates.
--

local template = require("resty.template")

local context = {
    title = "测试",
    name = "张三",
    description = "<script>alert(1);</script>",
    age = 20,
    hobby = {"电影", "音乐", "阅读"},
    score = {["语文"] = 90, ["数学"] = 80, ["英语"] = 70},
    score2 = {
        {name = "语文", score = 90},
        {name = "数学", score = 80},
        {name = "英语", score = 70},
    }
}

template.render("t3.html", context)

--请确认文件编码为UTF-8；context即我们渲染模板使用的数据。
-- {(include_file)}：包含另一个模板文件；
-- {* var *}：变量输出；
-- {{ var }}：变量转义输出；
-- {% code %}：代码片段；
-- {# comment #}：注释；
-- {-raw-}：中间的内容不会解析，作为纯文本输出；
-- 模板最终被转换为Lua代码进行执行，所以模板中可以执行任意Lua代码。

