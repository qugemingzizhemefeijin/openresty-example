--rewrite_by_lua
--rewrite阶段处理，可以实现复杂的转发/重定向逻辑；
--所处处理阶段 rewrite tail
--使用范围 http,server,location,location if

--所以请求如http://192.168.20.31/lua_rewrite_3?jump=1会到新的location中得到响应，此处没有/lua_rewrite_4，所以匹配到/lua请求，得到类似如下的响应
--global variable : 2 , shared memory : 1 hello world
--即
--rewrite ^ /lua_rewrite_3;  等价于  ngx.req.set_uri("/lua_rewrite_3", false);
--rewrite ^ /lua_rewrite_3 break;  等价于  ngx.req.set_uri("/lua_rewrite_3", false); 加 if/else判断/break/return
--rewrite ^ /lua_rewrite_4 last;  等价于  ngx.req.set_uri("/lua_rewrite_4", true);
--注意，在使用rewrite_by_lua时，开启rewrite_log on;后也看不到相应的rewrite log。

if ngx.req.get_uri_args()["jump"] == "1" then
    ngx.req.set_uri("/hello", true);
    ngx.log(ngx.ERR, "=========")
    ngx.req.set_uri_args({a = 1, b = 2});
end

--ngx.req.set_uri(uri, true)：可以内部重写uri，即会发起新的匹配location请求，等价于 rewrite ^ /lua_rewrite_4 last；此处看error log是看不到我们记录的log。

--rewrite    <regex>    <replacement>    [flag];

--rewrite参数的标签段位置
--server,location,if

--flag标记说明：
--last  #本条规则匹配完成后，继续向下匹配新的location URI规则
--break  #本条规则匹配完成即终止，不再匹配后面的任何规则
--redirect  #返回302临时重定向，浏览器地址会显示跳转后的URL地址
--permanent  #返回301永久重定向，浏览器地址栏会显示跳转后的URL地址

--1.last一般写在server和if中，而break一般使用在location中
--2.last不终止重写后的url匹配，即新的url会再从server走一遍匹配流程，而break终止重写后的匹配
--3.break和last都能组织继续执行后面的rewrite指令

--执行顺序是：
--1.执行server块的rewrite指令
--2.执行location匹配
--3.执行选定的location中的rewrite指令
