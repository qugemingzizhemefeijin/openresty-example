--
-- 删除空格
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/2
-- Time: 18:14
-- To change this template use File | Settings | File Templates.
--

local string_find = string.find
local string_sub = string.sub

--删除左侧空格
local function ltrim(s)
    if not s then
        return s
    end
    local res = s
    local tmp = string_find(res, '%S')
    if not tmp then
        res = ''
    elseif tmp ~= 1 then
        res = string_sub(res, tmp)
    end
    return res
end

--删除右侧空格
local function rtrim(s)
    if not s then
        return s
    end
    local res = s
    local tmp = string_find(res, '%S%s*$')
    if not tmp then
        res = ''
    elseif tmp ~= #res then
        res = string_sub(res, 1, tmp)
    end

    return res
end

--删除左右空格
local function trim(s)
    if not s then
        return s
    end
    local res1 = ltrim(s)
    local res2 = rtrim(res1)
    return res2
end

local str = " 我爱你中国 "
ngx.say("before trim[",str,"] and after trim[",trim(str),"]", "<br/>")

