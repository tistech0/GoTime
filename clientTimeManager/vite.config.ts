import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import VueDevTools from 'vite-plugin-vue-devtools'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [VueDevTools(), vue()],
  server: {
    port: 8081,
    host: "0.0.0.0",
  },
  resolve: {
    alias: {
      '@': '/src'
    }
  },
  base: process.env.NODE_ENV === 'production' ? 'gotime-api-service' : 'localhost'
})
