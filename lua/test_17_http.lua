--
-- Http客户端测试
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/2
-- Time: 10:51
-- To change this template use File | Settings | File Templates.
--

--下载lua-resty-http客户端到lualib
--wget https://raw.githubusercontent.com/pintsized/lua-resty-http/master/lib/resty/http_headers.lua
--wget https://raw.githubusercontent.com/pintsized/lua-resty-http/master/lib/resty/http.lua


local http = require("resty.http")
--创建http客户端实例
local httpc = http.new()

local resp, err = httpc:request_uri("http://search.lefeng.com", {
    method = "GET",
    path = "/search/showresult?keyword=hello",
    headers = {
        ["User-Agent"] = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.111 Safari/537.36"
    }
})

if not resp then
    ngx.say("request error :", err)
    return
end

--获取状态码
ngx.status = resp.status

--获取响应头
for k, v in pairs(resp.headers) do
    if k ~= "Transfer-Encoding" and k ~= "Connection" then
        ngx.header[k] = v
    end
end
--响应体
ngx.say(resp.body)

httpc:close()

--响应头中的Transfer-Encoding和Connection可以忽略，因为这个数据是当前server输出的。
--在nginx.conf中的http部分添加如下指令来做DNS解析
--resolver 8.8.8.8;
--记得要配置DNS解析器resolver 8.8.8.8，否则域名是无法解析的。

--访问如http://192.168.1.2/lua_http_1会看到淘宝的搜索界面。
--使用方式比较简单，如超时和连接池设置和之前Redis客户端一样，不再阐述。更多客户端使用规则请参考https://github.com/pintsized/lua-resty-http。

