# es_host='192.168.99.101'
es_host='192.168.99.102'

echo 'create index and mappings'
curl -XPUT -H "Content-Type:application/json" "http://${es_host}:9200/article" -d' 
{
        "settings": {
          "analysis": {
              "analyzer": {
                  "pinyin": {
                      "tokenizer" : "pinyin_tokenizer"
                  },
                  "tsconvert": {
                      "type": "custom",
                      "char_filter": ["tsconvert"],
                      "tokenizer": "ik_max_word"
                  },
                  "synonym": {
                      "type": "custom",
                      "char_filter": ["tsconvert"],
                      "tokenizer": "ik_smart",
                      "filter": ["synonym"]
                  }
              },
              "tokenizer": {
                  "tsconvert": {
                      "type" : "stconvert",
                      "delimiter" : "#",
                      "keep_both" : true,
                      "convert_type" : "t2s"
                  },
                  "pinyin_tokenizer": {
                      "type": "pinyin",
                      "keep_first_letter": false,
                      "keep_separate_first_letter" : false,
                      "keep_full_pinyin" : true,
                      "keep_original" : true,
                      "limit_first_letter_length" : 16,
                      "lowercase" : true,
                      "remove_duplicated_term" : true
                  }
              },
              "filter": {
                  "synonym" : {
                      "type": "synonym",
                      "synonyms_path": "synonyms.txt"
                  },
                  "tsconvert": {
                      "type":"stconvert",
                      "delimiter":"#",
                      "keep_both":true,
                      "convert_type":"t2s"
                  }
              },
              "char_filter": {
                  "tsconvert" : {
                    "type" : "stconvert",
                    "convert_type" : "t2s"
                  }
              }
          }
      },
      "mappings": {
          "properties": {
              "id": {
                  "type": "long"
              },
              "userName": {
                  "type": "completion"
              },
              "displayName": {
                  "type": "completion",
                  "analyzer": "pinyin",
                  "fields": {
                      "raw": {
                          "type": "text",
                          "analyzer": "tsconvert"
                      }
                  }
              },
              "title": {
                  "type": "text",
                  "index": true,
                  "analyzer": "tsconvert",
                  "fields": {
                      "synonyms": {
                          "type": "text",
                          "analyzer": "synonym"
                      }
                  }
              },
              "content": {
                  "type": "text",
                  "index": true,
                  "analyzer": "tsconvert",
                  "fields": {
                      "synonyms": {
                          "type": "text",
                          "analyzer": "synonym"
                      }
                  }
              },
              "embedding_vector": {
                  "type": "binary",
                  "doc_values": true
              },
              "factor": { "type": "text" }
          }
      }
}'
echo 

echo 'get mappings'
curl -XGET -H "Content-Type:application/json" "http://${es_host}:9200/article/_mappings/?pretty"
echo

echo 'test s2t analyzer'
curl -XGET -H "Content-Type:application/json" "http://${es_host}:9200/article/_analyze" -d'
{
  "tokenizer" : "keyword",
  "filter" : ["lowercase"],
  "char_filter" : ["stconvert"],
  "text" : "国际國際"
}'
echo 

echo 'test synonyms'
curl -XGET -H "Content-Type:application/json" "http://${es_host}:9200/article/_analyze?pretty=true" -d '{
  "analyzer": "synonym",
  "text": "番茄"
}'

echo 'add test data for synonyms'
curl -XPOST -H "Content-Type:application/json" "http://${es_host}:9200/article/_doc/1" -d'{"title":"我有一個西紅柿"}'
echo
curl -XPOST -H "Content-Type:application/json" "http://${es_host}:9200/article/_doc/2" -d'{"title":"番茄炒蛋饭"}'
echo
curl -XPOST -H "Content-Type:application/json" "http://${es_host}:9200/article/_doc/3" -d'{"title":"西紅柿雞蛋麵"}'
echo
curl -XPOST -H "Content-Type:application/json" "http://${es_host}:9200/article/_doc/4" -d'{"title":"酸辣土豆丝", "displayName": "張連麗"}'
echo

echo 'add test data for stconvert'
curl -XPOST -H "Content-Type:application/json" "http://${es_host}:9200/article/_doc/5" -d'{"title":"国际组织", "userName": "charlie"}'
echo
curl -XPOST -H "Content-Type:application/json" "http://${es_host}:9200/article/_doc/6" -d'{"title":"粵劇衝出國際聲援無處說話？"}'
echo

echo 'add test data for Chinese completion'
curl -XPOST -H "Content-Type:application/json" "http://${es_host}:9200/article/_doc/5" -d'{"title":"Chinese in English", "displayName": "潔平"}'
echo
curl -XPOST -H "Content-Type:application/json" "http://${es_host}:9200/article/_doc/6" -d'{"title":"Chinese in English 2", "displayName": "姜姜"}'
echo
curl -XPOST -H "Content-Type:application/json" "http://${es_host}:9200/article/_doc/7" -d'{"title":"Chinese in English 3", "displayName": "姜姜"}'
echo
curl -XPOST -H "Content-Type:application/json" "http://${es_host}:9200/article/_doc/8" -d'{"title":"Chinese in English 4", "displayName": "姜姜"}'
echo
curl -XPOST -H "Content-Type:application/json" "http://${es_host}:9200/article/_doc/9" -d'{"title":"Chinese in English 5", "displayName": "姜姜"}'
echo
curl -XPOST -H "Content-Type:application/json" "http://${es_host}:9200/article/_doc/10" -d'{"title":"Chinese in English 6", "displayName": "高重建"}'
echo

