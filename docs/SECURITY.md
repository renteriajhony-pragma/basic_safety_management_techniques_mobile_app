# Seguridad de la aplicación

Este documento resume el modelo de amenazas, las mitigaciones implementadas y las recomendaciones para mantener la seguridad de la app a largo plazo. Para la arquitectura del proyecto, los algoritmos utilizados y los diagramas de los flujos principales, ver [`arquitectura-y-seguridad.md`](arquitectura-y-seguridad.md).

## Modelo de amenazas

Esta es una app **cliente sin backend**: la propia app genera y firma sus tokens de sesión localmente. Esto implica una limitación estructural que ninguna técnica del lado del cliente elimina por completo: la clave de firma de los JWT necesariamente vive en el dispositivo del usuario. En un sistema real, esa clave viviría en un servidor y el cliente solo recibiría el token ya firmado.

Dado ese límite, el objetivo de las mitigaciones aplicadas aquí no es "hacer inextraíble" la clave, sino:

- Sacarla del código fuente y del binario empaquetado (donde sería trivial de extraer) y ponerla detrás de la protección que ofrece el sistema operativo (Keystore en Android, Keychain en iOS/macOS).
- Reducir la superficie de ataque alrededor de los datos sensibles que sí puede proteger un cliente: almacenamiento en reposo, validación de entradas y captura de pantalla.

## Mitigaciones implementadas por fase

| Fase | Mitigación |
|---|---|
| 1 | Tokens de sesión como JWT firmados (HS256, `dart_jsonwebtoken`) con expiración; flujo de autenticación completo (login → sesión → logout) |
| 2 | Cifrado autenticado AES-GCM 256 bits (`package:cryptography`) sobre todo lo que pasa por el almacenamiento seguro |
| 3 | Persistencia en `flutter_secure_storage` (Keystore/Keychain) con accesibilidad de Keychain endurecida (`unlocked_this_device`) y borrado explícito del token al cerrar sesión |
| 4 | `JWT_SECRET` y `ENCRYPTION_KEY` generados en el dispositivo y guardados directamente en Keystore/Keychain (ya no viven en el código fuente ni en un asset empaquetado); validación de entrada del usuario (longitud y caracteres permitidos) en la UI y en el dominio; bloqueo de capturas/grabación de pantalla en Android (`FLAG_SECURE`) |

## Gaps aceptados (fuera de alcance de esta fase)

- **Protección anti-captura en iOS**: no existe un equivalente directo a `FLAG_SECURE`. iOS solo permite *detectar* una captura ya tomada (`UIScreen.main.isCaptured`, notificación de screenshot), no impedirla. Implementar una mitigación parcial (p. ej. cubrir la pantalla al detectar grabación) queda pendiente si se decide invertir en ello.
- **Sin biometría**: la app solo se usa en primer plano; exigir Face ID/huella para leer el token añadiría fricción sin beneficio de seguridad real en este flujo.
- **Sin límite de intentos de login**: no hay un backend real que atacar por fuerza bruta (cualquier `subject` válido crea una sesión), así que un límite de intentos no tendría un atacante real contra el cual defender en este ejercicio.

## Recomendaciones para producción

- Compilar los builds de release con ofuscación para dificultar la ingeniería inversa:
  ```
  flutter build apk --obfuscate --split-debug-info=build/symbols
  flutter build ipa --obfuscate --split-debug-info=build/symbols
  ```
  Conservar `build/symbols` fuera del control de versiones público; son necesarios para interpretar stack traces de crashes en producción.
- No loguear tokens, claves ni el contenido de `SecureStorageDatasource`/`SecretsDatasource` en ningún build.
- Revisar `flutter pub outdated` periódicamente y actualizar dependencias con CVEs conocidos, en particular `flutter_secure_storage`, `dart_jsonwebtoken` y `cryptography`.
- Si en algún momento la app adquiere un backend real, migrar la firma de tokens al servidor: el cliente debería dejar de poseer `JWT_SECRET` por completo.
