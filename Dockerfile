ARG DOCKER_GEN_VERSION=0.9.0
FROM ghcr.io/nginx-proxy/docker-gen:${DOCKER_GEN_VERSION} as docker-gen

FROM nginx:1.21-alpine

COPY --from=docker-gen /usr/local/bin/docker-gen /usr/local/bin/docker-gen
COPY ./app /app

#ensure docker-entrypoint is executable
RUN chmod +x /app/docker-entrypoint.sh 
COPY ./static/ /usr/share/nginx/html/
WORKDIR /app/

EXPOSE 80
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 CMD curl -f http://localhost/ || exit 1
ENTRYPOINT ["/app/docker-entrypoint.sh"]
