--set_by_lua
--设置nginx变量，可以实现复杂的赋值逻辑；此处是阻塞的，Lua代码要做到非常快；
--设置nginx变量，我们用的set指令即使配合if指令也很难实现复杂的赋值逻辑；
--所处处理阶段 rewrite
--使用范围 server,server if,location,location if


local uri_args = ngx.req.get_uri_args()
local i = uri_args["i"] or 0
local j = uri_args["j"] or 0

return i + j

--set_by_lua_file：语法set_by_lua_file $var lua_file arg1 arg2...; 在lua代码中可以实现所有复杂的逻辑，但是要执行速度很快，不要阻塞；