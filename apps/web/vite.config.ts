import { fileURLToPath, URL } from 'node:url'
import tailwindcss from '@tailwindcss/vite'
import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

const API_PROXY = process.env.API_PROXY || 'http://localhost:3334'

// The API paths. `/oauth/authorize` is not here: it is the SPA's consent page.
// Set APP_URL of the API to this dev server, so MCP sign-in works in dev too.
const proxy = Object.fromEntries(
  ['/api', '/config.js', '/mcp', '/.well-known', '/oauth/register', '/oauth/token'].map((path) => [path, API_PROXY])
)

export default defineConfig({
  plugins: [react(), tailwindcss()],
  resolve: {
    alias: { '@': fileURLToPath(new URL('./src', import.meta.url)) },
  },
  server: { port: 5173, host: true, proxy },
  preview: { port: 5173, host: true, proxy },
})
