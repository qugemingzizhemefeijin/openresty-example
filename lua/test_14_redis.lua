--
-- 测试Redis Lua evalsha  SHA1
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/1
-- Time: 17:45
-- To change this template use File | Settings | File Templates.
--

--关闭redis客户端
local function close_redis(red)
    if not red then
        return
    end
    --释放连接(连接池实现)
    local pool_max_idle_time = 10000 --毫秒
    local pool_size = 100 --连接池大小
    local ok, err = red:set_keepalive(pool_max_idle_time, pool_size)
    if not ok then
        ngx.say("close redis error : ", err)
    end
end

local redis = require("resty.redis")
--创建实例
local red = redis:new()
--设置超时（毫秒）
red:set_timeout(1000)
--建立连接
local ip = "192.168.20.9"
local port = 6379
local ok, err = red:connect(ip, port)
if not ok then
    ngx.say("connect to redis error : ", err)
    return close_redis(red)
end

--调用API进行处理
ok, err = red:exists("msg")
if not ok then
    ngx.say("exists msg error : ", err)
    return close_redis(red)
else
    ok, err = red:set("msg", "hello world Redis Lua SHA1")
    if not ok then
        ngx.say("set msg error : ", err)
        return close_redis(red)
    end
end

local sha1, err = red:script("load",  "return redis.call('get', KEYS[1])");
if not sha1 then
    ngx.say("load script error : ", err)
    return close_redis(red)
end

--首先通过script load导入脚本并得到一个sha1校验和（仅需第一次导入即可），然后通过evalsha执行sha1校验和即可，这样如果脚本很长通过这种方式可以减少带宽的消耗。

ngx.say("sha1 : ", sha1, "<br/>")
local resp, err = red:evalsha(sha1, 1, "msg");
--得到的数据为空处理
if resp == ngx.null then
    resp = ''  --比如默认值
end
ngx.say("msg : ", resp)

return close_redis(red)