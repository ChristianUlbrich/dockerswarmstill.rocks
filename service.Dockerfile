ARG VERSION
FROM ghcr.io/christianulbrich/dockerswarmstillrocks-builder:$VERSION AS builder

COPY docs /opt/build

RUN python ./scripts/docs.py build

FROM nginx:alpine

COPY --from=builder /opt/build/site /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN chmod -R 755 /usr/share/nginx/html
