FROM golang:1.14-buster

ENV GOPROXY https://goproxy.cn
ENV RUSTUP_DIST_SERVER https://mirrors.ustc.edu.cn/rust-static/
ENV RUSTUP_UPDATE_ROOT https://mirrors.ustc.edu.cn/rust-static/rustup

RUN mkdir /tidb

# dependencies of tikv
COPY run/aliyun-debian-buster.source.list /etc/apt/sources.list
RUN apt-get update && apt-get install -y cmake
COPY run/rustup-init.sh /
RUN bash /rustup-init.sh -y

# build tikv
COPY tikv/ /tidb/tikv/
WORKDIR /tidb/tikv
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup component add rustfmt clippy
COPY run/cargo_config /root/.cargo/config
RUN make build -j4


# dependencies of pd
RUN apt-get install -y zip

# build pd
COPY pd/ /tidb/pd
WORKDIR /tidb/pd
RUN make -j4


# build tidb
COPY tidb/ /tidb/tidb/
WORKDIR /tidb/tidb
RUN make -j4


# collect binaries
RUN mkdir /tidb/bin && \
    mv /tidb/tikv/target/debug/tikv-* /tidb/bin/ && \
    mv /tidb/tidb/bin/tidb-* /tidb/bin/ && \
    mv /tidb/pd/bin/pd-* /tidb/bin/


# rock n roll!
RUN apt-get install -y mariadb-client
WORKDIR /tidb/bin
COPY run/entry.sh .
ENTRYPOINT [ "./entry.sh" ]
