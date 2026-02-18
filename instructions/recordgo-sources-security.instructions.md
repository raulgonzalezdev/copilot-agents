# RecordGo Sources & Security

## Objetivo
Estandarizar cómo los agentes consumen fuentes (Confluence, URLs públicas y texto manual) y cómo tratan credenciales.

## Reglas de entrada
- Se aceptan tres tipos de entrada:
  1) URL interna de Confluence (`recordgo.atlassian.net`)
  2) URL pública externa
  3) Texto pegado por el usuario
- Prioridad de fuentes para tareas del proyecto:
  1) Texto del usuario (si define requisitos explícitos)
  2) Confluence interna
  3) Fuentes públicas

## Identidad y git
- Autoría de commits, pushes y comentarios: siempre del usuario.
- El agente prepara cambios, resumen, diff y mensaje de commit sugerido.
- La ejecución final de `git commit` y `git push` la hace el usuario.

## Credenciales
- Cuenta de referencia para acceso del usuario: `mkaro@expertone.es`.
- No guardar contraseñas, tokens o secretos en archivos del workspace ni en `.vscode/`.
- No repetir secretos en respuestas ni documentación.
- Si se necesita autenticación, usar mecanismos locales del sistema (sesión ya iniciada, gestor de credenciales o variables de entorno locales no versionadas).

## Modo background
- Si el usuario pide ejecución en background, el agente debe ejecutar tareas de forma automática y devolver:
  - Resumen de cambios
  - Diff/patch
  - Mensaje de commit sugerido
  - Comando final para que el usuario ejecute git con su identidad
