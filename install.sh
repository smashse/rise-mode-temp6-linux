#!/usr/bin/env sh
# ==============================================================================
# Script de Instalação - Rise Mode Temp 6 Linux Driver
# ==============================================================================

set -eu

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

if [ "$(id -u)" -ne 0 ]; then
    printf "${RED}Erro: Execute como root usando 'sudo ./install.sh'.${NC}\n" >&2
    exit 1
fi

printf "Verificando dependência python3-psutil...\n"
if ! python3 -c "import psutil" 2>/dev/null; then
    printf "${RED}Dependência ausente: python3-psutil não está instalado.${NC}\n" >&2
    printf "No Ubuntu/Debian execute: sudo apt install python3-psutil\n" >&2
    exit 1
fi

printf "Copiando arquivos do driver...\n"
install -m 0755 rise_temp6.py /usr/local/bin/rise_temp6.py
install -m 0644 rise-temp6.service /etc/systemd/system/rise-temp6.service
install -m 0644 99-rise-temp6.rules /etc/udev/rules.d/99-rise-temp6.rules

printf "Atualizando regras do udev e subsistema HID/USB...\n"
udevadm control --reload-rules
udevadm trigger --subsystem-match=hidraw || true
udevadm trigger --subsystem-match=usb || true

printf "Configurando e iniciando o serviço systemd...\n"
systemctl daemon-reload
systemctl enable rise-temp6.service
systemctl restart rise-temp6.service

printf "${GREEN}Instalação concluída com sucesso!${NC}\n"
systemctl --no-pager --full status rise-temp6.service
