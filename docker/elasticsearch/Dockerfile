FROM docker.elastic.co/elasticsearch/elasticsearch:7.3.1

# ========= install elasticsearch ==========
ENV BASE_PATH="/usr/share/elasticsearch"
ENV PATH="/usr/share/elasticsearch/bin:${PATH}"

# ========= install unzip ============
RUN yum update && yum -y install unzip

# ========= install elasticsearch-vector-scoring plugin ==========
ENV EVS_PLUGIN_PATH file:///elasticsearch-binary-vector-scoring-7.3.1.zip
ADD plugins/elasticsearch-binary-vector-scoring-7.3.1.zip /elasticsearch-binary-vector-scoring-7.3.1.zip
# install elasticsearch-vector-scoring plugin
RUN elasticsearch-plugin install $EVS_PLUGIN_PATH

# ========= install elasticsearch-analysis-ik plugin ===========
RUN curl -L -O https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.3.1/elasticsearch-analysis-ik-7.3.1.zip
RUN unzip elasticsearch-analysis-ik-7.3.1.zip -d elasticsearch-analysis-ik
RUN mv elasticsearch-analysis-ik $BASE_PATH/plugins

# ========= install elasticsearch-analysis-stconvert
RUN curl -L -O https://github.com/medcl/elasticsearch-analysis-stconvert/releases/download/v7.3.1/elasticsearch-analysis-stconvert-7.3.1.zip
RUN unzip elasticsearch-analysis-stconvert-7.3.1.zip -d elasticsearch-analysis-stconvert
RUN mv elasticsearch-analysis-stconvert $BASE_PATH/plugins

# ========= install elasticsearch-analysis-pinyin
RUN curl -L -O https://github.com/medcl/elasticsearch-analysis-pinyin/releases/download/v7.3.1/elasticsearch-analysis-pinyin-7.3.1.zip
RUN unzip elasticsearch-analysis-pinyin-7.3.1.zip -d elasticsearch-analysis-pinyin
RUN mv elasticsearch-analysis-pinyin $BASE_PATH/plugins

# ========= copy synonyms.txt ==============
COPY synonyms/synonyms.txt $BASE_PATH/config/synonyms.txt

# ========= update config ===================
COPY elasticsearch.yml $BASE_PATH/config/elasticsearch.yml
