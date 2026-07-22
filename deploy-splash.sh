#!/usr/bin/env bash
#
# deploy-splash.sh — front a subdomain repo with its Assure module launch banner.
# Same moves as the main getamazednow.ai repo:
#   1. park the existing index.html as site-wip.html (redirect to / + noindex)
#   2. write the branded banner as index.html  (Assure <Module>, module italic)
#   3. lock down crawling (robots.txt = Disallow: /)
#   4. stage + commit  (you review, then push)
#
# USAGE — copy this file into a subdomain repo root, then run with the module:
#   bash deploy-splash.sh Observe     # in the observability repo
#   bash deploy-splash.sh Govern      # in the adsra repo
#   bash deploy-splash.sh Architect   # in the mesh repo
#   bash deploy-splash.sh Skills      # in the skills repo

set -euo pipefail
cd "$(dirname "$0")"

MODULE="${1:-}"
case "$MODULE" in
  Observe)
    LEAD="A reference dashboard for observing agentic GenAI in production — cost, reliability, security and responsible-AI risk correlated by trace across seven Datadog views." ;;
  Govern)
    LEAD="The governance plane, built on the Australian Digital Sovereignty Reference Architecture (ADSRA) — seven sovereignty pillars, a six-level maturity model and measurable KRIs a Risk Committee can govern." ;;
  Architect)
    LEAD="A multi-cadence EA agent mesh that runs enterprise architecture as a continuously operating practice — five clock speeds, twelve living artefacts, thirteen agents, one orchestrator." ;;
  Skills)
    LEAD="A library of Claude skills — capability mapping, brand automation and more — packaged as an installable plugin marketplace for Cowork and Claude Code. The build layer beneath the Observe, Govern and Architect planes." ;;
  *)
    echo "Usage: bash deploy-splash.sh {Observe|Govern|Architect|Skills}"; exit 1 ;;
esac
TAGLINE="See it. Prove it. Stand behind it."
MODULE_UC="$(printf '%s' "$MODULE" | tr '[:lower:]' '[:upper:]')"

if [ ! -f index.html ]; then
  echo "No index.html here — run this from the subdomain repo root."; exit 1
fi
if grep -q 'class="product"' index.html 2>/dev/null; then
  echo "index.html already looks like a banner — aborting to avoid double-parking."; exit 1
fi

# 1 ─ Park the existing site as site-wip.html with a redirect + noindex ────────
mv index.html site-wip.html
cat > .gan-redirect.html <<'REDIR'
  <!-- WORK IN PROGRESS — not for public serving. Redirects to the front door.
       To preview locally, comment out the meta refresh + redirect script below. -->
  <meta name="robots" content="noindex, nofollow" />
  <meta http-equiv="refresh" content="0; url=/" />
  <script>if(location.hostname!=="localhost"&&location.hostname!=="127.0.0.1"){location.replace("/");}</script>
REDIR
sed "/<head/r .gan-redirect.html" site-wip.html > site-wip.tmp
mv site-wip.tmp site-wip.html
rm -f .gan-redirect.html

