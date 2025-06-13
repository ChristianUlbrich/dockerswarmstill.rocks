FROM ghcr.io/christianulbrich/dockerswarmstillrocks-builder:latest as BUILDER

COPY docs /opt/build

RUN python ./scripts/docs.py build

FROM nginx:alpine

# Copy the site directory from the builder stage to the nginx html directory
COPY --from=BUILDER /opt/build/site /usr/share/nginx/html

# Optional: Set appropriate permissions
RUN chmod -R 755 /usr/share/nginx/html
