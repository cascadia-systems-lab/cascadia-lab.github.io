# Website Setup - Quick Start

This file provides a quick overview of the Astro website setup for the Cascadia Mobile Systems Lab.

## What Was Configured

Your repository now includes a complete production-ready Astro static site with automated GitHub Pages deployment:

### ✅ Core Configuration

1. **[package.json](package.json)** - Astro dependencies and build scripts
2. **[astro.config.mjs](astro.config.mjs)** - Static output mode with GitHub Pages optimization
3. **[tsconfig.json](tsconfig.json)** - TypeScript configuration
4. **[.github/workflows/deploy.yml](.github/workflows/deploy.yml)** - Automated deployment workflow

### ✅ Website Structure

```
src/
├── layouts/
│   └── Layout.astro          # Base layout with styles
└── pages/
    └── index.astro           # Homepage (customize this!)

public/
├── .nojekyll                 # GitHub Pages optimization
└── favicon.svg               # Site icon
```

### ✅ Deployment Pipeline

- **Trigger**: Automatic on push to `main` branch
- **Build**: Node.js 20, npm ci, Astro build
- **Deploy**: GitHub Actions → GitHub Pages
- **Result**: Live static site with HTTPS

---

## Getting Started

### 1. Install Dependencies

```bash
npm install
```

### 2. Start Development Server

```bash
npm run dev
```

Visit `http://localhost:4321` to see your site.

### 3. Customize Content

Edit [src/pages/index.astro](src/pages/index.astro) to update:
- Lab description
- Focus areas
- Links to your GitHub repository

**Important**: Replace placeholder URLs:
```astro
<!-- Update these in src/pages/index.astro -->
<a href="https://github.com/yourusername/cascadia-mobile-systems-lab">
```

### 4. Deploy to GitHub Pages

See **[DEPLOYMENT.md](DEPLOYMENT.md)** for complete instructions.

**Quick version:**
1. Push code to GitHub
2. Enable GitHub Pages (Settings → Pages → Source: GitHub Actions)
3. Workflow runs automatically
4. Site is live at `https://yourusername.github.io/repo-name/`

---

## Development Commands

| Command | Purpose |
|---------|---------|
| `npm run dev` | Start dev server (hot reload enabled) |
| `npm run build` | Build for production |
| `npm run preview` | Preview production build locally |

---

## Next Steps

### Immediate Actions

1. **Install dependencies**: `npm install`
2. **Start dev server**: `npm run dev`
3. **Customize homepage**: Edit `src/pages/index.astro`
4. **Update GitHub URLs**: Replace `yourusername/repo-name` placeholders

### Expand Your Site

1. **Add more pages**: Create new `.astro` files in `src/pages/`
   - Example: `src/pages/experiments.astro` → `/experiments` route
   - Example: `src/pages/docs/overview.astro` → `/docs/overview` route

2. **Add components**: Create reusable components in `src/components/`
   - Example: Header, Footer, Card components

3. **Style customization**: Update CSS variables in `src/layouts/Layout.astro`

4. **Add documentation pages**: Convert your markdown docs to Astro pages

5. **Integrate content collections**: Use Astro's content collections to manage docs

### Production Deployment

When ready to deploy:
1. Review [DEPLOYMENT.md](DEPLOYMENT.md)
2. Initialize git and push to GitHub
3. Enable GitHub Pages
4. Verify deployment at your GitHub Pages URL

---

## Key Files Reference

| File | Purpose | When to Edit |
|------|---------|--------------|
| [src/pages/index.astro](src/pages/index.astro) | Homepage content | Every time you update site content |
| [astro.config.mjs](astro.config.mjs) | Site configuration | When changing domain/base path |
| [package.json](package.json) | Dependencies | When adding Astro integrations |
| [.github/workflows/deploy.yml](.github/workflows/deploy.yml) | CI/CD pipeline | Rarely (it's production-ready) |

---

## Project Structure

This is still your Compute Systems Lab repository, now with a website:

```
cascadia-mobile-systems-lab/
├── docs/                    # Your existing documentation
├── experiments/             # Your existing experiments
├── infrastructure/          # Your existing infrastructure
├── src/                     # ← NEW: Astro website source
├── public/                  # ← NEW: Static assets
├── .github/workflows/       # ← NEW: Automated deployment
├── astro.config.mjs         # ← NEW: Astro config
├── package.json             # ← NEW: Dependencies
└── DEPLOYMENT.md            # ← NEW: Deployment guide
```

The website lives alongside your existing lab content. You can:
- Keep documentation in `docs/` (traditional markdown)
- Showcase it via Astro pages in `src/pages/`
- Link between them as needed

---

## Design Philosophy

This setup follows your lab's principles:

- **Minimal**: Only Astro core, no unnecessary dependencies
- **Static**: No server, no runtime, just HTML/CSS/JS
- **Reliable**: Automated builds, reproducible deployments
- **Simple**: Clear structure, well-documented
- **Production-safe**: GitHub Pages HTTPS, CDN delivery, zero secrets

---

## Resources

- **Astro Docs**: https://docs.astro.build
- **Astro Tutorial**: https://docs.astro.build/en/tutorial/0-introduction/
- **Deployment Guide**: See [DEPLOYMENT.md](DEPLOYMENT.md)
- **GitHub Pages**: https://pages.github.com

---

## Support

For deployment issues, see [DEPLOYMENT.md § Troubleshooting](DEPLOYMENT.md#troubleshooting).

For Astro questions, consult the [official documentation](https://docs.astro.build).

---

**You're all set!** Run `npm install && npm run dev` to start building your lab's website.
