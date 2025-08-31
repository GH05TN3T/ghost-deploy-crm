# 🚀 Instalador Automático de Odoo 18 Community en Debian 12 / Ubuntu 22.04+

## 📋 Descripción
Conjunto de scripts para instalar, gestionar y desinstalar Odoo 18 Community en Debian 12 y Ubuntu 22.04+ con PostgreSQL 14 específicamente configurado para evitar actualizaciones automáticas problemáticas.

## 🎯 Características Principales

### ✅ **PostgreSQL 14 Estable**
- Instala específicamente PostgreSQL 14 (no la versión 17 problemática)
- Configuración para evitar actualizaciones automáticas
- Protección contra conflictos de versiones

### 🛡️ **Instalación Segura**
- Scripts con verificaciones de seguridad
- Limpieza completa en caso de desinstalación
- Gestión de usuarios y permisos

### 🔧 **Gestión Completa**
- Instalación automática
- Verificación de estado
- Desinstalación completa
- Limpieza de PostgreSQL

## 📁 Scripts Disponibles

### 1. 🚀 **autoinstall.sh** - Instalador Principal
```bash
sudo bash autoinstall.sh
```
**Funciones:**
- Actualiza el sistema
- Instala dependencias necesarias
- Instala PostgreSQL 14 específicamente
- Descarga e instala Odoo 18
- Configura servicios systemd
- Crea usuarios y configuraciones

### 2. 🗑️ **auto-uninstall.sh** - Desinstalador Completo
```bash
sudo bash auto-uninstall.sh
```
**Funciones:**
- Elimina TODOS los archivos de Odoo
- Limpia bases de datos PostgreSQL
- Elimina servicios y configuraciones
- Limpia archivos temporales y logs
- Elimina usuarios del sistema

### 3. 🔍 **check-postgresql.sh** - Verificador de PostgreSQL
```bash
sudo bash check-postgresql.sh
```
**Funciones:**
- Verifica versión de PostgreSQL
- Estado de servicios
- Configuración de apt
- Puertos de escucha
- Logs y directorios

### 4. 🧹 **clean-postgresql.sh** - Limpiador de PostgreSQL
```bash
sudo bash clean-postgresql.sh
```
**Funciones:**
- Elimina PostgreSQL completamente
- Limpia directorios de datos
- Elimina usuarios y configuraciones
- Prepara para reinstalación limpia

## 🚨 **IMPORTANTE: PostgreSQL 14 vs 17**

### ❌ **Problemas con PostgreSQL 17:**
- Actualizaciones automáticas no deseadas
- Conflictos de compatibilidad
- Problemas de configuración
- Pérdida de control sobre la versión

### ✅ **Ventajas de PostgreSQL 14:**
- Versión estable y probada
- Compatibilidad garantizada con Odoo 18
- Control total sobre la instalación
- Sin actualizaciones automáticas problemáticas

## 📋 Requisitos del Sistema

- **OS:** Debian 12 (Bookworm) o Ubuntu 22.04+ (Jammy)
- **Arquitectura:** x86_64
- **Memoria:** Mínimo 2GB RAM
- **Espacio:** Mínimo 10GB libre
- **Usuario:** Ejecutar como root o con sudo

## 🔧 Instalación Paso a Paso

### **Paso 1: Preparar el Sistema**
```bash
# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar git si no está disponible
sudo apt install -y git
```

### **Paso 2: Clonar o Descargar Scripts**
```bash
# Si tienes git
git clone <tu-repositorio>
cd dev-odoo

# O descargar directamente
wget <url-del-script>
```

### **Paso 3: Ejecutar Instalador**
```bash
# Dar permisos de ejecución
chmod +x autoinstall.sh

# Ejecutar instalador
sudo bash autoinstall.sh
```

### **Paso 4: Verificar Instalación**
```bash
# Verificar PostgreSQL
sudo bash check-postgresql.sh

# Verificar Odoo
sudo systemctl status odoo
```

## 🚨 Solución de Problemas

### **Problema: PostgreSQL se actualiza automáticamente**
```bash
# Verificar configuración
sudo bash check-postgresql.sh

# Si es necesario, limpiar y reinstalar
sudo bash clean-postgresql.sh
sudo bash autoinstall.sh
```

### **Problema: Odoo no inicia**
```bash
# Verificar logs
sudo journalctl -u odoo -f

# Verificar configuración
sudo cat /etc/odoo.conf
```

### **Problema: Desinstalación incompleta**
```bash
# Ejecutar desinstalador completo
sudo bash auto-uninstall.sh

# Verificar limpieza
sudo find / -name "*odoo*" 2>/dev/null
```

## 📊 Verificación Post-Instalación

### **Servicios Activos:**
- ✅ PostgreSQL 14 funcionando
- ✅ Odoo 18 funcionando
- ✅ Puertos abiertos (5432, 8069)

### **Usuarios Creados:**
- ✅ Usuario `postgres` (PostgreSQL)
- ✅ Usuario `odoo` (Odoo)

### **Acceso Web:**
- 🌍 URL: `http://[IP-DEL-SERVIDOR]:8069`
- 🔑 Usuario: `admin`
- 🔒 Contraseña: `admin`

## 🔒 Seguridad

### **Cambios Recomendados:**
1. **Cambiar contraseña de admin de Odoo**
2. **Configurar firewall**
3. **Usar HTTPS en producción**
4. **Cambiar puertos por defecto**

### **Comandos de Seguridad:**
```bash
# Cambiar contraseña de admin
sudo -u odoo /opt/odoo/18.0/venv/bin/python3 /opt/odoo/18.0/odoo-bin -c /etc/odoo.conf -d [NOMBRE_DB] --password=admin --new-password=[NUEVA_CONTRASEÑA]

# Configurar firewall
sudo ufw allow 8069/tcp
sudo ufw allow 5432/tcp
```

## 📞 Soporte

### **Logs Importantes:**
- **Odoo:** `/var/log/odoo/` o `journalctl -u odoo`
- **PostgreSQL:** `/var/log/postgresql/`
- **Sistema:** `/var/log/syslog`

### **Comandos de Diagnóstico:**
```bash
# Estado general del sistema
sudo systemctl status --all

# Verificar puertos
sudo netstat -tlnp

# Verificar espacio en disco
df -h

# Verificar memoria
free -h
```

## 🎯 **Resumen de Uso**

1. **Instalar:** `sudo bash autoinstall.sh`
2. **Verificar:** `sudo bash check-postgresql.sh`
3. **Desinstalar:** `sudo bash auto-uninstall.sh`
4. **Limpiar PostgreSQL:** `sudo bash clean-postgresql.sh`

---

**👨‍💻 Desarrollado por GhostNetworks Dev**  
**🚀 Para instalaciones profesionales y estables de Odoo**
