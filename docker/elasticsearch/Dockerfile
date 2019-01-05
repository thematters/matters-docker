FROM docker.elastic.co/elasticsearch/elasticsearch:5.4.0

RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install https://github.com/MLnick/elasticsearch-vector-scoring/releases/download/v5.4.0/elasticsearch-vector-scoring-5.4.0.zip
RUN /usr/share/elasticsearch/bin/elasticsearch-plugin remove x-pack