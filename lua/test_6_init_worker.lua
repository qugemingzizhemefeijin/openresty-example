--init_worker_by_lua
--每个Nginx Worker进程启动时调用的计时器，如果Master进程不允许则只会在init_by_lua之后调用；
--用于启动一些定时任务，比如心跳检查，定时拉取服务器配置等等；此处的任务是跟Worker进程数量有关系的，比如有2个Worker进程那么就会启动两个完全一样的定时任务。
--所处处理阶段 loading-config
--使用范围 http

local count = 0
local delayInSeconds = 3
local heartbeatCheck = nil

heartbeatCheck = function(args)
    count = count + 1
    ngx.log(ngx.ERR, "do check ", count)

    local ok, err = ngx.timer.at(delayInSeconds, heartbeatCheck)

    if not ok then
        ngx.log(ngx.ERR, "failed to startup heartbeart worker...", err)
    end
end

heartbeatCheck()

--ngx.timer.at：延时调用相应的回调方法；ngx.timer.at(秒单位延时，回调函数，回调函数的参数列表)；可以将延时设置为0即得到一个立即执行的任务，
--任务不会在当前请求中执行不会阻塞当前请求，而是在一个轻量级线程中执行。

--另外根据实际情况设置如下指令
--lua_max_pending_timers 1024;  #最大等待任务数
--lua_max_running_timers 256;    #最大同时运行任务数