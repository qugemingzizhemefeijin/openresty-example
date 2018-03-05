--
-- lua-resty-template
--
--[[
而lua-resty-template和大多数模板引擎是类似的，大体内容有：
模板位置：从哪里查找模板；
变量输出/转义：变量值输出；
代码片段：执行代码片段，完成如if/else、for等复杂逻辑，调用对象函数/方法；
注释：解释代码片段含义；
include：包含另一个模板片段；
其他：lua-resty-template还提供了不需要解析片段、简单布局、可复用的代码块、宏指令等支持。

首先需要下载lua-resty-template
cd /usr/example/lualib/resty/
wget https://raw.githubusercontent.com/bungle/lua-resty-template/master/lib/resty/template.lua
mkdir /usr/example/lualib/resty/html
cd /usr/example/lualib/resty/html
wget https://raw.githubusercontent.com/bungle/lua-resty-template/master/lib/resty/template/html.lua

接下来就可以通过如下代码片段引用了
local template = require("resty.template")

我们需要告诉lua-resty-template去哪儿加载我们的模块，此处可以通过set指令定义template_location、template_root或者从root指令定义的位置加载。
如我们可以在example.conf配置文件的server部分定义
#first match ngx location
set $template_location "/templates";
#then match root read file
set $template_root "/usr/example/templates";

也可以通过在server部分定义root指令
root /usr/example/templates;

其顺序是
1、通过ngx.location.capture从template_location查找，如果找到（状态为为200）则使用该内容作为模板；此种方式是一种动态获取模板方式；
2、如果定义了template_root，则从该位置通过读取文件的方式加载模板；
3、如果没有定义template_root，则默认从root指令定义的document_root处加载模板。
此处建议首先template_root，如果实在有问题再使用template_location，尽量不要通过root指令定义的document_root加载，因为其本身的含义不是给本模板引擎使用的。


--]]

-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/5
-- Time: 11:21
-- To change this template use File | Settings | File Templates.
--

local template = require("resty.template")
template.render("t1.html")

--访问如http://192.168.1.2/lua_template_1将看到template2输出。然后rm /usr/example/templates2/t1.html，reload nginx将看到template1输出。
--接下来的测试我们会把模板文件都放到/usr/example/templates下。
--测试完成之后将template2目录删除掉，注释掉conf中的$template_location行
