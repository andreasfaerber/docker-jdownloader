FROM openjdk:jre-alpine as builder
FROM builder

ARG ARCH=armhf
ARG VERSION="1.3.1"
LABEL maintainer="Jay MOULIN <https://jaymoulin.me/me/docker-jdownloader> <https://twitter.com/MoulinJay>"
LABEL version="${VERSION}-${ARCH}"
ENV LD_LIBRARY_PATH=/lib;/lib32;/usr/lib
ENV XDG_DOWNLOAD_DIR=/opt/JDownloader/Downloads

COPY ./${ARCH}/*.jar /opt/JDownloader_install/libs/
# archive extraction uses sevenzipjbinding library
# which is compiled against libstdc++
RUN mkdir -p /opt/JDownloader_install/ && \
    apk add --update libstdc++ ffmpeg wget && \
    wget -O /opt/JDownloader_install/JDownloader.jar "http://installer.jdownloader.org/JDownloader.jar?$RANDOM" && \
    chmod +x /opt/JDownloader_install/JDownloader.jar && \
    chmod 777 /opt/JDownloader_install/ -R

COPY daemon.sh /opt/JDownloader_install/
COPY daemon_loop.sh /opt/JDownloader_install/
COPY default-config.json.dist /opt/JDownloader_install/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist
COPY configure.sh /usr/bin/configure

EXPOSE 3129
WORKDIR /opt/JDownloader


CMD ["/opt/JDownloader/daemon_loop.sh"]
