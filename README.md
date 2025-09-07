# 📘 AI-BernerModell-Toolkit

Ein leichtgewichtiges, **reines HTML/Tailwind/Chart.js**-Tool zur Trainingsplanung nach dem **Berner Modell** (Hans Furrer) – speziell für IT-Trainer:innen in der Erwachsenenbildung.  
Theorie ➜ Visualisierung ➜ **KI-gestützter Assistent** (wahlweise **Google Gemini** oder **lokaler LLM** via **LM Studio / Ollama**).

--

[![Code License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Content License: CC BY 4.0](https://img.shields.io/badge/Content-CC%20BY%204.0-blue.svg)](https://creativecommons.org/licenses/by/4.0/)
![Status: Active](https://img.shields.io/badge/Status-Active-success.svg)
[![Issues](https://img.shields.io/github/issues/fakaiser/AI-BernerModell-Toolkit.svg)](https://github.com/fakaiser/AI-BernerModell-Toolkit/issues)
[![Pull Requests](https://img.shields.io/github/issues-pr/fakaiser/AI-BernerModell-Toolkit.svg)](https://github.com/fakaiser/AI-BernerModell-Toolkit/pulls)
[![Security](https://img.shields.io/badge/Security-Policy-blue)](SECURITY.md)

---

## 🚀 Features
- **Modulare Visualisierung** der 6 Faktoren (Analyse & Planung)
- **Klickkarten** mit Leitfragen & Praxistipps
- **Key-Concept-Karten**: *Morpheme*, *Driftzone*, *Kompetenzorientierung*
- **KI-Assistent**
  - *Kompetenz-Generator* (Performanz → Kompetenz → Ressourcen)
  - *Methoden-Empfehlungen* (angepasst an Dauer/Gruppengröße)
- **Radar-Chart** zur **Interdependenz**
- **Checkliste** zur strukturierten Trainingsplanung

---

## ⚡ Quickstart
1. Repo klonen oder ZIP entpacken.  
2. `index.html` im Browser öffnen – läuft sofort.  
3. (Optional) KI nutzen:
   - **Google**: API-Key in der App eingeben *(nur zu Testzwecken; siehe Sicherheit)*.  
   - **Lokal (LM Studio / Ollama)**: OpenAI-kompatible URL eintragen, z. B.  
     `http://localhost:1234/v1/chat/completions`.

> 💡 Das Tool funktioniert **offline** ohne KI. KI-Funktionen werden erst nach **Opt-in** aktiviert.

---

## 🔌 KI-Anbieter
- **Google AI Studio (Gemini)**  
  - Modelle wie *1.5 Pro* oder *2.5 Flash*.  
  - ⚠️ Client-seitige Schlüssel sind **öffentlich einsehbar** → **nicht** für produktiven Einsatz.
- **LM Studio / Ollama (lokal)**  
  - OpenAI-kompatible Schnittstelle; Daten bleiben in deinem Netzwerk.  
  - Volle Kontrolle & keine externen Abflüsse.

---

## 🔒 Sicherheit & Datenschutz
- **Keine Tracker, keine Cookies** standardmäßig.  
- **Client-seitige API-Keys gelten als öffentlich.** Für produktive Nutzung bitte einen **Proxy** einsetzen, der den Key serverseitig injiziert und nur erlaubte Endpunkte durchlässt.  
- Empfohlene Header beim Hosting: CSP, Referrer-Policy, X-Frame-Options. (Beispiel siehe `_headers` im Repo.)  

Details siehe [SECURITY.md](SECURITY.md).

---

## 🧱 Tech-Stack
| Technologie | Zweck |
| --- | --- |
| **HTML5 + TailwindCSS** | UI/Layouts |
| **Chart.js** | Radar-Diagramm |
| **Gemini / LM Studio / Ollama** | Optionale KI-Vorschläge |

---

## 📷 Screenshots
> *(Hier Screenshots oder GIFs ergänzen, z. B. Karten-UI, Radar-Chart, KI-Ausgabe.)*

---

## 🗺️ Roadmap (Ideen für V2)
- Export nach **PDF/Markdown**  
- **Profile speichern/laden**  
- Proxy-Beispiel (Cloudflare Worker / FastAPI)  
- Backend-Hooks (z. B. Moodle/SCORM/CSV)  

---

## 🤝 Mitmachen
Pull Requests & Issues willkommen!  
Bitte:
- keine Secrets/Keys einchecken  
- kleine, fokussierte PRs  
- klare Commit-Messages  

Siehe [CONTRIBUTING.md](CONTRIBUTING.md).

---

## 👤 Autor
**Fabian Kaiser / VoyagerIQ**  
🌐 [voyageriq.tech](https://voyageriq.tech)  
📧 fkaiser@voyageriq.de  
🔗 [LinkedIn](https://www.linkedin.com/in/fkaiser95)

---

## 🪪 Lizenz

[![License: MIT](https://img.shields.io/badge/Code-MIT-green.svg)](LICENSE)  
[![License: CC BY 4.0](https://img.shields.io/badge/Content-CC%20BY%204.0-blue.svg)](https://creativecommons.org/licenses/by/4.0/)

- **Code** steht unter [MIT License](LICENSE).  
- **Texte & Inhalte** stehen unter [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). Attribution an *Fabian Kaiser / VoyagerIQ*.  

📌 Für Security-Meldungen: [SECURITY.md](SECURITY.md) (📧 security@voyageriq.de)
