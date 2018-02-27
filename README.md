# Install ��װ����<br/>
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
���ص�bundleĿ¼<br/>
wget -q -O ngx_cache_purge.2.3.tar.gz https://github.com/FRiCKLE/ngx_cache_purge/archive/2.3.tar.gz<br/>
tar -zxvf ngx_cache_purge.2.3.tar.gz<br/>
<br/>
wget -q -O nginx_upstream_check_module.v0.3.0.tar.gz https://github.com/yaoweibin/nginx_upstream_check_module/archive/v0.3.0.tar.gz<br/>
tar -zxvf nginx_upstream_check_module.v0.3.0.tar.gz <br/>
<br/>
��װopenresty<br/>
./configure --prefix=/usr/local/openresty-1.13.6.1 --with-http_realip_module --with-pcre --with-luajit --add-module=./bundle/ngx_cache_purge-2.3/ --add-module=./bundle/nginx_upstream_check_module-0.3.0/ -j2<br/>
gmake && gmake install<br/>
<br/>
cd /usr/local/<br/>
ln -s openresty-1.13.6.1/ openresty<br/>
<br/>
��װnginx<br/>
wget -q http://nginx.org/download/nginx-1.13.6.tar.gz<br/>
tar -zxvf nginx-1.13.6.tar.gz<br/>
<br/>
export LUAJIT_LIB=/usr/local/openresty/luajit/lib<br/>
export LUAJIT_INC=/usr/local/openresty/luajit/include/luajit-2.1<br/>
<br/>
./configure --prefix=/usr/local/nginx-1.13.6 --with-ld-opt="-Wl,-rpath,/path/to/luajit-or-lua/lib" --add-module=/root/openresty-1.13.6.1/bundle/ngx_devel_kit-0.3.0 --add-module=/root/openresty-1.13.6.1/bundle/ngx_lua-0.10.11<br/>
make -j2 && make install<br/>
<br/>
<br/>
# ����nginx openresty<br/>
nginx.conf��httpģ������<br/>
<br/>
lua_package_path "/usr/local/openresty/lualib/?.lua;;";#lua ģ��<br/>
lua_package_cpath "/usr/local/openresty/lualib/?.so;;";#cģ��<br/>
<br/>
��ԭ����server����ɾ����<br/>
�½�lua.conf����server����<br/>
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
nginx��confĿ¼�½�lua�ļ���<br/>
vi test.lua<br/>
<br/>
д�����<br/>
ngx.say("hello world");<br/>
<br/>
ִ��<br/>
/usr/local/nginx/sbin/nginx -t<br/>
<br/>
���������<br/>
/usr/local/nginx/sbin/nginx: error while loading shared libraries: libluajit-5.1.so.2: cannot open shared object file: No such file or directory<br/>
<br/>
����ִ�д˶�<br/>
echo "/usr/local/lib" >> /etc/ld.so.conf.d/usr_local_lib.conf<br/>
<br/>
ldd nginx��鿴��<br/>
libluajit-5.1.so.2 => not found<br/>
��Ϊ<br/>
libluajit-5.1.so.2 => /usr/local/lib/libluajit-5.1.so.2 (0x00007f72d2e3c000)<br/>
<br/>
�ٴ�ִ��<br/>
/usr/local/nginx/sbin/nginx -t<br/>
<br/>
nginx: the configuration file /usr/local/nginx-1.13.6/conf/nginx.conf syntax is ok<br/>
nginx: configuration file /usr/local/nginx-1.13.6/conf/nginx.conf test is successful<br/>
<br/>
�����װ�ɹ�<br/>
<br/>
# lua_code_cache<br/>
Ĭ�������lua_code_cache  �ǿ����ģ�������lua���룬��ÿ��lua����������reload nginx����Ч������ڿ����׶ο���ͨ��lua_code_cache  off;�رջ��棬��������ʱÿ���޸�lua���벻��Ҫreload nginx��������ʽ����һ���ǵÿ������档<br/>
<br/>
��lua.conf��<br/>
location /lua {  <br/>
        default_type 'text/html';  <br/>
        lua_code_cache off;  #�������Ǵ���<br/>
        content_by_lua_file conf/lua/test.lua;  <br/>
}<br/>
<br/>
������reload nginx�ῴ�����±���<br/>
nginx: [alert] lua_code_cache is off; this will hurt performance in /usr/servers/nginx/conf/lua.conf:8<br/>
<br/>
<br/>
# ������־<br/>
<br/>
������й����г��ִ����벻Ҫ���ǲ鿴������־�� <br/>
tail -f /usr/local/nginx/logs/error.log<br/>
<br/>
�������ǵĻ����������ϡ�<br/>
<br/>
<br/>
# nginx+lua��Ŀ����<br/>
�Ժ����ǵ�nginx lua�����ļ���Խ��Խ�࣬����Ӧ�ð�����Ŀ�����ѷ��㿪������ĿĿ¼�ṹ������ʾ��<br/>
<br/>
example<br/>
    example.conf     ---����Ŀ��nginx �����ļ�<br/>
    lua              ---�����Լ���lua����<br/>
      test.lua<br/>
    lualib            ---lua������/����������<br/>
      *.lua<br/>
      *.so<br/>
<br/>
�������ǰ�lualibҲ�ŵ���Ŀ�еĺô������Ժ����ʱ�����һ���𣬷�ֹ�еķ��������Ǹ������������ȱ�������������<br/>
<br/>
���ǽ���Ŀ�ŵ���/usr/exampleĿ¼�¡�<br/>
<br/>
/usr/local/nginx/conf/nginx.conf�����ļ�����(�˴�������С���������ļ�)<br/>
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
    #luaģ��·�������С�;;����ʾĬ������·����Ĭ�ϵ�/usr/servers/nginx����<br/>
    lua_package_path "/usr/example/lualib/?.lua;;";  #lua ģ��<br/>
    lua_package_cpath "/usr/example/lualib/?.so;;";  #cģ��<br/>
    include /usr/example/example.conf;<br/>
}  <br/>
ͨ������·���������ǵ�lua�������nginx��Ŀ�����ļ���<br/>
<br/>
/usr/example/example.conf�����ļ����� <br/>
<br/>
Java����  �ղش���<br/>
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
lua�ļ�����ʹ�þ���·��/usr/example/lua/test.lua<br/>
<br/>
�������ǾͿ��԰�example��svn��git���ˡ�<br/>
