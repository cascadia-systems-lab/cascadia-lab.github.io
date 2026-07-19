# Cascadia Mobile Research

**Drone and LiDAR field data collection, processed on our own infrastructure. Portland, Oregon.**

This is the repository behind [cascadiasystems.org](https://cascadiasystems.org) — the web home of **Cascadia Mobile Research LLC**, an independent lab that pairs field data capture (sub-250g UAS, handheld 3D LiDAR) with self-hosted spatial data processing (photogrammetry, LiDAR SLAM, GIS analysis) on hardware we own and operate.

---

## What lives here

- **`src/`** — the Astro site itself (dark theme, Tailwind)
- **`docs/`** — lab documentation: hardware inventory, architecture notes, experiment records, runbooks
- **`docs/experiments/`** — the experiment index and write-ups behind the site's [Lab Notes](https://cascadiasystems.org/research/)
- **`branding/`** — logo and brand assets

The lab publishes its methods as it goes — including negative results. Experiment write-ups land in `docs/experiments/` and are surfaced on the site as they complete.

## The pipeline

**Collect** — planned, repeatable drone flights and LiDAR scans →
**Process** — photogrammetry, SLAM, and analysis on a dedicated GPU workstation and multi-node virtualization cluster; client data never passes through third-party cloud services →
**Deliver** — orthomosaics, elevation models, point clouds, 3D meshes, and GIS analysis with documented accuracy limits.

## Contact

The lab's contact page is being set up. Until then, [open an inquiry issue](https://github.com/cascadia-systems-lab/cascadia-lab.github.io/issues/new?template=inquiry.yml) with your site, your question, and a way to reach you (a free GitHub account is required), or see [cascadiasystems.org/services](https://cascadiasystems.org/services/).

---

© Cascadia Mobile Research LLC · Portland, Oregon
