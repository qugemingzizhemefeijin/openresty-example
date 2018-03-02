--
-- dkjson测试wget -O dkjson.lua http://dkolf.de/src/dkjson-lua.fsl/raw/dkjson.lua?name=16cbc26080996d9da827df42cb0844a25518eeb3
-- 下载完成后放入lualib中即可
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/2
-- Time: 15:48
-- To change this template use File | Settings | File Templates.
--

local dkjson = require("dkjson")

--lua对象到字符串
local obj = {
    id = 1,
    name = "zhangsan",
    age = nil,
    is_male = false,
    hobby = {"film", "music", "read"}
}

local str = dkjson.encode(obj, {indent = true})
ngx.say(str, "<br/>")

--字符串到lua对象
str = '{"hobby":["film","music","read"],"is_male":false,"name":"zhangsan","id":1,"age":null}'
local obj, pos, err = dkjson.decode(str, 1, nil)

ngx.say(obj.age, "<br/>")
ngx.say(obj.age == nil, "<br/>")
ngx.say(obj.hobby[1], "<br/>")

--循环引用
obj = {
    id = 1
}
obj.obj = obj
--reference cycle
--ngx.say(dkjson.encode(obj), "<br/>")
--循环引用会报错，页面500

--默认情况下解析的json的字符会有缩排和换行，使用{indent = true}配置将把所有内容放在一行。和cjson不同的是解析json字符串中的null时会得到nil。

--dkjson文档http://dkolf.de/src/dkjson-lua.fsl/home和http://dkolf.de/src/dkjson-lua.fsl/wiki?name=Documentation。
