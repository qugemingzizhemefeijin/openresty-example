--
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/7
-- Time: 11:07
-- To change this template use File | Settings | File Templates.
--

local common = require("module.common")
local context = common.page_init()

local template = require("resty.template")
template.render("login.html" , context)

