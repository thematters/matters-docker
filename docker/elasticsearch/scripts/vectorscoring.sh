#!/bin/sh

# Init an index with custom analyzer
es_host='127.0.0.1'

curl -s -XPUT -H "Content-Type:application/json" "http://${es_host}:9200/test" -d '
{
    "mappings" : {
        "properties" : {
            "model_factor": {
                    "type": "dense_vector",
                    "dims": 20
             }
        }
    }
}
'

curl -s -XPUT -H "Content-Type:application/json" "http://${es_host}:9200/test/_doc/1?pretty" -d '
{
    "model_factor": [-0.0048684608191251755, 0.1810944378376007, 0.18171633780002594, 0.024017656221985817, -0.01932981237769127, 0.04675161466002464, 0.2835552394390106, 0.25660109519958496, 0.3189801871776581, 0.13470201194286346, -0.24838045239448547, -0.1424134373664856, -0.1209217980504036, 0.2833477854728699, 0.1720433384180069, 0.03762750327587128, -0.04354880005121231, -0.005714789964258671, 0.10342027992010117, 0.19893167912960052],
    "name": "Test 1"
}
'

curl -s -XPUT -H "Content-Type:application/json" "http://${es_host}:9200/test/_doc/2?pretty" -d '
{
    "model_factor": [-0.0048684608191251755, 0.1810944378376007, 0.18171633780002594, 0.024017656221985817, -0.01932981237769127, 0.04675161466002464, 0.2835552394390106, 0.25660109519958496, 0.3189801871776581, 0.13470201194286346, -0.24838045239448547, -0.1424134373664856, -0.1209217980504036, 0.2833477854728699, 0.1720433384180069, 0.03762750327587128, -0.04354880005121231, -0.005714789964258671, 0.10342027992010117, 0.19893167912960052],
    "name": "Test 2"
}
'

curl -s -XPUT -H "Content-Type:application/json" "http://${es_host}:9200/test/_doc/3?pretty" -d '
{
    "model_factor": [-0.0048684608191251755, 0.1810944378376007, 0.18171633780002594, 0.024017656221985817, -0.01932981237769127, 0.04675161466002464, 0.2835552394390106, 0.25660109519958496, 0.3189801871776581, 0.13470201194286346, -0.24838045239448547, -0.1424134373664856, -0.1209217980504036, 0.2833477854728699, 0.1720433384180069, 0.03762750327587128, -0.04354880005121231, -0.005714789964258671, 0.10342027992010117, 0.19893167912960052],
    "name": "Test 3"
}
'

curl -s -XPOST -H "Content-Type:application/json" "http://${es_host}:9200/test/_search?pretty" -d '
{
    "query": {
        "script_score": {
            "query" : {
                "query_string": {
                    "query": "*"
                }
            },
            "script": {
                "source": "cosineSimilarity(params.query_vector, '\''model_factor'\'') + 0.1",
                "params": {
                    "query_vector": [-0.0048684608191251755, 0.1810944378376007, 0.18171633780002594, 0.024017656221985817, -0.01932981237769127, 0.04675161466002464, 0.2835552394390106, 0.25660109519958496, 0.3189801871776581, 0.13470201194286346, -0.24838045239448547, -0.1424134373664856, -0.1209217980504036, 0.2833477854728699, 0.1720433384180069, 0.03762750327587128, -0.04354880005121231, -0.005714789964258671, 0.10342027992010117, 0.19893167912960052]
                }
            }
        }
    }
}
'
