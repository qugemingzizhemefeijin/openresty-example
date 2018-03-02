--
-- ngx.location.capture
-- ngx.location.capture也可以用来完成http请求，但是它只能请求到相对于当前nginx服务器的路径，不能使用之前的绝对路径进行访问，但是我们可以配合nginx upstream实现我们想要的功能。
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/2
-- Time: 13:54
-- To change this template use File | Settings | File Templates.
--

local resp = ngx.location.capture("/proxy/search/showresult", {
    method = ngx.HTTP_GET,
    args = {keyword = "%e7%be%8e%e5%8d%b3"}

})
if not resp then
    ngx.say("request error :", err)
    return
end
ngx.log(ngx.ERR , tostring(resp.status))

--获取状态码
ngx.status = resp.status

--获取响应头
for k, v in pairs(resp.header) do
    if k ~= "Transfer-Encoding" and k ~= "Connection" then
        ngx.header[k] = v
    end
end
--响应体
if resp.body then
    ngx.say(resp.body)
end

-- 通过ngx.location.capture发送一个子请求，此处因为是子请求，所有请求头继承自当前请求，
-- 还有如ngx.ctx和ngx.var是否继承可以参考官方文档http://wiki.nginx.org/HttpLuaModule#ngx.location.capture。
-- 另外还提供了ngx.location.capture_multi用于并发发出多个请求，这样总的响应时间是最慢的一个，批量调用时有用。

-- 我们通过upstream+ngx.location.capture方式虽然麻烦点，但是得到更好的性能和upstream的连接池、负载均衡、故障转移、proxy cache等特性。
-- 不过因为继承在当前请求的请求头，所以可能会存在一些问题，比较常见的就是gzip压缩问题，ngx.location.capture不会解压缩后端服务器的GZIP内容，
-- 解决办法可以参考https://github.com/openresty/lua-nginx-module/issues/12；因为我们大部分这种http调用的都是内部服务，
-- 因此完全可以在proxy location中添加proxy_pass_request_headers off;来不传递请求头。
