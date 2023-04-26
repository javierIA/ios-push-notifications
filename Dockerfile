# Dockerfile

# Usar una imagen base de Node.js
FROM node:16

# Crear un directorio de trabajo
WORKDIR /usr/src/app

# Copiar el archivo package.json y yarn.lock
COPY package*.json yarn.lock ./

# Instalar las dependencias
RUN yarn install

# Copiar el resto del código de la aplicación
COPY . .

# Exponer el puerto HTTPS
EXPOSE 443

# Ejecutar la aplicación
CMD ["node", "server.mjs"]
