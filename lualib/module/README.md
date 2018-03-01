# 自定义Lua模块 <br/>
在实际开发中，不可能把所有代码写到一个大而全的lua文件中，需要进行分模块开发；而且模块化是高性能Lua应用的关键。使用require第一次导入模块后，所有Nginx 进程全局共享模块的数据和代码，每个Worker进程需要时会得到此模块的一个副本（Copy-On-Write），即模块可以认为是每Worker进程共享而不是每Nginx Server共享；另外注意之前我们使用init_by_lua中初始化的全局变量是每请求复制一个；如果想在多个Worker进程间共享数据可以使用ngx.shared.DICT或如Redis之类的存储。<br/>
lualib中已经提供了大量第三方开发库如cjson、redis客户端、mysql客户端<br/>
cjson.so<br/>
resty/<br/>
   aes.lua<br/>
   core.lua<br/>
   dns/<br/>
   lock.lua<br/>
   lrucache/<br/>
   lrucache.lua<br/>
   md5.lua<br/>
   memcached.lua<br/>
   mysql.lua<br/>
   random.lua<br/>
   redis.lua<br/>
   ……<br/>
<br/>
需要注意在使用前需要将库在nginx.conf中导入：<br/>
lua模块路径，其中”;;”表示默认搜索路径，默认到/usr/servers/nginx下找<br/>
lua_package_path "/usr/example/lualib/?.lua;;";  #lua 模块<br/>
lua_package_cpath "/usr/example/lualib/?.so;;";  #c模块<br/>
使用方式是在lua中通过如下方式引入<br/>
local cjson = require(“cjson”)<br/>
local redis = require(“resty.redis”)<br/>

自定义的Lua模块可以存放在module目录下<br/>