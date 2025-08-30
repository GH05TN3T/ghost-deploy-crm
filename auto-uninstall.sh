#!/bin/bash

################################################################################
# 🗑️ Desinstalador Completo de Odoo 18 Community en Debian 12
# 👨‍💻 GhostNetworks Dev - Versión Mejorada
################################################################################

ODOO_USER="odoo"
ODOO_HOME="/opt/odoo"
ODOO_VERSION="18.0"
ODOO_CONF="/etc/odoo.conf"
ODOO_LOG_DIR="/var/log/odoo"
ODOO_TEMP_DIR="/tmp/odoo"
ODOO_ADDONS_DIR="/usr/local/lib/python3.11/dist-packages/odoo_addons"

GREEN="\\e[92m"
YELLOW="\\e[93m"
RED="\\e[91m"
BLUE="\\e[94m"
RESET="\\e[0m"
CHECK="✅"
WORK="⚙️"
DONE="🥳"
CROSS="❌"
INFO="ℹ️"

echo -e "${RED}${WORK} Iniciando desinstalación COMPLETA de Odoo ${ODOO_VERSION}...${RESET}"
echo -e "${BLUE}${INFO} Este script eliminará TODOS los archivos, bases de datos y configuraciones relacionadas con Odoo${RESET}"

# 🔥 Detener y deshabilitar servicio
echo -e "${WORK} Deteniendo y deshabilitando servicio Odoo..."
if systemctl is-active --quiet odoo; then
    systemctl stop odoo
fi

if systemctl is-enabled --quiet odoo; then
    systemctl disable odoo
fi

# 🗑️ Eliminar servicio systemd
echo -e "${WORK} Eliminando servicio systemd..."
if [ -f "/etc/systemd/system/odoo.service" ]; then
    rm -f /etc/systemd/system/odoo.service
fi

if [ -f "/lib/systemd/system/odoo.service" ]; then
    rm -f /lib/systemd/system/odoo.service
fi

if [ -f "/usr/lib/systemd/system/odoo.service" ]; then
    rm -f /usr/lib/systemd/system/odoo.service
fi

systemctl daemon-reload

# 🗑️ Eliminar configuración
if [ -f "${ODOO_CONF}" ]; then
    echo -e "${WORK} Eliminando archivo de configuración..."
    rm -f ${ODOO_CONF}
fi

# 🗑️ Eliminar directorio principal de Odoo
if [ -d "${ODOO_HOME}" ]; then
    echo -e "${WORK} Eliminando directorio principal de Odoo..."
    rm -rf ${ODOO_HOME}
fi

# 🗑️ Eliminar directorio de addons personalizados
if [ -d "${ODOO_ADDONS_DIR}" ]; then
    echo -e "${WORK} Eliminando directorio de addons personalizados..."
    rm -rf ${ODOO_ADDONS_DIR}
fi

# 🗑️ Eliminar directorio de logs
if [ -d "${ODOO_LOG_DIR}" ]; then
    echo -e "${WORK} Eliminando directorio de logs..."
    rm -rf ${ODOO_LOG_DIR}
fi

# 🗑️ Eliminar archivos temporales
if [ -d "${ODOO_TEMP_DIR}" ]; then
    echo -e "${WORK} Eliminando archivos temporales..."
    rm -rf ${ODOO_TEMP_DIR}
fi

# 🗑️ Limpiar archivos de log en /var/log
echo -e "${WORK} Limpiando archivos de log..."
find /var/log -name "*odoo*" -type f -delete 2>/dev/null
find /var/log -name "*odoo*" -type d -exec rm -rf {} + 2>/dev/null

# 🗑️ Limpiar archivos temporales del sistema
echo -e "${WORK} Limpiando archivos temporales del sistema..."
find /tmp -name "*odoo*" -type f -delete 2>/dev/null
find /tmp -name "*odoo*" -type d -exec rm -rf {} + 2>/dev/null

# 🗑️ Limpiar archivos en /var/tmp
echo -e "${WORK} Limpiando archivos en /var/tmp..."
find /var/tmp -name "*odoo*" -type f -delete 2>/dev/null
find /var/tmp -name "*odoo*" -type d -exec rm -rf {} + 2>/dev/null

# 🗑️ Eliminar bases de datos de Odoo
echo -e "${WORK} Eliminando bases de datos de Odoo..."
if command -v psql &> /dev/null; then
    # Obtener lista de bases de datos de Odoo
    DB_LIST=$(su - postgres -c "psql -t -c \"SELECT datname FROM pg_database WHERE datname LIKE '%odoo%' OR datname LIKE 'odoo%';\"")
    
    for db in $DB_LIST; do
        if [ ! -z "$db" ]; then
            echo -e "${WORK} Eliminando base de datos: $db"
            su - postgres -c "dropdb --if-exists \"$db\""
        fi
    done
fi

