--
-- 通过nginx读取redis中的广告词，如果不存在，则从mysql中读取并且放入到redis中。
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/5
-- Time: 14:50
-- To change this template use File | Settings | File Templates.
--

local redis = require("resty.redis")
local cjson = require("cjson")
local mysql = require("resty.mysql")
local cjson_encode = cjson.encode
local ngx_log = ngx.log
local ngx_ERR = ngx.ERR
local ngx_var = ngx.var

--关闭redis客户端
local function close_redis(red)
    if not red then
        return
    end

    --释放连接(连接池实现)
    local pool_max_idle_time = 10000 --毫秒
    local pool_size = 5 --连接池大小
    local ok , err = red:set_keepalive(pool_max_idle_time , pool_size)
    if not ok then
        ngx_log(ngx_ERR,"close redis error : ", err)
    end

    return ok
end

--关闭mysql客户端
local function close_mysql(db)
    if not db then
        return
    end

    --释放连接
    local pool_max_idle_time = 10000 --毫秒
    local pool_size = 5 --连接池大小

    local ok , err = db:set_keepalive(pool_max_idle_time, pool_size)
    if not ok then
        ngx_log(ngx_ERR,"close redis error : ", err)
    end

    return ok
end

--连接redis服务端
local function connect_redis()
    --创建实例
    local red = redis:new()
    --设置超时（毫秒）
    red:set_timeout(1000)
    --建立连接
    local ip = "192.168.20.9"
    local port = 6379
    local ok, err = red:connect(ip, port)
    if not ok then
        ngx_log(ngx_ERR,"connect to redis error : ", err)
        close_redis(red)
        return nil
    end

    return red
end

--连接mysql服务端
local function connect_mysql()
    --创建实例
    local db = mysql:new()
    --设置超时时间(毫秒)
    db:set_timeout(1000)

    local props = {
        host = "192.168.20.3",
        port = 3306,
        database = "miai_passport_test",
        user = "miai_passport",
        password = "miai_passport2017"
    }

    local res, err, errno, sqlstate = db:connect(props)
    if not res then
        ngx_log(ngx_ERR,"connect to mysql error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)
        close_mysql(db)
        return nil
    end

    return db
end

--mysql直接读取广告
local function read_by_mysql(adid)
    local db = connect_mysql()
    if not db then
        return nil
    end

    local select_sql = "select ad_id, content from test_ad where ad_id=" .. ngx.quote_sql_str(adid)
    local res, err, errno, sqlstate = db:query(select_sql)
    if not res then
        ngx_log(ngx_ERR,"select error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)
        res = ngx.null
    end

    --关闭mysql
    close_mysql(db)
    return res
end

--redis get
local function redis_set(key , val)
    local red = connect_redis()
    if not red or red == nil then
        return nil
    end

    if not val or val == null or val == ngx.null then
       return ngx.null
    end

    local res , err = red:set(key, val)
    if not res then
        ngx_log(ngx_ERR , "set redis error : ", err)
        res = ngx.null
    end

    close_redis(red)
    return res
end

--redis set
local function redis_get(key)
    local red = connect_redis()
    if not red or red == nil then
        return nil
    end

    local res , err = red:get(key)
    if not res then
        ngx_log(ngx_ERR , "get redis error : ", err)
        res = ngx.null
    end

    close_redis(red)
    return res
end

--根据广告ID读取广告词吗，如果redis中有则直接读取，否则从mysql中读取，并且放入到redis中
local function read_ad(adid)
    local content = redis_get("adid_"..adid)
    if not content then
        return ngx.null
    end
    if content ~= ngx.null then
        ngx_log(ngx_ERR , "adid=",adid," read from redis!")
        return content
    else
        ngx_log(ngx_ERR,"adid=",adid," redis not found!")
    end

    --否则从mysql中读取数据
    local res = read_by_mysql(adid)
    if not res then
        return null
    end
    if res ~= ngx.null and res[1] then
        ngx_log(ngx_ERR , "adid=",adid," read from mysql~")
        content = res[1].content
    else
        ngx_log(ngx_ERR,"adid=",adid," mysql not found!")
    end

    --放入redis中
    redis_set("adid_"..adid , content)
    --返回
    return content
end

--获取ID
local adid = ngx_var.adid
ngx.say("=======adid="..adid.."<br/>")
ngx.say("=====================<br/>")
ngx.say(cjson_encode({content = read_ad(adid)}).."<br/>")
ngx.say("=====================<br/>")


