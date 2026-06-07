import { createReadStream, existsSync, statSync } from "node:fs";
import { createServer } from "node:http";
import { extname, join, normalize, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = fileURLToPath(new URL(".", import.meta.url));
const root = resolve(__dirname);
const port = Number(process.env.PORT || 3000);

const mimeTypes = {
  ".css": "text/css; charset=utf-8",
  ".html": "text/html; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".webmanifest": "application/manifest+json; charset=utf-8",
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
  ".png": "image/png",
  ".svg": "image/svg+xml",
  ".webp": "image/webp"
};

function getSafePath(urlPath) {
  const cleanPath = decodeURIComponent(urlPath.split("?")[0]);
  const requestedPath = cleanPath === "/" ? "/index.html" : cleanPath;
  const fullPath = normalize(join(root, requestedPath));
  return fullPath.startsWith(root) ? fullPath : null;
}

const server = createServer((request, response) => {
  const safePath = getSafePath(request.url || "/");

  if (!safePath || !existsSync(safePath) || statSync(safePath).isDirectory()) {
    response.writeHead(404, { "Content-Type": "text/plain; charset=utf-8" });
    response.end("Pagina no encontrada");
    return;
  }

  const contentType = mimeTypes[extname(safePath)] || "application/octet-stream";
  response.writeHead(200, {
    "Cache-Control": "no-store",
    "Content-Type": contentType
  });
  createReadStream(safePath).pipe(response);
});

server.listen(port, () => {
  console.log(`Web Peña Campanar disponible en http://localhost:${port}`);
});
