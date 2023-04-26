#!/bin/bash

# Instalar dnsmasq
dnf install -y dnsmasq

# Crear un archivo de configuración personalizado para dnsmasq
cat <<EOT > /etc/dnsmasq.d/vitesco.conf
# Escuche las consultas DNS solo en la interfaz de red local
interface=wlp0s20f3 # Reemplace esto con el nombre de su interfaz de red local

# Dirección IP y nombre de dominio local
address=/vitesco.local/10.210.50.134
EOT

# Reiniciar dnsmasq para que los cambios surtan efecto
systemctl restart dnsmasq

# Habilitar dnsmasq para que se inicie automáticamente en el arranque
systemctl enable dnsmasq
