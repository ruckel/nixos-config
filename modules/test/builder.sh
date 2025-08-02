echo "$someString $(echo "$someJson" | jq -r '.') $someNumber" >$out
