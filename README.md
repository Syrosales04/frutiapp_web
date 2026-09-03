# FrutiApp Web

Proyecto del Laboratorio 1 – IF0009 Desarrollo de Software IV (Flutter Web).

## Contenido de este paquete

Este paquete **no es un proyecto Flutter completo** (no incluye las carpetas
`android/`, `ios/`, `linux/`, ni los íconos/`favicon.png` binarios que genera
Flutter automáticamente). Contiene únicamente el **código fuente** que debes
copiar dentro de un proyecto Flutter creado con `flutter create`:

```
frutiapp_web/
├── pubspec.yaml
├── analysis_options.yaml
├── lib/
│   ├── main.dart
│   ├── models/producto.dart
│   ├── services/producto_service.dart
│   └── screens/
│       ├── login_page.dart
│       └── home_page.dart
└── web/
    ├── index.html      (título ya modificado a "FrutiApp Web")
    └── manifest.json
```

## Pasos para levantar el proyecto (Flutter 3.35.x / Dart 3.13.x)

1. **Verifica tu ambiente** (como pide la sección 4 del laboratorio):
   ```bash
   flutter doctor
   flutter devices
   ```
   Debe aparecer `Chrome (web)` en la lista.

2. **Crea el proyecto base** con el nombre exacto que usa este código:
   ```bash
   flutter create frutiapp_web
   cd frutiapp_web
   ```

3. **Copia los archivos de este paquete sobre el proyecto recién creado**,
   reemplazando lo generado por `flutter create`:
   - `pubspec.yaml` → reemplaza el generado (ya trae la dependencia `http`).
   - Todo el contenido de `lib/` → reemplaza `lib/main.dart` y agrega las
     carpetas `models/`, `services/`, `screens/`.
   - `web/index.html` y `web/manifest.json` → reemplazan los generados
     (mantén `web/favicon.png` e `web/icons/` tal como los creó Flutter).

4. **Instala las dependencias**:
   ```bash
   flutter pub get
   ```

5. **Ejecuta la aplicación en Chrome**:
   ```bash
   flutter run -d chrome
   ```
   También puedes usar:
   ```bash
   flutter run -d web-server
   ```

6. **Prueba el flujo**:
   - Escribe un correo sin `@` o una contraseña de menos de 6 caracteres →
     debe mostrar el error de validación.
   - Escribe un correo válido (ej. `test@correo.com`) y una contraseña de
     al menos 6 caracteres → pulsa **Ingresar** → navega a la pantalla
     **Home**, que carga los productos desde
     `https://jsonplaceholder.typicode.com/posts` (mapeando
     `title → nombre` y `id * 100 → precio`).

7. **Genera la versión de producción** (Parte F del laboratorio):
   ```bash
   flutter build web
   ```
   El resultado queda en `build/web/`. Para probarlo con un servidor real
   (no abriendo `index.html` directamente):
   ```bash
   cd build/web
   python3 -m http.server 8000
   ```
   Luego abre `http://localhost:8000`.

## Notas sobre CORS

`jsonplaceholder.typicode.com` permite solicitudes CORS desde cualquier
origen, por eso funciona sin configuración adicional al ejecutarse en
Chrome como Flutter Web. Si en el futuro cambias el endpoint por una API
propia, recuerda: **CORS se configura en el servidor**, no deshabilitando
seguridad del navegador.

## Próximos pasos sugeridos

Cuando quieras, podemos:
- Tomar las capturas de pantalla que pide la sección 11.1 del PDF.
- Redactar el informe PDF de 1–2 páginas (sección 11.2).
- Implementar alguna de las extensiones opcionales (pantalla de detalle,
  botón de cerrar sesión ya incluido en el AppBar de Home, diseño
  responsivo con `LayoutBuilder`/`MediaQuery`, etc.).
