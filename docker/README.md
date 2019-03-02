## Shadowsocks-libev with v2ray-plugin docker image
### Usage
Edit configuration file `config_example.json` first. Then run:
```bash
docker build -t m3chd09/shadowsocks-with-v2ray-plugin .
docker run --name shadowsocks-with-v2ray-plugin -d -p 8008:8008 m3chd09/shadowsocks-with-v2ray-plugin
```
### Deploy it after nginx
Let's assume that you are using *Shadowsocks over websocket(HTTPS)*.  
Example configuration for nginx:  
```
server {
        listen       443 ssl http2;
        listen       [::]:443 ssl http2;
        server_name  example.com;     # Your domain.
        root         /usr/share/nginx/html/;
        ssl_certificate "/path/to/cert";     # Path to certificate
        ssl_certificate_key "/path/to/key";     # Path to private key
        ssl_session_cache shared:SSL:1m;
        ssl_session_timeout  10m;
        ssl_ciphers HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers on;
        location / {
            proxy_redirect off;
            proxy_http_version 1.1;
            proxy_pass http://localhost:8008;     # Port of v2ray-plugin
            proxy_set_header Host $http_host;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
        }
}
```
#### Nginx in host
Create this example configuration in `/etc/nginx/conf.d/v2ray.conf`.  
Change `server_name`, `ssl_certificate`, `ssl_certificate_key` and `proxy_pass` to suit your needs.  
#### Nginx in docker
Build and start shadowsocks-with-v2ray-plugin docker without exposing ports, then run:  
`docker run  --name nginx -p 443:443 --link shadowsocks-with-v2ray-plugin -d nginx`  
Create this example configuration in `/etc/nginx/conf.d/v2ray.conf` in nginx container.  
Change `server_name`, `ssl_certificate`, `ssl_certificate_key` and `proxy_pass` to suit your needs, which `proxy_pass` should look like `proxy_pass http://shadowsocks-with-v2ray-plugin:8008;`.  
Copy your SSL certificate and private key into nginx container.

Run `ss-local -c /path/to/config.json -p 443 --plugin v2ray-plugin --plugin-opts "tls;host=example.com"` on your client to connect.
