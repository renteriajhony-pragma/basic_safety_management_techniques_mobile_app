# security_app

Aplicación móvil Flutter que implementa técnicas de seguridad para proteger la información de los usuarios: autenticación con tokens JWT, cifrado de datos sensibles, almacenamiento seguro respaldado por el sistema operativo y buenas prácticas adicionales de hardening.

Para el detalle de qué se resolvió, la arquitectura del proyecto, los algoritmos utilizados y los diagramas de los flujos principales, ver [`docs/arquitectura-y-seguridad.md`](docs/arquitectura-y-seguridad.md). Para el modelo de amenazas y las recomendaciones de seguridad a largo plazo, ver [`docs/SECURITY.md`](docs/SECURITY.md).

## Requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.41.x o superior (Dart >= 3.8.0, según `pubspec.yaml`).
- Android Studio (con un emulador configurado) y/o Xcode, según la plataforma en la que quieras correr la app.
- Un dispositivo físico o un emulador/simulador disponible.

Verifica tu entorno con:

```bash
flutter doctor
```

## Instalación

```bash
git clone <url-del-repositorio>
cd project_fixed
flutter pub get
```

No se requiere configurar ningún archivo `.env` ni variable de entorno: todos los secretos (clave de firma de los tokens y clave de cifrado) se generan automáticamente en el dispositivo la primera vez que la app los necesita, y quedan guardados en el Keystore (Android) / Keychain (iOS), nunca en el código fuente.

## Correr la app

Con un emulador/simulador iniciado o un dispositivo conectado:

```bash
flutter devices        # lista los dispositivos disponibles
flutter run             # corre en el dispositivo por defecto
flutter run -d <id>      # corre en un dispositivo específico
```

También puedes usar la configuración de "Run and Debug" de VS Code (`.vscode/launch.json` ya incluye los perfiles *debug*, *profile* y *release*).

### Primer uso

La app no trae usuarios precargados. Al abrirla:

1. En la pantalla de inicio de sesión, toca **"¿No tienes cuenta? Regístrate"**.
2. Completa el formulario de registro (todos los campos son obligatorios).
3. Vuelve a la pantalla de login e ingresa el usuario y la contraseña que acabas de crear.
4. Verás la pantalla de perfil, con una cuenta regresiva de la sesión y un botón para refrescarla antes de que expire.

## Pruebas

```bash
flutter analyze   # análisis estático
flutter test      # suite de pruebas unitarias y de widgets
```

## Build de producción

Para dificultar la ingeniería inversa del binario, compila los builds de release con ofuscación:

```bash
flutter build apk --obfuscate --split-debug-info=build/symbols
flutter build ipa --obfuscate --split-debug-info=build/symbols
```

Conserva la carpeta `build/symbols` fuera del control de versiones público: es necesaria para interpretar los stack traces de errores en producción.
