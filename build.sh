#!/bin/bash

# Script de build para Vercel
set -e

echo "🚀 Iniciando build de Sistema Faro..."

# Verificar Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter no está instalado"
    exit 1
fi

# Navegar al directorio de la aplicación
cd faro/app

echo "📦 Instalando dependencias..."
flutter pub get

echo "🧹 Limpiando build anterior..."
flutter clean

echo "🏗️ Construyendo aplicación para web..."
flutter build web --release --web-renderer html

echo "✅ Build completado!"
echo "📁 Archivos en: build/web/"

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

