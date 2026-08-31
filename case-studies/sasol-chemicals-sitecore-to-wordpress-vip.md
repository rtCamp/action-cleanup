# Sasol Chemicals: Sitecore + Next.js to WordPress VIP

**Client:** Sasol Chemicals
**Industry:** Specialty Chemicals (a division of Sasol Limited, JSE/NYSE: SOL)
**Site:** chemicals.sasol.com
**Status:** Live on WordPress VIP

---

## The Short Version

Sasol Chemicals needed its global site off a Sitecore XM Cloud and Next.js stack that had made even small content changes dependent on developers. rtCamp rebuilt chemicals.sasol.com natively in WordPress VIP: every one of its 320+ pages migrated with nothing lost, its design system rebuilt as a block library editors can run themselves, and its security posture raised from a failing grade to a passing one.

The result: a content team that creates pages, reorders sections, and manages navigation without a developer or a deployment — on a platform whose security claims can be checked line by line against WordPress's own open-source code.

- **320+ pages migrated, nothing lost** — checked against a full crawl of the live site, not just the export
- **48 legacy components → 20 WordPress blocks** — six near-duplicate card designs alone became one flexible block
- **Security headers: Grade D → Grade A** — verified against WordPress's own source code, not a vendor's word for it
- **Editors publish in 6 languages themselves** — no developer required

*(The "Technical detail" toggles below are optional reading — everything above and around them is written for a general audience.)*

---

## About the Client

Sasol Chemicals is the specialty-chemicals division of Sasol Limited, one of the world's largest integrated energy and chemicals companies. Its site, chemicals.sasol.com, serves buyers, formulators and technical partners across agriculture, adhesives, automotive, mining and personal care, in markets spanning Europe, North America, Asia and Africa.

## The Challenge

The site ran on Sitecore XM Cloud with a Next.js frontend — a capable enterprise setup, but one where routine content changes had quietly become developer work. Updating a product description, reordering a page's sections, or adding new content usually meant working through Sitecore's data model or shipping a code change. That dependency on engineering for everyday editorial work, more than any single technical shortcoming, is what made the case for moving.

rtCamp's brief had four parts:

1. Migrate all 320+ pages without losing content
2. Preserve the existing URL structure and search rankings
3. Rebuild the design system so editors could work independently of engineering
4. Meet the client's enterprise security bar on the new platform

## The Approach: Understand the Old System Before Rebuilding It

None of that was possible without first understanding, in full, exactly how the old site stored and rendered its content — Sitecore doesn't offer an export a new platform can simply read.

So the team built its own: a custom tool that queried Sitecore's Edge GraphQL API to pull every content record out of the live environment, paired with an automated crawl of all 320+ live pages to see how that content actually rendered on screen. Together, the two gave a complete picture — **48 distinct component types**, each mapped field by field to its WordPress equivalent in a shared reference spreadsheet before a line of code was written.

## For the Content Team: Editors Run the Platform Now

The technical migration was built around a bigger goal: giving Sasol Chemicals' own team control of the platform after launch, not just of individual pages. rtCamp rebuilt the site's design system as a native WordPress block library — 20 custom blocks covering every page layout the site needs — and used the rebuild to simplify the old system, not just replicate it. Six near-identical Sitecore card layouts, for instance, became a single flexible Feature Cards block with its own controls for layout, shape, column count and content source.

Navigation, including the mega-menu, is now managed entirely inside the WordPress Site Editor — no code change or deployment needed to add, reorder or update a menu item. Cookie-consent settings, including the tracking container ID and a policy version number, live on a simple settings page; bumping that version automatically re-prompts returning visitors for consent, site-wide. By launch, the content team could create pages, update content, restructure navigation and manage global settings entirely on their own — work that used to mean a ticket, a developer and a deployment now happens the same day.

## Five Places This Got Genuinely Hard

