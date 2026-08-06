#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TERRAFORM_DIRECTORY="${ROOT_DIRECTORY}/terraform"

echo "========================================"
echo "Remoção da infraestrutura AWS"
echo "========================================"

cd "${TERRAFORM_DIRECTORY}"

terraform init

terraform validate

terraform plan \
  -destroy \
  -out destroy.tfplan

echo
echo "ATENÇÃO: todos os recursos do projeto serão removidos."
echo

read -r -p "Digite DESTRUIR para continuar: " CONFIRMATION

if [[ "${CONFIRMATION}" != "DESTRUIR" ]]; then
  echo "Operação cancelada."
  exit 0
fi

terraform apply destroy.tfplan

rm -f destroy.tfplan

echo "Infraestrutura removida."