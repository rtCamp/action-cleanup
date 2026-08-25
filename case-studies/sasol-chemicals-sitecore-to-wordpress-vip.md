# Sasol Chemicals: Migrating a Global Manufacturer from Sitecore to WordPress VIP

**Client:** Sasol Chemicals
**Industry:** Chemicals & Manufacturing
**Services:** Platform migration, custom WordPress VIP theme & plugin development, AI-assisted content migration, enterprise SSO, multilingual publishing
**Site:** chemicals.sasol.com

---

## At a Glance

| | |
|---|---|
| **From → To** | Sitecore (SXA/JSS) → WordPress VIP |
| **Architecture** | Custom Full Site Editing (FSE) block theme + Tailwind CSS |
| **Scope delivered** | 74 tracked GitHub deliverables across theme, plugins, page templates and 30+ custom Gutenberg blocks |
| **Content types** | 5 custom post types (Applications, Products, Formulations, Events, Press Releases) + custom taxonomies |
| **Languages** | English + German + Simplified Chinese (Polylang Pro + DeepL machine translation) |
| **Security** | Microsoft Entra ID (SAML 2.0) SSO across Dev, Pre-Prod and Production, with role mapping, session controls and auth-attempt logging |
| **Status** | Live on WordPress VIP |

---

## About the Client

Sasol Chemicals is the chemicals arm of Sasol, a global integrated chemicals and energy company. Its corporate site is the primary digital touchpoint for a technical, multi-region audience — customers researching formulations and applications, industry partners, press, and internal stakeholders — spread across markets that require the site to work fluently in more than one language.

## The Challenge

Sasol Chemicals' existing site ran on Sitecore, with content modeled through Sitecore's XM Cloud/SXA layout and component system and served via its GraphQL Layout Service. The company needed to move onto WordPress VIP without regressing on three fronts that mattered most to a global enterprise brand:

1. **Content fidelity** — hundreds of pages of structured content (industries, applications, products, formulations, events, press releases) built from dozens of interlocking Sitecore components, with no acceptable margin for silently dropped or mismatched content during the move.
2. **Enterprise-grade security** — the client's security team required Microsoft Entra ID single sign-on across every environment, with WordPress's default login surface removed entirely, not layered on top of it.
3. **Multilingual publishing at editorial speed** — content needed to ship in English, German and Simplified Chinese, through a workflow that non-technical editors with newly defined roles could run themselves after launch.

Underneath all three was a harder constraint: this had to be an **auditable, incremental delivery**, not a single-shot cutover. The team tracked the entire build as 74 discrete, milestone-tagged GitHub issues — from foundational custom post types and taxonomies, through 30+ purpose-built Gutenberg blocks (Hero Banner, Feature Cards, Carousel, Accordion, Stat Cards, Insight Gallery, Tab Section, and more), to enterprise security and final UAT — so that scope, ownership and progress stayed visible to both the delivery team and the client throughout.

## The Approach

rtCamp built a custom FSE (Full Site Editing) block theme on Tailwind CSS, purpose-fit to WordPress VIP, and reconstructed Sasol's component library as native Gutenberg blocks rather than reaching for a page-builder. Content migration was run as an AI-assisted pipeline: a script pulled structured content directly from Sitecore's GraphQL Layout Service, mapped it against a field-mapping sheet (co-maintained by the team and an AI drafting pass), and wrote it into the new WordPress content model in repeatable, verifiable passes — with every pass diffed against the live site rather than trusted blindly.

Three of Sasol's legacy Sitecore "Multilist" components (used for Applications, Products and Featured content) were manually curated by editors, with hand-picked ordering. Rebuilding these as an automatic, CPT-and-taxonomy-driven **Feature Cards** block was a deliberate content-modeling decision, not a mechanical migration step — one made jointly with the client after weighing editorial control against long-term maintainability.

## Challenges We Solved

This project's real difficulty wasn't the theme or the blocks — both teams had done that before. It was the handful of places where legacy-system nuance, AI-assisted tooling, and enterprise security requirements collided, and where a wrong call would have been expensive to unwind after launch.

### 1. When the AI-drafted mapping sheet hallucinated a rule

The Sitecore-to-WordPress field mapping was too large to build entirely by hand, so the team used an AI pass to draft the initial mapping sheet and refined it against real content on every migration run. Partway through migration, QA caught industry and application pages consistently rendering a "glass" hero variant instead of the default one. The root cause: the AI-drafted mapping sheet contained a rule stating hero variants for those post types should *always* use the glass effect — a plausible-sounding instruction that had no basis in the actual Sitecore data or client requirement. It was a hallucination baked into what looked like a legitimate field note.

The fix was procedural as much as technical: the team stopped treating the mapping sheet as a fixed spec and instead re-verified and revised it on *every* migration pass against the live site, rather than trusting it once and reusing it. It's a pattern worth calling out explicitly for any migration that leans on AI-assisted mapping — the tooling accelerates the work, but the source of truth stays the legacy system, not the sheet describing it.

### 2. A migration pass that was quietly reading from the wrong environment

Midway through migration, the team noticed several pages missing YouTube embeds that were clearly present in the exported data. Investigation traced it to the GraphQL credentials used for extraction — they resolved to Sasol's **development** Sitecore instance, not production, so an entire pass had silently migrated dev content believing it was live content. Once identified, the extraction was pointed at the correct production context and re-run, and a lightweight verification script was added to cross-check migrated output against the live frontend on subsequent passes, rather than relying on visual QA alone to catch environment drift.

