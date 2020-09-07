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
            "encoded_vector": "PRrWGD3mfrq9Sum5PMhFqLyvueG9Rjo4POZSVz0dNW26gm9rvRolkb3aW+O9WFDdPUm89L3MoMq9yWxzvfT/WL20Grk98iuKvR0sxr0ajkI="
          }
        }
      }
    }
  },
  "size": 100
}
'
echo
