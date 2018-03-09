--
-- 用户列表ajax查询
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/9
-- Time: 17:32
-- To change this template use File | Settings | File Templates.
--
ngx.header.content_type = "application/json;charset=utf8"

local common = require("module.common")
local ngx_log = ngx.log
local ngx_ERR = ngx.ERR
ngx.req.read_body()

local req_body = ngx.req.get_body_data() or "{}"

local query = common.toJsonObject(req_body)

--检查传递的参数
common.checkPostBodyQuery(query)

local sql = "select * from t_user limit "..query.start.." , "..query.length
ngx.log(ngx.ERR , "sql : " , sql)
local user_list = common.selectDB(sql)

if common.isEmpty(user_list) ~= true then
    ngx_log(ngx_ERR , "user_list is not empty")
end

ngx.say('{"recordsFiltered":0,"recordsTotal":0,"draw":1,"data":[]}')
