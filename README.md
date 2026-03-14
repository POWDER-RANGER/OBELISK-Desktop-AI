# OBELISK-Desktop-AI

> 🎯 **General-purpose desktop AI orchestrator** — Natural language → Application automation across ANY Windows app.

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue?logo=powershell)](https://docs.microsoft.com/powershell/)
[![Ollama](https://img.shields.io/badge/Ollama-Local%20LLM-green)](https://ollama.ai)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![CI](https://github.com/POWDER-RANGER/OBELISK-Desktop-AI/actions/workflows/ci.yml/badge.svg)](https://github.com/POWDER-RANGER/OBELISK-Desktop-AI/actions)

---

## Overview

**OBELISK-Desktop-AI** bridges local LLMs (via Ollama) with Windows UI Automation to let you control any desktop application using plain English commands. Describe what you want done — OBELISK parses intent, maps it to UI actions, and executes.

```
User: "Open Notepad and type a summary of today's tasks"
OBELISK: → Launches Notepad → Generates summary via Ollama → Types via UIAutomation
```

---

## Architecture

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
├── .github/workflows/
│   └── ci.yml
├── LICENSE
└── README.md
```

---

## Requirements

- **Windows 10/11** (PowerShell 5.1+ or PowerShell 7+)
- **[Ollama](https://ollama.ai)** installed and running locally
- A local model pulled: `ollama pull llama3` or `ollama pull mistral`
- .NET Framework 4.5+ (for UIAutomation COM access)

---

## Quick Start

```powershell
# 1. Clone the repo
git clone https://github.com/POWDER-RANGER/OBELISK-Desktop-AI.git
cd OBELISK-Desktop-AI

# 2. Ensure Ollama is running
ollama serve

# 3. Launch OBELISK
.\OBELISK.ps1

# 4. Start giving commands
OBELISK> open notepad and write a haiku about automation
OBELISK> take a screenshot and describe what's on screen
OBELISK> search google chrome for 'PowerShell UIAutomation'
```

---

## Configuration

Edit `config/settings.json` to set your preferred model and behavior:

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

## Module Reference

### `UIAutomation.ps1`
Wraps the Windows `System.Windows.Automation` namespace. Key functions:
- `Find-UIElement` — locate elements by name, class, or AutomationId
- `Invoke-UIClick` — click buttons, menu items
- `Set-UIValue` — set text in input fields
- `Get-UITree` — dump the automation tree of a window

### `OllamaClient.ps1`
HTTP client for the Ollama REST API:
- `Invoke-OllamaChat` — send a prompt, get a response
- `Get-OllamaModels` — list available local models
- `Test-OllamaConnection` — health check

### `Orchestrator.ps1`
Routes natural language input to the correct action module:
- Parses intent via LLM structured output
- Maintains action history and rollback capability
- Handles ambiguous commands with clarification prompts

---

## Example Commands

| Natural Language | Action Taken |
|---|---|
| `open calculator` | Launches calc.exe via AppLauncher |
| `click the OK button` | UIAutomation finds + clicks OK |
| `type 'hello world' in notepad` | Focuses Notepad, types via InputSimulator |
| `what's on my screen?` | ScreenReader + Ollama vision description |
| `close chrome` | Terminates chrome.exe gracefully |

---

## Contributing

PRs welcome. Please run the test suite before submitting:

```powershell
.\tests\Test-Orchestrator.ps1
.\tests\Test-UIAutomation.ps1
.\tests\Test-OllamaClient.ps1
```

---

## License

MIT © [POWDER-RANGER](https://github.com/POWDER-RANGER)
