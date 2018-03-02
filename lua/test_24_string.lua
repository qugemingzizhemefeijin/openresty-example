--
-- 字符串处理
-- Lua 5.3之前没有提供字符操作相关的函数，如字符串截取、替换等都是字节为单位操作；在实际使用时尤其包含中文的场景下显然不能满足需求；即使Lua 5.3也仅提供了基本的UTF-8操作。
-- Lua UTF-8库
-- https://github.com/starwing/luautf8
-- LuaRocks安装
-- yum -y install luarocks lua-devel
-- luarocks install utf8
-- cp /usr/lib/lua/5.1/utf8.so  /usr/example/lualib/
--
-- 源码安装
-- wget https://github.com/starwing/luautf8/archive/master.zip
-- unzip master.zip
-- cd luautf8-master/
-- gcc -O2 -fPIC -I/usr/include/lua5.1 -c utf8.c -o utf8.o -I/usr/include
-- gcc -shared -o utf8.so -L/usr/local/lib utf8.o -L/usr/lib
--
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/2
-- Time: 17:54
-- To change this template use File | Settings | File Templates.
--

local utf8 = require("utf8")
local str = "abc中文"
ngx.say("len : ", utf8.len(str), "<br/>")
ngx.say("sub : ", utf8.sub(str, 1, 4))

-- 文件编码必须为UTF8，此处我们实现了最常用的字符串长度计算和字符串截取。

-- 访问如 http://192.168.20.31/lua_utf8_test 测试得到如下结果
-- len : 5
-- sub : abc中