# 🗑️ Eliminar usuario de PostgreSQL
echo -e "${WORK} Eliminando usuario PostgreSQL de Odoo..."
if command -v psql &> /dev/null; then
    su - postgres -c "dropuser --if-exists ${ODOO_USER}" 2>/dev/null
fi

# 🗑️ Eliminar archivos de configuración adicionales
echo -e "${WORK} Eliminando archivos de configuración adicionales..."
find /etc -name "*odoo*" -type f -delete 2>/dev/null
find /etc -name "*odoo*" -type d -exec rm -rf {} + 2>/dev/null

# 🗑️ Eliminar enlaces simbólicos
echo -e "${WORK} Eliminando enlaces simbólicos..."
find /usr/local/bin -name "*odoo*" -type l -delete 2>/dev/null
find /usr/bin -name "*odoo*" -type l -delete 2>/dev/null

# 🗑️ Eliminar enlaces simbólicos del sistema
echo -e "${WORK} Eliminando enlaces simbólicos del sistema..."
find /etc/systemd/system -name "*odoo*" -type l -delete 2>/dev/null
find /etc/systemd/system -name "*odoo*" -type f -delete 2>/dev/null

# 🗑️ Limpiar caché de Python
echo -e "${WORK} Limpiando caché de Python..."
find /usr/local/lib/python3.*/dist-packages -name "*odoo*" -type d -exec rm -rf {} + 2>/dev/null
find /usr/lib/python3.*/dist-packages -name "*odoo*" -type d -exec rm -rf {} + 2>/dev/null

# 🗑️ Limpiar archivos de configuración del usuario
echo -e "${WORK} Limpiando archivos de configuración del usuario..."
find /home -name ".odoorc" -type f -delete 2>/dev/null
find /home -name ".odoo" -type d -exec rm -rf {} + 2>/dev/null

# 👤 Eliminar usuario y grupo del sistema
if id "${ODOO_USER}" &>/dev/null; then
    echo -e "${WORK} Eliminando usuario y grupo Odoo..."
    userdel -r ${ODOO_USER} 2>/dev/null
    groupdel ${ODOO_USER} 2>/dev/null
fi

# 🗑️ Limpiar archivos de cron relacionados con Odoo
echo -e "${WORK} Limpiando archivos de cron..."
find /etc/cron.d -name "*odoo*" -type f -delete 2>/dev/null
find /etc/cron.daily -name "*odoo*" -type f -delete 2>/dev/null
find /etc/cron.hourly -name "*odoo*" -type f -delete 2>/dev/null
find /etc/cron.monthly -name "*odoo*" -type f -delete 2>/dev/null
find /etc/cron.weekly -name "*odoo*" -type f -delete 2>/dev/null

# 🗑️ Limpiar archivos de logrotate
if [ -f "/etc/logrotate.d/odoo" ]; then
    echo -e "${WORK} Eliminando configuración de logrotate..."
    rm -f /etc/logrotate.d/odoo
fi

# 🗑️ Limpiar archivos de nginx/apache si existen
echo -e "${WORK} Limpiando configuraciones de web server..."
if [ -f "/etc/nginx/sites-available/odoo" ]; then
    rm -f /etc/nginx/sites-available/odoo
    rm -f /etc/nginx/sites-enabled/odoo
    systemctl reload nginx 2>/dev/null
fi

if [ -f "/etc/apache2/sites-available/odoo.conf" ]; then
    rm -f /etc/apache2/sites-available/odoo.conf
    rm -f /etc/apache2/sites-enabled/odoo.conf
    systemctl reload apache2 2>/dev/null
fi

# 🗑️ Limpiar archivos de backup
echo -e "${WORK} Limpiando archivos de backup..."
find /var/backups -name "*odoo*" -type f -delete 2>/dev/null
find /backup -name "*odoo*" -type f -delete 2>/dev/null

# 🗑️ Limpiar archivos de cache del sistema
echo -e "${WORK} Limpiando caché del sistema..."
find /var/cache -name "*odoo*" -type f -delete 2>/dev/null
find /var/cache -name "*odoo*" -type d -exec rm -rf {} + 2>/dev/null

# 🗑️ Limpiar archivos de spool
echo -e "${WORK} Limpiando archivos de spool..."
find /var/spool -name "*odoo*" -type f -delete 2>/dev/null
find /var/spool -name "*odoo*" -type d -exec rm -rf {} + 2>/dev/null

# 🎉 Finalizado
echo -e "${GREEN}${DONE} Odoo ${ODOO_VERSION} eliminado COMPLETAMENTE del sistema.${RESET}"
echo -e "${CHECK} Todos los archivos, bases de datos, configuraciones y servicios han sido limpiados."
echo -e "${YELLOW}⚠️ Si deseas eliminar PostgreSQL totalmente ejecuta: apt remove --purge postgresql* -y${RESET}"
echo -e "${BLUE}${INFO} Se recomienda reiniciar el sistema para completar la limpieza.${RESET}"
