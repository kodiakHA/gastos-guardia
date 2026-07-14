# CLAUDE.md

Lee `AGENTS.md` como fuente principal de reglas para trabajar en este repositorio.

Resumen critico:

- Proyecto estatico: la mayor parte de la aplicacion esta en `index.html`.
- Backend: Supabase, usado directamente desde el navegador.
- Produccion: https://kampanar.com.
- Despliegue: GitHub `main` -> Cloudflare Pages.
- No hay build, dependencias ni servidor Node en produccion.
- No anadir frameworks nuevos sin autorizacion expresa.
- No Railway: no reintroducir `railway.json`, `server.js` ni `package.json` salvo peticion expresa y necesidad tecnica real.
- No poner secretos en el frontend: solo clave publica `anon`; nunca `service_role`.
- Mantener cambios pequenos y localizados.
- Preservar la integracion con Supabase y revisar RLS/permisos si cambia el acceso a datos.
- Antes de terminar, comprobar que la aplicacion sigue cargando y que las operaciones principales previstas no quedan afectadas.

Para tareas solo documentales, no modificar `index.html` ni la logica de la aplicacion.
