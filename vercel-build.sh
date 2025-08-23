#!/bin/bash

# Script de build personalizado para Vercel
# Sistema Faro - Flutter Web

set -e

echo "🚀 Iniciando build de Sistema Faro..."

# Verificar que estamos en el directorio correcto
if [ ! -f "faro/app/pubspec.yaml" ]; then
    echo "❌ Error: No se encontró pubspec.yaml en faro/app/"
    exit 1
fi

# Navegar al directorio de la aplicación
cd faro/app

echo "📦 Instalando dependencias de Flutter..."
flutter pub get

echo "🧹 Limpiando build anterior..."
flutter clean

echo "🔧 Verificando Flutter..."
flutter doctor

echo "🏗️ Construyendo aplicación para web..."
flutter build web --release --web-renderer html

echo "✅ Build completado exitosamente!"
echo "📁 Archivos generados en: faro/app/build/web/"

# Verificar que los archivos principales existen
if [ ! -f "build/web/index.html" ]; then
    echo "❌ Error: No se generó index.html"
    exit 1
fi

if [ ! -f "build/web/main.dart.js" ]; then
    echo "❌ Error: No se generó main.dart.js"
    exit 1
fi

echo "🎉 ¡Sistema Faro listo para producción!"

