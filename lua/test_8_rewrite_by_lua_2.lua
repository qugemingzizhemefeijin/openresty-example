--rewrite_by_lua
--rewrite阶段处理，可以实现复杂的转发/重定向逻辑；
--所处处理阶段 rewrite tail
--使用范围 http,server,location,location if

--访问如http://192.168.1.2/lua_rewrite_2?jump=0时得到响应
--rewrite2 uri : /lua_rewrite_2, a : b :
--访问如http://192.168.1.2/lua_rewrite_2?jump=1时得到响应
--rewrite2 uri : /lua_rewrite_4, a : 1，b : 2

if ngx.req.get_uri_args()["jump"] == "1" then
    ngx.req.set_uri("/lua_rewrite_3", false);
    ngx.req.set_uri("/lua_rewrite_4", false);
    ngx.req.set_uri_args({a = 1, b = 2});
end

--ngx.req.set_uri(uri, false)：可以内部重写uri（可以带参数），等价于 rewrite ^ /lua_rewrite_3；
--通过配合if/else可以实现 rewrite ^ /lua_rewrite_3 break；这种功能；此处两者都是location内部url重写，不会重新发起新的location匹配；
--ngx.req.set_uri_args：重写请求参数，可以是字符串(a=1&b=2)也可以是table；