# # Stage 1
# FROM debian:latest AS build-env
#
# RUN apt-get update
# RUN apt-get install -y curl git wget unzip zip gdb xz-utils libglu1-mesa fonts-droid-fallback python3
# RUN apt-get clean
#
# RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
#
# ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
#
# RUN flutter doctor -v
#
# RUN flutter channel master
# RUN flutter upgrade
# RUN flutter config --enable-web
#
# RUN mkdir /app/
# COPY . /app/
# WORKDIR /app/
# RUN flutter build web
#
# # EXPOSE 80
# # EXPOSE 8000
#
# # Stage 2
# FROM nginx:1.21.1-alpine
FROM nginx:bullseye

# Remove the default Nginx configuration file
RUN rm /etc/nginx/conf.d/default.conf

# Add a new configuration file
COPY nginx.conf /etc/nginx/conf.d/

# RUN mkdir /app/
# COPY . /app/
# WORKDIR /app/
# COPY --from=build-env  /app/build/web /usr/share/nginx/html

# Copy the compiled flutter files to the Nginx document root
COPY ./build/web /usr/share/nginx/html

# # Copy the HTML file to the Nginx document root
# COPY index.html /usr/share/nginx/html
########################################### URL Rewriting ###########################################
RUN mv /usr/share/nginx/html/index.html /usr/share/nginx/html/index.html.template
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
RUN ls /usr/share/nginx/html
RUN env
