#!/bin/bash

################################################################################
# 🧹 Limpiador de PostgreSQL 14 para reinstalación limpia
# 👨‍💻 GhostNetworks Dev
################################################################################

GREEN="\\e[92m"
YELLOW="\\e[93m"
RED="\\e[91m"
BLUE="\\e[94m"
RESET="\\e[0m"
CHECK="✅"
WORK="⚙️"
CROSS="❌"
INFO="ℹ️"

echo -e "${RED}${WORK} ⚠️ ADVERTENCIA: Este script eliminará PostgreSQL del sistema${RESET}"
echo -e "${YELLOW}⚠️ Solo ejecuta esto si quieres reinstalar PostgreSQL desde cero${RESET}"
read -p "¿Estás seguro? (escribe 'SI' para continuar): " confirm

if [ "$confirm" != "SI" ]; then
    echo -e "${YELLOW}Operación cancelada${RESET}"
    exit 0
fi

echo -e "${WORK} Iniciando limpieza de PostgreSQL..."

# Detener servicios
echo -e "${WORK} Deteniendo servicios PostgreSQL..."
systemctl stop postgresql 2>/dev/null
systemctl disable postgresql 2>/dev/null

# Eliminar paquetes
echo -e "${WORK} Eliminando paquetes PostgreSQL..."
apt remove --purge postgresql* -y
apt autoremove -y
apt autoclean

# Eliminar directorios de datos
echo -e "${WORK} Eliminando directorios de datos..."
rm -rf /var/lib/postgresql
rm -rf /var/log/postgresql
rm -rf /etc/postgresql
rm -rf /etc/init.d/postgresql

# Eliminar usuario postgres
echo -e "${WORK} Eliminando usuario postgres..."
userdel -r postgres 2>/dev/null
groupdel postgres 2>/dev/null

# Eliminar archivos de configuración
echo -e "${WORK} Eliminando archivos de configuración..."
rm -f /etc/apt/sources.list.d/pgdg.list
rm -f /etc/apt/preferences.d/postgresql
rm -f /etc/apt/trusted.gpg.d/postgresql*

# Limpiar repositorios
echo -e "${WORK} Limpiando repositorios..."
apt update

echo -e "${GREEN}${CHECK} PostgreSQL eliminado completamente${RESET}"
echo -e "${BLUE}${INFO} Ahora puedes ejecutar el instalador para PostgreSQL 14${RESET}"
