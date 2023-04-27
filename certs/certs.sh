#!/bin/bash

# Configuración
IP_ADDRESS="192.168.100.3"
CERT_FILE="server.pem"
KEY_FILE="server.key"
P12_FILE="server.p12"
PASSWORD="1234qwert"

# Verificar si mkcert está instalado
if ! command -v mkcert &> /dev/null; then
    echo "mkcert no está instalado. Instalándolo..."
    sudo apt-get update
    sudo apt-get install -y libnss3-tools
    sudo apt-get install -y certutil
    wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.6/mkcert-v1.4.6-linux-amd64
    chmod +x mkcert-v1.4.6-linux-amd64
    sudo mv mkcert-v1.4.6-linux-amd64 /usr/local/bin/mkcert
fi

# Crear un CA local y generar el certificado SSL para la dirección IP
mkcert -install -cert-file "$CERT_FILE" -key-file "$KEY_FILE" "$IP_ADDRESS"

# Convertir a formato PKCS#12
openssl pkcs12 -export -in "$CERT_FILE" -inkey "$KEY_FILE" -out "$P12_FILE" -passout "pass:$PASSWORD"

# Instalar el certificado en Ubuntu
sudo cp "$(mkcert -CAROOT)/rootCA.pem" /usr/local/share/ca-certificates/
sudo update-ca-certificates
