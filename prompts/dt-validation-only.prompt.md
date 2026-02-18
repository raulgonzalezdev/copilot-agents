# DT -> Solo Validación (RecordGo)

Usa este prompt cuando quieras que el agente compare DT vs código existente, sin modificar archivos.

---
Tipo de fuente: [confluence | publica | texto]
Fuente: [URL o texto]
Módulo: [ej. AccidentReportRepository]
Objetivo: Validar consistencia DT vs código actual (SP, XSJS, Proxy, Model, Controller, Route)
Alcance: validar
Modo: solo lectura (sin cambios)
Reglas clave:
- Detectar faltantes, sobrantes y nombres incorrectos
- Verificar orden de parámetros IN del SP vs XSJS
- Confirmar parser usado (ObjectParser / ObjectParserGen2)
- No modificar archivos
Salida obligatoria:
- ✅ Correcto
- ❌ Falta en SP
- ❌ Falta en XSJS template
- ⚠️ Nombre o estructura incorrecta
- Tabla resumen por capa (SP, XSJS, Proxy, Model, Controller, Route)
- Riesgos y propuesta de fix mínima

Texto adicional opcional:
[Pega aquí reglas extra o criterios de aceptación]
---

Ejemplo:
Tipo de fuente: confluence
Fuente: https://recordgo.atlassian.net/wiki/spaces/M/pages/2471002169/AccidentReportRepository
Módulo: AccidentReportRepository
Objetivo: Validar consistencia DT vs código actual (SP, XSJS, Proxy, Model, Controller, Route)
Alcance: validar
Modo: solo lectura (sin cambios)
Reglas clave:
- Detectar faltantes, sobrantes y nombres incorrectos
- Verificar orden de parámetros IN del SP vs XSJS
- Confirmar parser usado (ObjectParser / ObjectParserGen2)
- No modificar archivos
Salida obligatoria:
- ✅ Correcto
- ❌ Falta en SP
- ❌ Falta en XSJS template
- ⚠️ Nombre o estructura incorrecta
- Tabla resumen por capa (SP, XSJS, Proxy, Model, Controller, Route)
- Riesgos y propuesta de fix mínima
