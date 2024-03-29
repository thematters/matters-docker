# es_host='192.168.99.101'
es_host='192.168.99.102'

echo 'create index and mappings'
curl -XPUT "http://${es_host}:9200/article" -d' 
{
  "settings": {
    "index": {
      "analysis": {
        "analyzer": {
          "by_smart": {
            "type": "custom",
            "tokenizer": "ik_smart",
            "filter": ["by_tfr", "by_sfr"],
            "char_filter": ["by_cfr", "stconvert"]
          },
          "by_max_word": {
            "type": "custom",
            "tokenizer": "ik_max_word",
            "filter": ["by_tfr", "by_sfr"],
            "char_filter": ["by_cfr", "stconvert"]
          },
          "by_smart_syn": {
            "type": "custom",
            "tokenizer": "ik_smart",
            "filter": ["by_tfr", "by_sfr"],
            "char_filter": ["by_cfr"]
          },
          "by_max_word_syn": {
            "type": "custom",
            "tokenizer": "ik_max_word",
            "filter": ["by_tfr", "by_sfr"],
            "char_filter": ["by_cfr"]
          },
          "pinyin": {
            "tokenizer" : "pinyin_tokenizer"
          }, 
          "stconvert": {
            "tokenizer": "stconvert"
  	  }
        },
        "tokenizer": {
          "stconvert": {
            "type" : "stconvert",
            "delimiter" : "#",
            "keep_both" : true,
            "convert_type" : "s2t"
          },
          "pinyin_tokenizer": {
            "type" : "pinyin",
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
          "by_tfr": {
            "type": "stop",
            "stopwords": [" "]
          },
          "by_sfr": {
            "type": "synonym",
            "synonyms_path": "synonyms.txt"
          },
          "s2t_convert": {
            "type": "stconvert",
            "delimiter": "#",
            "keep_both": true,
            "convert_type": "s2t"
          }
        },
        "char_filter": {
          "by_cfr": {
            "type": "mapping",
            "mappings": ["| => |"]
          },
          "stconvert" : {
             "type" : "stconvert",
             "convert_type" : "s2t"
          }
        }
      }
    }
  },
  "mappings": {
    "article": {
      "properties": {
        "username": {
          "type": "completion"
        }, 
        "name": {
          "type": "completion",
          "analyzer": "pinyin"
        },
        "title": {
          "type": "text",
          "analyzer": "by_max_word",
          "search_analyzer": "by_smart",
          "fields": {
            "synonym": {
              "type": "text",
              "analyzer": "by_max_word_syn"
            }
          }
        }
      }     
    }  
  }
}'
echo 

echo 'get mappings'
curl -XGET "http://${es_host}:9200/article/_mappings/?pretty"
echo

echo 'test s2t analyzer'
curl -XGET "http://${es_host}:9200/article/_analyze" -d'
{
  "tokenizer" : "keyword",
  "filter" : ["lowercase"],
  "char_filter" : ["stconvert"],
  "text" : "国际國際"
}'
echo 

echo 'test synonyms'
curl -XGET "http://${es_host}:9200/article/_analyze?pretty=true&analyzer=by_smart" -d '{"text":"番茄"}'

echo 'add test data for synonyms'
curl -XPOST "http://${es_host}:9200/article/article/1" -d'{"title":"我有一個西紅柿"}'
echo
curl -XPOST "http://${es_host}:9200/article/article/2" -d'{"title":"番茄炒蛋饭"}'
echo
curl -XPOST "http://${es_host}:9200/article/article/3" -d'{"title":"西紅柿雞蛋麵"}'
echo
curl -XPOST "http://${es_host}:9200/article/article/4" -d'{"title":"酸辣土豆丝", "name": "張連麗"}'
echo

echo 'add test data for stconvert'
curl -XPOST "http://${es_host}:9200/article/article/5" -d'{"title":"国际组织", "username": "charlie"}'
echo
curl -XPOST "http://${es_host}:9200/article/article/6" -d'{"title":"粵劇衝出國際聲援無處說話？"}'
echo

echo 'add test data for Chinese completion'
curl -XPOST "http://${es_host}:9200/article/article/5" -d'{"title":"Chinese in English", "name": "潔平"}'
echo
curl -XPOST "http://${es_host}:9200/article/article/6" -d'{"title":"Chinese in English 2", "name": "姜姜"}'
echo
curl -XPOST "http://${es_host}:9200/article/article/6" -d'{"title":"Chinese in English 3", "name": "姜姜"}'
echo
curl -XPOST "http://${es_host}:9200/article/article/6" -d'{"title":"Chinese in English 4", "name": "姜姜"}'
echo
curl -XPOST "http://${es_host}:9200/article/article/6" -d'{"title":"Chinese in English 5", "name": "姜姜"}'
echo

sleep 3

echo 'search all'
curl -s -XGET "http://${es_host}:9200/article/_search/?pretty"
echo

echo 'search synonyms'
curl -XPOST "http://${es_host}:9200/article/_search?pretty"  -d'
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
curl -XPOST "http://${es_host}:9200/article/_search?pretty"  -d'
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
curl -XPOST "http://${es_host}:9200/article/_search?pretty"  -d'
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
curl -XPOST "http://${es_host}:9200/article/_search?pretty"  -d'
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
curl -XPOST "http://${es_host}:9200/article/_search?pretty"  -d'
{
    "suggest" : { 
      "username_suggest" : { 
        "prefix": "cha",
        "completion" : {
           "field": "username"
        }
      }
    }
}
'
echo

echo 'test pinyin'
curl -XPOST "http://${es_host}:9200/article/_search?pretty"  -d'
{
    "query" : { "match" : { "name" : "zhanglianli" }},
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
curl -XPOST "http://${es_host}:9200/article/_search?pretty"  -d'
{
    "query" : { "match" : { "name" : "zhanglianli" }},
    "suggest" : { 
      "username_suggest" : { 
        "prefix": "cha",
        "completion" : {
           "field": "username"
        }
      },
      "name_suggest" : {
        "prefix": "zhang",
        "completion" : {
           "field": "name"
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
curl -XPOST "http://${es_host}:9200/article/_search?pretty"  -d'
{
    "suggest" : { 
      "name_suggest" : {
        "prefix": "潔",
        "completion" : {
           "field": "name"
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
curl -XGET "http://${es_host}:9200/article/_analyze?pretty"  -d'
{
  "text": ["潔平", "姜姜"],
  "analyzer": "pinyin"
}
'

echo
curl -XPOST "http://${es_host}:9200/article/_search?pretty"  -d'
{
    "query" : { "match" : { "name" : "zll" }},
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

# delete index
curl -XDELETE "http://${es_host}:9200/article"
echo
