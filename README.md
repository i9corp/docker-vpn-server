docker run -d --restart=always --privileged --net=host  --name vpn-server sobrito/vpn-server 
docker exec -it --user root vpn-server /bin/bash