FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=redmine \
    BITNAMI_IMAGE_VERSION=3.3.0-r3 \
    PATH=/opt/bitnami/ruby/bin:$PATH

# Additional modules required
RUN bitnami-pkg install ruby-2.1.10-1 --checksum aa7c266eda9468e204980b41427a0566176aff5103b6ef96b81f86a525bc8772
RUN bitnami-pkg install imagemagick-6.7.5-10-3 --checksum 617e85a42c80f58c568f9bc7337e24c03e35cf4c7c22640407a7e1e16880cf88
RUN bitnami-pkg install mysql-libraries-10.1.13-0 --checksum 71ca428b619901123493503f8a99ccfa588e5afddd26e0d503a32cca1bc2a389
RUN bitnami-pkg install mysql-client-10.1.13-4 --checksum 14b45c91dd78b37f0f2366712cbe9bfdf2cb674769435611955191a65dbf4976

# Install redmine
RUN bitnami-pkg unpack redmine-3.3.0-0 --checksum 2634457caca2700cf48636f7cc2953e53dfd7b02d0c3f4fcb14e1a2124500919

COPY rootfs /

VOLUME ["/bitnami/redmine"]

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "redmine"]
