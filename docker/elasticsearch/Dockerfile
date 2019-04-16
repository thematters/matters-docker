FROM maven:3.6-jdk-8

RUN apt-get update 

# ========= install elasticsearch ==========
ENV PATH="/elasticsearch-5.4.0/bin:${PATH}"
RUN curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.4.0.tar.gz
RUN tar -xvf elasticsearch-5.4.0.tar.gz

# ========= install elasticsearch-vector-scoring plugin ==========
ENV EVS_PLUGIN_PATH file:///elasticsearch-vector-scoring/target/releases/elasticsearch-vector-scoring-5.4.0.zip
# build elasticsearch-vector-scoring plugin
RUN git clone https://github.com/MLnick/elasticsearch-vector-scoring.git
RUN cd elasticsearch-vector-scoring && mvn package
# install elasticsearch-vector-scoring plugin
RUN elasticsearch-plugin install $EVS_PLUGIN_PATH

# ========= install elasticsearch-analysis-ik plugin ===========
RUN curl -L -O https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v5.4.0/elasticsearch-analysis-ik-5.4.0.zip
RUN unzip elasticsearch-analysis-ik-5.4.0.zip -d elasticsearch-analysis-ik
RUN mv elasticsearch-analysis-ik /elasticsearch-5.4.0/plugins

# ========= install elasticsearch-analysis-stconvert
RUN curl -L -O https://github.com/medcl/elasticsearch-analysis-stconvert/releases/download/v5.4.0/elasticsearch-analysis-stconvert-5.4.0.zip
RUN unzip elasticsearch-analysis-stconvert-5.4.0.zip -d elasticsearch-analysis-stconvert
RUN mv elasticsearch-analysis-stconvert /elasticsearch-5.4.0/plugins

# ========= install elasticsearch-analysis-pinyin
RUN curl -L -O https://github.com/medcl/elasticsearch-analysis-pinyin/releases/download/v5.4.0/elasticsearch-analysis-pinyin-5.4.0.zip
RUN unzip elasticsearch-analysis-pinyin-5.4.0.zip -d elasticsearch-analysis-pinyin
RUN mv elasticsearch-analysis-pinyin /elasticsearch-5.4.0/plugins

# ========= copy synonyms.txt ==============
COPY synonyms/synonyms.txt /elasticsearch-5.4.0/config/synonyms.txt

# change to non-root user
RUN apt-get install sudo -y
RUN useradd elasticsearch && \
    echo "elasticsearch ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/elasticsearch && \
    chmod 0440 /etc/sudoers.d/elasticsearch && \
    chown -R elasticsearch /elasticsearch-5.4.0

RUN mkdir -p /usr/share/elasticsearch/data && \
    mkdir -p /usr/share/elasticsearch/logs && \
    chown -R elasticsearch /usr/share/elasticsearch
COPY elasticsearch.yml /elasticsearch-5.4.0/config/elasticsearch.yml

WORKDIR /elasticsearch-5.4.0/bin
USER elasticsearch


