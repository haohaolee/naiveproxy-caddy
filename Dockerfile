FROM alpine:latest

ENV NAIVEPROXY_VERSION=v81.0.4044.92-1

# install s6-overlay & caddy & naiveproxy
RUN apk add --no-cache --virtual .build-deps \
     curl binutils \
  && curl -OJ 'https://caddyserver.com/download/linux/amd64?plugins=http.forwardproxy&license=personal' \
  && echo "caddy" | tar xf caddy_*.tar.gz -C /usr/local/bin/ -T - \
  && rm caddy_*.tar.gz && strip /usr/local/bin/caddy \
  && curl --fail --silent -L https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-amd64.tar.gz | \
    tar xzvf - -C / \
  && curl --fail --silent -L https://github.com/klzgrad/naiveproxy/releases/download/${NAIVEPROXY_VERSION}/naiveproxy-${NAIVEPROXY_VERSION}-openwrt-x86_64.tar.xz | \
    tar xJvf - -C / && mv naiveproxy-* naiveproxy \
  && strip /naiveproxy/naive \
  && apk del .build-deps

# dependency of naiveproxy
RUN apk add --no-cache nss

COPY ./services /etc/services.d/

ENTRYPOINT [ "/init" ]

