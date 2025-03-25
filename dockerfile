# Etapa 1: Construir los activos de frontend con Node.js
FROM node:18 AS node-build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

# Etapa 2: Configurar Laravel con PHP
FROM php:8.2-fpm

# Instalar dependencias para PHP y extensiones requeridas por Laravel
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-configure gd \
    && docker-php-ext-install pdo pdo_mysql gd

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configurar el directorio de trabajo
WORKDIR /var/www

# Copiar los archivos del proyecto
COPY . .

# Copiar los activos generados por Node.js
COPY --from=node-build /app/public/build public/build

# Instalar dependencias de Laravel
RUN composer install --optimize-autoloader --no-dev

# Crear el enlace simbólico para storage
RUN php artisan storage:link

# Cache de configuración y rutas
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache

# Exponer el puerto para Laravel
EXPOSE 8080

# Comando de inicio
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8080"]
