#!/bin/bash

# Instalar mkcert si no está instalado
if ! command -v mkcert &> /dev/null; then
    echo "mkcert no está instalado. Instalando..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get install -y libnss3-tools
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y nss-tools
    fi
    wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.6/mkcert-v1.4.6-linux-amd64
    chmod +x mkcert-v1.4.6-linux-amd64
    sudo mv mkcert-v1.4.6-linux-amd64 /usr/local/bin/mkcert
fi

# Crear una nueva autoridad de certificación local si no existe
if [ ! -f "$(mkcert -CAROOT)/rootCA-key.pem" ]; then
    echo "Creando una nueva autoridad de certificación local..."
    mkcert -install
fi

# Generar certificados para la dirección IP local
IP="10.210.50.134"
PASSWORD="1234qwert"

echo "Generando certificados para la dirección IP local: $IP"

mkcert    -cert-file "$IP.crt" -key-file "$IP.key" "$IP"

# Crear archivo PKCS12
openssl pkcs12 -export -out "$IP.p12" -inkey "$IP.key" -in "$IP.crt" -passout pass:"$PASSWORD"

# Convertir el archivo PKCS12 a formato PEM
openssl pkcs12 -in "$IP.p12" -out "$IP.pem" -nodes -passin pass:"$PASSWORD"

echo "Certificados generados:"
echo "Certificado: $IP.crt"
echo "Clave privada: $IP.key"
echo "Certificado PKCS12: $IP.p12"
echo "Certificado PEM: $IP.pem"

# Cambiar permisos
chmod 644 "$IP.crt" "$IP.key" "$IP.p12" "$IP.pem"
    