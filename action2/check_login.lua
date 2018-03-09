--
-- 检查是否登录
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/9
-- Time: 13:41
-- To change this template use File | Settings | File Templates.
--

local common = require("module.common")

--获取请求地址
local request_uri = ngx.var.request_uri;
if request_uri ~= '/login' and request_uri ~= '/login_check' then
    --读取cookie请求
    local userCookieStr = common.getCookie("user");
    --ngx.log(ngx.ERR , "userCookieStr = " , userCookieStr)
    if not userCookieStr or userCookieStr == ngx.null then
        return ngx.exit(403)
    end

    local user = common.toJsonObject(ngx.unescape_uri(userCookieStr))
    if not user or user == ngx.null then
        ngx.log(ngx.ERR , "user can not found")
        return ngx.exit(403)
    end

    --验证token
    local token = ngx.md5(user.id.."#"..user.username.."#"..ngx.var.encode_salt)
    if token ~= user.token then
        ngx.log(ngx.ERR , "user tokent not equals , token = " , token , " ~= user token =" , user.token)
        return ngx.exit(403)
    end

    ngx.var.userid = user.id
    ngx.var.username = user.username
end
