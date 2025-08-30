#!/bin/bash

################################################################################
# 🔍 Verificador de PostgreSQL 14 para Odoo
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

echo -e "${BLUE}${INFO} Verificando instalación de PostgreSQL...${RESET}"

# Verificar versión instalada
echo -e "${WORK} Versión de PostgreSQL:"
if command -v psql &> /dev/null; then
    PSQL_VERSION=$(psql --version | grep -oP 'PostgreSQL \K[0-9]+')
    echo -e "${CHECK} PostgreSQL $PSQL_VERSION instalado"
    
    if [ "$PSQL_VERSION" = "14" ]; then
        echo -e "${GREEN}${CHECK} Versión correcta (14) instalada${RESET}"
    else
        echo -e "${RED}${CROSS} Versión incorrecta ($PSQL_VERSION) instalada${RESET}"
    fi
else
    echo -e "${RED}${CROSS} PostgreSQL no está instalado${RESET}"
    exit 1
fi

# Verificar estado del servicio
echo -e "${WORK} Estado del servicio PostgreSQL:"
if systemctl is-active --quiet postgresql; then
    echo -e "${GREEN}${CHECK} Servicio PostgreSQL activo${RESET}"
else
    echo -e "${RED}${CROSS} Servicio PostgreSQL inactivo${RESET}"
    systemctl status postgresql --no-pager -l
fi

# Verificar puerto de escucha
echo -e "${WORK} Puerto de escucha PostgreSQL:"
PG_PORT=$(netstat -tlnp | grep postgres | grep LISTEN | awk '{print $4}' | cut -d: -f2 | head -1)
if [ ! -z "$PG_PORT" ]; then
    echo -e "${CHECK} PostgreSQL escuchando en puerto: $PG_PORT"
else
    echo -e "${RED}${CROSS} PostgreSQL no está escuchando en ningún puerto${RESET}"
fi

# Verificar configuración de apt
echo -e "${WORK} Configuración de apt para PostgreSQL:"
if [ -f "/etc/apt/preferences.d/postgresql" ]; then
    echo -e "${CHECK} Archivo de preferencias encontrado:"
    cat /etc/apt/preferences.d/postgresql
else
    echo -e "${YELLOW}⚠️ Archivo de preferencias no encontrado${RESET}"
fi

# Verificar paquetes instalados
echo -e "${WORK} Paquetes PostgreSQL instalados:"
dpkg -l | grep postgresql | grep -E "^ii" | awk '{print $2 " " $3}'

# Verificar directorio de datos
echo -e "${WORK} Directorio de datos PostgreSQL:"
PG_DATA_DIR=$(pg_config --sysconfdir 2>/dev/null || echo "/etc/postgresql")
if [ -d "$PG_DATA_DIR" ]; then
    echo -e "${CHECK} Directorio de configuración: $PG_DATA_DIR"
    ls -la "$PG_DATA_DIR"
else
    echo -e "${RED}${CROSS} Directorio de configuración no encontrado${RESET}"
fi

# Verificar logs
echo -e "${WORK} Logs de PostgreSQL:"
PG_LOG_DIR="/var/log/postgresql"
if [ -d "$PG_LOG_DIR" ]; then
    echo -e "${CHECK} Directorio de logs: $PG_LOG_DIR"
    ls -la "$PG_LOG_DIR"
else
    echo -e "${YELLOW}⚠️ Directorio de logs no encontrado${RESET}"
fi

echo -e "${GREEN}${CHECK} Verificación completada${RESET}"
