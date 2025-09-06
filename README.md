# deploychat
NovoChat Deploy em produção

Gere chave 32 forte

$openssl rand -base64 24
__________________

Clone os repositorios:
https://github.com/chatwoot/chatwoot
https://github.com/EvolutionAPI/evolution-api

Controle as versões com:
https://hub.docker.com/r/chatwoot/chatwoot/tags
https://hub.docker.com/r/atendai/evolution-api/tags
__________________

aponte dominio.exemplo para o host no /etc/host

192.168.2.213 host.mordorlab.com

192.168.2.213 api.mordorlab.com

#192.168.2.213 n8n.mordorlab.com

192.168.2.213 chat.mordorlab.com

aponte servername com IP do host para primeira resolução local de DNS em:

root@ser-old-vps /o/s/c/evolution (main)# cat /etc/netplan/50-cloud-init.yaml 



network:
  
  version: 2

      ethernets:
   
    ens18:
    
      addresses:
           
      
      - "192.168.2.213/24"
      
      nameservers:
      
        addresses:
        
        - 192.168.2.213 # <--
        
        search:
        - 8.8.8.8
....
        
__________________
pós configureção nginx

sudo ln -s /etc/nginx/sites-available/chatwoot /etc/nginx/sites-enabled/
ls -l /etc/nginx/sites-available/
sudo rm /etc/nginx/sites-enabled/100.116.220.121.conf
ls -l /etc/nginx/sites-enabled/
___________________
Preparando o banco:

echo ""
echo " Removendo orphnas e imagens"
sleep 7
docker compose down -v --remove-orphans --rmi all --volumes
echo "Restart Docker....."
sudo systemctl restart docker
sleep 7
echo ""
echo "Preparando banco db:chatwoot_prepare"
docker-compose run --rm rails bundle exec rails db:chatwoot_prepare
sleep 5
docker compose up -d
sleep 7
#DISABLE_DATABASE_ENVIRONMENT_CHECK=1 docker-compose run --rm rails bundle exec rails db:schema:reload
echo ""
echo "Criando user admin defautl diretamente no banco"
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 docker compose run --rm rails bundle exec rake chatwoot:create_admin --trace EMAIL="amdrelmes@gmail.com" PASSWORD="fghaasdasd24ss"
echo "Fim"
echo "Acesse https://host.novochat.internal/" 
eho ""
echo "
