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

返回到bundle目录
wget -q -O ngx_cache_purge.2.3.tar.gz https://github.com/FRiCKLE/ngx_cache_purge/archive/2.3.tar.gz
tar -zxvf ngx_cache_purge.2.3.tar.gz

wget -q -O nginx_upstream_check_module.v0.3.0.tar.gz https://github.com/yaoweibin/nginx_upstream_check_module/archive/v0.3.0.tar.gz
tar -zxvf nginx_upstream_check_module.v0.3.0.tar.gz 

安装openresty
./configure --prefix=/usr/local/openresty-1.13.6.1 --with-http_realip_module --with-pcre --with-luajit --add-module=./bundle/ngx_cache_purge-2.3/ --add-module=./bundle/nginx_upstream_check_module-0.3.0/ -j2
gmake && gmake install

cd /usr/local/
ln -s openresty-1.13.6.1/ openresty

安装nginx
wget -q http://nginx.org/download/nginx-1.13.6.tar.gz
tar -zxvf nginx-1.13.6.tar.gz

export LUAJIT_LIB=/usr/local/openresty/luajit/lib
export LUAJIT_INC=/usr/local/openresty/luajit/include/luajit-2.1

./configure --prefix=/usr/local/nginx-1.13.6 --with-ld-opt="-Wl,-rpath,/path/to/luajit-or-lua/lib" --add-module=/root/openresty-1.13.6.1/bundle/ngx_devel_kit-0.3.0 --add-module=/root/openresty-1.13.6.1/bundle/ngx_lua-0.10.11
make -j2 && make install


#配置nginx openresty
nginx.conf中http模块新增

lua_package_path "/usr/local/openresty/lualib/?.lua;;";#lua 模块
lua_package_cpath "/usr/local/openresty/lualib/?.so;;";#c模块

将原来的server区块删除掉
新建lua.conf放入server区块

#lua.conf  
server {  
    listen       80;
    server_name  _;

    location /lua {  
        default_type 'text/html';
        content_by_lua_file conf/lua/test.lua;
    }
}

nginx的conf目录新建lua文件夹
vi test.lua

写入此行
ngx.say("hello world");

执行
/usr/local/nginx/sbin/nginx -t

如果报错误
/usr/local/nginx/sbin/nginx: error while loading shared libraries: libluajit-5.1.so.2: cannot open shared object file: No such file or directory

可以执行此段
echo "/usr/local/lib" >> /etc/ld.so.conf.d/usr_local_lib.conf

ldd nginx后查看由
libluajit-5.1.so.2 => not found
变为
libluajit-5.1.so.2 => /usr/local/lib/libluajit-5.1.so.2 (0x00007f72d2e3c000)

再次执行
/usr/local/nginx/sbin/nginx -t

nginx: the configuration file /usr/local/nginx-1.13.6/conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx-1.13.6/conf/nginx.conf test is successful

则代表安装成功

#lua_code_cache
默认情况下lua_code_cache  是开启的，即缓存lua代码，即每次lua代码变更必须reload nginx才生效，如果在开发阶段可以通过lua_code_cache  off;关闭缓存，这样调试时每次修改lua代码不需要reload nginx；但是正式环境一定记得开启缓存。

在lua.conf中
location /lua {  
        default_type 'text/html';  
        lua_code_cache off;  #新增的是此行
        content_by_lua_file conf/lua/test.lua;  
}

开启后reload nginx会看到如下报警
nginx: [alert] lua_code_cache is off; this will hurt performance in /usr/servers/nginx/conf/lua.conf:8


#错误日志

如果运行过程中出现错误，请不要忘记查看错误日志。 
tail -f /usr/local/nginx/logs/error.log

到此我们的基本环境搭建完毕。


#nginx+lua项目构建
以后我们的nginx lua开发文件会越来越多，我们应该把其项目化，已方便开发。项目目录结构如下所示：

example
    example.conf     ---该项目的nginx 配置文件
    lua              ---我们自己的lua代码
      test.lua
    lualib            ---lua依赖库/第三方依赖
      *.lua
      *.so

其中我们把lualib也放到项目中的好处就是以后部署的时候可以一起部署，防止有的服务器忘记复制依赖而造成缺少依赖的情况。

我们将项目放到到/usr/example目录下。

/usr/local/nginx/conf/nginx.conf配置文件如下(此处我们最小化了配置文件)

#user  nobody;
worker_processes  2;
error_log  logs/error.log;
events {
    worker_connections  1024;
}
http {
    include       mime.types;
    default_type  text/html;
  
    #lua模块路径，其中”;;”表示默认搜索路径，默认到/usr/servers/nginx下找
    lua_package_path "/usr/example/lualib/?.lua;;";  #lua 模块
    lua_package_cpath "/usr/example/lualib/?.so;;";  #c模块
    include /usr/example/example.conf;
}  
通过绝对路径包含我们的lua依赖库和nginx项目配置文件。

/usr/example/example.conf配置文件如下 

Java代码  收藏代码
server {  
    listen       80;  
    server_name  _;  
  
    location /lua {  
        default_type 'text/html';
        lua_code_cache off;
        content_by_lua_file /usr/example/lua/test.lua;
    }  
}
lua文件我们使用绝对路径/usr/example/lua/test.lua

到此我们就可以把example扔svn或git上了。
