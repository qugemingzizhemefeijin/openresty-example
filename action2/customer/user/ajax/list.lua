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
local apparea = require("module.apparea")
local ngx_log = ngx.log
local ngx_ERR = ngx.ERR
ngx.req.read_body()

local req_body = ngx.req.get_body_data() or "{}"

local query = common.toJsonObject(req_body)

--检查传递的参数
common.checkPostBodyQuery(query)

local sql = "select * from t_user order by create_time desc limit "..query.start.." , "..query.length
ngx.log(ngx.ERR , "sql : " , sql)
local user_list = common.selectDB(sql)

local list = {}
if common.isEmpty(user_list) ~= true then
    for i=1, #user_list do
        local user = user_list[i]
        list[i] = {
            id = user.id.."",
            nickname = user.nickname,
            photo = user.photo,
            signature = user.signature,
            status = user.status,
            proxy = user.proxy,
            birthday = user.birthday,
            fr =  ngx.shared.shared_data:get("user_fr_"..user.fr) or '未知'
        }

        if user.status == 1 then
            list[i].statusStr = "正常"
        else
            list[i].statusStr = "停用"
        end

        if user.sex == 1 then
            list[i].sex = "男"
        else
            list[i].sex = "女"
        end

        local city = apparea.findById(user.cityid+0)
        if common.isEmpty(city) ~= true then
            list[i].cityname = city.name
        end
    end
end

local total = 0
local count_list = common.selectDB("select count(1) as c from t_user")
if common.isEmpty(count_list) ~= true then
    total = count_list[1].c + 0
end

local context = {
    recordsFiltered = total,
    recordsTotal = total,
    draw = query.draw,
    data = list
}
ngx.say(common.toJsonString(context))
