--init_by_lua
--每次Nginx重新加载配置时执行，可以用它来完成一些耗时模块的加载，或者初始化一些全局配置；
--在Master进程创建Worker进程时，此指令中加载的全局变量会进行Copy-OnWrite，即会复制到所有全局变量到Worker进程。

--1、nginx.conf配置文件中的http部分添加如下代码
--共享全局变量，在所有worker间共享
--lua_shared_dict shared_data 1m;
--init_by_lua_file /opt/openresty/openresty-example/lua/init.lua;

--初始化耗时的模块
local redis = require 'resty.redis'
local cjson = require 'cjson'

--全局变量，不推荐
count = 1

--共享全局内存
local shared_data = ngx.shared.shared_data
shared_data:set("count", 1)
