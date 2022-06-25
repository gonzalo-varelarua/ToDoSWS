# Compilación

FROM node:18.4.0-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# La siguiente linea falla en ESBUILD a su vez llamado por VITE BUILD:
#    [ERROR] Cannot start service: Host version "0.14.46" does not match binary version "0.14.47"
# Se pone a comentario a cambio de que ya exista la carpeta /dist
#
# RUN npm run build

# Producción

FROM nginx:1.23.0-alpine as production
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]