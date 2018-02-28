# Install 安装流程<br/>
nginx-1.13.6.tar.gz openresty-1.13.6.1.tar.gz<br/>
<br/>
yum -y install pcre pcre-devel libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl<br/>
<br/>
wget https://openresty.org/download/openresty-1.13.6.1.tar.gz<br/>
tar -zxvf openresty-1.13.6.1.tar.gz<br/>
<br/>
cd bundle/LuaJIT-2.1-20171103/<br/>
make clean && make && make install<br/>
<br/>
返回到bundle目录<br/>
wget -q -O ngx_cache_purge.2.3.tar.gz https://github.com/FRiCKLE/ngx_cache_purge/archive/2.3.tar.gz<br/>
tar -zxvf ngx_cache_purge.2.3.tar.gz<br/>
<br/>
wget -q -O nginx_upstream_check_module.v0.3.0.tar.gz https://github.com/yaoweibin/nginx_upstream_check_module/archive/v0.3.0.tar.gz<br/>
tar -zxvf nginx_upstream_check_module.v0.3.0.tar.gz <br/>
<br/>
安装openresty<br/>
./configure --prefix=/usr/local/openresty-1.13.6.1 --with-http_realip_module --with-pcre --with-luajit --add-module=./bundle/ngx_cache_purge-2.3/ --add-module=./bundle/nginx_upstream_check_module-0.3.0/ -j2<br/>
gmake && gmake install<br/>
<br/>
cd /usr/local/<br/>
ln -s openresty-1.13.6.1/ openresty<br/>
<br/>
安装nginx<br/>
wget -q http://nginx.org/download/nginx-1.13.6.tar.gz<br/>
tar -zxvf nginx-1.13.6.tar.gz<br/>
<br/>
export LUAJIT_LIB=/usr/local/openresty/luajit/lib<br/>
export LUAJIT_INC=/usr/local/openresty/luajit/include/luajit-2.1<br/>
<br/>
./configure --prefix=/usr/local/nginx-1.13.6 \<br/>
--with-ld-opt="-Wl,-rpath,/path/to/luajit-or-lua/lib" \<br/>
--add-module=/root/openresty-1.13.6.1/bundle/ngx_devel_kit-0.3.0 \<br/>
--add-module=/root/openresty-1.13.6.1/bundle/ngx_lua-0.10.11 \<br/>
--add-module=/root/openresty-1.13.6.1/bundle/echo-nginx-module-0.61<br/>
<br/>
make -j2 && make install<br/>
<br/>
<br/>
# 配置nginx openresty<br/>
nginx.conf中http模块新增<br/>
<br/>
http {<br/>
    include       mime.types;<br/>
    default_type  application/octet-stream;<br/>
    sendfile        on;<br/>
    keepalive_timeout  65;<br/>
    gzip  on;<br/>
    lua_package_path "/opt/openresty/openresty-example/lualib/?.lua;;";#lua 模块<br/>
    lua_package_cpath "/opt/openresty/openresty-example/lualib/?.so;;";#c模块<br/>
    include /opt/openresty/openresty-example/lua.conf;<br/>
}<br/>
<br/>
将原来的server区块删除掉<br/>
新建lua.conf放入server区块<br/>
<br/>
#lua.conf  <br/>
server {  <br/>
    listen       80;<br/>
    server_name  _;<br/>
<br/>
    location /lua {  <br/>
        default_type 'text/html';<br/>
        content_by_lua_file conf/lua/test.lua;<br/>
    }<br/>
}<br/>
<br/>
nginx的conf目录新建lua文件夹<br/>
vi test.lua<br/>
<br/>
写入此行<br/>
ngx.say("hello world");<br/>
<br/>
执行<br/>
/usr/local/nginx/sbin/nginx -t<br/>
<br/>
如果报错误<br/>
/usr/local/nginx/sbin/nginx: error while loading shared libraries: libluajit-5.1.so.2: cannot open shared object file: No such file or directory<br/>
<br/>
可以执行此段<br/>
echo "/usr/local/lib" >> /etc/ld.so.conf.d/usr_local_lib.conf<br/>
<br/>
ldd nginx后查看由<br/>
libluajit-5.1.so.2 => not found<br/>
变为<br/>
libluajit-5.1.so.2 => /usr/local/lib/libluajit-5.1.so.2 (0x00007f72d2e3c000)<br/>
<br/>
再次执行<br/>
/usr/local/nginx/sbin/nginx -t<br/>
<br/>
nginx: the configuration file /usr/local/nginx-1.13.6/conf/nginx.conf syntax is ok<br/>
nginx: configuration file /usr/local/nginx-1.13.6/conf/nginx.conf test is successful<br/>
<br/>
则代表安装成功<br/>
<br/>
# lua_code_cache<br/>
默认情况下lua_code_cache  是开启的，即缓存lua代码，即每次lua代码变更必须reload nginx才生效，如果在开发阶段可以通过lua_code_cache  off;关闭缓存，这样调试时每次修改lua代码不需要reload nginx；但是正式环境一定记得开启缓存。<br/>
<br/>
在lua.conf中<br/>
location /lua {  <br/>
        default_type 'text/html';  <br/>
        lua_code_cache off;  #新增的是此行<br/>
        content_by_lua_file conf/lua/test.lua;  <br/>
}<br/>
<br/>
开启后reload nginx会看到如下报警<br/>
nginx: [alert] lua_code_cache is off; this will hurt performance in /usr/servers/nginx/conf/lua.conf:8<br/>
<br/>
<br/>
# 错误日志<br/>
<br/>
如果运行过程中出现错误，请不要忘记查看错误日志。 <br/>
tail -f /usr/local/nginx/logs/error.log<br/>
<br/>
到此我们的基本环境搭建完毕。<br/>
<br/>
<br/>
# nginx+lua项目构建<br/>
以后我们的nginx lua开发文件会越来越多，我们应该把其项目化，已方便开发。项目目录结构如下所示：<br/>
<br/>
example<br/>
    example.conf     ---该项目的nginx 配置文件<br/>
    lua              ---我们自己的lua代码<br/>
      test.lua<br/>
    lualib            ---lua依赖库/第三方依赖<br/>
      *.lua<br/>
      *.so<br/>
