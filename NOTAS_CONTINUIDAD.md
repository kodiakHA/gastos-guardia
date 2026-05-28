# Web Peña Campanar - notas de continuidad

## Estado actual

- La aplicación está implementada en `index.html`.
- La pantalla principal usa el estilo clásico con paleta azul clara.
- Campos de gastos actuales: `Almuerzo`, `Pan`, `Comida` y `Cena`.
- Almuerzo, comida y cena admiten hasta 3 compradores, cada uno con su propio importe.
- Pan tiene un unico comprador.
- `Gasto mínimo` es editable y está separado de los gastos.
- Hay contador grande de compañeros presentes.
- Hay panel de Supabase para guardar y cargar guardias compartidas.
- Hay calendario de guardias cada 5 días usando como referencia el 29/05/2026.
- Hay historial de guardias guardadas en Supabase.
- Se pueden introducir compras previas seleccionando una fecha futura; la app carga esa guardia o empieza una ficha limpia para esa fecha.
- Hay una `Pantalla de gastos` para abrir una vista limpia de liquidaciones y hacer captura.

## Compañeros cargados

Acedo, Almela, Blesa, Chema, Espín, Galisteo, Migue, Noelia, Laki, Vladi, Poveda, Pla, Nole y Mora.

## Reglas de cálculo actuales

- Solo entran en cálculos los compañeros marcados como presentes.
- El gasto de cada concepto se reparte entre quienes tengan marcado ese concepto.
- Si un gasto tiene varios compradores, cada comprador recupera exactamente el importe que ha puesto.
- El `Pan` tiene columna propia y solo lo pagan quienes lo marcan.
- Si alguien solo marca `Pan`, también paga el `Gasto mínimo`.
- El gasto mínimo se aplica a quien está presente pero no entra a `Almuerzo`, `Comida` ni `Cena`.
- Las liquidaciones finales se muestran como pagos directos: `Persona A debe X € a Persona B`.

## Para continuar

Abrir:

`C:\Users\familia\Documents\Programación Software\Web Peña Campanar\index.html`

O, si el servidor local sigue activo:

`http://127.0.0.1:4173/index.html`
