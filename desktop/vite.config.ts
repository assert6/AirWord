import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import electron from 'vite-plugin-electron';
import renderer from 'vite-plugin-electron-renderer';
import path from 'path';

export default defineConfig({
  plugins: [
    react(),
    electron({
      entry: 'src/main/index.ts',
      onstart(args) {
        args.startup();
      },
      vite: {
        build: {
          rollupOptions: {
            external: ['robotjs']
          }
        }
      }
    }),
    renderer(),
  ],
  server: {
    port: 5173,
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'src'),
    },
  },
});
