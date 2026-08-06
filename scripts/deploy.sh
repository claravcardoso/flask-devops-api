#!/usr/bin/env bash
set -Eeuo pipefail

IMAGE_NAME="flask-devops-api"
CONTAINER_NAME="flask-devops-api"
APPLICATION_PORT="80"
CONTAINER_PORT="5000"

echo "========================================"
echo "Iniciando deploy da aplicação"
echo "========================================"

echo "Diretório atual:"
pwd

echo "Arquivos recebidos:"
ls -la

echo "Versão do Docker:"
sudo docker --version

echo "Construindo nova imagem Docker..."
sudo docker build --tag "${IMAGE_NAME}:latest" .

echo "Removendo container anterior, caso exista..."
if sudo docker ps -a --format '{{.Names}}' | grep -Fxq "${CONTAINER_NAME}"; then
  sudo docker rm --force "${CONTAINER_NAME}"
fi

echo "Iniciando novo container..."
sudo docker run \
  --detach \
  --name "${CONTAINER_NAME}" \
  --restart unless-stopped \
  --publish "${APPLICATION_PORT}:${CONTAINER_PORT}" \
  --env APP_ENV=production \
  --env APP_VERSION="${APP_VERSION:-1.0.0}" \
  "${IMAGE_NAME}:latest"

echo "Aguardando inicialização..."
sleep 10

echo "Testando health check..."
curl --fail --silent --show-error http://localhost/health

echo
echo "Containers ativos:"
sudo docker ps

echo "Removendo imagens Docker antigas..."
sudo docker image prune --force

echo "========================================"
echo "Deploy concluído com sucesso"
echo "========================================"
