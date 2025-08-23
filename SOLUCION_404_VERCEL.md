# 🔧 Solución Error 404 en Vercel

## 🚨 Problema Identificado

El error `404: NOT_FOUND` indica que Vercel no está encontrando los archivos de build de Flutter.

## 🛠️ Soluciones

### **Opción 1: Configuración Manual en Vercel Dashboard**

1. **Ve a tu proyecto en Vercel Dashboard**
2. **Settings > General**
3. **Build & Development Settings**
4. Configura manualmente:

```
Framework Preset: Other
Build Command: cd faro/app && flutter build web --release
Output Directory: faro/app/build/web
Install Command: cd faro/app && flutter pub get
```

### **Opción 2: Usar Vercel CLI**

```bash
# Instalar Vercel CLI
npm i -g vercel

# Desde la raíz del proyecto
vercel

# Seguir las instrucciones:
# - Framework: Other
# - Build Command: cd faro/app && flutter build web --release
# - Output Directory: faro/app/build/web
```

### **Opción 3: Configuración Simplificada**

Reemplaza el `vercel.json` actual con:

```json
{
  "version": 2,
  "builds": [
    {
      "src": "faro/app/build/web/**",
      "use": "@vercel/static"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/faro/app/build/web/index.html"
    }
  ],
  "buildCommand": "cd faro/app && flutter build web --release",
  "outputDirectory": "faro/app/build/web"
}
```

## 🔍 Verificación Local

Antes de desplegar, verifica que funciona localmente:

```bash
# Desde la raíz del proyecto
cd faro/app
flutter clean
flutter pub get
flutter build web --release

# Verificar que se generaron los archivos
ls -la build/web/
# Deberías ver: index.html, main.dart.js, assets/, etc.
```

## 🚀 Pasos para Solucionar

### **1. Verificar Estructura del Proyecto**
```
faro/
├── vercel.json
├── package.json
├── build.sh
└── app/
    ├── pubspec.yaml
    ├── lib/
    └── build/web/ (se genera)
```

### **2. Commit y Push**
```bash
git add .
git commit -m "Fix Vercel configuration"
git push origin main
```

### **3. Redeploy en Vercel**
1. Ve a tu proyecto en Vercel
2. **Deployments > Redeploy**
3. O haz un nuevo commit para trigger automático

### **4. Verificar Logs**
En Vercel Dashboard > Deployments > [último deploy] > Functions:
- Busca errores de build
- Verifica que Flutter se ejecute correctamente

## 🎯 Configuración Recomendada

### **vercel.json Final**
```json
{
  "buildCommand": "cd faro/app && flutter build web --release",
  "outputDirectory": "faro/app/build/web",
  "framework": "other",
  "installCommand": "cd faro/app && flutter pub get",
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "Cache-Control",
          "value": "public, max-age=0, must-revalidate"
        }
      ]
    },
    {
      "source": "/assets/(.*)",
      "headers": [
        {
          "key": "Cache-Control",
          "value": "public, max-age=31536000, immutable"
        }
      ]
    }
  ],
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```

## 🔧 Troubleshooting

### **Error: Flutter not found**
```bash
# En Vercel, Flutter debe estar pre-instalado
# Si no funciona, usa la configuración manual
```

### **Error: Build fails**
```bash
# Verificar localmente primero
cd faro/app
flutter doctor
flutter clean
flutter pub get
flutter build web --release
```

### **Error: Files not found**
```bash
# Verificar que el outputDirectory es correcto
# Debe ser: faro/app/build/web
```

## 📞 Soporte

Si el problema persiste:

1. **Vercel Support**: [vercel.com/support](https://vercel.com/support)
2. **Flutter Web**: [flutter.dev/web](https://flutter.dev/web)
3. **GitHub Issues**: Tu repositorio

---

**¡Con estas configuraciones debería funcionar!** 🚀✨

