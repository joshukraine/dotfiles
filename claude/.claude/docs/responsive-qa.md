# Browser & Responsive QA

How to verify a layout at a mobile breakpoint so the result is actually trustworthy. Read this **before** checking any layout at a mobile width through a browser-automation MCP.

Extracted from the global `CLAUDE.md` in Phase 1 of joshukraine/dotfiles#252. The global file keeps a short trigger pointing here; the body lives at this path because it is irrelevant in most sessions and load-bearing in a few.

## The core rule

**Verify mobile/responsive widths by emulating the CSS viewport, never by resizing the OS window.**

When checking a layout at a mobile breakpoint (e.g. the common 375px), use the device-emulation tool — `emulate` in the chrome-devtools MCP, with a viewport like `375x812x3,mobile,touch` — not a window-resize tool (`resize_page`, `resize_window`).

**A window-resize tool reports success without moving the CSS viewport.** Observed 2026-07-28 with Claude in Chrome's `resize_window` on euroteamoutreach.org: it returned `Successfully resized window ... to 375x812`, while `window.innerWidth` stayed at **2315** and the `sm:` breakpoint remained active.

The failure is silent in the worst way — **the overflow check then _passes_**, because a desktop-width layout has no horizontal overflow. You get a green result that means nothing.

> An earlier version of this note said Chrome clamps to a ~500px minimum. It may clamp on some setups; it may also ignore the resize entirely. Either way the viewport is not what you asked for, so **never infer the width from the tool's return value.**

## Always confirm the viewport actually took

A screenshot alone does not prove the width. After emulating, assert via the page-eval tool that:

1. `window.innerWidth` equals the target width, **and**
2. `document.documentElement.scrollWidth <= window.innerWidth` (the horizontal-overflow check)

**`innerWidth` is the load-bearing half.** The `scrollWidth <= innerWidth` comparison passes trivially at the wrong width, so it is only evidence once the width itself is confirmed. Check them in that order and report both.

## `emulate` missing? The chrome-devtools MCP is project-scoped, not global

It comes from a checked-in `.mcp.json` at the repo root (`chrome-devtools-mcp`, run with `--isolated` so it never touches the real browser session).

Claude in Chrome is a separate, complementary server: it drives the real logged-in session but has **no viewport emulation, no Lighthouse, and no performance traces**.

If a repo lacks `.mcp.json`, copy it from `ofreport.com-hugo`, `comix_distro`, or `euroteamoutreach.org-hugo` and restart Claude Code. **Do not fall back to `resize_window`.** Full rationale: `comix_distro/docs/chrome-devtools-mcp.md`.

## Fallback: a same-origin iframe is a real CSS viewport

When emulation genuinely isn't available, an iframe at the target width gives the inner document a true viewport that media queries evaluate against. Assert `innerWidth` and `scrollWidth` **inside** the iframe.

Caveat: this fails on any site sending `X-Frame-Options: DENY` — which the Netlify sites do. So it works against a local dev server but **not** against a deploy preview.

## Fallback: Puppeteer against the installed Chrome

When the repo has no `.mcp.json` and an iframe won't do (or you need to script many widths), drive the locally installed Chrome with `puppeteer-core`. `page.setViewport({ width: 375, height: 812, deviceScaleFactor: 2, isMobile: true, hasTouch: true })` is real CSS-viewport emulation, unlike `resize_window`. The same two assertions still apply: read `window.innerWidth` back, then check `scrollWidth`. First used 2026-11-23 on joshukraine.github.io#4.

Setup lives in the session scratchpad, never the project: `npm i puppeteer-core` there, then `puppeteer.launch({ executablePath: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' })`. No browser download is needed.

### Proving a style refactor changed nothing

For a refactor that must not change what renders (swapping a CSS framework for plain CSS, consolidating rules), compare **computed styles and geometry**, not just screenshots:

1. Copy the pre-change page into the scratchpad and serve old and new on two local ports.
2. At each target width, walk every element under `body` in document order. Record `getBoundingClientRect()` and a fixed list of `getComputedStyle()` properties (font, size, weight, line-height, color, margins, padding, borders, display, grid/gap).
3. Diff old against new element by element. Also take full-page screenshots and pixel-compare them (`compare -metric AE -fuzz 2%` from ImageMagick).
4. Drive any interactive state (open a dialog, press keys) and diff that state too.

Why both: screenshots miss differences that don't paint _yet_. On #4, a `<button>` lost its inherited font (it fell back to Arial 13px). The pixels were identical because the button held only an icon, and the computed-style diff was the only thing that caught it. Expect harmless noise to filter out: `border-style` on zero-width borders, `box-sizing` on elements with no padding or border, and the same color serialized as `oklab()` vs `rgba()`.
