--rewrite_by_lua
--rewrite阶段处理，可以实现复杂的转发/重定向逻辑；
--所处处理阶段 rewrite tail
--使用范围 http,server,location,location if

--执行内部URL重写或者外部重定向，典型的如伪静态化的URL重写。其默认执行在rewrite处理阶段的最后。

if ngx.req.get_uri_args()["jump"] == "1" then
    return ngx.redirect("http://www.jd.com?jump=1", 302)
end

--当我们请求http://192.168.1.2/lua_rewrite_1时发现没有跳转，而请求http://192.168.1.2/lua_rewrite_1?jump=1时发现跳转到京东首页了。 此处需要301/302跳转根据自己需求定义。