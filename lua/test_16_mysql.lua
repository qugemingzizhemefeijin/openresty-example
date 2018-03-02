--
-- 测试loadfile
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/2
-- Time: 10:08
-- To change this template use File | Settings | File Templates.
--

require("module.mysql_module")

local db = create_db()

--查询
local select_sql = "select id, ch from test"
local res, err, errno, sqlstate = db:query(select_sql)
if not res then
    ngx.say("select error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)
    return close_db(db)
end

for i, row in ipairs(res) do
    for name, value in pairs(row) do
        ngx.say("select row ", i, " : ", name, " = ", value, "<br/>")
    end
end

ngx.say("<br/>")

return close_db(db)

---完事了
