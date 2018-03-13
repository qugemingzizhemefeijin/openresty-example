--
-- 初始化常量
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/13
-- Time: 17:26
-- To change this template use File | Settings | File Templates.
--

if not ngx.shared.shared_data:get("user_fr_0") then
    ngx.shared.shared_data:set("user_fr_0" , "未知")
    ngx.shared.shared_data:set("user_fr_1" , "微信注册")
    ngx.shared.shared_data:set("user_fr_2" , "QQ注册")
    ngx.shared.shared_data:set("user_fr_3" , "手机注册")
    ngx.shared.shared_data:set("user_fr_4" , "客服注册")
    ngx.shared.shared_data:set("user_fr_9" , "机器人")
    ngx.shared.shared_data:set("user_fr_10" , "美丽约机器人")

    ngx.log(ngx.ERR , "初始化常量...")
end
