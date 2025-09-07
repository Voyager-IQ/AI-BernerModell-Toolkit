# Security Policy

## Meldung von Schwachstellen
Bitte Schwachstellen **vertraulich** an folgende Adresse melden:  
📧 security@voyageriq.de

Wir bestätigen innerhalb von **3 Werktagen** und koordinieren eine Lösung oder ein Fix-Release.

## Client-seitige API-Keys
⚠️ Hinweis: In diesem Projekt werden API-Keys client-seitig abgefragt.  
Das bedeutet, dass Schlüssel **öffentlich einsehbar** sind. Bitte niemals produktive oder sensible Keys hier einsetzen.

Empfehlung für Produktion:
- Nutzung eines **Proxys** (z. B. Cloudflare Worker oder FastAPI), der den Key serverseitig injiziert.
- Rate-Limiting & Domain-Restriktionen aktivieren.

## Responsible Disclosure
- Keine Bug-Bounty.  
- Responsible Disclosure wird ausdrücklich begrüßt.  
