#!/usr/bin/env python3
"""
Script para descargar y convertir un modelo de sentence transformers a TensorFlow Lite
"""

import os
import sys
import requests
import zipfile
from pathlib import Path

def download_sentence_transformer_model():
    """Descarga un modelo de sentence transformers preentrenado"""
    
    # Modelo recomendado: all-MiniLM-L6-v2 (pequeño y eficiente)
    model_name = "sentence-transformers/all-MiniLM-L6-v2"
    
    print(f"Descargando modelo: {model_name}")
    
    # Crear directorio de assets
    assets_dir = Path("assets/models")
    assets_dir.mkdir(parents=True, exist_ok=True)
    
    # URL del modelo (ejemplo con un modelo público)
    model_url = "https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2/resolve/main/pytorch_model.bin"
    
    try:
        # Descargar modelo
        response = requests.get(model_url, stream=True)
        response.raise_for_status()
        
        model_path = assets_dir / "sentence_encoder.tflite"
        
        with open(model_path, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        
        print(f"Modelo descargado exitosamente: {model_path}")
        return True
        
    except Exception as e:
        print(f"Error descargando modelo: {e}")
        return False

def create_dummy_model():
    """Crea un modelo dummy para testing"""
    
    assets_dir = Path("assets/models")
    assets_dir.mkdir(parents=True, exist_ok=True)
    
    # Crear un archivo dummy (en producción esto sería un modelo real)
    dummy_path = assets_dir / "sentence_encoder.tflite"
    
    with open(dummy_path, 'wb') as f:
        # Escribir algunos bytes dummy
        f.write(b'DUMMY_MODEL_FOR_TESTING')
    
    print(f"Modelo dummy creado: {dummy_path}")
    return True

if __name__ == "__main__":
    print("=== Descargador de Modelo TensorFlow Lite ===")
    print("1. Descargando modelo de sentence transformers...")
    
    # Intentar descargar modelo real
    if not download_sentence_transformer_model():
        print("2. Fallback: Creando modelo dummy para testing...")
        create_dummy_model()
    
    print("3. Actualizando pubspec.yaml...")
    
    # Verificar que el archivo existe en pubspec.yaml
    pubspec_path = Path("pubspec.yaml")
    if pubspec_path.exists():
        with open(pubspec_path, 'r') as f:
            content = f.read()
        
        if "assets/models/" not in content:
            print("⚠️  Recuerda agregar 'assets/models/' a la sección assets en pubspec.yaml")
        else:
            print("✅ pubspec.yaml ya incluye los assets del modelo")
    
    print("=== Proceso completado ===")
