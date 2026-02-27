---
# DEPLOYMENT GUIDE
## Cascadia Mobile Systems Lab Website
---

This guide provides complete deployment instructions for the Cascadia Mobile Systems Lab website to GitHub Pages with a custom domain.

## ✅ Configuration Summary

- **Repository**: `cascadia-ai-lab/cascadia-ai-lab.github.io`
- **Custom Domain**: `cascadiasystems.org`
- **Site URL**: `https://cascadiasystems.org`
- **Framework**: Astro 4 (static output)
- **Deployment**: GitHub Actions → GitHub Pages
- **Hosting**: GitHub Pages with HTTPS

---

## Prerequisites

- Node.js 18+ installed locally
- GitHub organization: `cascadia-ai-lab` (must be created first)
- Domain: `cascadiasystems.org` (must be owned/controlled)
- Git configured locally

---

## Part 1: Local Development

### Install Dependencies

```bash
npm install
```

### Development Server

```bash
npm run dev
```

Visit `http://localhost:4321` to preview the site locally.

### Production Build Test

```bash
npm run build
npm run preview
```

This builds the site and previews the production output locally.

---

## Part 2: GitHub Setup

### Step 1: Create GitHub Organization

If not already created:

1. Go to: https://github.com/account/organizations/new
2. Organization name: `cascadia-ai-lab`
3. Contact email: [your email]
4. Plan: **Free** (perfect for public repositories)
5. Click **Create organization**

### Step 2: Create Repository

1. Go to: https://github.com/organizations/cascadia-ai-lab/repositories/new
2. Repository name: **`cascadia-ai-lab.github.io`**
3. Description: "Cascadia Mobile Systems Lab - Infrastructure Research Website"
4. Visibility: **Public**
5. **Do NOT initialize** with README (you already have code)
6. Click **Create repository**

### Step 3: Push Code to GitHub

From the project directory:

```bash
# Initialize git (if not already done)
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Production-ready Astro site with GitHub Pages deployment"

# Add remote
git remote add origin https://github.com/cascadia-ai-lab/cascadia-ai-lab.github.io.git

# Push to main
git branch -M main
git push -u origin main
```

### Step 4: Enable GitHub Pages

1. Go to repository: https://github.com/cascadia-ai-lab/cascadia-ai-lab.github.io
2. Click **Settings** (top navigation)
3. Click **Pages** (left sidebar, under "Code and automation")
4. Under **Source**, select:
   - **Source**: `GitHub Actions`
   - (This tells GitHub to use the workflow file for deployment)
5. Click **Save**

### Step 5: Verify First Deployment

1. Go to **Actions** tab: https://github.com/cascadia-ai-lab/cascadia-ai-lab.github.io/actions
2. You should see "Deploy to GitHub Pages" workflow running
3. Wait for the workflow to complete (~1-2 minutes)
4. Site will be live at: `https://cascadia-ai-lab.github.io`

✅ **Checkpoint**: Verify the site loads at the GitHub Pages URL before configuring the custom domain.

---

## Part 3: Custom Domain Setup

### Step 1: Configure DNS

At your domain registrar (where you manage `cascadiasystems.org`), add these DNS records:

**For Apex Domain (cascadiasystems.org):**

```
Type: A
Name: @
Value: 185.199.108.153

Type: A
Name: @
Value: 185.199.109.153

Type: A
Name: @
Value: 185.199.110.153

Type: A
Name: @
Value: 185.199.111.153
```

**For WWW Subdomain (recommended):**

```
Type: CNAME
Name: www
Value: cascadia-ai-lab.github.io
```

### Step 2: Verify CNAME File

The repository already includes `public/CNAME` with:

```
cascadiasystems.org
```

✅ This file is committed and will be deployed automatically.

### Step 3: Configure Custom Domain in GitHub

1. Go to: https://github.com/cascadia-ai-lab/cascadia-ai-lab.github.io/settings/pages
2. Under **Custom domain**, enter: `cascadiasystems.org`
3. Click **Save**
4. GitHub will perform DNS check (this can take 1-24 hours, usually minutes)
5. Wait for the green checkmark: "DNS check successful"

### Step 4: Enable HTTPS

After DNS verification completes:

1. Still in Settings → Pages
2. Check the box: **Enforce HTTPS**
3. Click **Save**

GitHub will automatically provision an SSL certificate via Let's Encrypt.

### Step 5: Verify Custom Domain

1. Visit: `https://cascadiasystems.org`
2. Verify site loads correctly
3. Check that HTTPS works (padlock icon in browser)
4. Test navigation between pages

---

## Part 4: Ongoing Deployments

### Automatic Deployment

Every push to the `main` branch triggers automatic deployment:

```bash
# Make changes to the site
git add .
git commit -m "Update homepage content"
git push

# GitHub Actions will automatically:
# 1. Build the site
# 2. Deploy to GitHub Pages
# 3. Update live site in ~1-2 minutes
```

