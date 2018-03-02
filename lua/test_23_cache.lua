--
-- ngx_lua模块本身提供了全局共享内存ngx.shared.DICT可以实现全局共享，另外可以使用如Redis来实现缓存。另外还一个lua-resty-lrucache实现，
-- 其和ngx.shared.DICT不一样的是它是每Worker进程共享，即每个Worker进行会有一份缓存，而且经过实际使用发现其性能不如ngx.shared.DICT。
-- 但是其好处就是不需要进行全局配置。
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/2
-- Time: 17:26
-- To change this template use File | Settings | File Templates.
--

local mycache = require("module.lrucache_module")
local count = mycache.get("count") or 0
count = count + 1
mycache.set("count", count, 10 * 60 * 60) --10分钟
ngx.say(mycache.get("count"))

--可以实现诸如访问量统计，但仅是每Worker进程的。
-- 访问如 http://192.168.20.31/lua_lrucache_test 测试。