None of the difficulty was in the page designs — it was in getting a decade of Sitecore content and behavior to survive the move into a platform that works on fundamentally different assumptions. Here's what that took, in plain terms first, with engineering detail available for anyone who wants it.

### 1. Sitecore and WordPress don't store content the same way

**Plain English:** Sitecore doesn't keep a page's content in one place — it's spread across linked records that only make sense once Sitecore itself reassembles them. There was no way to copy that structure straight into WordPress; every page had to be reconstructed, piece by piece, into something editors could actually work with.

<details>
<summary>Technical detail</summary>

Sitecore stores component content as separate datasource items linked to page renderings, so a single page with several sections can depend on several independent records in the content tree — a structure WordPress has no equivalent for. rtCamp built a mapping layer that walked each page's rendering tree, resolved every datasource reference, and converted the result into WordPress block attributes, guided by a master spreadsheet defining how all 48 Sitecore component types translated field by field into their WordPress equivalents before development began.
</details>

### 2. The extraction tool was quietly leaving content behind

**Plain English:** Partway through, the team discovered the tool pulling content out of Sitecore was silently capping how much it retrieved from each page — no error, no warning, just missing content. Catching it meant never trusting the export on its own.

<details>
<summary>Technical detail</summary>

Sitecore's Edge GraphQL API returns only 10 child items per query by default; anything beyond that is omitted without an error. Left unnoticed, that could have carried missing content straight through the migration. The extractor was rewritten to explicitly request every child item, and the parallel crawl of all 320+ live pages served as an independent check — the two datasets were reconciled against each other before migration planning was considered final.
</details>

### 3. Imported pages had to survive WordPress's own rules

**Plain English:** Moving content into WordPress isn't just copying text over — WordPress checks everything it imports against strict internal rules, and two of those rules quietly broke things: one flagged legitimate content as invalid, the other silently deleted text that should have stayed. Both took real debugging to catch before a single page went live.

<details>
<summary>Technical detail</summary>

WordPress validates imported block content against each block's registered save function; 22 of Sasol's custom blocks used client-side save functions with no PHP render callback, so the import file needed the exact serialized HTML WordPress expected, not just raw data — rtCamp's custom WXR generator pre-computed that output for all 22 blocks. Separately, feature-card descriptions were vanishing after import: WordPress core's `WP_Block_Type::prepare_attributes_for_render()` strips any attribute not registered in a block's `block.json`, silently deleting the content. The fix moved the description into a typed InnerBlock instead of a plain attribute, which survived both the import and WordPress's attribute-handling pipeline. All 321 posts imported with zero invalid block-content errors.
</details>

### 4. Interactive features had no framework left to run on

**Plain English:** Several features on the old site — the mega-menu, an expandable content gallery, the cookie banner, filterable archives — relied on a JavaScript framework doing the work in the visitor's browser. WordPress doesn't work that way by default, so those interactions had to be rebuilt on a server-rendered foundation without losing any of the original behavior.

<details>
<summary>Technical detail</summary>

rtCamp rebuilt the interactive components using the WordPress Interactivity API, with PHP handling content rendering and the Interactivity API managing only browser-side state. For the insight gallery, cards are grouped into rows server-side with one hidden expansion panel pre-rendered per row; the Interactivity API just tracks which row is open, without fetching anything extra. The mega-menu follows the same pattern — every navigation panel renders in PHP, and browser-side code only shows or hides it. The cookie banner was rebuilt with full feature parity plus real improvements: `SameSite=Lax` on consent cookies, proper ARIA dialog semantics, and Escape-key support the original didn't have.
</details>

### 5. Security compliance needed proof, not a claim

**Plain English:** The client's security requirements couldn't be satisfied by a vendor's word that something was secure — they needed evidence anyone could independently check. That meant tracing every claim back to WordPress's own publicly readable code, not a summary of it.

<details>
<summary>Technical detail</summary>

