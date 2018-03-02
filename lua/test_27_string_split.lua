--
-- 字符串split案例
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/2
-- Time: 18:21
-- To change this template use File | Settings | File Templates.
--

local function split(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    while true do
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
        if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
            break
        end
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)
        nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end

local str = "我,爱,你,中,国"
local arr = split(str , ",")

for i,v in pairs(arr) do
    ngx.say(i,"-",v,"<br/>")
end

--如split("a,b,c", ",") 将得到一个分割后的table。
--到此基本的字符串操作就完成了，其他luautf8模块的API和LuaAPI类似可以参考
--http://cloudwu.github.io/lua53doc/manual.html#6.4
--http://cloudwu.github.io/lua53doc/manual.html#6.5
--另外对于GBK的操作，可以先转换为UTF-8，最后再转换为GBK即可。

