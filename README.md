# Sobre o projeto
Esse projeto tem por objetivo gerar uma container seguro e funcional de 
servidor de vpn via pptp, servidor de syslog onde o a vpn seja capaz de autenticar usuários com base em um banco de dados externo postgres via radius.

> Esse container já possui o serviço de radius, pptp e syslog. É necessário apenas iniciar o container fornecendo o parametro para conexão com a base de dados.

> Caso as tabelas não existam o sistema irá criar.

## Construir a image
> Constroí a imagem a partir do código fonte do dockerfile

`docker build -t sobrito/vpn-server .`

## Iniciando o container
> Execute o comando abaixo para iniciar o container

`docker run -d  --privileged --net=host  --name vpn-server -e pg_user='i9corp' -e pg_pass='f63c48513baa39d8e358bd6e214cc6e2' -e pg_host='10.224.100.12'  sobrito/vpn-server`
## Acessar o terminal do container
> Apesar de não ser algo usual, pode ser necessário acessar o container via terminal, para isso execute o comando abaixo

`docker exec -it --user root vpn-2 /bin/bash`