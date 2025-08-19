#!/bin/bash
echo "auto-remoção e setup"
echo "
   _____
  | ___ |
  ||   ||  T.I.
  ||___||
  |   _ |
  |_____|
 /_/_|_\_\----.
/_/__|__\_\   )
             (
             []


"
echo ""
sleep 7
echo " Parando os serviços do NovoChat"
sleep 7
# 1. Pare os serviços do NovoChat
docker compose stop
sleep 5
# 2. Remova os containers antigos para garantir um início limpo
docker compose rm -f
echo " Removendo os serviços do NovoChat"
sleep 5
echo " Parando os serviços do NovoChat"
# 3. Limpe os assets pré-compilados e o cache do Vite/Rails
# Certifique-se de estar no diretório raiz do NovoChat
docker compose run --rm rails bundle exec rails assets:clobber
docker compose run --rm rails bundle exec rails tmp:clear
docker compose run --rm rails rm -rf public/packs public/vite

# 4. Recompile os assets com as novas variáveis de ambiente
# IMPORTANTE: Confirme que seu .env está como discutimos anteriormente:
# FRONTEND_URL=https://host.novochat.internal
# HELPCENTER_URL=https://host.novochat.internal
# ASSET_CDN_HOST=https://host.novochat.internal
docker compose run --rm rails bundle exec rails assets:precompile

# 5. Inicie todos os serviços novamente
docker compose up -d
echo " Recreate db:schema"
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 docker-compose run --rm rails bundle exec rails db:schema:recreate
echo "Reload db:schema "
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 docker compose run --rm rails bundle exec rails db:schema:load
echo " Create user defalt no db"
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 docker compose run --rm rails bundle exec rake chatwoot:create_admin --trace EMAIL="amdrelmes@gmail.com" PASSWORD="@mdreWp4ss"
echo " Reload no db:schema novamente"
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 docker compose run --rm rails bundle exec rails db:schema:load
echo "Verificando status Container"
# 6. Verifique o status novamente
docker compose ps

echo "
 ______________
||            ||
||            ||
||            ||
||            ||
||____________||
|______________|
 \\##############\\
  \\##############\\
   \      ____    \   
    \_____\___\____\... Automação Concluida | @m3ss14s-2025

______________________________________________________
"
echo ""
sleep 7
sleep 7
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 docker compose run --rm rails bundle exec rake chatwoot:create_admin --trace EMAIL="amdrelmes@gmail.com" PASSWORD="@mdreWp4ss"
echo "$?"
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 docker-compose run --rm rails bundle exec rails db:schema:recreate



docker compose down -v --remove-orphans

Confirme se o comando removeu os volumes, você deve ver algo como:
Removing chatwoot_postgres_data ...
Removing chatwoot_redis_data ...
Removing chatwoot_storage_data ...

docker compose up -d

DISABLE_DATABASE_ENVIRONMENT_CHECK=1 docker compose run --rm rails bundle exec rails db:schema:load

docker compose run --rm rails bundle exec rails assets:clobber
docker compose run --rm rails bundle exec rails assets:precompile

DISABLE_DATABASE_ENVIRONMENT_CHECK=1 docker compose run --rm rails bundle exec rake chatwoot:create_admin --trace EMAIL="amdrelmes@gmail.con" PASSWORD="4mdreWp4ss"
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 docker compose run --rm rails bundle exec rails db:schema:load
echo "$?"
docker compose logs rails

