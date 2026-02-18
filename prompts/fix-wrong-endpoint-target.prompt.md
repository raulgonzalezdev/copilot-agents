# Fix aplicado al endpoint equivocado (Vehicle vs Vehicle/StatusKMS)

Pega este bloque al agente `recordgo-developer`:

---
Incidencia:
- El commit `e2c0aa397fe3f5e9203f0a542af90f4303cca197` aplicó cambios en el endpoint equivocado.
- Se modificó `Vehicle` en lugar de `Vehicle/StatusKMS`.

Objetivo:
1) Deshacer el comportamiento introducido en la cadena de `Vehicle`.
2) Aplicar ese comportamiento en la cadena correcta de `Vehicle/StatusKMS`.

Método obligatorio (autobúsqueda):
1) Investigar el commit y extraer diff + archivos tocados reales.
2) Trazar cadena real del endpoint afectado y del endpoint correcto:
  Route -> Controller -> Model -> XsjsProxy -> XSJS -> SP.
3) Confirmar que los cambios se aplican en los archivos realmente ejecutados.
4) Solo después de esa verificación, editar.

Fuente de referencia del error:
- Commit: `e2c0aa397fe3f5e9203f0a542af90f4303cca197`
- Archivos tocados por ese commit:
  - `db/MOSY/PROCEDURES/EXO_VEHICLE_UPDATE/export/MOSY/EX/EXO_VEHICLE_UPDATE/create.sql`
  - `xs/MOSY_ODATA/VehicleUpdate.xsjs`

Cadena correcta del endpoint destino (StatusKMS):
- Route: `PATCH /Vehicle/StatusKMS` en `routes/XSOData.js`
- Controller: `controllers/VehicleStatus.js` método `patchStatusKm`
- Model: `models/VehicleStatus.js` método `patchStatusKm`
- Proxy: `lib/XsjsProxy.js` método `updateVehicleStatusKm` -> `MOSY_ODATA/VehicleUpdateKMS.xsjs`
- XSJS destino: `xs/MOSY_ODATA/VehicleUpdateKMS.xsjs`
- SP destino: `db/MOSY/PROCEDURES/EXO_VEHICLE_UPDATE_KMS_STATUS/export/MOSY/EX/EXO_VEHICLE_UPDATE_KMS_STATUS/create.sql`

Instrucciones de implementación:
- No asumir archivos por nombre: validar primero qué ruta y método ejecutan realmente cada endpoint.
- Revertir en `Vehicle` únicamente lo que corresponde al cambio equivocado del commit (sin tocar lógica no relacionada).
- Replicar el manejo de respuesta/error en la cadena `StatusKMS` (SP + XSJS destino), manteniendo compatibilidad con el contrato actual del endpoint.
- Verificar nombres de parámetros y orden de llamada SP en XSJS destino.
- Mantener estilo actual del proyecto (sin refactor global).

Criterios de aceptación:
- `PATCH /Vehicle/StatusKMS` devuelve el comportamiento esperado con manejo de éxito/error aplicado en destino.
- `VehicleUpdate` queda sin el cambio incorrecto derivado de esta incidencia.
- No se alteran rutas distintas a esta incidencia.
- Entregar:
  - Resumen de cambios
  - Archivos tocados
  - Diff/patch
  - Mensaje de commit sugerido
  - Comando git final para ejecutar yo (sin commit/push automático)

Restricciones:
- No hacer commit automático
- No hacer push automático
- No usar identidad del agente para comentarios/autoría
---
