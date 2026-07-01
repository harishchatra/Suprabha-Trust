# Suprabha Trust — 2026 Website Upgrade Plan

**Goal:** Move the site from a polished 2021-era glassmorphism template to a 2026-feeling design: rich media, confident typography, bento layouts, restrained effects, and baseline accessibility.

**Stack (do not break):** Static HTML + one shared `assets/css/main.css` + one shared `assets/js/main.js`. Deployed on Netlify. Every page reuses the same `#mpt-topbar` nav, `#mpt-sidebar`, and `<footer>`. Fonts via Google Fonts (currently only **Philosopher**, serif).

**Working rule for the agent:** Make changes in the shared CSS/JS wherever possible so all ~15 pages benefit at once. Avoid per-page inline styles — migrate them into reusable classes. Test on mobile (≤480px), tablet (768px), and desktop after each phase.

---

## Phase 0 — Cleanup & guardrails (do first, ~0.5 day)

These are zero-risk and make everything after easier.

- [ ] **Delete dead files** so the deploy is lean and the repo is unambiguous:
  `old_index.html`, `minimal_index.html`, `claude_index.html`, `suprabha-trust.html`, `old_logo.txt`, `solid_logo.txt`. Confirm none are linked anywhere first (`grep` each filename).
- [ ] **Fix the founding-date inconsistency:** site says "Est. 2006" everywhere, but `contact.html` says "Established 2010". Pick one (likely 2006) and make it consistent across all pages + footer.
- [ ] **Verify form handlers:** `contact.html` calls `handleContact(event)` but `main.js` only defines `handleSubmit`/`handleVideoSubmit`. Either add `handleContact` or repoint the form. Test an actual submission through Netlify Forms.
- [ ] **Resolve placeholders:** `SUBMISSION_CONFIG` in `main.js:236-238` still has `YOUR_GOOGLE_DRIVE_URL_HERE`. Wire real URLs or remove the feature.
- [ ] **Confirm `assets/img/suprabha-og.jpg` exists** (referenced as OG image in every page `<head>`).

**Acceptance:** repo has no orphan HTML files; one founding date sitewide; contact + article + video forms submit successfully; no console errors on load.

---

## Phase 1 — Accessibility & polish baseline (~1 day)

Fastest credibility wins; touches the shared CSS so it applies everywhere.

- [ ] **`prefers-reduced-motion` guard.** Add a `@media (prefers-reduced-motion: reduce)` block in `main.css` that disables/short-circuits the infinite animations: `floatAnim` (hero logo), `cosmicSpin` (`#vedic-bg`, 120s), `slowSpin` (`.yantra-bg`), `pulse`, and the scroll-reveal transforms.
- [ ] **`:focus-visible` styles.** Links, buttons, the hamburger, and nav items currently have no visible keyboard focus (only form inputs do). Add a consistent gold focus ring.
- [ ] **Skip-to-content link** at the top of `<body>`, visible on focus, jumping to `#spt-main`.
- [ ] **Hamburger a11y:** toggle `aria-expanded` true/false in `mptToggle()` (`main.js`); add `aria-controls="mpt-sidebar"`.
- [ ] **Contrast pass:** `--color-muted: #9CA3AF` on dark fails WCAG AA at small sizes. Lighten to ~`#B6BCC9` and/or raise small body text to ≥1rem. Re-check gradient-clipped headings against contrast.
- [ ] **Consistent border-radius:** inline `border-radius:2px` (contact icons, status boxes) conflicts with the 8/16/32px tokens. Standardize on the tokens.

**Acceptance:** Lighthouse Accessibility ≥ 95; full keyboard navigation with visible focus; motion stops when OS "reduce motion" is on.

---

## Phase 2 — Typography system (~1 day)

