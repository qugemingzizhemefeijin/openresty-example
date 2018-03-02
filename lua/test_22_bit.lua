--
-- Lua 5.3之前是没有提供位运算支持的，需要使用第三方库，比如LuaJIT提供了bit库。
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/2
-- Time: 16:58
-- To change this template use File | Settings | File Templates.
--

local bit = require("bit")
ngx.say(bit.lshift(1, 2))

--lshift进行左移位运算，即得到4。

--其他位操作API请参考http://bitop.luajit.org/api.html。Lua 5.3的位运算操作符http://cloudwu.github.io/lua53doc/manual.html#3.4.2.

