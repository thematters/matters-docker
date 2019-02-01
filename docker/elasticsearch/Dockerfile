FROM maven:3.6-jdk-8

ENV PLUGIN_PATH file:///elasticsearch-vector-scoring/target/releases/elasticsearch-vector-scoring-5.4.0.zip
ENV PATH="/elasticsearch-5.4.0/bin:${PATH}"

# build elasticsearch-vector-scoring plugin
RUN git clone https://github.com/MLnick/elasticsearch-vector-scoring.git
RUN cd elasticsearch-vector-scoring && mvn package

# install elasticsearch
RUN curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.4.0.tar.gz
RUN tar -xvf elasticsearch-5.4.0.tar.gz
WORKDIR /elasticsearch-5.4.0/bin

# install plugin
RUN elasticsearch-plugin install $PLUGIN_PATH

# change to non-root user
RUN apt-get update && apt-get install sudo -y
RUN useradd elasticsearch && \
    echo "elasticsearch ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/elasticsearch && \
    chmod 0440 /etc/sudoers.d/elasticsearch && \
    chown -R elasticsearch /elasticsearch-5.4.0

RUN mkdir -p /usr/share/elasticsearch/data && \
    mkdir -p /usr/share/elasticsearch/logs && \
    chown -R elasticsearch /usr/share/elasticsearch
COPY elasticsearch.yml /elasticsearch-5.4.0/config/elasticsearch.yml

USER elasticsearch


