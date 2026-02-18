# Quick Confluence Run (1 línea)

Usa este formato mínimo:

`RUN <URL> <MODULO> [implementar|validar] [ObjectParser|ObjectParserGen2|actual]`

## Ejemplos

`RUN https://recordgo.atlassian.net/wiki/spaces/M/pages/2471002169/AccidentReportRepository AccidentReportRepository implementar actual`

`RUN https://recordgo.atlassian.net/wiki/spaces/M/pages/2471002169/AccidentReportRepository AccidentReportRepository validar actual`

## Comportamiento esperado

- Si pones `implementar`: ejecuta flujo completo (SP SQL + XSJS + Proxy + Model + Controller + Route).
- Si pones `validar`: ejecuta solo auditoría DT vs código (sin cambios).
- Siempre:
  - Sin commit automático
  - Sin push automático
  - Sin comentarios automáticos con identidad del agente
  - Salida con resumen, archivos tocados, diff/patch, mensaje sugerido y comando git final para ejecutar tú
