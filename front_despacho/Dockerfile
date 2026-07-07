# --- Etapa de Compilación ---
FROM node:20-alpine AS build
WORKDIR /app

# Copiar archivos de dependencias y descargarlas
COPY package*.json ./
RUN npm install

# Copiar el resto del código y compilar la app
COPY . .
RUN npm run build

# --- Etapa de Producción ---
FROM nginx:1.25-alpine
# Copiar archivos estáticos compilados desde la etapa anterior
COPY --from=build /app/dist /usr/share/nginx/html

# Copiar configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exponer el puerto 80
EXPOSE 80

# Iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]
