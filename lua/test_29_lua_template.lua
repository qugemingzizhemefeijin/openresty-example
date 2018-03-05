--
-- lua-resty-template 测试变量输出
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/5
-- Time: 11:34
-- To change this template use File | Settings | File Templates.
--

local template = require("resty.template")
--是否缓存解析后的模板，默认true
template.caching(true)
--渲染模板需要的上下文(数据)
local context = {title = "模块测试"}
--渲染模板
template.render("t2.html", context)

--ngx.say("<br/>")
--编译得到一个lua函数
--local func = template.compile("t1.html")
--执行函数，得到渲染之后的内容
--local content = func(context)
--通过ngx API输出
--ngx.say(content)

--常见用法即如下两种方式：要么直接将模板内容直接作为响应输出，要么得到渲染后的内容然后按照想要的规则输出。
