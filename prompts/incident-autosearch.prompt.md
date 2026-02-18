# Incident AutoSearch (commit -> endpoint correcto)

Pega esto al `recordgo-developer` cambiando solo los valores entre corchetes:

---
MODO: incidencia-autosearch
COMMIT_ORIGEN: [hash_commit]
ENDPOINT_CORRECTO: [ej. PATCH /Vehicle/StatusKMS]
ENDPOINT_AFECTADO_POR_ERROR: [ej. PATCH /Vehicle]
OBJETIVO:
- Deshacer cambio en endpoint equivocado
- Aplicar cambio en endpoint correcto

REGLAS OBLIGATORIAS:
- Investiga primero el diff del commit
- Traza cadena real Route -> Controller -> Model -> XsjsProxy -> XSJS -> SP para ambos endpoints
- No asumas archivos por nombre
- Edita solo archivos realmente ejecutados en la cadena
- Sin commit/push automático

SALIDA OBLIGATORIA:
- Evidencia de cadena encontrada
- Resumen de cambios
- Archivos tocados
- Diff/patch
- Mensaje de commit sugerido
- Comando git final para que lo ejecute el usuario
---
