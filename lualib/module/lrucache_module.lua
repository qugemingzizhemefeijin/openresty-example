--
-- 创建缓存模块来实现只初始化一次
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/2
-- Time: 17:27
-- To change this template use File | Settings | File Templates.
--

local lrucache = require("resty.lrucache")
--创建缓存实例，并指定最多缓存多少条目
local cache, err = lrucache.new(200)
if not cache then
    ngx.log(ngx.ERR, "create cache error : ", err)
end

local function set(key, value, ttlInSeconds)
    cache:set(key, value, ttlInSeconds)
end

local function get(key)
    return cache:get(key)
end

local _M = {
    set = set,
    get = get
}

return _M
