#!/bin/bash

docker compose down

docker compose up --build -d

aze=("redis" "postgresql" "poll" "worker" "result")

echo "" > my-inventory.yml
for item in "${aze[@]}"; do
echo "${item}:" >> my-inventory.yml
echo "  hosts:" >> my-inventory.yml
echo "    ${item}-1:" >> my-inventory.yml
echo "      ansible_host: $(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${item})" >> my-inventory.yml
done

# docker build -t ansible_debian .

# docker stop "$(docker ps -a -q)"

# docker run --rm --name web-1 ansible_debian /bin/bash