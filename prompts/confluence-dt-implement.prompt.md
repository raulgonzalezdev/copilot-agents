# Confluence DT -> Implementación Completa (RecordGo)

Usa este prompt cuando quieras que el agente implemente de punta a punta desde una DT en Confluence.

---
Tipo de fuente: confluence
Fuente: [URL de Confluence]
Módulo: [ej. AccidentReportRepository]
Objetivo: Implementar completo según DT (SP SQL + XSJS + XsjsProxy + Model + Controller + Route)
Parser objetivo: [ObjectParser | ObjectParserGen2 | mantener actual]
Alcance: implementar
Reglas clave:
- Respetar MAYÚSCULAS en aliases SP y template XSJS (`objname`/`dbname`)
- Alinear exactamente con DT (request/response)
- No commits automáticos
- No push automático
- No comentarios automáticos con identidad del agente
Salida obligatoria:
- Resumen de cambios
- Lista de archivos tocados
- Diff/patch
- Mensaje de commit sugerido
- Comando git final para ejecutar yo

Texto adicional opcional:
[Pega aquí reglas extra, decisiones de negocio o ajustes de naming]
---

Ejemplo:
Tipo de fuente: confluence
Fuente: https://recordgo.atlassian.net/wiki/spaces/M/pages/2471002169/AccidentReportRepository
Módulo: AccidentReportRepository
Objetivo: Implementar completo según DT (SP SQL + XSJS + XsjsProxy + Model + Controller + Route)
Parser objetivo: mantener actual
Alcance: implementar
Reglas clave:
- Respetar MAYÚSCULAS en aliases SP y template XSJS (`objname`/`dbname`)
- Alinear exactamente con DT (request/response)
- No commits automáticos
- No push automático
- No comentarios automáticos con identidad del agente
Salida obligatoria:
- Resumen de cambios
- Lista de archivos tocados
- Diff/patch
- Mensaje de commit sugerido
- Comando git final para ejecutar yo
Texto adicional opcional:
- En getById incluir `DAMAGES` solo en detalle
