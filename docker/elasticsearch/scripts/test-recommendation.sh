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

echo
curl -XPOST -H "Content-Type: application/json" "http://${es_host}:9200/article/_search?pretty"  -d'
{
  "query": {
    "function_score": {
      "boost_mode": "replace",
      "script_score": {
        "script": {
          "source": "binary_vector_score",
          "lang": "knn",
          "params": {
            "cosine": true,
            "field": "embedding_vector",
            "encoded_vector": "vOeTZDzoROu8rfyDOtbmJLx+eyO7N6HSPQlhPjyASk48VtvLPPH5frxJtWO9DLElPLqwb7wczpu83TU0PSVgsLyKo6M8OOfCuoWkN70CwFQ="
          }
        }
      }
    }
  },
  "size": 100
}
'
echo