# 2 ─ Write the branded banner as the new index.html ──────────────────────────
cat > index.html <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Assure ${MODULE} — Launching soon · Getamazednow AI</title>
<meta name="description" content="Assure ${MODULE} — ${TAGLINE} Launching soon." />
<meta name="robots" content="noindex, nofollow" />
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500&family=Poppins:wght@500;600;700;800&display=swap" rel="stylesheet" />
<style>
:root{
--ink:#2A363B;--ink-2:#1F282C;--signal:#5FA8CC;--deep:#2E7DA6;--core:#8FC3DE;--stone:#A8A17B;
--n300:#B7BEC2;--disp:'Poppins',sans-serif;--body:'Inter',sans-serif;
}
*{box-sizing:border-box;margin:0}
html,body{height:100%}
body{font-family:var(--body);background:var(--ink);color:#fff;min-height:100vh;display:flex;flex-direction:column}
.stage{flex:1;display:flex;align-items:stretch;border-top:3px solid var(--signal)}
.split{display:flex;flex:1;min-height:100%}
.left{flex:0 0 48%;background:var(--ink-2);border-right:1px solid rgba(95,168,204,.28);display:flex;flex-direction:column;align-items:center;justify-content:center;padding:40px;text-align:center}
.left .badge{width:min(82%,380px);height:auto}
.left .company{font-family:var(--disp);font-weight:700;font-size:clamp(2rem,3.8vw,3rem);line-height:1.02;margin-top:20px}
.left .company .sig{color:var(--signal)}
.right{flex:1;display:flex;flex-direction:column;justify-content:center;padding:56px clamp(28px,5vw,72px)}
.byline{color:var(--stone);font-size:.74rem;letter-spacing:.18em;font-weight:500}
.product{font-family:var(--disp);font-weight:800;line-height:1.06;font-size:clamp(1.9rem,4vw,2.9rem);margin-top:16px}
.product .fam{color:#fff}
.product .mod{color:var(--signal);font-style:italic}
.tagline{font-family:var(--disp);font-weight:500;color:var(--core);font-size:clamp(.95rem,1.5vw,1.15rem);letter-spacing:.05em;margin-top:14px}
.rule{width:52px;height:2px;background:var(--deep);margin:26px 0}
.lead{color:var(--n300);font-size:1.02rem;line-height:1.55;max-width:460px}
.cta{margin-top:32px;display:flex;gap:14px;align-items:center;flex-wrap:wrap}
.btn{font-family:var(--disp);font-weight:600;font-size:.95rem;text-decoration:none;border-radius:8px;padding:13px 26px;transition:.15s}
.btn-sig{background:var(--signal);color:var(--ink)}
.btn-sig:hover{background:var(--core)}
.pill{display:inline-block;border-radius:999px;padding:7px 15px;font-family:var(--disp);font-weight:600;font-size:.68rem;letter-spacing:.14em;background:rgba(95,168,204,.14);border:1px solid var(--signal);color:var(--signal)}
footer{padding:16px 24px;text-align:center;font-size:.72rem;color:var(--stone);letter-spacing:.14em}
footer .sig{color:var(--signal);font-weight:700;letter-spacing:.1em}
footer em{font-style:italic}
@media (max-width:820px){
.split{flex-direction:column}
.left{flex:0 0 auto;padding:48px 28px 34px}
.left .badge{width:min(64%,300px)}
.left .company{font-size:clamp(1.8rem,7vw,2.4rem)}
.right{padding:36px 28px 46px;text-align:center;align-items:center}
.lead{max-width:none}.cta{justify-content:center}.rule{margin:22px auto}
}
</style>
</head>
<body>
<main class="stage"><div class="split">
  <section class="left">
    <svg class="badge" viewBox="128 58 184 184" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Getamazednow AI — Tensor Node Lattice">
      <circle cx="220" cy="150" r="90" fill="#2A363B" stroke="#5FA8CC" stroke-width="1.4"/>
      <line x1="220" y1="108" x2="178" y2="129" stroke="#5FA8CC" stroke-width="1.6" opacity="0.5"/>
      <line x1="220" y1="108" x2="262" y2="129" stroke="#5FA8CC" stroke-width="1.6" opacity="0.5"/>
      <line x1="178" y1="129" x2="178" y2="171" stroke="#5FA8CC" stroke-width="1.6" opacity="0.5"/>
      <line x1="262" y1="129" x2="262" y2="171" stroke="#5FA8CC" stroke-width="1.6" opacity="0.5"/>
      <line x1="178" y1="171" x2="220" y2="192" stroke="#5FA8CC" stroke-width="1.6" opacity="0.5"/>
      <line x1="262" y1="171" x2="220" y2="192" stroke="#5FA8CC" stroke-width="1.6" opacity="0.5"/>
      <line x1="178" y1="129" x2="220" y2="150" stroke="#5FA8CC" stroke-width="2.2" opacity="0.85"/>
      <line x1="262" y1="129" x2="220" y2="150" stroke="#5FA8CC" stroke-width="2.2" opacity="0.85"/>
      <line x1="220" y1="150" x2="220" y2="192" stroke="#5FA8CC" stroke-width="2.2" opacity="0.85"/>
      <line x1="220" y1="171" x2="220" y2="108" stroke="#5FA8CC" stroke-width="1.1" opacity="0.35"/>
      <line x1="220" y1="171" x2="178" y2="129" stroke="#5FA8CC" stroke-width="1.1" opacity="0.35"/>
      <line x1="220" y1="171" x2="262" y2="129" stroke="#5FA8CC" stroke-width="1.1" opacity="0.35"/>
      <line x1="220" y1="171" x2="178" y2="171" stroke="#5FA8CC" stroke-width="1.1" opacity="0.35"/>
      <line x1="220" y1="171" x2="262" y2="171" stroke="#5FA8CC" stroke-width="1.1" opacity="0.35"/>
      <line x1="220" y1="171" x2="220" y2="192" stroke="#5FA8CC" stroke-width="1.1" opacity="0.35"/>
      <circle cx="220" cy="108" r="5" fill="#5FA8CC" opacity="0.4"/>
      <circle cx="178" cy="129" r="6" fill="#5FA8CC" opacity="0.75"/>
      <circle cx="262" cy="129" r="6" fill="#5FA8CC" opacity="0.75"/>
      <circle cx="178" cy="171" r="6" fill="#5FA8CC" opacity="0.75"/>
      <circle cx="262" cy="171" r="6" fill="#5FA8CC" opacity="0.75"/>
      <circle cx="220" cy="192" r="7" fill="#5FA8CC" opacity="0.85"/>
      <circle cx="220" cy="150" r="7" fill="#5FA8CC" opacity="0.95"/>
      <circle cx="220" cy="171" r="9" fill="#8FC3DE"/>
    </svg>
    <div class="company">Getamazednow<span class="sig"> AI</span></div>
  </section>
  <section class="right">
    <div class="byline">A GETAMAZEDNOW COMPANY</div>
    <h1 class="product"><span class="fam">Assure</span> <em class="mod">${MODULE}</em></h1>
    <div class="tagline">${TAGLINE}</div>
    <div class="rule" aria-hidden="true"></div>
    <p class="lead">${LEAD}</p>
    <div class="cta">
      <a class="btn btn-sig" href="mailto:support@getamazednow.com?subject=Register%20interest%20%E2%80%94%20Assure%20${MODULE}">Register interest &rarr;</a>
      <span class="pill">LAUNCHING SOON</span>
    </div>
  </section>
</div></main>
<footer><span class="sig">ASSURE <em>${MODULE_UC}</em></span> · A GETAMAZEDNOW COMPANY</footer>
</body>
</html>
HTML

# 3 ─ Lock down crawling ──────────────────────────────────────────────────────
printf 'User-agent: *\nDisallow: /\n' > robots.txt

# 4 ─ Stage + commit (you review, then push) ──────────────────────────────────
git add -A
git commit -m "Launch banner for Assure ${MODULE}; park previous site, lock down crawling"

echo ""
echo "Done — Assure ${MODULE}. Review the diff, then push with:"
echo "    git push origin main"
