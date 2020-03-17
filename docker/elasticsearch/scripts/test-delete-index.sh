es_host='192.168.99.102'

# delete index
curl -XDELETE "http://${es_host}:9200/article"
echo
