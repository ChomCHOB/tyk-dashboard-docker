FROM ubuntu:14.04 

ENV TYK_DASHBOARD_VERSION 1.4.2
ENV NODE_JS_VERSION 6
ENV DASHBOARD_LISTEN_PORT 5000

RUN set -ex; \
  apt-get update && apt-get install -y --no-install-recommends \ 
    curl \
    ca-certificates \
    apt-transport-https \
    gnupg \
    unzip \
    python \
    build-essential; \
  \
  # install nodejs
  curl -sL https://deb.nodesource.com/setup_$NODE_JS_VERSION.x | sudo -E bash -; \
  apt-get install -y nodejs; \
  node -v; \
  npm install -g aglio; \
  \
  # install dashboard
  curl https://packagecloud.io/gpg.key | apt-key add -; \
  echo "deb https://packagecloud.io/tyk/tyk-dashboard/ubuntu/ trusty main" | tee /etc/apt/sources.list.d/tyk_tyk-dashboard.list; \
  echo "deb-src https://packagecloud.io/tyk/tyk-dashboard/ubuntu/ trusty main" | tee -a /etc/apt/sources.list.d/tyk_tyk-dashboard.list; \
  \
  apt-get update && apt-get install -y tyk-dashboard=$TYK_DASHBOARD_VERSION; \
  \
  # clean up
  apt-get purge -y build-essential; \
  apt-get autoremove -y; \
  rm -rf /var/lib/apt/lists/*; 

COPY tyk_analytics.conf /opt/tyk-dashboard/tyk_analytics.conf

WORKDIR /opt/tyk-dashboard

CMD ["/opt/tyk-dashboard/tyk-analytics", "--conf=/opt/tyk-dashboard/tyk_analytics.conf"]

EXPOSE 3000
EXPOSE 5000