### Manual Deployment

To manually trigger deployment:

1. Go to: https://github.com/cascadia-ai-lab/cascadia-ai-lab.github.io/actions
2. Click **Deploy to GitHub Pages** workflow
3. Click **Run workflow** → **Run workflow**

### View Deployment Status

Monitor deployments at:
- https://github.com/cascadia-ai-lab/cascadia-ai-lab.github.io/actions

Each deployment shows:
- Build logs
- Deployment status
- Any errors or warnings

---

## Troubleshooting

### Build Fails

**Check workflow logs:**
1. Go to Actions tab
2. Click the failed workflow run
3. Click the failed job to see detailed logs

**Common issues:**
- TypeScript errors: Run `npm run build` locally to debug
- Missing dependencies: Delete `node_modules` and run `npm install`
- Linting errors: Check Astro component syntax

**Fix process:**
```bash
# Debug locally
npm run build

# Fix issues
# Commit and push
git add .
git commit -m "Fix build errors"
git push
```

### Site Not Loading

**If site doesn't load after initial deployment:**

1. Verify GitHub Pages is enabled (Settings → Pages → Source: GitHub Actions)
2. Check workflow completed successfully (Actions tab)
3. Wait 5 minutes for DNS propagation
4. Clear browser cache and try again
5. Check deployment URL matches site URL in astro.config.mjs

### Custom Domain Not Working

**DNS not resolving:**
```bash
# Check DNS propagation
dig cascadiasystems.org

# Should return GitHub Pages IP addresses:
# 185.199.108.153
# 185.199.109.153
# 185.199.110.153
# 185.199.111.153
```

**DNS takes time:**
- Propagation can take up to 24 hours
- Most registrars: 15 minutes to 2 hours
- Use https://www.whatsmydns.net to check global propagation

**HTTPS certificate not issued:**
- DNS must be verified first
- Certificate issuance takes 5-15 minutes after DNS verification
- Revisit Settings → Pages to check status

### Assets Not Loading (404 Errors)

**Check browser console for 404s:**

1. Open browser DevTools (F12)
2. Go to Console tab
3. Look for failed requests

**Likely cause:** Incorrect base path in astro.config.mjs

**Fix:**
```js
// astro.config.mjs
export default defineConfig({
  site: 'https://cascadiasystems.org',
  base: '/', // For custom domain, this should be '/'
  // ...
});
```

### Deployment Succeeds but Site Shows Old Content

**Browser cache:**
```bash
# Hard refresh
Ctrl+Shift+R (Windows/Linux)
Cmd+Shift+R (Mac)
```

**GitHub Pages cache:**
- Wait 5-10 minutes for GitHub Pages CDN to update
- GitHub Pages caches aggressively

**Force cache clear:**
- Add query parameter: `?v=123` to URL
- Change version number to force fresh fetch

---

## Environment Variables

The workflow **does not use environment variables** because:
- Custom domain is hardcoded in `astro.config.mjs`
- Base path is set to `/` for custom domain
- All configuration is in committed files

This ensures:
- ✅ Reproducible builds
- ✅ No secrets required
- ✅ Simple deployment pipeline

---

## DNS Configuration Details

### Why A Records Instead of CNAME for Apex?

GitHub Pages requires **A records** for apex domains (`cascadiasystems.org`) because:
- CNAME at apex violates DNS RFC standards
- Most registrars don't allow CNAME at apex
- A records point directly to GitHub Pages IPs

### TTL Recommendations

Set TTL (Time To Live) based on stability:

- **Initial setup**: 300 seconds (5 minutes) — allows quick changes if you make a mistake
- **After verification**: 3600 seconds (1 hour) — good balance
- **Production stable**: 86400 seconds (24 hours) — reduces DNS queries

### Subdomain Redirects

To redirect `www.cascadiasystems.org` to `cascadiasystems.org`:

GitHub Pages automatically handles this when:
1. You set `www` CNAME to `cascadia-ai-lab.github.io`
2. Your `public/CNAME` contains `cascadiasystems.org` (no www)

Users visiting `www.cascadiasystems.org` will be redirected to `https://cascadiasystems.org`

---

## Security

### HTTPS Enforcement

Once enabled, HTTPS is enforced by:
1. GitHub Pages automatically redirects HTTP → HTTPS
2. SSL certificate auto-renewed by Let's Encrypt
3. Modern TLS protocols supported

### Content Security

- Site is static HTML/CSS/JS (no backend)
- No user data collected
- No cookies or tracking
- No forms or dynamic content
- Minimal attack surface

### Repository Security

**Recommendations:**

1. Enable branch protection for `main`:
   - Require pull request reviews
   - Require status checks to pass
   - Restrict push access

2. Enable Dependabot:
   - Automatic security updates
   - Vulnerability alerts

3. Review workflow permissions:
   - Workflow already uses minimal permissions
   - `pages: write` only for deployment

---

## Performance

