--
-- lua工具类
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/7
-- Time: 14:56
-- To change this template use File | Settings | File Templates.
--

local mysql = require("resty.mysql")
local dkjson = require("dkjson")
local ngx_log = ngx.log
local ngx_ERR = ngx.ERR

--生成常量表功能
local function newConst( const_table )
    function Const( const_table )
        local mt =
        {
            __index = function (t,k)
                if type(const_table[k])=="table" then
                    const_table[k] = newConst(const_table[k])
                end
                return const_table[k]
            end,
            __newindex = function (t,k,v)
                ngx_log(ngx_ERR,"*can't update " .. tostring(const_table) .."[" .. tostring(k) .."] = " .. tostring(v))
            end
        }
        return mt
    end

    local t = {}
    setmetatable(t, Const(const_table))
    return t
end

--判断变量是否是null
local function isNull(obj)
    if not obj or obj == ngx.null then
        return true
    end

    return false
end
-- 判断table是否为空，字符串为""，table为{}也包含
local function isEmpty(obj)
    if isNull(obj) then
        return true
    end

    local t = type(obj)
    if t == "table" and next(obj) == nil then
        return true
    elseif t == 'string' and string.len(obj) == 0 then
        return true
    end

    return false
end

--md5加密
local function toMd5(str)
    str = str or ""
    if type(str) ~= "string" then
        str = ""
    end

    return ngx.md5(str)
end

--生成JSON字符串
local function toJsonString(json)
    json = json or {}
    if type(json) ~= "table" then
        json = {}
    end

    return dkjson.encode(json , {indent = true})
end

--生成JSON对象
local function toJsonObject(str)
    str = str or "{}"
    if type(str) ~= "string" then
        str = "{}"
    end

    return dkjson.decode(str, 1, nil)
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

--mysql查询
local function selectDB(query)
    if not query or type(query) ~= "string" then
        ngx_log(ngx_ERR,"select error : query is null or not string")
        return ngx.null
    end

    local db = connect_mysql()
    if not db then
        return nil
    end

    local res, err, errno, sqlstate = db:query(query)
    if not res then
        ngx_log(ngx_ERR,"select error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)
        res = ngx.null
    end

    --关闭mysql
    close_mysql(db)
    return res
end

-- 成功返回的JSON
local function ok(msg , data , resultType)
    msg = msg or "操作成功"
    local res = {
        success = true,
        code = 0,
        msg = msg,
        data = data,
        resultType = resultType
    }

    return res
end

-- 失败返回的JSON
local function fail(code , msg , data , resultType)
    code = code or 1
    msg = msg or "系统异常"
    local res = {
        success = false,
        code = code,
        msg = msg,
        data = data,
        resultType = resultType
    }

    return res
end

local _M = {
    selectDB = selectDB,
    ok = ok,
    fail = fail,
    toJsonString = toJsonString,
    toJsonObject = toJsonObject,
    toMd5 = toMd5,
    isNull = isNull,
    isEmpty = isEmpty,
    CONST = newConst({
        RESULT_TYPE_SELFPAGE = 1,
        RESULT_TYPE_FUNCTION = 2,
        RESULT_TYPE_CLOSE_BOX_SELFPAGE = 3,
        RESULT_TYPE_CLOSE_BOX_FUNCTION = 4,
        RESULT_TYPE_CLOSE_BOX = 5,
        RESULT_TYPE_URL = 6,
        RESULT_TYPE_NO_OPERATE = 7,
        RESULT_TYPE_CLOSE_SELFPAGE_RELOAD_OPENER = 8,
        RESULT_TYPE_CLOSE_SELFPAGE = 9,
        RESULT_TYPE_REFRESH_TABLE = 10
    })
}

return _M
