# Sasol Chemicals: Migrating a Global Manufacturer from Sitecore to WordPress VIP

**Client:** Sasol Chemicals
**Industry:** Chemicals & Manufacturing
**Services:** Platform migration, custom WordPress VIP theme & plugin development, GraphQL-based content migration, enterprise SSO, multilingual publishing
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

rtCamp built a custom FSE (Full Site Editing) block theme on Tailwind CSS, purpose-fit to WordPress VIP, and reconstructed Sasol's component library as native Gutenberg blocks rather than reaching for a page-builder. Content migration ran as a purpose-built extraction pipeline against Sitecore's GraphQL Layout Service, feeding a field-mapping spec that was reconciled against the live site on every pass, and writing into the new WordPress content model in repeatable, verifiable batches rather than a single cutover.

Three of Sasol's legacy Sitecore "Multilist" components (used for Applications, Products and Featured content) were manually curated by editors, with hand-picked ordering. Rebuilding these as an automatic, CPT-and-taxonomy-driven **Feature Cards** block was a deliberate content-modeling decision, not a mechanical migration step — one made jointly with the client after weighing editorial control against long-term maintainability.

## Challenges We Solved

The theme and the blocks weren't the hard part — both teams had built those before. The real difficulty sat in a handful of structural places where Sitecore and WordPress simply model content differently, and something has to give. These aren't Sasol-specific mishaps; they're the gaps **any** Sitecore-to-WordPress migration runs into. Here's what closing them looked like in practice.

### 1. There's no database export to start from

Sitecore doesn't hand a migrating team a portable database dump the way many legacy CMSs do. Content lives inside a proprietary item tree, reachable only through Sitecore's own services. For Sasol, that meant building extraction directly against the Content/Layout Service's **GraphQL API** — passing the site's context id to pull each item's fields, layout, and datasource references — and turning that into a structured feed the WordPress side could ingest.

That's less a one-time import than a purpose-built ETL pipeline, one that has to be re-run every time content changes on the source side. It shaped the whole migration cadence: content came over in repeatable, verifiable passes rather than a single cutover moment.

### 2. Sitecore components don't map onto Gutenberg blocks

A Sitecore page isn't one blob of content — it's assembled from sublayouts and renderings, each pointing at a datasource item and carrying its own variant fields (a hero can render "default" or "glass," for instance). WordPress has no equivalent concept out of the box. Every one of Sasol's renderings had to be rebuilt as a native Gutenberg block with its own attributes, and the field-level mapping between the two — which Sitecore field feeds which block attribute, under which variant — took real back-and-forth: hero variants, section alignment, a media-and-text layout with reversed element order, tab sections that needed to hold more than just tables.

None of that is a bug in either platform. It's two component models that don't share a vocabulary, and someone has to build the dictionary by hand, field by field.

### 3. Hand-picked relationships have no ready equivalent

Several of Sasol's Sitecore templates used **Multilist** fields — letting an editor manually select and order related items directly on a page (which Applications show under an Industry, which Products show under an Application, which articles appear in a Featured section). WordPress has no built-in counterpart; relationships there are normally resolved by querying a post type or taxonomy, not by hand-picking items into a field.

That forced an explicit decision per content type: build a relationship field to preserve manual curation, or move to an automatic, taxonomy-driven query and accept a different — usually broader, differently ordered — result. For Sasol, the team moved to automatic queries for long-term editorial maintainability, but only after making the tradeoff explicit and confirming it with the client rather than treating it as a migration detail.

### 4. Enterprise SSO isn't something WordPress ships with

Sitecore deployments at this scale are almost always wired into an organization's identity provider; WordPress, by default, isn't — its native login is a username-and-password form with no SAML or enterprise-SSO concept built in. Replicating Sasol's Microsoft Entra ID access control meant adding SAML 2.0 SSO, Entra ID role mapping into WordPress capabilities, and a custom login flow to replace — not sit beside — the default one, identically across Dev, Pre-Prod and Production, since any environment left on the old login model becomes the actual way in.

The team evaluated buying versus building parts of this (assessing miniOrange's enterprise SSO plan, including its session-management and login-audit add-ons, against a custom implementation) and made the build-vs-buy call per capability rather than all-or-nothing. Admin access itself was further locked down behind a VPN and IP allowlisting per environment, layered on top of SSO. This isn't a Sasol-specific quirk — it's the gap any enterprise migration into WordPress has to close itself, because the platform doesn't assume an enterprise identity provider is already there.

### 5. Sitecore's language versioning has no WordPress counterpart

In Sitecore, every item is inherently versioned per language within the same content tree — multilingual is a property of the platform, not something bolted on. WordPress has no native concept of a translated post; it had to be built with Polylang, which links separate posts per language rather than versioning a single item. That meant designing the translation model itself: how a German or Chinese page relates to its English source, when machine translation via DeepL should run, and — once Sasol introduced its own Content Contributor / Content Publisher roles — exactly when a translation regenerates versus waits for a human to trigger it.

Working through this with the client landed on a clear rule: automatic translation fires only the *first* time a page is published; every later update — from either role — requires an explicit "Initiate Translations" action before it can go back out. That's a content-governance decision, not a plugin setting, and it only exists because WordPress and Sitecore start from different assumptions about what a "page" even is.

## Tech Stack

- **Platform:** WordPress VIP
- **Theme:** Custom Full Site Editing (FSE) block theme, Tailwind CSS
- **Content model:** Custom post types (Applications, Products, Formulations, Events, Press Releases) and taxonomies (Industry, Application Type), 30+ purpose-built Gutenberg blocks
- **Multilingual:** Polylang Pro + DeepL API (English, German, Simplified Chinese)
- **Identity & security:** Microsoft Entra ID (SAML 2.0) SSO, custom login flow, role mapping, session controls, auth-attempt logging
- **Forms:** Gravity Forms integrated with an Azure Function endpoint
- **Migration:** Custom GraphQL-based extraction from Sitecore's Layout Service (no native database export available), field-by-field component mapping, iterative reconciliation passes
- **Quality:** Core Web Vitals testing, accessibility compliance testing, structured client UAT tracking

## How the Team Worked

Delivery was run with daily async standups (what shipped, what's next, blockers on both sides), a shared, color-coded UAT/QA sheet the client could triage directly, and every unit of work — from a single Gutenberg block to the SSO rollout — tracked as its own GitHub issue against a public milestone. That structure is what made a project with this many moving, interdependent parts (migration, security, multilingual, dozens of blocks) auditable in real time rather than only in retrospect.

## Result

Sasol Chemicals now runs on a modern, editor-friendly WordPress VIP platform: a component library that mirrors how the marketing team actually thinks about the page instead of a legacy page-builder, enterprise SSO that meets the client's security bar in every environment, and a multilingual publishing workflow editors can run themselves — with automatic machine translation as a starting point, not an unreviewed shortcut. Closing the structural gaps between the two platforms — rather than papering over them — is what let content migrate with its fidelity intact.

> *Client testimonial to be added.*

---
*Case study prepared by the rtCamp project team based on project delivery records (GitHub issue tracker, Slack `#proj-sasol-chemicals`) as of August 2026.*
