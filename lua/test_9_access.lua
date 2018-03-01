--
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/1
-- Time: 15:14
-- To change this template use File | Settings | File Templates.
--

--access_by_lua
--请求访问阶段处理，用于访问控制
--所处处理阶段 access tail
--使用范围 http,server,location,location if

if ngx.req.get_uri_args()["token"] ~= "123" then
    return ngx.exit(403)
end

--即如果访问如http://192.168.20.31/lua_access?token=234将得到403 Forbidden的响应。这样我们可以根据如cookie/用户token来决定是否有访问权限。
--http://192.168.20.31/lua_access?token=123将显示access字样

--另外在使用PCRE进行正则匹配时需要注意正则的写法，具体规则请参考http://wiki.nginx.org/HttpLuaModule中的Special PCRE Sequences部分。还有其他的注意事项也请阅读官方文档。