Authentication cookie handling was verified directly in WordPress core's `pluggable.php`, including the Secure flag derived from `is_ssl()` and correct HttpOnly handling. Session management was traced through `WP_Session_Tokens`, which uses 43-character random tokens stored as SHA-256 hashes in user meta, with no `session_start()` or PHPSESSID anywhere in the request lifecycle. Logout was verified through `wp_logout()`, which destroys the active session token and expires the browser's auth cookies.

The review also surfaced a real improvement over the old site: Sitecore's consent cookies, set via the js-cookie library, had no HttpOnly, Secure or SameSite attributes at all. The WordPress implementation is measurably stronger than what it replaced, not just a like-for-like copy.
</details>

## Where AI Helped

AI ran through this project as an accelerant for analysis and verification, not a replacement for engineering judgment — the team still made every architectural call, but spent far less time on repetitive groundwork to get there.

- **Faster discovery.** Sorting through 1,234 extracted content records and a 320-page live crawl by hand would have taken weeks; AI-assisted analysis found the patterns across all 48 component types in days — including the six near-duplicate card designs that became a single WordPress block.
- **Sharper planning.** More than 40 implementation tickets were drafted with AI assistance, each carrying exact field names and edge cases pulled straight from the live-site crawl — work developers could start from immediately instead of re-deriving it themselves.
- **Consistent review, on every pull request.** A custom AI review checked each change against WordPress security practices, WP VIP platform rules, accessibility and the project's own conventions, producing a report tied to exact lines of code — replacing a separate manual compliance pass.
- **Security evidence, verified faster.** AI helped trace every security claim to the exact line of WordPress core source behind it, so the compliance review was based on the real implementation, not documentation.
- **Bugs found sooner.** When 22 blocks were failing import validation, and again when feature-card content was silently disappearing, AI-assisted debugging traced both to their root cause before they reached a live import.

## SEO & Performance: No Lost Rankings, No Lost Visitors

Preserving the search visibility chemicals.sasol.com had already earned was a hard requirement, not a nice-to-have. All 320+ page URLs carried over into the new WordPress structure; where the new content model needed different paths — structured sub-paths for News and Events, for instance — 301 redirects preserved the inbound links pointing at the old ones. Yoast SEO Premium manages sitemaps across all seven content types, and Polylang manages translated content and hreflang tags across six languages: English, German, Italian, French, Spanish and Chinese. The updated sitemap went to Google Search Console on launch day.

*(Before/after Core Web Vitals report — pending.)*

## Tech Stack *(reference for technical readers)*

- **Platform:** WordPress VIP — Git-based deployments, automated PHPCS checks via the VIP Code Analysis Bot, global CDN
- **Search:** Elasticsearch-powered enterprise search, surfaced through a custom search block with Content Type and Country filters
- **Content model:** 7 custom post types, 20 purpose-built Gutenberg blocks consolidating 48 legacy component types
- **Import:** 321 posts imported via WP-CLI from a custom Node.js–generated WXR file with pre-computed block markup
- **Multilingual:** Polylang — English, German, Italian, French, Spanish, Chinese, with hreflang across all six
- **Interactivity:** WordPress Interactivity API — mega-menu, insight gallery, cookie consent, filterable archives
- **Security:** Headers independently verified via securityheaders.com — Grade A at launch, up from Grade D

## Result

chemicals.sasol.com is live on WordPress VIP, with its full content intact and its search rankings undisturbed. The team that used to wait on developers for routine changes can now make them directly — and every security and compliance claim about the new platform can be checked against WordPress's own open-source code, not taken on faith.

- **Editors work independently** — pages, navigation and global settings, no developer or deployment required
- **Every inbound link and search ranking carried through** — 320+ URLs preserved, redirects in place where paths changed
- **Security claims are independently checkable** — Grade A headers, verified against WordPress core
- **Self-service multilingual publishing** — English, German, Italian, French, Spanish and Chinese, entirely inside WordPress

> *Client testimonial to be added.*

---
*Case study prepared by the rtCamp project team from project delivery documentation.*
