--
-- 测试Redis Lua eval
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/1
-- Time: 17:37
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
ok, err = red:set("msg", "hello world Redis Lua")
if not ok then
    ngx.say("set msg error : ", err)
    return close_redis(red)
end

local resp, err = red:eval("return redis.call('get', KEYS[1])", 1, "msg");
if not resp then
    ngx.say("get msg error : ", err)
    return close_redis(red)
end

--得到的数据为空处理
if resp == ngx.null then
    resp = ''  --比如默认值
end
ngx.say("msg : ", resp)

return close_redis(red)