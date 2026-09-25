# Archived: the Cascadia Mobile Research site (2026-03 → 2026-09-25)

The field-data version of cascadiasystems.org: drone photogrammetry, LiDAR scanning, GIS
analysis, the open lab notebook, and the infrastructure and documentation pages. Retired on
2026-09-25 when the site was repositioned as Cascadia Systems, an operations-automation practice.

Kept here on purpose. Nothing in this folder is built or served. Astro only builds files under
`src/pages/`, so these render nowhere.

- `pages/` (stored as `.astro.txt` so the site build ignores them) — index, about, services, research, infrastructure, documentation as they were at
  commit `1e70682`, plus `field-data.astro`, the briefly published consolidation of the drone
  and LiDAR service lines.
- `components/` and `Layout.astro` — the matching navigation, footer, and layout.

To bring any page back, copy it into `src/pages/`, drop the `.txt` suffix, and add it to the nav in
`src/components/Navigation.astro`. The images they reference are still in `public/images/`.
