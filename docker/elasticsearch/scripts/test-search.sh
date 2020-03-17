# es_host='54.254.193.99'
es_host='10.10.1.108'

echo
curl -XPOST -H "Content-Type: application/json" "http://${es_host}:9200/tag/_search?pretty"  -d'
{
  "query": {
    "bool": {
      "must": [
        {
          "match": { "content": "中國" }
        }
      ]
    }
  },
  "size": 100
}
'
echo
