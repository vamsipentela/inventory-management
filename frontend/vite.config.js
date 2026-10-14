import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  // GitHub Pages needs the repository path; Vercel serves from the domain root.
  base: process.env.GITHUB_ACTIONS ? '/inventory-management/' : '/',
  build: {
    sourcemap: false,
    target: 'es2020'
  },
  server: {
    port: 5173,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    }
  }
})
