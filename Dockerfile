FROM gcr.io/stacksmith-images/ubuntu:14.04-r10
MAINTAINER Bitnami <containers@bitnami.com>

RUN bitnami-pkg unpack apache-2.4.23-5 --checksum ce7996de3c2173a72ad742e7ad0b4d48a1947454d4e0001497be74f19f9aa74c
RUN ln -sf /opt/bitnami/apache/htdocs /app
ENV PATH=/opt/bitnami/apache/sbin:/opt/bitnami/apache/bin:/opt/bitnami/common/bin:$PATH

ENV BITNAMI_APP_NAME=apache \
    BITNAMI_APP_USER=daemon \
    BITNAMI_IMAGE_VERSION=2.4.23-r6

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "apache"]

VOLUME ["/bitnami/apache"]

WORKDIR /app

EXPOSE 80 443
