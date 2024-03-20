#!/bin/bash

docker compose down

docker compose up --build -d

aze=("web-1" "web-2" "cache-1")

for item in "${aze[@]}"; do
  echo "${item}"
  echo "${item} is running"
  docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${item}
done


echo "all:
  children:
    web:
      hosts:
        web-1:
          ansible_host: $(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "web-1")
        web-2:
          ansible_host: $(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "web-2")
    redis:
      hosts:
        cache-1:
          ansible_host: $(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "cache-1")" > my-inventory.yml

# docker build -t ansible_debian .

# docker stop "$(docker ps -a -q)"

# docker run --rm --name web-1 ansible_debian /bin/bash