# AGENTS.md

Instrucciones para agentes de programacion que trabajen en este repositorio.

## Principios del proyecto

- Inspecciona primero el repositorio real antes de asumir tecnologias, comandos o estructura.
- La aplicacion es un sitio estatico. El frontend vive principalmente en `index.html`.
- No usa React, Vite, Next.js, Express ni servidor Node en produccion.
- No requiere instalacion de dependencias ni proceso de build.
- Se despliega desde `main` en GitHub a Cloudflare Pages.
- Produccion: https://kampanar.com.
- Supabase es el backend. La aplicacion se comunica con Supabase directamente desde el navegador.

## Reglas de cambio

- Realiza cambios minimos, localizados y proporcionales al objetivo.
- Preserva el funcionamiento actual de la aplicacion y la integracion con Supabase.
- Mantener la arquitectura estatica salvo peticion expresa o necesidad funcional clara.
- No anadir frameworks, bundlers, dependencias ni herramientas nuevas sin una razon clara.
- No anadir backend propio salvo peticion expresa.
- No reintroducir Railway ni archivos de servidor antiguos (`railway.json`, `server.js`, `package.json`) salvo que el usuario lo pida expresamente y exista una necesidad tecnica real.
- No modificar `index.html` ni la logica de la aplicacion cuando la tarea sea solo documental.
- Evita refactorizaciones amplias no solicitadas.
- Mantener compatibilidad con Cloudflare Pages sin build.

## Supabase y datos

- Preserva el uso de Supabase como backend.
- En el frontend solo puede usarse la clave publica `anon`.
- Nunca escribas claves `service_role`, tokens privados ni secretos en archivos publicos.
- En una app estatica, la URL de Supabase y la clave `anon` son visibles por diseno.
- La seguridad debe apoyarse en RLS, permisos, restricciones y validaciones de Supabase.
- Si cambias el acceso a datos, revisa las politicas RLS y permisos implicados.
- No modifiques datos, tablas o politicas de produccion de forma destructiva.
- Antes de proponer SQL destructivo, explica el impacto y pide confirmacion explicita.

## Verificacion

Usa comprobaciones razonables sin instalar dependencias innecesarias:

- Validar la sintaxis JavaScript embebida si se toca `index.html`.
- Comprobar que los recursos referenciados existen (`Fotos/`, icono, manifest, etc.).
- Revisar que no se rompa la configuracion de Cloudflare Pages (`_headers`, raiz estatica).
- Revisar enlaces y rutas cuando se cambie documentacion o estructura.
- Si no puedes verificar algo, indicalo claramente.

## Antes de terminar

- `git status` revisado y cambios inesperados identificados.
- Cambios limitados al alcance pedido.
- Sin secretos nuevos en archivos publicos.
- Sin dependencias o frameworks nuevos salvo autorizacion clara.
- Sin Railway ni archivos de servidor antiguos reintroducidos.
- Documentacion actualizada si el cambio afecta arquitectura, despliegue o mantenimiento.
- Comprobaciones ejecutadas o limitaciones explicadas.