<br/>
其中我们把lualib也放到项目中的好处就是以后部署的时候可以一起部署，防止有的服务器忘记复制依赖而造成缺少依赖的情况。<br/>
<br/>
我们将项目放到到/usr/example目录下。<br/>
<br/>
/usr/local/nginx/conf/nginx.conf配置文件如下(此处我们最小化了配置文件)<br/>
<br/>
#user  nobody;<br/>
worker_processes  2;<br/>
error_log  logs/error.log;<br/>
events {<br/>
    worker_connections  1024;<br/>
}<br/>
http {<br/>
    include       mime.types;<br/>
    default_type  text/html;<br/>
  <br/>
    #lua模块路径，其中”;;”表示默认搜索路径，默认到/usr/servers/nginx下找<br/>
    lua_package_path "/usr/example/lualib/?.lua;;";  #lua 模块<br/>
    lua_package_cpath "/usr/example/lualib/?.so;;";  #c模块<br/>
    include /usr/example/example.conf;<br/>
}  <br/>
通过绝对路径包含我们的lua依赖库和nginx项目配置文件。<br/>
<br/>
/usr/example/example.conf配置文件如下 <br/>
<br/>
server {  <br/>
    listen       80;  <br/>
    server_name  _;  <br/>
  <br/>
    location /lua {  <br/>
        default_type 'text/html';<br/>
        lua_code_cache off;<br/>
        content_by_lua_file /usr/example/lua/test.lua;<br/>
    }  <br/>
}<br/>
lua文件我们使用绝对路径/usr/example/lua/test.lua<br/>
<br/>
到此我们就可以把example扔svn或git上了。<br/>

# 相关资料<br/>
参考开涛的博客 (OpenResty + Lua 开发入门) http://jinnianshilongnian.iteye.com/blog/2190344<br/>
nginx与lua的执行顺序和步骤说明 http://blog.csdn.net/wlgy123/article/details/49815531<br/>
Lua简明教程 http://coolshell.cn/articles/10739.html<br/>
lua在线lua学习教程 http://book.luaer.cn/<br/>
Lua 5.1 参考手册 http://www.codingnow.com/2000/download/lua_manual.html<br/>
Lua 5.3 参考手册 http://cloudwu.github.io/lua53doc/<br/>