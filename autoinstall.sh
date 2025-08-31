#!/bin/bash

################################################################################
# 🚀 Instalador automático de Odoo 18 Community en Debian 12
# 🐧 Corre desde root (VPS recién instalada)
# 👨‍💻 GhostNetworks Dev
################################################################################

# Variables
ODOO_USER="odoo"
ODOO_HOME="/opt/odoo"
ODOO_VERSION="18.0"
ODOO_PORT="8069"
ODOO_CONF="/etc/odoo.conf"

# 🎉 Emojis y colores
GREEN="\\e[92m"
YELLOW="\\e[93m"
RESET="\\e[0m"
CHECK="✅"
WORK="⚙️"
PACKAGE="📦"
DONE="🥳"

echo -e "${GREEN}${WORK} Iniciando instalación de Odoo ${ODOO_VERSION} en Debian 12...${RESET}"

# 📦 Actualizar sistema
echo -e "${PACKAGE} Actualizando sistema..."
apt update && apt upgrade -y

# 📦 Instalar dependencias
echo -e "${PACKAGE} Instalando dependencias necesarias..."
apt install -y git python3 python3-pip python3-venv python3-dev \
build-essential libxml2-dev libxslt1-dev zlib1g-dev libsasl2-dev \
libldap2-dev libjpeg-dev libpq-dev libffi-dev libjpeg-turbo8-dev \
liblcms2-dev libblas-dev libatlas-base-dev libssl-dev libtiff5-dev \
libopenjp2-7-dev libwebp-dev node-less npm curl wget xz-utils fontconfig

# 🐘 Instalar PostgreSQL 14 específicamente
echo -e "${PACKAGE} Instalando PostgreSQL 14 (versión estable)..."
# Agregar repositorio oficial de PostgreSQL
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/postgresql-keyring.gpg] http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Actualizar repositorios
apt update

# Instalar PostgreSQL 14 específicamente
apt install -y postgresql-14 postgresql-client-14 postgresql-common

# Configurar para evitar actualizaciones automáticas
echo -e "${WORK} Configurando PostgreSQL para evitar actualizaciones automáticas..."
apt-mark hold postgresql-14 postgresql-client-14 postgresql-common

# Verificar que se instaló la versión correcta
echo -e "${CHECK} Versión de PostgreSQL instalada:"
psql --version

# Configurar apt para evitar actualizaciones de PostgreSQL
echo -e "${WORK} Configurando apt para evitar actualizaciones automáticas de PostgreSQL..."
cat > /etc/apt/preferences.d/postgresql <<EOF
Package: postgresql*
Pin: release a=*
Pin-Priority: -1
EOF

echo -e "${CHECK} PostgreSQL 14 configurado y protegido contra actualizaciones automáticas."

# 🐘 Crear usuario postgres para Odoo
echo -e "${WORK} Creando usuario PostgreSQL para Odoo..."
su - postgres -c "createuser -s ${ODOO_USER}" || true

# 👨‍💻 Crear usuario del sistema para Odoo
if id "${ODOO_USER}" &>/dev/null; then
    echo -e "${CHECK} Usuario del sistema ${ODOO_USER} ya existe."
else
    echo -e "${WORK} Creando usuario del sistema Odoo..."
    useradd -m -d ${ODOO_HOME} -U -r -s /bin/bash ${ODOO_USER}
fi

# 📂 Descargar Odoo
echo -e "${WORK} Descargando Odoo ${ODOO_VERSION}..."
sudo -u ${ODOO_USER} git clone https://www.github.com/odoo/odoo --branch ${ODOO_VERSION} ${ODOO_HOME}/${ODOO_VERSION}

# 📦 Crear entorno virtual
echo -e "${WORK} Creando entorno virtual Python..."
sudo -u ${ODOO_USER} python3 -m venv ${ODOO_HOME}/${ODOO_VERSION}/venv

# 📦 Instalar dependencias Python
echo -e "${PACKAGE} Instalando requerimientos de Odoo..."
sudo -u ${ODOO_USER} ${ODOO_HOME}/${ODOO_VERSION}/venv/bin/pip install --upgrade pip wheel
sudo -u ${ODOO_USER} ${ODOO_HOME}/${ODOO_VERSION}/venv/bin/pip install -r ${ODOO_HOME}/${ODOO_VERSION}/requirements.txt

# 📝 Configuración de Odoo
echo -e "${WORK} Creando archivo de configuración..."
cat > ${ODOO_CONF} <<EOF
[options]
admin_passwd = admin
db_host = False
db_port = False
db_user = ${ODOO_USER}
db_password = False
addons_path = ${ODOO_HOME}/${ODOO_VERSION}/addons
xmlrpc_port = ${ODOO_PORT}
EOF

chown ${ODOO_USER}:${ODOO_USER} ${ODOO_CONF}
chmod 640 ${ODOO_CONF}

# 🔥 Crear servicio systemd
echo -e "${WORK} Creando servicio systemd para Odoo..."
cat > /etc/systemd/system/odoo.service <<EOF
[Unit]
Description=Odoo ${ODOO_VERSION}
After=network.target postgresql.service

[Service]
Type=simple
User=${ODOO_USER}
ExecStart=${ODOO_HOME}/${ODOO_VERSION}/venv/bin/python3 ${ODOO_HOME}/${ODOO_VERSION}/odoo-bin -c ${ODOO_CONF}
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# 🔥 Activar servicio
echo -e "${WORK} Iniciando servicio Odoo..."
systemctl daemon-reload
systemctl enable odoo
systemctl start odoo

# 🎉 Finalizado
echo -e "${GREEN}${DONE} Instalación completada.${RESET}"
echo -e "🌍 Accede a Odoo en: ${YELLOW}http://$(hostname -I | awk '{print $1}'):${ODOO_PORT}${RESET}"
echo -e "🔑 Usuario administrador: admin"
echo -e "🔒 Contraseña maestra DB: admin"
echo -e "${CHECK} ¡Odoo 18 listo para usar!"

# 🔍 Verificación final
echo -e "${WORK} Verificando instalación..."
echo -e "${CHECK} Versión de PostgreSQL: $(psql --version)"
echo -e "${CHECK} Estado del servicio PostgreSQL: $(systemctl is-active postgresql)"
echo -e "${CHECK} Estado del servicio Odoo: $(systemctl is-active odoo)"
echo -e "${CHECK} Puerto Odoo escuchando: $(netstat -tlnp | grep :${ODOO_PORT} || echo 'No disponible aún')"
