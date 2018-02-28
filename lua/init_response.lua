--读取init.lua中的变量和打印相关信息
count = count + 1
ngx.say("global variable : ", count , "<br/>")

local shared_data = ngx.shared.shared_data

--共享全局内存
ngx.say("shared memory : ", shared_data:get("count") , "<br/>")
shared_data:incr("count", 1)

ngx.say("hello world , count : " , shared_data:get("count") , "<br/>")

--这里会产生一个问题，就是同样lua_code_cache off的情况下
--/lua_shared_dict可以持续不断的累计+1
--但是这里的共享全局内存count却不累计加，只要把lua_code_cache on则又正常了。这到底是为什么呢？

--当lua_code_cache off的情况下  openresty关闭lua代码缓存，为每一个请求都创建一个独立的lua_state，这样每一个请求来临的时候 在新创建的lua_state中 都没有代码记录 需要重新读取文件加载代码，
--因此可以立即动态加载新的lua脚本，而不需要reload nginx，但因为每个请求都需要分配新的lua_state,和读取文件加载代码，所以性能较差
--当lua_code_cache on的情况下 openresty打开lua代码缓存，每一个请求使用ngx_http_lua_module全局的lua_state，新的lua文件在首次加载的时候，会去读取文件，然后存放到lua的全局变量中，
--请求再次的时候 就会在lua_state全局变量中找到了，因此修改完代码之后，需要reload nginx之后 才可以生效
--就是这个问题，是因为lua_state中不存在init.lua的文件信息了，所以重新加载了。。。这个可以通过另一种方式去验证
--那就是读取/lua_shared_dict中创建的i去累计，就能看到每次都累计2而不是1。