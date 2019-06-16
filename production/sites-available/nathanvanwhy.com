server {
	listen [::]:443 ssl ipv6only=on;
    listen 443 ssl;

	root /var/www/nathanvanwhy.com/public;

	index index.html;

	server_name nathanvanwhy.com;

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files $uri $uri/ =404;
	}

    ssl_certificate /etc/letsencrypt/live/nathanvanwhy.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/nathanvanwhy.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
}

# Do not allow HTTP connections
server {
    listen 80 ;
    listen [::]:80 ;
    server_name nathanvanwhy.com;
    return 301 https://$host$request_uri;
}