sleep 3

echo 'search all'
curl -s -XGET "http://${es_host}:9200/article/_search/?pretty"
echo

echo 'search synonyms'
curl -XPOST -H "Content-Type:application/json" "http://${es_host}:9200/article/_search?pretty"  -d'
{
    "query": { 
      "multi_match" : { 
        "query": "西红柿",
        "fields": [
          "title",
          "title.synonym"
        ],
        "type": "most_fields"
      }
    },
    "highlight" : {
        "pre_tags" : ["<tag1>", "<tag2>"],
        "post_tags" : ["</tag1>", "</tag2>"],
        "fields" : {
            "title" : {}
        }
    }
}
'
echo
curl -XPOST -H "Content-Type:application/json" "http://${es_host}:9200/article/_search?pretty"  -d'
{
    "query": { 
      "multi_match" : { 
        "query": "马铃薯",
        "fields": [
          "title",
          "title.synonym"
        ],
        "type": "most_fields"
      }
    },
    "highlight" : {
        "pre_tags" : ["<tag1>", "<tag2>"],
        "post_tags" : ["</tag1>", "</tag2>"],
        "fields" : {
            "title" : {}
        }
    }
}
'
echo

echo 'search stconvert'
curl -XPOST -H "Content-Type:application/json" "http://${es_host}:9200/article/_search?pretty"  -d'
{
    "query": { 
      "multi_match" : { 
        "query": "國際",
        "fields": [
          "title",
          "title.synonym"
        ],
        "type": "most_fields"
      }
    },
    "highlight" : {
        "pre_tags" : ["<tag1>", "<tag2>"],
        "post_tags" : ["</tag1>", "</tag2>"],
        "fields" : {
            "title" : {}
        }
    }
}
'
echo
curl -XPOST -H "Content-Type:application/json" "http://${es_host}:9200/article/_search?pretty"  -d'
{
    "query" : { "match" : { "title" : "说话" }},
    "highlight" : {
        "pre_tags" : ["<tag1>", "<tag2>"],
        "post_tags" : ["</tag1>", "</tag2>"],
        "fields" : {
            "title" : {}
        }
    }
}
'
echo

echo 'test completion'
curl -XPOST -H "Content-Type:application/json" "http://${es_host}:9200/article/_search?pretty"  -d'
{
    "suggest" : { 
      "username_suggest" : { 
        "prefix": "cha",
        "completion" : {
           "field": "userName"
        }
      }
    }
}
'
echo

echo 'test pinyin'
curl -XPOST -H "Content-Type:application/json"  "http://${es_host}:9200/article/_search?pretty"  -d'
{
    "query" : { "match" : { "displayName" : "zhanglianli" }},
    "highlight" : {
        "pre_tags" : ["<tag1>", "<tag2>"],
        "post_tags" : ["</tag1>", "</tag2>"],
        "fields" : {
            "title" : {}
        }
    }
}
'

echo
echo 'test pinyin and completion'
curl -XPOST -H "Content-Type:application/json" "http://${es_host}:9200/article/_search?pretty"  -d'
{
    "query" : { "match" : { "displayName" : "zhanglianli" }},
    "suggest" : { 
      "username_suggest" : { 
        "prefix": "cha",
        "completion" : {
           "field": "userName"
        }
      },
      "name_suggest" : {
        "prefix": "zhang",
        "completion" : {
           "field": "displayName"
        }
      }
    },
    "highlight" : {
        "pre_tags" : ["<tag1>", "<tag2>"],
        "post_tags" : ["</tag1>", "</tag2>"],
        "fields" : {
            "title" : {}
        }
    }
}
'

echo
echo 'test chinese completion'
curl -XPOST -H "Content-Type:application/json" "http://${es_host}:9200/article/_search?pretty"  -d'
{
    "suggest" : { 
      "name_suggest" : {
        "prefix": "潔",
        "completion" : {
           "field": "displayName"
        }
      }
    },
    "highlight" : {
        "pre_tags" : ["<tag1>", "<tag2>"],
        "post_tags" : ["</tag1>", "</tag2>"],
        "fields" : {
            "title" : {}
        }
    }
}
'

echo 
echo 'chinese completion pinyin analyze'
curl -XGET -H "Content-Type:application/json" "http://${es_host}:9200/article/_analyze?pretty"  -d'
{
  "text": ["潔平", "姜姜"],
  "analyzer": "pinyin"
}
'

echo
curl -XPOST -H "Content-Type:application/json" "http://${es_host}:9200/article/_search?pretty"  -d'
{
    "query" : { "match" : { "displayName.raw" : "重建" }},
    "suggest": {
      "name_suggest" : {
        "prefix": "重建",
        "completion" : {
           "field": "displayName"
        }
      }
    },
    "highlight" : {
        "pre_tags" : ["<tag1>", "<tag2>"],
        "post_tags" : ["</tag1>", "</tag2>"],
        "fields" : {
            "title" : {}
        }
    }
}
'
echo
