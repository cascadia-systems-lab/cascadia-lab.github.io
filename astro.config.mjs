import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';

// https://astro.build/config
export default defineConfig({
  // Static site generation mode (no SSR)
  output: 'static',

  // Site URL - Custom domain for Cascadia AI Systems Lab
  site: 'https://cascadiasystems.org',

  // Base path - Root domain, no subdirectory
  base: '/',

  // Integrations
  integrations: [
    tailwind({
      // Disable default base styles to have full control
      applyBaseStyles: false,
    }),
  ],

  // Build output configuration
  build: {
    // Output directory for built files
    outDir: './dist',

    // Assets are placed in dist/_astro/
    assets: '_astro',

    // Ensure proper trailing slashes for GitHub Pages
    format: 'directory',

    // Inline small assets for performance
    inlineStylesheets: 'auto',
  },

  // Vite configuration for asset handling
  vite: {
    build: {
      // Minify CSS and JS for production
      minify: 'esbuild',
      cssMinify: true,
    },
  },

  // Development server configuration
  server: {
    port: 4321,
    host: true,
  },

  // Markdown configuration
  markdown: {
    shikiConfig: {
      theme: 'github-dark',
    },
  },
});
