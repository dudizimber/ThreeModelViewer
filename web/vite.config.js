import { defineConfig } from 'vite'

// https://vitejs.dev/config/
export default defineConfig(({command, mode }) => {
  return {
    publicDir: 'public',
    build: {
      outDir: '../three_model_viewer/web',
      minify: false,
      emptyOutDir: true,
      rollupOptions: {
        output: {
          entryFileNames: `[name].js`,
          chunkFileNames: `[name].js`,
          assetFileNames: `[name].[ext]`
        }
      }
    }
  }
});
