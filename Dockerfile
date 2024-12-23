# syntax=docker/dockerfile:1

# Keycloak base image version, set with --build-arg="KEYCLOAK_VERSION=..."
ARG KEYCLOAK_VERSION

# See "Installing additional RPM packages" https://www.keycloak.org/server/containers
FROM registry.access.redhat.com/ubi9 AS ubi-micro-build
ARG DEV_DEPENDENCIES="tar gzip util-linux"
RUN mkdir -p /mnt/rootfs
RUN dnf -y update
RUN dnf install --installroot /mnt/rootfs ${DEV_DEPENDENCIES} --releasever 9 --setopt install_weak_deps=false --nodocs -y && \
    dnf --installroot /mnt/rootfs clean all && \
    rpm --root /mnt/rootfs -e --nodeps setup

FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}
COPY --from=ubi-micro-build /mnt/rootfs /

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