### Optimization Built-In

The site is optimized for performance:

- ✅ Static HTML (no server-side rendering)
- ✅ Tailwind CSS purged (only used styles shipped)
- ✅ Minified assets (CSS, JS)
- ✅ Modern font loading (Google Fonts)
- ✅ Astro auto-optimizes images
- ✅ GitHub Pages CDN (global distribution)

### Measuring Performance

Use Lighthouse or PageSpeed Insights:

```
https://pagespeed.web.dev/analysis?url=https://cascadiasystems.org
```

Expected scores:
- Performance: 95-100
- Accessibility: 95-100
- Best Practices: 95-100
- SEO: 95-100

---

## Maintenance

### Regular Updates

**Dependencies:**

```bash
# Check for updates
npm outdated

# Update dependencies
npm update

# Test build
npm run build

# Commit and push
git add package.json package-lock.json
git commit -m "Update dependencies"
git push
```

**Astro upgrades:**

Follow Astro upgrade guides: https://docs.astro.build/en/upgrade-astro/

### Monitoring

**Watch for:**
- Failed workflow runs (GitHub will email you)
- SSL certificate expiration warnings (GitHub handles renewal)
- DNS configuration changes

**Set up notifications:**
1. Go to: https://github.com/settings/notifications
2. Enable notifications for failed Actions

---

## Rollback Procedure

### If a deployment breaks the site:

```bash
# Find the last working commit
git log --oneline

# Revert to that commit
git revert <commit-hash>

# Or hard reset (use with caution)
git reset --hard <commit-hash>
git push --force

# This triggers automatic redeployment
```

**Note:** GitHub Pages keeps previous deployments for ~10 minutes, but it's safest to fix forward or rollback via git.

---

## Production Checklist

Before announcing the site publicly:

- [ ] DNS configured correctly (dig cascadiasystems.org)
- [ ] HTTPS enabled and working
- [ ] All pages load correctly
- [ ] Navigation works across all pages
- [ ] GitHub links point to correct organization
- [ ] Mobile responsive (test on phone/tablet)
- [ ] Lighthouse score > 90 on all metrics
- [ ] No console errors in browser DevTools
- [ ] Deployment workflow runs successfully
- [ ] Custom domain redirects working (www → apex)
- [ ] SSL certificate valid (check padlock)
- [ ] Social meta tags set (for link sharing)

---

## Support & Resources

### Official Documentation

- **Astro Docs**: https://docs.astro.build
- **GitHub Pages**: https://docs.github.com/pages
- **GitHub Actions**: https://docs.github.com/actions
- **Tailwind CSS**: https://tailwindcss.com/docs

### Key Files Reference

| File | Purpose | Edit When |
|------|---------|-----------|
| `astro.config.mjs` | Site config | Changing domain/integrations |
| `public/CNAME` | Custom domain | Never (already configured) |
| `.github/workflows/deploy.yml` | CI/CD pipeline | Rarely (production-ready) |
| `package.json` | Dependencies | Adding packages/integrations |
| `src/pages/*.astro` | Page content | Updating site content |
| `tailwind.config.mjs` | Design tokens | Customizing theme |

### Getting Help

- **Astro Discord**: https://astro.build/chat
- **GitHub Community**: https://github.community
- **DNS Issues**: Contact your domain registrar

---

## Next Steps

After successful deployment:

1. **Announce the site**: Share `https://cascadiasystems.org` publicly
2. **Update GitHub org**: Add site URL to organization profile
3. **Monitor Analytics**: Consider adding privacy-respecting analytics (Plausible, Fathom)
4. **Expand content**: Add experiment reports, hardware specs, blog posts
5. **Automate more**: Consider automated builds on schedule for dynamic content

---

## File Structure

```
cascadia-ai-lab.github.io/
├── .github/
│   └── workflows/
│       └── deploy.yml              # GitHub Actions workflow
├── public/
│   ├── CNAME                       # Custom domain configuration
│   ├── .nojekyll                   # GitHub Pages optimization
│   └── favicon.svg                 # Site icon
├── src/
│   ├── components/
│   │   ├── Navigation.astro        # Header navigation
│   │   └── Footer.astro            # Site footer
│   ├── layouts/
│   │   └── Layout.astro            # Base layout
│   ├── pages/
│   │   ├── index.astro             # Homepage
│   │   ├── about.astro             # About page
│   │   ├── infrastructure.astro    # Infrastructure page
│   │   ├── research.astro          # Research page
│   │   └── documentation.astro     # Documentation page
│   └── styles/
│       └── global.css              # Global styles
├── astro.config.mjs                # Astro configuration
├── tailwind.config.mjs             # Tailwind configuration
├── package.json                    # Dependencies
├── tsconfig.json                   # TypeScript config
└── DEPLOYMENT.md                   # This file
```

---

**You're ready to deploy!** 🚀

Follow the steps above to get your site live at https://cascadiasystems.org
