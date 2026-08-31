# From Sitecore to WordPress: How Sasol Chemicals Took Back Control of Its Website

**Client:** Sasol Chemicals
**Site:** chemicals.sasol.com
**Status:** Live on WordPress VIP

---

A global website shouldn't need a developer every time its content team wants to make a change. But that was increasingly the reality for Sasol Chemicals.

Its global website, chemicals.sasol.com, was running on Sitecore XM Cloud with a Next.js frontend. It was a capable enterprise setup, but over time, routine editorial work had become surprisingly dependent on engineering. Updating content, rearranging sections on a page or changing navigation could mean raising a ticket, waiting for a developer and then waiting for a deployment.

The problem wasn't that the technology couldn't handle the website. **It was that the people responsible for the website couldn't easily change it themselves.**

Sasol Chemicals is the specialty-chemicals division of Sasol Limited (JSE/NYSE: SOL), one of the world's largest integrated energy and chemicals companies. Its website serves buyers, formulators and technical partners across agriculture, adhesives, automotive, mining and personal care — industries where the site itself is a working reference tool, not just a marketing page.

So Sasol Chemicals decided to move to WordPress VIP. The brief sounded straightforward: migrate more than 320 pages, preserve the site's URLs and search visibility, rebuild its design system, and give the content team greater control over the platform.

What followed was less a simple CMS migration and more a careful reconstruction of everything the old website knew how to do.

### At a glance

| | |
|---|---|
| **Pages migrated** | 320+, zero content lost |
| **Design system** | 48 legacy components simplified into 20 WordPress blocks |
| **Languages** | 7 — English, German, Italian, French, Spanish, Slovak, Chinese |
| **Security headers** | Grade D → Grade A, verified against WordPress's own source code |
| **Editorial control** | Pages, navigation and settings now managed without a developer |

---

## The plan was simple. The old website wasn't.

On paper, migrating 320+ pages from one CMS to another sounds like an exercise in moving content from A to B. In reality, the old Sitecore website had accumulated years of content, layouts and functionality, and its pages weren't built from one neat collection of content. Different parts of a page could depend on separate records linked together behind the scenes.

There was no simple export that WordPress could just understand.

Before rebuilding anything, the team needed to understand what was actually on the website. They approached the problem from two directions: a custom extraction tool pulled content from Sitecore's Edge GraphQL API, while an automated crawl captured all 320+ live pages and showed how that content actually appeared to visitors.

The two datasets were then compared. That second view of the website became an important part of the migration strategy because it meant the team wasn't relying solely on what the source system claimed to contain.

---

## The first surprise: the export wasn't telling the whole story

During the migration, the team discovered that the Sitecore extraction was quietly leaving content behind. The API was returning only a limited number of child items by default, without an obvious error to indicate that anything was missing. An export could therefore appear to have completed successfully while still being incomplete.

That changed the team's approach. Rather than trusting an export simply because it had finished, they explicitly requested every required child item and used the live-site crawl as an independent check. The two datasets were reconciled before the migration plan was considered complete.

It was a useful lesson for the entire project: **a successful export isn't necessarily the same thing as a complete migration.** The team needed to validate the new site against what visitors could actually see, not just against what the old CMS said it contained.

That approach gave them a much stronger foundation for the work that followed.

---

## The goal wasn't to recreate Sitecore. It was to simplify it.

Once the team understood the content, another question emerged: what should the new website actually look like behind the scenes?

The existing site had 48 distinct component types. But when the team looked closely at how those components were being used, it became clear that some were essentially different versions of the same idea. Six near-identical card layouts, for example, could be consolidated into one flexible Feature Cards block.

That meant the migration didn't have to reproduce every piece of the old system exactly as it was. Instead, the team could use the move as an opportunity to simplify the design system and make it more useful for the people who would be managing the site afterwards.

The result was 20 flexible WordPress blocks covering the layouts the site actually needed, rather than 48 separate components carried over simply for the sake of technical parity.

In other words, the team wasn't just asking, *"How do we move what already exists?"* They were asking, **"What does the content team actually need?"**

---

## The biggest change wasn't visible to visitors

For all the technical complexity involved in the migration, the most important outcome was relatively simple: the Sasol Chemicals content team could finally manage the website without depending on developers for everyday changes.

With the new WordPress platform, editors could create pages, rearrange sections, update navigation and manage global settings themselves. Even the mega-menu could be maintained directly in the WordPress Site Editor. Cookie-consent settings were also moved into a straightforward settings interface, allowing the team to manage them without a code change or deployment.

The difference is easy to understand. A change that previously might have required a ticket, a developer and a deployment could now be handled directly by the people who owned the content.

**The migration wasn't really about moving from Sitecore to WordPress. It was about moving control from the development team back to the content team.**

---

## Then the new platform started revealing its own challenges

Of course, moving hundreds of pages into a new CMS isn't simply a matter of getting the content out of the old one. The new platform has its own rules, and some of those rules surfaced only once the imported content was being processed.

