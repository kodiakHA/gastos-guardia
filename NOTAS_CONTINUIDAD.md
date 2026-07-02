# Web Pena Campanar - notas de continuidad

## Estado actual

- La aplicacion esta implementada en `index.html`.
- Nombre visible de la app: `Pena Empastre Kampanar`.
- La pantalla principal usa una paleta azul clara y estructura responsive para movil y escritorio.
- El calendario de guardias esta arriba del todo y al abrir la web se marca por defecto la fecha del dia.
- La fecha ya no se muestra en la cabecera; se gestiona desde el calendario.
- La cabecera muestra el grupo de cocina que toca por fecha, con texto grande en mayusculas: `COCINA GRUPO N`.
- Al pulsar el grupo de cocina se muestran sus componentes.
- Los grupos de cocina son editables y se guardan como configuracion compartida en Supabase.
- 29/05/2026 empieza con Grupo 2 y avanza Grupo 3, Grupo 4, Grupo 1 en cada guardia.
- Campos de gastos actuales: `ALMUERZO`, `PAN`, `COMIDA` y `CENA`.
- En la tabla de turno del dia, las columnas se abrevian como `ALM`, `PAN`, `COMID`, `CENA` para que no se solapen en movil.
- Almuerzo, comida y cena admiten hasta 3 compradores, cada uno con su propio importe.
- Pan tiene un unico comprador.
- Los importes empiezan en 0.
- `Gasto minimo` es editable y esta separado de los gastos.
- Hay contador grande de companeros presentes.
- El panel tecnico de Supabase esta oculto; la conexion se hace automaticamente con la configuracion guardada en `index.html`.
- Hay calendario de guardias cada 5 dias usando como referencia el 29/05/2026.
- El historial muestra solo guardias liquidadas; las compras previas quedan guardadas, pero no aparecen en historial hasta abrir liquidacion.
- Se pueden introducir compras previas seleccionando una fecha futura; la app carga esa guardia o empieza una ficha limpia para esa fecha.
- Al abrir liquidacion, la guardia se guarda como liquidada y queda bloqueada para evitar modificaciones accidentales.
- El boton `Corregir liquidacion` desbloquea una guardia liquidada; al volver a abrir liquidacion se sobrescribe la misma guardia en Supabase.
- Las guardias liquidadas mantienen un panel de pagos pendientes; se puede marcar cada pago como realizado sin desbloquear la liquidacion.
- Hay una `Pantalla de gastos` para abrir una vista limpia de liquidaciones y hacer captura.

## Companeros cargados

Acedo, Almela, Blesa, Chema, Picolo, Galisteo, Migue, Noelia, Laki, Vladi, Poveda, Pla, Nole y Mora.

## Grupos de cocina iniciales

- Grupo 1: Galisteo, Migue, Mora.
- Grupo 2: Noelia, Laki, Picolo, Blesa.
- Grupo 3: Poveda, Vladi, Pla.
- Grupo 4: Chema, Nole, Almela.

## Reglas de calculo actuales

- Solo entran en calculos los companeros marcados como presentes.
- El gasto de cada concepto se reparte entre quienes tengan marcado ese concepto.
- Si un gasto tiene varios compradores, cada comprador recupera exactamente el importe que ha puesto.
- El `Pan` tiene columna propia y solo lo pagan quienes lo marcan.
- Si alguien solo marca `Pan`, tambien paga el `Gasto minimo`.
- El gasto minimo se aplica a quien esta presente pero no entra a `Almuerzo`, `Comida` ni `Cena`.
- Las liquidaciones finales se muestran como pagos directos: `Persona A debe X euros a Persona B`.

## Pendiente para otra sesion

- Seguir con mejoras de apariencia y diseno grafico, especialmente pensando en uso desde movil.
- Revisar espaciados, jerarquia visual, botones principales, color y legibilidad de tablas.
- No subir cambios de diseno hasta que el usuario lo pida expresamente.

## Para continuar

Abrir:

`C:\Users\familia\Documents\Programacion Software\Web Pena Campanar\index.html`

Web publicada:

`https://kampanar.com`
