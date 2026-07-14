# Herramientas de backup y restauracion

Scripts Windows para crear y restaurar copias logicas de la base de datos de Supabase de Web Pena Campanar.

No usan Docker ni Railway. Usan las herramientas oficiales de PostgreSQL:

- `pg_dump` para exportar.
- `psql` para restaurar.

## Requisitos

- Windows.
- PostgreSQL instalado con herramientas de linea de comandos.
- `pg_dump` y `psql` disponibles en el `PATH`.
- Una cadena de conexion PostgreSQL de Supabase.

Para comprobar la instalacion:

```bat
pg_dump --version
psql --version
```

Si faltan, instala PostgreSQL para Windows desde el instalador oficial y marca la opcion de herramientas de linea de comandos. En Windows 10 y Windows 11 puede ser necesario anadir la carpeta `bin` de PostgreSQL al `PATH`, por ejemplo `C:\Program Files\PostgreSQL\16\bin`. Abre una terminal nueva despues de instalar.

## Configuracion local

1. Copia el ejemplo:

```bat
copy tools\backup-config.example.bat tools\backup-config.local.bat
```

2. Edita `tools\backup-config.local.bat` y pega tu cadena de conexion.

Ese archivo queda ignorado por Git y no debe subirse nunca.

Supabase recomienda usar la conexion directa para herramientas PostgreSQL como `pg_dump`, migraciones y backup/restore. En Free, la conexion directa usa IPv6; si tu red no soporta IPv6, usa el Session Pooler de Supabase, que suele funcionar mejor en redes IPv4. No uses Transaction Pooler para estos scripts.

Los scripts fuerzan SSL con esta variable:

```bat
set "PGSSLMODE=require"
```

Por eso `DATABASE_URL` puede venir con o sin `sslmode=require`; no se valida ni se exige ese parametro dentro de la URL.

Si la contrasena contiene caracteres especiales, usa la connection string tal como la entrega Supabase o codifica esos caracteres para URL.

Ejemplos de `DATABASE_URL`:

```bat
rem Conexion directa, si tu red soporta IPv6
set "DATABASE_URL=postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres"

rem Session Pooler recomendado para redes IPv4
set "DATABASE_URL=postgres://postgres.[PROJECT-REF]:[PASSWORD]@aws-[REGION].pooler.supabase.com:5432/postgres"
```

## Backup

Ejecuta:

```bat
tools\backup.bat
```

El script:

- comprueba que existe `pg_dump`;
- carga `tools\backup-config.local.bat`;
- crea `backups\YYYY-MM-DD_HH-mm-ss\`;
- comprueba que la carpeta de destino se puede escribir;
- exporta el esquema `public` a `schema.sql`;
- exporta los datos de `public` a `data.sql`;
- valida que `schema.sql` y `data.sql` existen y no tienen 0 bytes;
- se detiene si `pg_dump` falla;
- muestra carpeta, tamano de archivos y duracion aproximada.

Salida final esperada:

```text
========================================
Backup completado correctamente

Carpeta:
C:\...\backups\YYYY-MM-DD_HH-mm-ss

Archivos generados:
  schema.sql   3 KB
  data.sql     115 KB

Duracion aproximada: 8 segundos
========================================
```

## Restauracion

Ejecuta manualmente:

```bat
tools\restore.bat
```

El script:

- comprueba que existe `psql`;
- carga `tools\backup-config.local.bat`;
- muestra el destino configurado;
- lista las copias disponibles;
- exige escribir `RESTAURAR`;
- valida que `schema.sql` y `data.sql` existen y no tienen 0 bytes;
- muestra que archivo esta restaurando;
- aplica primero `schema.sql`;
- aplica despues `data.sql`;
- usa `ON_ERROR_STOP=1` para detenerse ante errores;
- muestra duracion aproximada y un mensaje final de exito.

Ejemplo de restauracion:

```bat
tools\restore.bat
```

Despues elige el numero de copia y escribe exactamente:

```text
RESTAURAR
```

## Mensajes de error

Los scripts intentan diferenciar los errores mas habituales:

- falta de `pg_dump` o `psql`;
- carpeta de destino no accesible;
- fallo de resolucion DNS;
- contrasena incorrecta;
- conexion rechazada;
- timeout de red.

Si PostgreSQL devuelve otro error, se muestra el detalle original para poder diagnosticarlo.

## Alcance y limitaciones

- Se exporta solo el esquema `public` y sus datos.
- El esquema incluye tablas, indices, restricciones, funciones, triggers y politicas RLS definidas en `public`.
- No se exportan esquemas gestionados por Supabase como `auth`, `storage`, `extensions` o `vault`.
- No se descargan objetos de Supabase Storage; para Storage haria falta un procedimiento especifico aparte.
- `--no-owner` y `--no-privileges` facilitan restaurar en otro proyecto Supabase sin depender de propietarios o grants exactos del origen.
- `--column-inserts` hace el backup de datos mas portable y legible, aunque puede ser mas lento que `COPY` en bases grandes.
- Restaurar sobre una base de datos con objetos o datos existentes puede fallar por objetos ya creados, claves duplicadas o restricciones. Haz siempre una copia antes de restaurar.
- La duracion mostrada es aproximada y se calcula en segundos.
- La clasificacion de errores depende del texto que devuelvan `pg_dump` y `psql`; si cambia el idioma o version de PostgreSQL, puede aparecer el mensaje original sin clasificar.

## Futuro Linux

La estructura permite anadir scripts `.sh` equivalentes usando la misma configuracion conceptual y la misma carpeta `backups/YYYY-MM-DD_HH-mm-ss/`.
