FROM alpine:latest
MAINTAINER hmxrobert

RUN apk --update --no-cache add \
    ca-certificates \
    less \
    ncurses-terminfo-base \
    krb5-libs \
    libgcc \
    libintl \
    libssl1.1 \
    libstdc++ \
    tzdata \
    userspace-rcu \
    zlib \
    icu-libs \
    curl \
    git \
    ffmpeg \
    python3 && \
    apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
    lttng-ust && \
    curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.3.2/powershell-7.3.2-linux-alpine-x64.tar.gz -o /tmp/powershell.tar.gz && \
    mkdir -p /opt/microsoft/powershell/7 && \
    tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 && \
    chmod +x /opt/microsoft/powershell/7/pwsh && \
    ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

RUN mkdir -p /mnt/TVerRec/conf && mkdir -p /mnt/TVerRec/video && \
    mkdir -p /mnt/tmp

RUN git clone https://github.com/dongaba/TVerRec.git

WORKDIR /TVerRec

RUN sed -i "s|read -r -t $sleepTime|sleep $sleepTime |g" unix/start_tverrec.sh

RUN wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O ./bin/youtube-dl && \
    chmod +x ./bin/youtube-dl

VOLUME ["/mnt/TVerRec"]

RUN rm -rf conf && ln -s /mnt/TVerRec/conf conf

WORKDIR /TVerRec/unix/

ENTRYPOINT ["/bin/sh"]
CMD ["start_tverrec.sh"]
