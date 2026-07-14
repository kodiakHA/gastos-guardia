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
- `tools/`: scripts de backup/restauracion de Supabase con `pg_dump` y `psql`.
- `backups/`: destino local de copias, ignorado en Git salvo su `.gitignore`.
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

## Copias de seguridad

Hay scripts en `tools/` para crear y restaurar copias logicas de la base de datos de Supabase sin Docker:

- `tools/backup.bat`: crea `backups/YYYY-MM-DD_HH-mm-ss/schema.sql` y `backups/YYYY-MM-DD_HH-mm-ss/data.sql` usando `pg_dump`.
- `tools/restore.bat`: permite elegir una copia y restaurarla con confirmacion previa.
- `tools/backup-config.example.bat`: plantilla sin secretos para crear la configuracion local.
- `tools/backup-config.local.bat`: configuracion local ignorada por Git; debe contener la cadena PostgreSQL de Supabase.
- `tools/README.md`: explica instalacion, conexion recomendada, uso y limitaciones.

Supabase recomienda conexion directa para herramientas como `pg_dump`, migraciones y backup/restore. En Free esa conexion usa IPv6; si tu red no soporta IPv6, usa el Session Pooler, recomendado para redes IPv4. No uses Transaction Pooler para estas copias.

Los scripts fuerzan SSL con `PGSSLMODE=require`, asi que `DATABASE_URL` puede venir con o sin el parametro `sslmode=require`. No guardes contrasenas ni cadenas privadas fuera de `tools/backup-config.local.bat`.

Uso basico:

```bat
tools\backup.bat
tools\restore.bat
```

Requisitos principales:

- PostgreSQL instalado en Windows con `pg_dump` y `psql` disponibles en el `PATH`.
- `tools\backup-config.local.bat` creado a partir de `tools\backup-config.example.bat`.
- `DATABASE_URL` configurada con la cadena PostgreSQL de Supabase, preferiblemente Session Pooler si la red no tiene IPv6.

En el plan Free, Supabase recomienda exportar regularmente la base de datos, ya que los backups automaticos diarios del panel son para planes de pago. Los dumps de base de datos no incluyen objetos de Storage API, solo datos de base de datos y metadatos relacionados.

## Mantenimiento

- Mantener el proyecto como sitio estatico salvo necesidad funcional clara.
- No anadir frameworks, dependencias ni backend propio sin motivo tecnico real.
- Mantener la integracion con Supabase compatible con acceso desde navegador.
- Evitar refactorizaciones amplias si el cambio puede ser localizado.
- Documentar cambios relevantes en este README o en notas internas cuando aplique.
