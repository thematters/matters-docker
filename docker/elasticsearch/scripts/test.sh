echo
# curl -XPOST 'http://10.10.1.61:9200/article/_search?pretty'  -d'
# {
#     "query": { 
#       "multi_match" : { 
#         "query": "信 / 第一",
#         "fuzziness": "AUTO",
#         "fields": [
#           "title^10",
#           "title.synonym^5",
#           "content^2",
#           "content.synonyms"
#         ],
#         "type": "most_fields"
#       }
#     },
#     "highlight" : {
#         "pre_tags" : ["<tag1>", "<tag2>"],
#         "post_tags" : ["</tag1>", "</tag2>"],
#         "fields" : {
#             "title" : {}
#         }
#     }
# }
# '

echo '==============================='
echo
curl -H "Content-Type: application/json" -XPOST 'http://192.168.99.101:9200/user/_search?pretty'  -d'
{
    "suggest" : {
      "name_suggest" : {
        "prefix": "feizi",
        "completion" : {
           "field": "displayName"
        }
      }
    }
}
'

echo '==============================='
echo
curl -H "Content-Type: application/json" -XPOST 'http://192.168.99.101:9200/user/_analyze' -d '
{
    "analyzer": "by_smart",
    "text": "信 / 第一季"
}
'
