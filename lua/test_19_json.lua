--
-- 在进行数据传输时JSON格式目前应用广泛，因此从Lua对象与JSON字符串之间相互转换是一个非常常见的功能；
-- 目前Lua也有几个JSON库，其中cjson的语法严格（比如unicode \u0020\u7eaf），要求符合规范否则会解析失败（如\u002），
-- 而dkjson相对宽松，当然也可以通过修改cjson的源码来完成一些特殊要求。而在使用dkjson时也没有遇到性能问题，目前使用的就是dkjson。
-- 使用时要特别注意的是大部分JSON库都仅支持UTF-8编码；因此如果你的字符编码是如GBK则需要先转换为UTF-8然后进行处理。
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/2
-- Time: 15:33
-- To change this template use File | Settings | File Templates.
--

local cjson = require("cjson")

--lua对象到字符串
local obj = {
    id = 1,
    name = "zhangsan",
    age = nil,
    is_male = false,
    hobby = {"film", "music", "read"}
}

local str = cjson.encode(obj)
ngx.say(str, "<br/>")

--字符串到lua对象
str = '{"hobby":["film","music","read"],"is_male":false,"name":"zhangsan","id":1,"age":null}'
local obj = cjson.decode(str)

ngx.say(obj.age, "<br/>")
ngx.say(obj.age == nil, "<br/>")
ngx.say(obj.age == cjson.null, "<br/>")
ngx.say(obj.hobby[1], "<br/>")


--循环引用
obj = {
    id = 1
}
obj.obj = obj
-- Cannot serialise, excessive nesting
--ngx.say(cjson.encode(obj), "<br/>")
local cjson_safe = require("cjson.safe")
--nil
ngx.say(cjson_safe.encode(obj), "<br/>")

--null将会转换为cjson.null；循环引用会抛出异常Cannot serialise, excessive nesting，默认解析嵌套深度是1000，可以通过cjson.encode_max_depth()设置深度提高性能；
-- 使用cjson.safe不会抛出异常而是返回nil。

--lua-cjson文档http://www.kyne.com.au/~mark/software/lua-cjson-manual.html。
