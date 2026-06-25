<!-- ══════════════════════════════════════════ OBELISK DESKTOP AI HEADER -->
<div align="center">

[![Header](https://capsule-render.vercel.app/api?type=waving&color=0:0D1117,35:1A0033,70:311B92,100:7C4DFF&height=300&section=header&text=OBELISK+DESKTOP+AI&fontSize=70&fontColor=B388FF&animation=fadeIn&fontAlignY=40&desc=General-Purpose+Desktop+AI+Orchestrator+%E2%80%94+Windows+Automation&descColor=CE93D8&descSize=17&descAlignY=64)](https://github.com/POWDER-RANGER/OBELISK-Desktop-AI)

<br>

[![Typing SVG](https://readme-typing-svg.demolab.com?font=JetBrains+Mono&weight=700&size=18&duration=2600&pause=700&color=B388FF&center=true&vCenter=true&width=900&lines=Natural+Language+%E2%86%92+Application+Automation;Ollama+LLM+%C3%97+Windows+UIAutomation+%E2%80%94+ANY+Windows+App;PowerShell+5.1+Compatible+%E2%80%94+Local+%26+Private;Open+Notepad+%E2%86%92+Type+a+Summary+%E2%86%92+Done.)](https://github.com/POWDER-RANGER/OBELISK-Desktop-AI)

<br>

![](https://img.shields.io/badge/PowerShell-5.1+-5391FE?style=for-the-badge&logo=powershell&labelColor=0D1117)
![](https://img.shields.io/badge/Ollama-Local_LLM-00C853?style=for-the-badge&labelColor=0D1117)
![](https://img.shields.io/badge/LICENSE-MIT-B388FF?style=for-the-badge&labelColor=0D1117)

</div>

---

## 🎯 What It Does

**OBELISK-Desktop-AI** bridges local LLMs (via Ollama) with Windows UI Automation to let you control any desktop application using plain English commands.

```
User: "Open Notepad and type a summary of today's tasks"
OBELISK: → Launches Notepad → Generates summary via Ollama → Types via UIAutomation
```

---

## 🏗️ Architecture

```
OBELISK-Desktop-AI/
├── OBELISK.ps1                  # Main entry point / REPL
├── core/
│   ├── Orchestrator.ps1         # Intent parsing + task routing
│   ├── OllamaClient.ps1         # Ollama API integration
│   └── SessionManager.ps1       # Conversation + context state
├── modules/
│   ├── UIAutomation.ps1         # Windows UIAutomation wrapper
│   ├── AppLauncher.ps1          # Process management
│   ├── InputSimulator.ps1       # Keyboard/mouse simulation
│   └── ScreenReader.ps1         # OCR + element detection
├── config/
│   ├── settings.json            # User preferences + model config
│   └── app-profiles/            # Per-app automation profiles
├── tests/
│   ├── Test-Orchestrator.ps1
│   ├── Test-UIAutomation.ps1
│   └── Test-OllamaClient.ps1
└── .github/workflows/
    └── ci.yml
```

---

## 🚀 Quick Start

```powershell
# 1. Clone the repo
git clone https://github.com/POWDER-RANGER/OBELISK-Desktop-AI.git
cd OBELISK-Desktop-AI

# 2. Ensure Ollama is running
ollama serve

# 3. Launch OBELISK
.\\OBELISK.ps1

# 4. Start giving commands
OBELISK> open notepad and write a haiku about automation
OBELISK> take a screenshot and describe what's on screen
OBELISK> search google chrome for 'PowerShell UIAutomation'
```

---

## ⚙️ Configuration

Edit `config/settings.json`:

```json
{
  "ollama": {
    "host": "http://localhost:11434",
    "model": "llama3",
    "temperature": 0.3,
    "context_window": 4096
  },
  "ui_automation": {
    "action_delay_ms": 150,
    "screenshot_on_error": true,
    "verbose_logging": false
  },
  "session": {
    "max_history": 50,
    "persist_context": true
  }
}
```

---

## 📋 Example Commands

| Natural Language | Action Taken |
|---|---|
| `open calculator` | Launches calc.exe via AppLauncher |
| `click the OK button` | UIAutomation finds + clicks OK |
| `type 'hello world' in notepad` | Focuses Notepad, types via InputSimulator |
| `what's on my screen?` | ScreenReader + Ollama vision description |
| `close chrome` | Terminates chrome.exe gracefully |

---

## 📦 Module Reference

### UIAutomation.ps1
- `Find-UIElement` — locate elements by name, class, or AutomationId
- `Invoke-UIClick` — click buttons, menu items
- `Set-UIValue` — set text in input fields
- `Get-UITree` — dump the automation tree of a window

### OllamaClient.ps1
- `Invoke-OllamaChat` — send a prompt, get a response
- `Get-OllamaModels` — list available local models
- `Test-OllamaConnection` — health check

### Orchestrator.ps1
- Routes natural language to the correct action module
- Parses intent via LLM structured output
- Maintains action history and rollback capability

---

## 🧪 Testing

```powershell
.\\tests\\Test-Orchestrator.ps1
.\\tests\\Test-UIAutomation.ps1
.\\tests\\Test-OllamaClient.ps1
```

---

## 📈 GitHub Stats

<div align="center">

![OBELISK Desktop Stats](https://github-readme-stats.vercel.app/api?username=POWDER-RANGER&repo=OBELISK-Desktop-AI&show_icons=true&theme=midnight-purple&hide_border=true)

</div>

---

## 🔗 POWDER-RANGER Ecosystem

### 🌐 Live .io Pages
| Project | Link | Description |
|---------|------|-------------|
| **Main Portfolio** | [powder-ranger.github.io](https://powder-ranger.github.io) | Master portfolio with all 46 repos |
| **OBELISK Desktop AI** | [powder-ranger.github.io/OBELISK-Desktop-AI](https://powder-ranger.github.io/OBELISK-Desktop-AI) | Desktop AI orchestrator demo |
| **CIVWATCH** | [powder-ranger.github.io/CIVWATCH](https://powder-ranger.github.io/CIVWATCH) | Civic transparency platform |
| **OBLISK** | [powder-ranger.github.io/OBLISK](https://powder-ranger.github.io/OBLISK) | Multi-agent AI orchestration |
| **AI Nexus** | [powder-ranger.github.io/ai-nexus](https://powder-ranger.github.io/ai-nexus) | Browser-based AI platform |
| **Dollar Gravity** | [powder-ranger.github.io/dollar-gravity-framework](https://powder-ranger.github.io/dollar-gravity-framework) | USD gravity visualization |

### 🔧 Core Repositories
| Repository | Language | Purpose |
|-----------|----------|---------|
| **[OBELISK-Desktop-AI](https://github.com/POWDER-RANGER/OBELISK-Desktop-AI)** | PowerShell | Desktop AI orchestrator (this repo) |
| **[CIVWATCH](https://github.com/POWDER-RANGER/CIVWATCH)** | TypeScript | Civic transparency platform |
| **[OBLISK](https://github.com/POWDER-RANGER/OBLISK)** | Python | Multi-agent AI with encrypted vaults |
| **[RED-AGENT-GOV](https://github.com/POWDER-RANGER/RED-AGENT-GOV)** | Python | Governance-enforced agent engine |
| **[CharlesAI](https://github.com/POWDER-RANGER/CharlesAI)** | PowerShell | COMET Agent with memory & orchestration |
| **[OBELISK-Enterprise](https://github.com/POWDER-RANGER/OBELISK-Enterprise)** | Python | $2.5M AI Governance Platform |
| **[NSO Kryptonite](https://github.com/POWDER-RANGER/nso-kryptonite-platform)** | TypeScript | Adversarial defense command center |
| **[AI Nexus](https://github.com/POWDER-RANGER/ai-nexus)** | JavaScript | Browser-based complete AI platform |
| **[Guiding Light AI](https://github.com/POWDER-RANGER/guiding-light-ai)** | Rust | Values-to-policies CLI tool |
| **[Dollar Gravity](https://github.com/POWDER-RANGER/dollar-gravity-framework)** | JavaScript | USD-centric finance-security dashboard |
| **[Dojin D](https://github.com/POWDER-RANGER/dojin-d)** | TypeScript | ECS combat simulation engine |
| **[Contextual Memory UI](https://github.com/POWDER-RANGER/contextual-memory-ui)** | JavaScript | AI memory infrastructure platform |
| **[POWDER-RANGER Bot](https://github.com/POWDER-RANGER/powder-ranger-bot)** | Python | Autonomous GTA V + MGS5 agent |
| **[CIVWATCH Cell Titan](https://github.com/POWDER-RANGER/civwatch-cell-titan)** | Shell | RF observability platform |
| **[CIVWATCH v3](https://github.com/POWDER-RANGER/civwatch-v3)** | HTML | Unified RF observability |

---

## 🤝 Connect

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Curtis_Farrar-0077B5?style=flat&logo=linkedin)](https://www.linkedin.com/in/curtis-farrar-g6b)
[![GitHub](https://img.shields.io/badge/GitHub-POWDER--RANGER-181717?style=flat&logo=github)](https://github.com/POWDER-RANGER)
[![Portfolio](https://img.shields.io/badge/Portfolio-powder--ranger.github.io-B388FF?style=flat&logo=githubpages)](https://powder-ranger.github.io)
[![ORCID](https://img.shields.io/badge/ORCID-0009--0008--9273--2458-A6CE39?style=flat&logo=orcid)](https://orcid.org/0009-0008-9273-2458)

---

MIT © [POWDER-RANGER](https://github.com/POWDER-RANGER)

<div align="center">

[![Footer](https://capsule-render.vercel.app/api?type=waving&color=0:7C4DFF,35:311B92,70:1A0033,100:0D1117&height=150&section=footer)](https://github.com/POWDER-RANGER/OBELISK-Desktop-AI)

</div>
