FROM jekyll/jekyll AS build-stage

# Note: Can't use /srv/jekyll dir, as the base image mounts a volume here so every RUN's changes get discarded
RUN mkdir /srv/build
# RUN chmod -R 777 /srv/build
RUN chown -R jekyll:jekyll /srv/build

WORKDIR /srv/build

ADD _data /srv/build/_data
ADD _includes /srv/build/_includes
ADD _layouts /srv/build/_layouts
ADD _sass /srv/build/_sass
ADD assets /srv/build/assets
ADD _config.yml /srv/build/_config.yml
ADD favicon.ico /srv/build/favicon.ico
ADD index.html /srv/build/index.html

RUN whoami

RUN jekyll build --source /srv/build --trace

FROM nginx:1.16

COPY --from=build-stage /srv/build/_site /usr/share/nginx/html
