--
-- mysql 公共函数自定义
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/2
-- Time: 10:39
-- To change this template use File | Settings | File Templates.
--

local mysql = require("resty.mysql")

--关闭mysql连接
function close_db(db)
    if not db then
        return
    end
    db:close()
end

--创建mysql连接
function create_db()
    --创建实例
    local db, err = mysql:new()
    if not db then
        ngx.say("new mysql error : ", err)
        return nil
    end
    --设置超时时间(毫秒)
    db:set_timeout(1000)

    local props = {
        host = "192.168.20.3",
        port = 3306,
        database = "miai_passport_test",
        user = "miai_passport",
        password = "miai_passport2017"
    }

    local res, err, errno, sqlstate = db:connect(props)
    if not res then
        ngx.say("connect to mysql error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)
        close_db(db)
        return nil
    end

    return db
end
