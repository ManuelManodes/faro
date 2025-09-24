# Modelos TensorFlow Lite

Este directorio contiene los modelos de TensorFlow Lite para el chatbot del reglamento.

## Modelo Requerido

- **sentence_encoder.tflite**: Modelo de sentence transformers para generar embeddings semánticos

## Cómo Obtener el Modelo

### Opción 1: Usar el Script Automático
```bash
cd app
python scripts/download_model.py
```

### Opción 2: Descarga Manual
1. Visita [Hugging Face Model Hub](https://huggingface.co/models?library=sentence-transformers)
2. Descarga un modelo compatible como `all-MiniLM-L6-v2`
3. Convierte el modelo a TensorFlow Lite usando [transformers](https://huggingface.co/docs/transformers/converting_tensorflow_models)
4. Coloca el archivo `.tflite` en este directorio

### Opción 3: Modelo Dummy para Testing
Si no tienes un modelo real, el sistema creará automáticamente un modelo dummy para testing.

## Especificaciones del Modelo

- **Dimensión de salida**: 384 (típico para sentence-transformers)
- **Formato**: TensorFlow Lite (.tflite)
- **Idioma**: Español (recomendado)
- **Tamaño**: < 50MB (para dispositivos móviles)

## Modelos Recomendados

1. **all-MiniLM-L6-v2**: Pequeño y eficiente (22MB)
2. **paraphrase-multilingual-MiniLM-L12-v2**: Multilingüe
3. **distiluse-base-multilingual-cased**: Base multilingüe

## Notas de Implementación

- El modelo se carga automáticamente al inicializar la app
- Si el modelo no está disponible, se usa el sistema de fallback simple
- Los embeddings se generan de forma asíncrona para no bloquear la UI
- El modelo se mantiene en memoria durante toda la sesión de la app
