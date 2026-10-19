#!/usr/bin/env sh
# ==============================================================================
# Script de Desinstalação - Rise Mode Temp 6 Linux Driver
# ==============================================================================

set -eu

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

if [ "$(id -u)" -ne 0 ]; then
    printf "${RED}Erro: Execute como root usando 'sudo ./uninstall.sh'.${NC}\n" >&2
    exit 1
fi

printf "Parando e desativando o serviço...\n"
systemctl disable --now rise-temp6.service 2>/dev/null || true

printf "Removendo arquivos do sistema...\n"
rm -f /etc/systemd/system/rise-temp6.service
rm -f /etc/udev/rules.d/99-rise-temp6.rules
rm -f /usr/local/bin/rise_temp6.py

printf "Recarregando configurações do kernel e udev...\n"
systemctl daemon-reload
udevadm control --reload-rules
udevadm trigger --subsystem-match=hidraw || true

printf "${GREEN}rise-temp6 foi completamente removido do sistema.${NC}\n"
