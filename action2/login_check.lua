--
-- 登录检查
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/7
-- Time: 14:51
-- To change this template use File | Settings | File Templates.
--

-- 非post请求一律拒绝
if string.lower(ngx.req.get_method()) ~= "post" then
    return ngx.exit(403)
end

local ngx_log = ngx.log
local ngx_ERR = ngx.ERR

ngx.header.content_type = "application/json;charset=utf8"
--post请求必须先执行此方法
ngx.req.read_body()

local common = require("module.common")
local toJsonString = common.toJsonString
local selectDB = common.selectDB
local CONST = common.CONST
local post_args = ngx.req.get_post_args()

local username ,password = post_args.username , post_args.password
if not username or string.len(username) < 4 or string.len(username) > 30 then
    ngx.say(toJsonString(common.fail(1000,"用户名为空或不符合规则")))
    return ngx.exit(200)
end

if not password or string.len(password) < 5 or string.len(password) > 20 then
    ngx.say(toJsonString(common.fail(1001,"用户名或密码输入错误")))
    return ngx.exit(200)
end

local sql = "select * from t_admin where username = "..ngx.quote_sql_str(username)
local admin = selectDB(sql)
if common.isEmpty(admin) then
    ngx.say(toJsonString(common.fail(1002,"用户名或密码输入错误")))
    return ngx.exit(200)
end

ngx_log(ngx_ERR , admin[1].password,"....",common.toMd5(password))

if admin[1].password ~= common.toMd5(password) then
    ngx.say(toJsonString(common.fail(1003,"用户名或密码输入错误")))
    return ngx.exit(200)
end

local res = common.ok("登录成功，正在跳转中...","/index" , CONST.RESULT_TYPE_URL)
ngx.say(toJsonString(res))

