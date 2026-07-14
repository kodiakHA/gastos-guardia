# Web Pena Campanar

Aplicacion web estatica para repartir gastos de guardia en Parque Campanar.

Produccion: https://kampanar.com

## Arquitectura actual

- Frontend: HTML, CSS y JavaScript en `index.html`.
- Hosting: Cloudflare Pages.
- Origen de despliegue: rama `main` de GitHub.
- Backend: Supabase.
- Datos compartidos: tabla `guardias` en Supabase.
- Autenticacion y almacenamiento: servicios gestionados en Supabase cuando el proyecto los necesite.
- Recursos locales: imagenes en `Fotos/`, `icon.svg` y `site.webmanifest`.

No hay servidor propio en produccion, no hay proceso Node, no hay framework frontend y no hay paso de build. El navegador carga el sitio desde Cloudflare Pages y se comunica directamente con Supabase.

Supabase proporciona la base de datos y los servicios de autenticacion y almacenamiento del proyecto. En el codigo actual, el acceso verificado desde el frontend es por REST a la tabla `guardias`, usando la configuracion publica definida en `index.html`.

## Tecnologias utilizadas

- HTML/CSS/JavaScript estatico.
- Cloudflare Pages.
- GitHub.
- Supabase.
- API publica de Binance para mostrar BTC/EUR.

No se usa React, Vite, Next.js, Express ni servidor Node.

## Estructura basica

- `index.html`: aplicacion completa.
- `_headers`: cabeceras usadas por Cloudflare Pages.
- `site.webmanifest`: configuracion de instalacion/PWA.
- `icon.svg`: icono de la aplicacion.
- `Fotos/`: imagenes usadas por la interfaz.
- `supabase-setup.sql`: SQL base para crear la tabla `guardias` y sus politicas.
- `borrar-guardia-*.sql`: scripts puntuales de mantenimiento de datos.
- `Abrir Web Pena Campanar.bat`: acceso rapido local para abrir la web.
- `NOTAS_CONTINUIDAD.md`: notas internas de continuidad.

## Despliegue

El despliegue es automatico:

1. Se modifica el repositorio.
2. Se suben los cambios a GitHub en `main`.
3. Cloudflare Pages publica el sitio en https://kampanar.com.

Configuracion de Cloudflare Pages:

- Framework preset: `None` / sin framework.
- Build command: vacio. Si Cloudflare obliga a rellenarlo, usar `exit 0`.
- Build output directory: `/` o `.`.
- Root directory: `/`.
- Environment variables: ninguna.

## Desarrollo local

No hace falta instalar dependencias.

Para probar la aplicacion:

1. Abre `index.html` directamente en el navegador.
2. O ejecuta `Abrir Web Pena Campanar.bat`.
3. Revisa la consola del navegador si se modifica JavaScript.
4. Comprueba que las operaciones principales siguen cargando y guardando datos en Supabase.

## Supabase y seguridad

La configuracion publica de Supabase esta actualmente en `index.html`. En una aplicacion puramente estatica, la URL del proyecto y la clave publica `anon` no pueden mantenerse secretas: cualquier visitante puede verlas en el navegador.

No se debe introducir nunca una clave `service_role`, tokens privados ni secretos en archivos publicos del repositorio.

La seguridad depende principalmente de Supabase:

- politicas RLS;
- permisos de tablas;
- validaciones y restricciones de datos;
- uso correcto de la clave publica `anon`.

Antes de cambiar el acceso a datos, revisar `supabase-setup.sql` y las politicas activas en Supabase.

## Mantenimiento

- Mantener el proyecto como sitio estatico salvo necesidad funcional clara.
- No anadir frameworks, dependencias ni backend propio sin motivo tecnico real.
- Mantener la integracion con Supabase compatible con acceso desde navegador.
- Evitar refactorizaciones amplias si el cambio puede ser localizado.
- Documentar cambios relevantes en este README o en notas internas cuando aplique.
