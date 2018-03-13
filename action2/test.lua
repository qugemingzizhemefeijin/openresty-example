--
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/8
-- Time: 17:14
-- To change this template use File | Settings | File Templates.
--

--[[local common = require("module.common")
local ss = '{"draw":1,"columns":[{"data":"id","name":"","searchable":false,"orderable":false,"search":{"value":"","regex":false}},{"data":"id","name":"","searchable":false,"orderable":false,"search":{"value":"","regex":false}},{"data":"fr","name":"","searchable":false,"orderable":false,"search":{"value":"","regex":false}},{"data":"nickname","name":"","searchable":false,"orderable":false,"search":{"value":"","regex":false}},{"data":"sex","name":"","searchable":false,"orderable":false,"search":{"value":"","regex":false}},{"data":"cityname","name":"","searchable":false,"orderable":false,"search":{"value":"","regex":false}},{"data":"signature","name":"","searchable":false,"orderable":false,"search":{"value":"","regex":false}},{"data":"birthday","name":"","searchable":false,"orderable":false,"search":{"value":"","regex":false}},{"data":8,"name":"","searchable":true,"orderable":false,"search":{"value":"","regex":false}}],"order":[],"start":0,"length":10,"totalLength":0,"search":{"value":"","regex":false},"_ajax":true}'

ngx.log(ngx.ERR , "body :" , ss)

local ss = common.toJsonObject(ss)
ngx.say("id = " , ss.draw , "<br/>")
]]--

local ngx_log = ngx.log
local ngx_ERR = ngx.ERR

local common = require("module.common")
local apparea = require("module.apparea")
local area = apparea.findById(3647)

if common.isEmpty(area) ~= true then
    ngx_log(ngx_ERR , "user_list is not empty")
end

ngx.say("===========")

--[[local salt = "*&^%$#$^&kjtrKUYG"
local common = require("module.common")
local user = {
    id = 1,
    username = "小橙子",
    token ="111"
}

common.setCookie({
    key = "user", value = ngx.escape_uri(common.toJsonString(user)), path = "/"
    --key = "aaa", value = "123", path = "/"
})

local v = common.getCookie("user");
ngx.say(common.getCookie("user"),"<br/>")
if v then
    user = common.toJsonObject(ngx.unescape_uri(common.getCookie("user")))
    ngx.say("id = " , user.id , ", username = " , user.username , "<br/>")
end
]]--

--[[local bit = require("bit")

--- 使用密钥对字符串进行加密(解密)
--
-- @param string str 原始字符串(加密后的密文)
-- @param string key 密钥
-- @return string 加密后的密文(原始字符串)
local function encrypt(str, key)
    local strBytes = { str:byte(1, #str) }
    local keyBytes = { key:byte(1, #key) }
    local n, keyLen = 1, #keyBytes

    for i = 1, #strBytes do
        strBytes[i] = bit.bxor(strBytes[i], keyBytes[n])

        n = n + 1

        if n > keyLen then
            n = n - keyLen
        end
    end

    return string.char(unpack(strBytes))
end

-- 加密密钥
local ENCRYPT_KEY = "EFH@^&%#^&*@#G@&()*!&*@)(#$!@$GJHGHJ$G#HJ!$G"

-- 原始字符串
local originalStr = "Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!"

-- 加密字符串
local encryptStr = encrypt(originalStr, ENCRYPT_KEY)

-- 打印密文
ngx.say("encryptStr:" .. encryptStr , "<br/>")

-- 打印原文
ngx.say("originalStr:" .. encrypt(encryptStr, ENCRYPT_KEY) , "<br/>")
]]--

--ngx.say(ngx.md5("1234566" .. "*&^%$#$^&kjtrKUYG"))
