# Background Task Prompt (RecordGo)

Usa este prompt para pedir trabajo automático en background:

---
Tipo de fuente: [confluence | publica | texto]
Fuente: [URL o texto]
Módulo: [ej. AccidentReportRepository]
Objetivo: [qué hay que implementar/validar]
Parser objetivo: [ObjectParser | ObjectParserGen2 | mantener actual]
Alcance: [solo plan | implementar | validar]
Restricciones:
- No commits automáticos
- No push automático
- No comentarios automáticos con identidad del agente
Salida esperada:
- Resumen
- Archivos tocados
- Diff/patch
- Mensaje de commit sugerido
- Comando git final para ejecutar yo
---

Ejemplo:
Tipo de fuente: confluence
Fuente: https://recordgo.atlassian.net/wiki/spaces/M/pages/2471002169/AccidentReportRepository
Módulo: AccidentReportRepository
Objetivo: Alinear GETBY y GETBYID con DT y mappings actuales
Parser objetivo: mantener actual
Alcance: implementar
Restricciones:
- No commits automáticos
- No push automático
- No comentarios automáticos con identidad del agente
Salida esperada:
- Resumen
- Archivos tocados
- Diff/patch
- Mensaje de commit sugerido
- Comando git final para ejecutar yo
