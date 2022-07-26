# es_host='54.254.193.99'
es_host='10.10.1.108'

# Check if all indices contents embedding_vector field
# echo 
# curl -XPOST -H "Content-Type: application/json" "http://${es_host}:9200/article/_search?pretty" -d'
# {
#   "query": {
#     "bool": {
#       "must_not": {
#         "exists": {
#           "field": "embedding_vector" 
#         }
#       }
#     }
#   }
# }
# '
# echo

# echo
# curl -XPOST -H "Content-Type: application/json" "http://${es_host}:9200/article/_search?pretty"  -d'
# {
#   "query": {
#     "function_score": {
#       "boost_mode": "replace",
#       "script_score": {
#         "script": {
#           "source": "binary_vector_score",
#           "lang": "knn",
#           "params": {
#             "cosine": true,
#             "field": "embedding_vector",
#             "encoded_vector": "vOeTZDzoROu8rfyDOtbmJLx+eyO7N6HSPQlhPjyASk48VtvLPPH5frxJtWO9DLElPLqwb7wczpu83TU0PSVgsLyKo6M8OOfCuoWkN70CwFQ="
#           }
#         }
#       }
#     }
#   },
#   "size": 100
# }
# '

echo
curl -XPOST -H "Content-Type: application/json" "http://${es_host}:9200/article/_search?pretty"  -d'
{
  "query": {
    "script_score": {
      "script": {
        "source": "cosineSimilarity(params.query_vector, 'embedding_vector') + 1.0",
        "params": {
          "query_vector": [
            0.10922031104564667,
            -0.15928466618061066,
            0.12807728350162506,
            0.08932537585496902,
            -0.13199761509895325,
            0.2342795878648758,
            -0.0839029848575592,
            -0.06416820734739304,
            0.005764890927821398,
            -0.07997861504554749,
            -0.03284456208348274,
            -0.05154338479042053,
            0.19747799634933472,
            0.14339806139469147,
            -0.042927321046590805,
            -0.07268387824296951,
            -0.13749252259731293,
            0.08005811274051666,
            0.0522056482732296,
            -0.03342394530773163
          ]
        }
      }
    }
  },
  "size": 100
}
'
echo
