# DatqBox Modernización - Instrucciones Base

## Objetivo

Trabajar en la modernización de DatqBox manteniendo trazabilidad con el legado VB6 y foco en web + API + modular frontend.

## Contexto funcional prioritario

- Legacy VB6:
  - `DatQBox Admin`
  - `DatQBox Admin Gym`
  - `DatQBox Compras`
  - `DatQBox Configurador`
  - `DatQBox PtoVenta`
  - `Spooler Fiscal*`
  - `Visor SQL Server`
- Moderno:
  - `DatqBoxWeb/src` (.NET)
  - `DatqBoxWeb/web/api`
  - `DatqBoxWeb/web/frontend`
  - `DatqBoxWeb/web/modular-frontend`

## Reglas de trabajo

1. Cambios mínimos y orientados a causa raíz.
2. Mantener contratos API (`/v1/*`) consistentes con frontend.
3. Reutilizar componentes y hooks existentes antes de crear nuevos.
4. No mover lógica de negocio a UI cuando deba ir en backend/casos de uso.
5. Documentar mapeo VB6 → moderno al implementar funcionalidades críticas.

## Reglas de seguridad

- Nunca imprimir secretos (`DB_PASSWORD`, tokens, claves JWT, etc.).
- No copiar credenciales de `.env` a prompts/wikis/commits.
- Si se requiere conexión SQL Server, usar variables de entorno locales del usuario.

## Modo background

Toda ejecución en background debe devolver:

- Resumen de cambios
- Lista de archivos tocados
- Diff/patch
- Riesgos pendientes
- Mensaje de commit sugerido
- Comando final para que lo ejecute el usuario
