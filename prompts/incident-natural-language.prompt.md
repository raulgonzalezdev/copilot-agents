# Incidencia en lenguaje natural (sin formato rígido)

Pega texto libre como este al `recordgo-developer`:

"e2c0aa397fe3f5e9203f0a542af90f4303cca197 esta fue la mezcla de mi rama anterior. El commit es correcto para la rama actual, pero hubo confusión en los archivos ejecutados. Se modificó el endpoint Vehicle en lugar de Vehicle/StatusKMS. En esta incidencia hay que deshacer los cambios en Vehicle y hacerlos en Vehicle/StatusKMS. Analiza, busca la cadena real y ejecútalo."

## Lo que debe hacer el agente automáticamente
- Detectar hash de commit
- Detectar endpoint equivocado y endpoint correcto
- Buscar diff del commit
- Trazar cadena real route -> controller -> model -> proxy -> xsjs -> sp
- Revertir solo en endpoint equivocado
- Aplicar en endpoint correcto
- Entregar resumen, archivos tocados, diff/patch, mensaje commit sugerido y comando git final

## Variación corta reutilizable
"[HASH] se aplicó en endpoint equivocado [A] y debía ir en [B]. Haz búsqueda completa de cadena real, deshaz en [A] y aplica en [B], sin commit automático."
