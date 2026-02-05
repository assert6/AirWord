import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://airword-dev.assert6.com:3001',
        changeOrigin: true
      }
    }
  }
});
