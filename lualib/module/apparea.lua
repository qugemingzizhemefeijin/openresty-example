--
-- 城市信息
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/13
-- Time: 15:24
-- To change this template use File | Settings | File Templates.
--

local common = require("module.common")

local ngx_log = ngx.log
local ngx_ERR = ngx.ERR
local namespace = "apparea_"
local shared_data = ngx.shared.shared_data

--根据ID获取城市信息
local function findById(id)
    if not id or type(id) ~= 'number' then
        ngx_log(ngx_ERR , "id not found or id not number type."..type(id))
        return ngx.null
    end

    local area_string = shared_data:get(namespace..id)
    --ngx.log(ngx.ERR , area_string)
    local area = common.toJsonObject(area_string)
    if not area or area==ngx.null then
        ngx_log(ngx_ERR , "area can not found , reload data!")

        local sql = "select * from t_app_area where id = "..id
        ngx.log(ngx.ERR , sql)

        local areaList = common.selectDB(sql)
        if not areaList or areaList == ngx.null then
            areaList = {[1]={}}
        end

        area = areaList[1]

        shared_data:set(namespace..id , common.toJsonString(area))
    end

    return area
end

local _M = {
    findById = findById
}

return _M
