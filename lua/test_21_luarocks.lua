--
-- 我们在使用一些类库时会发现大部分库仅支持UTF-8编码，因此如果使用其他编码的话就需要进行编码转换的处理；而Linux上最常见的就是iconv，而lua-iconv就是它的一个Lua API的封装。
-- 安装lua-iconv可以通过如下两种方式：
-- yum -y install luarocks lua-devel
-- luarocks install lua-iconv
-- cp /usr/lib/lua/5.1/iconv.so  /usr/example/lualib/
--
-- 源码安装方式，需要有gcc环境
-- wget https://github.com/do^Cloads/ittner/lua-iconv/lua-iconv-7.tar.gz
-- tar -xvf lua-iconv-7.tar.gz
-- cd lua-iconv-7
-- gcc -O2 -fPIC -I/usr/include/lua5.1 -c luaiconv.c -o luaiconv.o -I/usr/include
-- gcc -shared -o iconv.so -L/usr/local/lib luaiconv.o -L/usr/lib
-- cp iconv.so  /usr/example/lualib/
--
-- Created by IntelliJ IDEA.
-- User: chengang
-- Date: 2018/3/2
-- Time: 16:36
-- To change this template use File | Settings | File Templates.
--

--ngx.say("中文")

local iconv = require("iconv")
local togbk = iconv.new("gbk", "utf-8")
local str, err = togbk:iconv("中文")
ngx.say(str)

--此时文件编码必须为UTF-8，即Lua文件编码为什么里边的字符编码就是什么。
--通过charset告诉浏览器我们的字符编码为gbk。
--访问 http://192.168.1.2/lua_iconv_test会发现输出乱码；

--通过转码我们得到最终输出的内容编码为gbk， 使用方式iconv.new(目标编码, 源编码)。
--有如下可能出现的错误
--nil 没有错误成功。
--iconv.ERROR_NO_MEMORY 内存不足。
--iconv.ERROR_INVALID 有非法字符。
--iconv.ERROR_INCOMPLETE 有不完整字符。
--iconv.ERROR_FINALIZED 使用已经销毁的转换器，比如垃圾回收了。
--iconv.ERROR_UNKNOWN 未知错误

--iconv在转换时遇到非法字符或不能转换的字符就会失败，此时可以使用如下方式忽略转换失败的字符
--local togbk_ignore = iconv.new("GBK//IGNORE", "UTF-8")

--另外在实际使用中进行UTF-8到GBK转换过程时，会发现有些字符在GBK编码表但是转换不了，此时可以使用更高的编码GB18030来完成转换。
--更多介绍请参考http://ittner.github.io/lua-iconv/。

