--
-- lua-resty-mysql是为基于cosocket API的ngx_lua提供的Lua Mysql客户端，通过它可以完成Mysql的操作。
-- 默认安装OpenResty时已经自带了该模块，使用文档可参考https://github.com/openresty/lua-resty-mysql。
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/1
-- Time: 18:12
-- To change this template use File | Settings | File Templates.
--

--关闭mysql连接
local function close_db(db)
    if not db then
        return
    end
    db:close()
end

local mysql = require("resty.mysql")
--创建实例
local db, err = mysql:new()
if not db then
    ngx.say("new mysql error : ", err)
    return
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
    return close_db(db)
end

--删除表
local drop_table_sql = "drop table if exists test"
res, err, errno, sqlstate = db:query(drop_table_sql)
if not res then
    ngx.say("drop table error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)
    return close_db(db)
end

--创建表
local create_table_sql = "create table test(id int primary key auto_increment, ch varchar(100))"
res, err, errno, sqlstate = db:query(create_table_sql)
if not res then
    ngx.say("create table error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)
    return close_db(db)
end

--插入
local insert_sql = "insert into test (ch) values('hello')"
res, err, errno, sqlstate = db:query(insert_sql)
if not res then
    ngx.say("insert error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)
    return close_db(db)
end

res, err, errno, sqlstate = db:query(insert_sql)
ngx.say("insert rows : ", res.affected_rows, " , id : ", res.insert_id, "<br/>")

--更新
local update_sql = "update test set ch = 'hello2' where id =" .. res.insert_id
res, err, errno, sqlstate = db:query(update_sql)
if not res then
    ngx.say("update error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)
    return close_db(db)
end

ngx.say("update rows : ", res.affected_rows, "<br/>")
--查询
local select_sql = "select id, ch from test"
res, err, errno, sqlstate = db:query(select_sql)
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

--防止sql注入
local ch_param = ngx.req.get_uri_args()["ch"] or ''
--使用ngx.quote_sql_str防止sql注入
local query_sql = "select id, ch from test where ch = " .. ngx.quote_sql_str(ch_param)
res, err, errno, sqlstate = db:query(query_sql)
if not res then
    ngx.say("select error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)
    return close_db(db)
end

for i, row in ipairs(res) do
    for name, value in pairs(row) do
        ngx.say("select row ", i, " : ", name, " = ", value, "<br/>")
    end
end

--删除
local delete_sql = "delete from test"
res, err, errno, sqlstate = db:query(delete_sql)
if not res then
    ngx.say("delete error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)
    return close_db(db)
end

ngx.say("delete rows : ", res.affected_rows, "<br/>")

return close_db(db)

--对于新增/修改/删除会返回如下格式的响应：
--[[{
    insert_id = 0,
    server_status = 2,
    warning_count = 1,
    affected_rows = 32,
    message = nil
}
affected_rows表示操作影响的行数，insert_id是在使用自增序列时产生的id。

对于查询会返回如下格式的响应：
{
    { id= 1, ch= "hello"},
    { id= 2, ch= "hello2"}
}

null将返回ngx.null。

客户端目前还没有提供预编译SQL支持（即占位符替换位置变量），这样在入参时记得使用ngx.quote_sql_str进行字符串转义，防止sql注入；连接池和之前Redis客户端完全一样就不介绍了。
对于Mysql客户端的介绍基本够用了，更多请参考https://github.com/openresty/lua-resty-mysql。
其他如MongoDB等数据库的客户端可以从github上查找使用。
--]]

