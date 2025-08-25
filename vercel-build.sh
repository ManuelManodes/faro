#!/bin/bash

# Script de build personalizado para Vercel
# Sistema Faro - Flutter Web

set -e

echo "🚀 Iniciando build de Sistema Faro (v2)..."

# Instalar Flutter si no está disponible
if ! command -v flutter &> /dev/null; then
    echo "📥 Flutter no encontrado, instalando..."
    
    # Descargar Flutter
    git clone https://github.com/flutter/flutter.git -b stable --depth 1
    export PATH="$PATH:$PWD/flutter/bin"
    
    # Verificar instalación
    flutter doctor
else
    echo "✅ Flutter ya está instalado"
fi

# Verificar la estructura del directorio y navegar al directorio correcto
if [ -f "app/pubspec.yaml" ]; then
    echo "📁 Encontrado pubspec.yaml en app/"
    cd app
elif [ -f "faro/app/pubspec.yaml" ]; then
    echo "📁 Encontrado pubspec.yaml en faro/app/"
    cd faro/app
else
    echo "❌ Error: No se encontró pubspec.yaml en app/ ni en faro/app/"
    echo "📂 Contenido del directorio actual:"
    ls -la
    exit 1
fi

echo "📦 Instalando dependencias de Flutter..."
flutter pub get

echo "🧹 Limpiando build anterior..."
flutter clean

echo "🔧 Verificando Flutter..."
flutter doctor

echo "🏗️ Construyendo aplicación para web..."
flutter build web --release

echo "✅ Build completado exitosamente!"
echo "📁 Archivos generados en: build/web/"

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

