# create index and mappings
curl -XPUT 'http://127.0.0.1:9200/article' -d' 
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

# get mappings
curl -XGET 'http://127.0.0.1:9200/article/_mappings/?pretty'
echo

# test s2t analyzer
curl -XGET 'http://127.0.0.1:9200/article/_analyze' -d'
{
  "tokenizer" : "keyword",
  "filter" : ["lowercase"],
  "char_filter" : ["stconvert"],
  "text" : "国际國際"
}'
echo 

# test synonyms
curl -XGET 'http://127.0.0.1:9200/article/_analyze?pretty=true&analyzer=by_smart' -d '{"text":"番茄"}'

# add test data for synonyms
curl -XPOST 'http://127.0.0.1:9200/article/article/1' -d'{"title":"我有一個西紅柿"}'
echo
curl -XPOST 'http://127.0.0.1:9200/article/article/2' -d'{"title":"番茄炒蛋饭"}'
echo
curl -XPOST 'http://127.0.0.1:9200/article/article/3' -d'{"title":"西紅柿雞蛋麵"}'
echo
curl -XPOST 'http://127.0.0.1:9200/article/article/4' -d'{"title":"酸辣土豆丝"}'
echo

# add test data for stconvert
curl -XPOST 'http://127.0.0.1:9200/article/article/5' -d'{"title":"国际组织"}'
echo
curl -XPOST 'http://127.0.0.1:9200/article/article/6' -d'{"title":"粵劇衝出國際聲援無處說話？"}'
echo

sleep 3

# search all
curl -s -XGET 'http://127.0.0.1:9200/article/_search/?pretty'
echo

# search synonyms
curl -XPOST 'http://127.0.0.1:9200/article/_search?pretty'  -d'
{
    "query": { 
      "multi_match" : { 
        "query": "tomato",
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
curl -XPOST 'http://127.0.0.1:9200/article/_search?pretty'  -d'
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

# search stconvert
curl -XPOST 'http://127.0.0.1:9200/article/_search?pretty'  -d'
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
curl -XPOST 'http://127.0.0.1:9200/article/_search?pretty'  -d'
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

# delete index
curl -XDELETE 'http://127.0.0.1:9200/article'
echo