- [ ] **Introduce a real type pairing.** Keep a display serif for headings (Philosopher, or upgrade to e.g. *Fraunces*/*Cormorant*), add one clean sans for body (e.g. *Inter*, *Geist*, or *General Sans*). Update `--font-display` and `--font-body` in `main.css:45-46` and load the second font in each page `<head>`.
- [ ] **Remove ad-hoc `system-ui` overrides** scattered in HTML/CSS (hero-sub, aspect cards, contact blocks) — they exist only because body-serif looked wrong. The new `--font-body` sans replaces them.
- [ ] **Scale up & breathe:** raise base body to 1rem–1.125rem, increase paragraph `line-height` and section spacing.
- [ ] **Restrain gradient headings:** stop using `-webkit-text-fill-color: transparent` on *every* heading (`.section-title`, etc.). Reserve the gold gradient for the hero + one accent per page; make the rest solid `--color-text`.

**Acceptance:** one cohesive heading/body pairing across all pages; no raw `system-ui` font declarations remain; headings readable, not uniformly gold.

---

## Phase 3 — Iconography & imagery (~2-3 days, highest visual impact)

- [ ] **Replace all emoji icons** (🙏 📚 🏛 ✦ in the Connections section, and any others) with a single consistent stroke-SVG set. The clean 24×24 stroke SVGs already in `contact.html` are the house style — build a small inline `<symbol>` sprite (like the existing `#suprabha-logo`) and `<use>` it everywhere.
- [ ] **Add real photography/media.** Source or commission images of temples, manuscripts, rituals, people, heritage sites. Add:
  - A hero image or short looping video behind the homepage hero (currently just SVG glow).
  - Banner images on the content pages (the `.page-banner` component already supports this).
  - Cards in Knowledge / Life / Vedic / Meta pages get thumbnail imagery.
- [ ] **Image hygiene:** WebP/AVIF, explicit `width`/`height`, `loading="lazy"`, descriptive `alt`. Keep hero media optimized (<300KB) to protect LCP.

**Acceptance:** zero emoji used as UI icons; homepage hero has real media; content pages and knowledge cards carry imagery; Lighthouse Performance stays ≥ 85.

---

## Phase 4 — Layout modernization (~2-3 days)

- [ ] **Break the repetitive rhythm.** Almost every section is centered eyebrow → gradient title → gold-line → description → equal-card grid. Introduce variety:
  - **Bento grid** for the Knowledge Bank (mixed-size tiles instead of uniform cards).
  - **Asymmetric/split hero** (text left, media right) as an option.
  - Alternating section backgrounds and the occasional full-bleed image band.
- [ ] **Migrate inline-styled content pages to shared components.** `lifesciences.html` (~59KB), `vedicsciences.html`, `metaphysics.html`, `biofield.html` are heavy walls of inline style. Reuse the existing `.c-card`, `.grid-2/3/4`, `.c-heading`, `.pullquote`, `.c-table` classes already defined in `main.css`.
- [ ] **Navigation consistency:** desktop nav shows only 6 of ~15 pages and has no active-page indicator, while the sidebar shows all. Add an active state and consider a **mega-menu** for "Knowledge."

**Acceptance:** content pages contain little/no inline styling; at least one bento-style section live; desktop nav highlights the current page.

---

## Phase 5 — Conversion & content features (~2 days)

- [ ] **Real donate flow.** Donate page currently routes everything to "Get in Touch." Add an actual path: UPI/QR, Razorpay/Instamojo, or bank details + 80G receipt info. This is the single most important functional gap for an NGO.
- [ ] **Contact map embed** (the registered/primary office addresses are already there).
- [ ] **Structured data (SEO):** add JSON-LD `Organization`/`NGO` on the homepage and `BreadcrumbList` on inner pages. Confirm `sitemap.xml`/`robots.txt` are current.
- [ ] **Sticky/persistent donate CTA** on scroll (mobile-friendly).

**Acceptance:** a visitor can complete (or clearly initiate) a donation without emailing; valid JSON-LD (passes Google Rich Results test); map renders on Contact.

---

## Phase 6 — Optional "wow" (nice-to-have)

- [ ] Light/dark theme toggle (currently dark-only).
- [ ] Scroll progress indicator + scroll-driven section animations (building on the existing IntersectionObserver reveals).
- [ ] More interactive set-pieces like the existing 7-Chakras SVG (its hover/tap interaction is the most "2026" moment on the site — make more of them).

---

## Suggested sequencing & effort

| Phase | Theme | Effort | Risk |
|-------|-------|--------|------|
| 0 | Cleanup & guardrails | 0.5d | none |
| 1 | Accessibility baseline | 1d | low |
| 2 | Typography | 1d | low |
| 3 | Icons & imagery | 2-3d | medium (needs assets) |
| 4 | Layout modernization | 2-3d | medium |
| 5 | Conversion & SEO | 2d | medium (needs payment decision) |
| 6 | Optional wow | flexible | low |

**Order rationale:** 0→1→2 are global, low-risk, and compound. 3 needs real image assets (the gating dependency — start sourcing now). 4 builds on the new type/icons. 5 needs a business decision on the payment provider.

## Open decisions to settle before/with Antigravity
1. **Image assets** — who supplies photography? (Phase 3 is blocked without it.)
2. **Donation provider** — UPI/QR only, or a gateway (Razorpay/Instamojo)? Is 80G applicable?
3. **Font choice** — keep Philosopher for headings or upgrade the display serif too?
4. **Scope of redesign** — incremental (reuse current sections, restyle) vs. a fuller homepage rethink.
