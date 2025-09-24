#!/bin/bash

# Script de configuración para TensorFlow Lite
echo "=== Configuración de TensorFlow Lite para Chatbot ==="

# Verificar que estamos en el directorio correcto
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Ejecuta este script desde el directorio raíz de la app"
    exit 1
fi

echo "1. Instalando dependencias de Flutter..."
flutter pub get

echo "2. Creando directorio de modelos..."
mkdir -p assets/models

echo "3. Descargando modelo (si está disponible)..."
if command -v python3 &> /dev/null; then
    python3 scripts/download_model.py
else
    echo "⚠️  Python3 no encontrado. Creando modelo dummy..."
    echo "DUMMY_MODEL_FOR_TESTING" > assets/models/sentence_encoder.tflite
fi

echo "4. Verificando configuración..."
if [ -f "assets/models/sentence_encoder.tflite" ]; then
    echo "✅ Modelo encontrado: assets/models/sentence_encoder.tflite"
else
    echo "❌ Modelo no encontrado. El sistema usará fallback simple."
fi

echo "5. Verificando dependencias en pubspec.yaml..."
if grep -q "tflite_flutter" pubspec.yaml; then
    echo "✅ Dependencias de TensorFlow Lite encontradas"
else
    echo "❌ Dependencias de TensorFlow Lite no encontradas"
    echo "   Agrega las siguientes líneas a pubspec.yaml:"
    echo "   tflite_flutter: ^0.10.4"
    echo "   tflite_flutter_helper: ^0.3.1"
fi

echo "6. Ejecutando flutter pub get..."
flutter pub get

echo "=== Configuración completada ==="
echo ""
echo "Para probar la integración:"
echo "1. Ejecuta: flutter run"
echo "2. Navega a 'Asistente Virtual'"
echo "3. Haz preguntas sobre el reglamento"
echo ""
echo "Si el modelo TensorFlow Lite no está disponible,"
echo "el sistema usará automáticamente el método de fallback."
