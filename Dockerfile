FROM vulhub/nginx:heartbleed

MAINTAINER phithon <root@leavesongs.com>

RUN ln -sf /dev/stdout /var/log/access.log \
	&& ln -sf /dev/stderr /var/log/error.log \
    && ln -sf /usr/local/nginx/sbin/nginx /usr/sbin/nginx

RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y openssl \
    && mkdir -p /etc/ssl/nginx/ \
    && openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/nginx/local.key \
        -out /etc/ssl/nginx/local.crt \
        -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=localhost" \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge -y --auto-remove openssl

EXPOSE 80 443

CMD ["nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]