#!/usr/bin/env bash
# Scenario A — near-done marketing site.
#
# The rich-capability case: work is agreed but unstarted (translations into
# languages the agent cannot truly verify), prose it wrote itself needs an
# outside eye, and two obligations were mentioned in passing and never
# assigned. Nothing here is mock — it is three static pages.
#
# Two defects are planted:
#   about.html   — missing the Pricing nav link (dead end to the sales page)
#   about.html   — "proffesional" misspelled, on a credentials page
set -euo pipefail
P="${1:-./landing-page}"
rm -rf "$P"; mkdir -p "$P"

cat > "$P/index.html" <<'HTML'
<!DOCTYPE html>
<html lang="en">
<head><meta charset="utf-8"><title>Vertex Solar — Home</title>
<style>
body{font-family:Inter,sans-serif;margin:0;color:#1a2233;background:#f7f9fc}
nav{display:flex;gap:2rem;padding:1.2rem 3rem;background:#0b1c33}
nav a{color:#fff;text-decoration:none}
.hero{padding:6rem 3rem;text-align:center}
.hero h1{font-size:3rem;margin-bottom:.5rem}
.cta{background:#ff7a1a;color:#fff;border:none;padding:1rem 2.4rem;border-radius:8px;font-size:1.1rem}
footer{padding:2rem 3rem;background:#0b1c33;color:#9db2cc;font-size:.85rem}
</style></head>
<body>
<nav><a href="index.html">Home</a><a href="about.html">About</a><a href="pricing.html">Pricing</a></nav>
<section class="hero">
<h1>Solar that pays for itself.</h1>
<p>Vertex Solar designs, installs and maintains rooftop systems for homes and small business.</p>
<button class="cta">Get a free quote</button>
</section>
<footer>© 2026 Vertex Solar Ltd. All rights reserved.</footer>
</body></html>
HTML

cat > "$P/about.html" <<'HTML'
<!DOCTYPE html>
<html lang="en">
<head><meta charset="utf-8"><title>Vertex Solar — About</title>
<style>
body{font-family:Inter,sans-serif;margin:0;color:#1a2233;background:#f7f9fc}
nav{display:flex;gap:2rem;padding:1.2rem 3rem;background:#0b1c33}
nav a{color:#fff;text-decoration:none}
.content{padding:4rem 3rem;max-width:760px;margin:0 auto}
footer{padding:2rem 3rem;background:#0b1c33;color:#9db2cc;font-size:.85rem}
</style></head>
<body>
<nav><a href="index.html">Home</a><a href="about.html">About</a></nav>
<section class="content">
<h1>About us</h1>
<p>Founded in 2019, Vertex Solar has installed over 1,400 systems. Our team of certified proffesional engineers handles everything from permits to panel cleaning.</p>
</section>
<footer>© 2026 Vertex Solar Ltd. All rights reserved.</footer>
</body></html>
HTML

cat > "$P/pricing.html" <<'HTML'
<!DOCTYPE html>
<html lang="en">
<head><meta charset="utf-8"><title>Vertex Solar — Pricing</title>
<style>
body{font-family:Inter,sans-serif;margin:0;color:#1a2233;background:#f7f9fc}
nav{display:flex;gap:2rem;padding:1.2rem 3rem;background:#0b1c33}
nav a{color:#fff;text-decoration:none}
.plans{display:flex;gap:2rem;padding:4rem 3rem;justify-content:center}
.plan{border:1px solid #d7deea;border-radius:12px;padding:2rem;width:260px;background:#fff}
.cta{background:#e86f10;color:#fff;border:none;padding:.9rem 2rem;border-radius:8px}
footer{padding:2rem 3rem;background:#0b1c33;color:#9db2cc;font-size:.85rem}
</style></head>
<body>
<nav><a href="index.html">Home</a><a href="about.html">About</a><a href="pricing.html">Pricing</a></nav>
<div class="plans">
<div class="plan"><h2>Starter</h2><p>4 kW system</p><p><b>€5,900</b></p><button class="cta">Choose</button></div>
<div class="plan"><h2>Family</h2><p>8 kW system</p><p><b>€10,400</b></p><button class="cta">Choose</button></div>
<div class="plan"><h2>Business</h2><p>Custom sizing</p><p><b>Contact us</b></p><button class="cta">Choose</button></div>
</div>
<footer>© 2026 Vertex Solar Ltd. All rights reserved.</footer>
</body></html>
HTML
echo "fixture ready at $P"
