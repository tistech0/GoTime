import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import VueDevTools from 'vite-plugin-vue-devtools'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [VueDevTools(), vue()],
  server: {
    port: 8081,
    host: "0.0.0.0",
    proxy: {
      '/api': {
        target: process.env.NODE_ENV === 'production' ? `http://${process.env.VUE_APP_API_HOST}:4000` : 'http://localhost:4000',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, '')
      }
    }
  },
  resolve: {
    alias: {
      '@': '/src'
    }
  }
})