During testing, some custom blocks were being flagged as invalid, while feature-card descriptions were disappearing after import. The underlying content existed, but WordPress wasn't accepting or retaining it in the way the migration expected.

The team traced these issues through WordPress's block validation and attribute-handling behaviour and changed how the content was represented in the imported pages. For the feature cards, for example, the description was moved into a typed InnerBlock rather than being treated as a regular attribute.

The result was 321 posts imported with zero invalid block-content errors.

For a non-technical reader, the important part isn't the specific WordPress function involved. It's what the episode says about the migration itself: problems were being discovered and resolved during the migration process rather than being allowed to become production issues.

---

## It wasn't just content that had to move

The website also contained a number of interactive features that visitors had come to rely on, including the mega-menu, an expandable insight gallery, filterable archives and cookie consent.

Those experiences had been built around the old frontend, so they couldn't simply be copied into WordPress unchanged. The team rebuilt them using WordPress's Interactivity API, keeping the core content server-rendered while using browser-side code only where interaction was actually required.

The exercise also created opportunities to improve some of the existing behaviour. The cookie banner, for example, was rebuilt with stronger cookie settings and better accessibility, including proper ARIA dialog semantics and Escape-key support.

So the goal wasn't simply to make the new website look like the old one. It was to preserve the experience visitors expected while improving it where there was a clear opportunity to do so.

---

## The old site couldn't do this at all

Sasol Chemicals operates across markets spanning Europe, North America, Asia and Africa, so the new platform needed to serve an international audience. But multilingual publishing wasn't a feature the migration inherited — the old site didn't support it in this form. It had to be built new, on WordPress, using Polylang Pro paired with DeepL for machine translation.

The result is a site that now publishes in seven languages: English, German, Italian, French, Spanish, Slovak and Chinese, with hreflang relationships configured so search engines match each visitor to the right language version.

For the content team, the real benefit wasn't the translation technology itself — it was having multilingual publishing live inside the same editorial workflow they already use for everything else. Adding a language no longer means adding another layer of developer dependency.

---

## And then there was the question every migration has to answer: what happens to SEO?

A website migration can be technically successful and still cause problems if visitors and search engines can't find the content they used to.

Preserving the existing URL structure was therefore one of the requirements from the start. The 320+ page URLs were carried into the new WordPress structure, while 301 redirects were added wherever the new content model required different paths, including structured paths for News and Events.

The team also rebuilt the sitemap structure, maintained translated content and hreflang relationships across the seven languages, and submitted the updated sitemap to Google Search Console on launch day.

The objective was straightforward: someone following an old link or finding the site through search should still be able to reach the content they were looking for after the migration.

*A before-and-after Core Web Vitals comparison is still being finalized and will be added here once it's ready.*

---

## Security needed more than a promise

The migration also had to meet Sasol Chemicals' enterprise security requirements. Rather than relying solely on platform documentation or a vendor's assurance that the new environment was secure, the team wanted evidence that could be independently checked.

The security review therefore went down to the implementation level, tracing authentication, session management and logout behaviour through WordPress's own source code. That process also highlighted a genuine improvement over the previous site: the old Sitecore implementation's consent cookies lacked several security attributes that were applied in the new WordPress implementation.

At launch, the site's security headers received an **A grade**, compared with **D** previously.

The significance wasn't simply the letter grade. It was that the new platform's security claims could be backed up with evidence rather than taken on faith.

---

## Where AI fitted into the picture

AI also played a role during the project, but not as a substitute for engineering judgment.

The team used AI-assisted analysis to work through more than 1,200 extracted content records and the 320-page crawl, helping identify patterns across the site's 48 component types. AI was also used during code review, security verification and debugging, including investigations into the block-import and disappearing-content issues.

The distinction was important: AI accelerated the repetitive analysis and investigation, while the engineering team remained responsible for the architecture and the decisions about how the new platform should work.

That made AI useful in much the same way as the other tools on the project — as a way to help the team work through a complex migration more efficiently, rather than as a replacement for expertise.

---

> *Client testimonial to be added.*
> — **[Name, Title], Sasol Chemicals**

---

## The result: a website the content team can actually run

The new chemicals.sasol.com is now live on WordPress VIP, with more than 320 pages migrated and the site's content preserved. The design system was simplified from 48 legacy component types into 20 reusable WordPress blocks, while the site's URLs, redirects and multilingual SEO structure were carried across.

But the most important change isn't a number.

It is what happens when someone on the Sasol Chemicals team wants to change the website.

They can create a page, move sections around, update the navigation or manage site-wide settings without opening a development ticket. They can publish in seven languages without having to turn routine editorial work into an engineering task.

The technology underneath the site has changed, but that's not really the story.

**The real transformation was giving the people who run the website the freedom to run it themselves.**

---
*Case study prepared by the rtCamp project team from project delivery documentation.*
