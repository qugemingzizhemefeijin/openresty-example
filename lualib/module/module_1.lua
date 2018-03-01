--
-- 自定义模块测试1
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/1
-- Time: 16:09
-- To change this template use File | Settings | File Templates.
--

local count = 0
local function hello()
    count = count + 1
    ngx.say("count : ", count)
end

local _M = {
    hello = hello
}

return _M

--开发时将所有数据做成局部变量/局部函数；通过 _M导出要暴露的函数，实现模块化封装。
--接下来创建test_module_1.lua