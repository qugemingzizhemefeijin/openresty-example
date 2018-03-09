--
-- 用户列表
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/9
-- Time: 16:55
-- To change this template use File | Settings | File Templates.
--

local common = require("module.common")
local context = common.page_init()

local template = require("resty.template")
template.render("customer/user/list.html" , context)
