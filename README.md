# openresty-example
openresty example

nginx-1.13.6.tar.gz
openresty-1.13.6.1.tar.gz

# Install

yum -y install pcre pcre-devel libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl

wget https://openresty.org/download/openresty-1.13.6.1.tar.gz
tar -zxvf openresty-1.13.6.1.tar.gz

cd bundle/LuaJIT-2.1-20171103/
make clean && make && make install

���ص�bundleĿ¼
wget -q -O ngx_cache_purge.2.3.tar.gz https://github.com/FRiCKLE/ngx_cache_purge/archive/2.3.tar.gz
tar -zxvf ngx_cache_purge.2.3.tar.gz

wget -q -O nginx_upstream_check_module.v0.3.0.tar.gz https://github.com/yaoweibin/nginx_upstream_check_module/archive/v0.3.0.tar.gz
tar -zxvf nginx_upstream_check_module.v0.3.0.tar.gz 

��װopenresty
./configure --prefix=/usr/local/openresty-1.13.6.1 --with-http_realip_module --with-pcre --with-luajit --add-module=./bundle/ngx_cache_purge-2.3/ --add-module=./bundle/nginx_upstream_check_module-0.3.0/ -j2
gmake && gmake install

cd /usr/local/
ln -s openresty-1.13.6.1/ openresty

��װnginx
wget -q http://nginx.org/download/nginx-1.13.6.tar.gz
tar -zxvf nginx-1.13.6.tar.gz

export LUAJIT_LIB=/usr/local/openresty/luajit/lib
export LUAJIT_INC=/usr/local/openresty/luajit/include/luajit-2.1

./configure --prefix=/usr/local/nginx-1.13.6 --with-ld-opt="-Wl,-rpath,/path/to/luajit-or-lua/lib" --add-module=/root/openresty-1.13.6.1/bundle/ngx_devel_kit-0.3.0 --add-module=/root/openresty-1.13.6.1/bundle/ngx_lua-0.10.11
make -j2 && make install


#����nginx openresty
nginx.conf��httpģ������

lua_package_path "/usr/local/openresty/lualib/?.lua;;";#lua ģ��
lua_package_cpath "/usr/local/openresty/lualib/?.so;;";#cģ��

��ԭ����server����ɾ����
�½�lua.conf����server����

#lua.conf  
server {  
    listen       80;
    server_name  _;

    location /lua {  
        default_type 'text/html';
        content_by_lua_file conf/lua/test.lua;
    }
}

nginx��confĿ¼�½�lua�ļ���
vi test.lua

д�����
ngx.say("hello world");

ִ��
/usr/local/nginx/sbin/nginx -t

���������
/usr/local/nginx/sbin/nginx: error while loading shared libraries: libluajit-5.1.so.2: cannot open shared object file: No such file or directory

����ִ�д˶�
echo "/usr/local/lib" >> /etc/ld.so.conf.d/usr_local_lib.conf

ldd nginx��鿴��
libluajit-5.1.so.2 => not found
��Ϊ
libluajit-5.1.so.2 => /usr/local/lib/libluajit-5.1.so.2 (0x00007f72d2e3c000)

�ٴ�ִ��
/usr/local/nginx/sbin/nginx -t

nginx: the configuration file /usr/local/nginx-1.13.6/conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx-1.13.6/conf/nginx.conf test is successful

�����װ�ɹ�

#lua_code_cache
Ĭ�������lua_code_cache  �ǿ����ģ�������lua���룬��ÿ��lua����������reload nginx����Ч������ڿ����׶ο���ͨ��lua_code_cache  off;�رջ��棬��������ʱÿ���޸�lua���벻��Ҫreload nginx��������ʽ����һ���ǵÿ������档

��lua.conf��
location /lua {  
        default_type 'text/html';  
        lua_code_cache off;  #�������Ǵ���
        content_by_lua_file conf/lua/test.lua;  
}

������reload nginx�ῴ�����±���
nginx: [alert] lua_code_cache is off; this will hurt performance in /usr/servers/nginx/conf/lua.conf:8


#������־

������й����г��ִ����벻Ҫ���ǲ鿴������־�� 
tail -f /usr/local/nginx/logs/error.log

�������ǵĻ����������ϡ�


#nginx+lua��Ŀ����
�Ժ����ǵ�nginx lua�����ļ���Խ��Խ�࣬����Ӧ�ð�����Ŀ�����ѷ��㿪������ĿĿ¼�ṹ������ʾ��

example
    example.conf     ---����Ŀ��nginx �����ļ�
    lua              ---�����Լ���lua����
      test.lua
    lualib            ---lua������/����������
      *.lua
      *.so

�������ǰ�lualibҲ�ŵ���Ŀ�еĺô������Ժ����ʱ�����һ���𣬷�ֹ�еķ��������Ǹ������������ȱ�������������

���ǽ���Ŀ�ŵ���/usr/exampleĿ¼�¡�

/usr/local/nginx/conf/nginx.conf�����ļ�����(�˴�������С���������ļ�)

#user  nobody;
worker_processes  2;
error_log  logs/error.log;
events {
    worker_connections  1024;
}
http {
    include       mime.types;
    default_type  text/html;
  
    #luaģ��·�������С�;;����ʾĬ������·����Ĭ�ϵ�/usr/servers/nginx����
    lua_package_path "/usr/example/lualib/?.lua;;";  #lua ģ��
    lua_package_cpath "/usr/example/lualib/?.so;;";  #cģ��
    include /usr/example/example.conf;
}  
ͨ������·���������ǵ�lua�������nginx��Ŀ�����ļ���

/usr/example/example.conf�����ļ����� 

Java����  �ղش���
server {  
    listen       80;  
    server_name  _;  
  
    location /lua {  
        default_type 'text/html';
        lua_code_cache off;
        content_by_lua_file /usr/example/lua/test.lua;
    }  
}
lua�ļ�����ʹ�þ���·��/usr/example/lua/test.lua

�������ǾͿ��԰�example��svn��git���ˡ�
