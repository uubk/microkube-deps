FROM golang:stretch
RUN mkdir /build && apt update && apt install -y rsync
COPY cni-plugins /build/cni-plugins
COPY etcd /build/etcd
COPY kubernetes /build/kubernetes
COPY build.sh /build
# ETCD build relies on this...
COPY .git /build/.git
RUN cd /build && ./build.sh && chmod -R uga+rwx artifacts && tar -cvf /payload.tar artifacts

FROM busybox
COPY --from=0 /payload.tar /
CMD tar -xvf /payload.tar -C /target
