--
-- Lua模块测试
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/1
-- Time: 16:10
-- To change this template use File | Settings | File Templates.
--

local module1 = require("module.module_1")
module1.hello()

--使用 local var = require("模块名")，该模块会到lua_package_path和lua_package_cpath声明的的位置查找我们的模块，对于多级目录的使用require("目录1.目录2.模块名")加载。
--基本的模块开发就完成了，如果是只读数据可以通过模块中声明local变量存储；
--如果想在每Worker进程共享，请考虑竞争；
--如果要在多个Worker进程间共享请考虑使用ngx.shared.DICT或如Redis存储。