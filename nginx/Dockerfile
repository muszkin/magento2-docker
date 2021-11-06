FROM nginx:alpine
ARG MEMORY_LIMIT
WORKDIR /var/www/html
COPY nginx.conf.sample /etc/nginx/nginx.conf.sample
RUN sed -i 's/memory_limit=756M/memory_limit='${MEMORY_LIMIT}'/g' /etc/nginx/nginx.conf.sample
CMD ["nginx"]
EXPOSE 80