# Web Pena Campanar

Aplicacion web estatica para repartir gastos de guardia en Parque Campanar.

## Arrancar en local

Abre `index.html` directamente en el navegador o usa `Abrir Web Pena Campanar.bat`.

## Despliegue recomendado

La app no necesita servidor: `index.html` contiene la aplicacion completa y se conecta a Supabase desde el navegador. La opcion recomendada es Cloudflare Pages.

Configuracion exacta en Cloudflare Pages:

- Framework preset: `None` / sin framework.
- Build command: vacio. Si Cloudflare obliga a rellenarlo, usa `exit 0`.
- Build output directory: `/` o `.`.
- Root directory: `/`.
- Environment variables: ninguna.

No hay que configurar variables de Supabase en la plataforma. La URL y la clave publica `anon` ya estan definidas en `index.html`, igual que antes.

## Archivos principales

- `index.html`: aplicacion completa.
- `_headers`: cabeceras de Cloudflare Pages para servir sin cache.
- `site.webmanifest` e `icon.svg`: configuracion de instalacion/PWA.
- `supabase-setup.sql`: tabla y politicas necesarias en Supabase.

## Funciones actuales

- Gastos por almuerzo, pan, comida y cena.
- Hasta 3 compradores por almuerzo, comida y cena, con importe separado por comprador.
- Un comprador para pan.
- Control de presentes por guardia.
- Gasto minimo editable.
- Liquidacion directa entre companeros.
- Calendario de guardias con ciclo de 5 dias desde el 29/05/2026.
- Guardado local en el navegador y guardado compartido opcional con Supabase.
- Historial solo de guardias liquidadas.
- Compras previas para guardias futuras.
- Bloqueo automatico de guardias liquidadas al abrir la pantalla de liquidacion.
- Control de pagos pendientes tras liquidar.
- Correccion de liquidaciones.
- Grupo de cocina calculado por guardia desde el 29/05/2026 y grupos editables compartidos en Supabase.
- Pantalla limpia para captura de liquidaciones.
- Banner de Bitcoin con precio BTC/EUR desde Binance.

## Supabase

En Supabase crea una tabla llamada `guardias` con el SQL de `supabase-setup.sql`. La app usa la URL del proyecto y la clave publica `anon`, nunca la clave secreta.

Para que los cambios de otros companeros aparezcan en vivo, activa Realtime para la tabla `guardias` en Supabase. Si no se activa, la app igualmente guarda y carga con los botones.