### 3. Trading manual curation for automated content, deliberately

Sitecore's Applications and Products lists were hand-curated by editors — specific items, in a specific order, sometimes deliberately excluding entries that would otherwise qualify. Rebuilding these as an automatic CPT/taxonomy query (the new Feature Cards block) meant the output would no longer exactly match the legacy site: all qualifying items would appear, in query order, not the editor's curated subset. Rather than quietly shipping a behavior change, the team flagged the tradeoff to the client explicitly, agreed to proceed with automatic queries for long-term maintainability, and set up a sync-up path to review any cases where the automated output diverged meaningfully from what editors expected to see live.

### 4. Building enterprise SSO across three environments without weakening it anywhere

The client's security requirement was strict: Microsoft Entra ID (Azure AD) SAML 2.0 SSO for both the WordPress admin and the WP VIP dashboard, replicated identically across Development, Pre-Production and Production, with WordPress's native login disabled outright rather than left as a fallback. That single requirement fanned out into a cluster of interdependent pieces: a custom login screen, Entra ID role mapping into WordPress roles, enforced single-concurrent-session, configurable session timeouts, and authentication-attempt logging — each of which had to work identically in all three environments or the weakest one would become the actual attack surface.

The team evaluated buying versus building parts of this (assessing miniOrange's enterprise SSO plan, including its session-management and login-audit add-ons, against a custom implementation) and made the build-vs-buy call per capability rather than all-or-nothing, based on what needed to be tightly integrated with the site's own role logic versus what a proven third-party plugin already handled well. Admin access itself was further locked down behind a VPN and IP allowlisting per environment, layered on top of SSO rather than instead of it.

### 5. Re-engineering the translation workflow around new editorial roles, mid-project

Late in the build, the client introduced two new editorial roles — Content Contributor (can create/edit, cannot publish) and Content Publisher (can also publish and delete any page) — layered on top of the multilingual setup (Polylang Pro with DeepL machine translation for German and Simplified Chinese). That combination raised a genuinely non-obvious question: *when* should automatic translation fire, given that a Contributor's edits to an already-published page can't go live without a Publisher's review?

The team worked through the scenarios explicitly with the client rather than guessing at "reasonable" defaults: automatic translation now fires only the *first* time a page is published; every subsequent update — whether made by a Contributor (which forces the page to draft pending review) or a Publisher (which doesn't) — requires an explicit "Initiate Translations" action before it can be republished. That deliberately breaks full automation in favor of giving a human a checkpoint before translated content goes live, which was the actual client priority once the roles were introduced.

### 6. Catching a staging-domain leak on launch day itself

Hours after go-live, the client reported missing featured images on a live event page. The root cause was a gap in the production database search-and-replace: a handful of image and settings references — including the site's admin email and general-settings site title — were still pointing at the pre-launch `go-vip.net` staging domain instead of `chemicals.sasol.com`. The team traced, fixed and verified the URL rewrite within the hour, then proactively audited the same class of settings site-wide (site title, admin email, remaining media references) rather than waiting for the client to find the next instance — turning a single reported bug into a full sweep.

## Tech Stack

- **Platform:** WordPress VIP
- **Theme:** Custom Full Site Editing (FSE) block theme, Tailwind CSS
- **Content model:** Custom post types (Applications, Products, Formulations, Events, Press Releases) and taxonomies (Industry, Application Type), 30+ purpose-built Gutenberg blocks
- **Multilingual:** Polylang Pro + DeepL API (English, German, Simplified Chinese)
- **Identity & security:** Microsoft Entra ID (SAML 2.0) SSO, custom login flow, role mapping, session controls, auth-attempt logging
- **Forms:** Gravity Forms integrated with an Azure Function endpoint
- **Migration:** Custom GraphQL-based extraction from Sitecore's Layout Service, AI-assisted field mapping with human verification, iterative reconciliation passes
- **Quality:** Core Web Vitals testing, accessibility compliance testing, structured client UAT tracking

## How the Team Worked

Delivery was run with daily async standups (what shipped, what's next, blockers on both sides), a shared, color-coded UAT/QA sheet the client could triage directly, and every unit of work — from a single Gutenberg block to the SSO rollout — tracked as its own GitHub issue against a public milestone. That structure is what made a project with this many moving, interdependent parts (migration, security, multilingual, dozens of blocks) auditable in real time rather than only in retrospect.

## Result

Sasol Chemicals now runs on a modern, editor-friendly WordPress VIP platform: a component library that mirrors how the marketing team actually thinks about the page instead of a legacy page-builder, enterprise SSO that meets the client's security bar in every environment, and a multilingual publishing workflow editors can run themselves — with automatic machine translation as a starting point, not an unreviewed shortcut. The migration preserved the site's content fidelity through an auditable, AI-assisted-but-human-verified pipeline, and the team's post-launch monitoring caught and closed out the last staging-domain references within hours of going live.

> *Client testimonial to be added.*

---
*Case study prepared by the rtCamp project team based on project delivery records (GitHub issue tracker, Slack `#proj-sasol-chemicals`) as of August 2026.*
