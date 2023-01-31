
FROM postgres:14
SHELL ["/bin/bash", "-c"]

WORKDIR /src
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
      bzip2 \
      gcc \
      make \
      libc-dev \
      libicu-dev \
      postgresql-server-dev-14 \
      wget \
      unzip \
      ca-certificates \
      openssl \
  && wget -q -O - "http://www.xunsearch.com/scws/down/scws-1.2.3.tar.bz2" | tar jxvv \
  && wget -q -O - "https://github.com/amutu/zhparser/archive/refs/tags/V2.2.tar.gz" | tar zxvv \
  && wget -q -O - "https://ja.osdn.net/dl/pgbigm/pg_bigm-1.2-20200228.tar.gz" | tar zxvv \
  && cd /src/scws-1.2.3 && ./configure && make install \
  && cd /src/zhparser-2.2 && SCWS_HOME=/usr/local make && make install \
  && cd /src/pg_bigm-1.2-20200228 && make USE_PGXS=1 && make USE_PGXS=1 install \
  && apt-get purge -y gcc make libc-dev libicu-dev postgresql-server-dev-14 \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf \
    /src/zhparser-2.2 \
    /src/scws-1.2.3 \
    /src/pg_bigm-1.2-20200228

RUN echo shared_preload_libraries='pg_bigm' >> /var/lib/postgresql/data/postgresql.conf
COPY init-zhparser.sql /docker-entrypoint-initdb.d/init-zhparser.sql

