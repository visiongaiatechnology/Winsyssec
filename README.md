<div align="center">

```
██████╗ ██╗ █████╗ ███╗   ███╗ ██████╗ ███╗   ██╗██████╗ 
██╔══██╗██║██╔══██╗████╗ ████║██╔═══██╗████╗  ██║██╔══██╗
██║  ██║██║███████║██╔████╔██║██║   ██║██╔██╗ ██║██║  ██║
██║  ██║██║██╔══██║██║╚██╔╝██║██║   ██║██║╚██╗██║██║  ██║
██████╔╝██║██║  ██║██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██████╔╝
╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═════╝ 
```

## ⚠️ DISCLAIMER: EXPERIMENTAL R&D PROJECT

This project is a **Proof of Concept (PoC)** and part of ongoing research and development at
VisionGaia Technology. It is **not** a certified or production-ready product.

**Use at your own risk.** The software may contain security vulnerabilities, bugs, or
unexpected behavior. It may break your environment if misconfigured or used improperly.

**Do not deploy in critical production environments** unless you have thoroughly audited
the code and understand the implications. For enterprise-grade, verified protection,
we recommend established and officially certified solutions.

Found a vulnerability or have an improvement? **Open an issue or contact us.**



# VGT CIVILIAN SYSTEM CHECKER
### Open Source Windows Security Audit · v2.2 PLATINUM

[![Made by VisionGaiaTechnology](https://img.shields.io/badge/Made%20by-VisionGaiaTechnology-00d4ff?style=for-the-badge&logo=shield&logoColor=white)](https://visiongaiatechnology.de)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue?style=for-the-badge&logo=powershell&logoColor=white)](https://github.com/PowerShell/PowerShell)
[![License](https://img.shields.io/badge/License-AGPLv3-green?style=for-the-badge)](LICENSE)
[![Open Source](https://img.shields.io/badge/Open%20Source-Yes-brightgreen?style=for-the-badge&logo=github)](https://github.com/VisionGaiaTechnology)

---

<a href="https://www.paypal.com/paypalme/dergoldenelotus">
  <img src="https://img.shields.io/badge/☕%20Support%20VGT-PayPal%20Donate-00457C?style=for-the-badge&logo=paypal&logoColor=white" alt="Donate with PayPal" height="45"/>
</a>
&nbsp;&nbsp;
<a href="https://visiongaiatechnology.de">
  <img src="https://img.shields.io/badge/🛡️%20Professional%20Audit-VisionGaiaTechnology-00d4ff?style=for-the-badge" alt="VisionGaiaTechnology" height="45"/>
</a>

</div>

---

## 💎 Was ist der VGT Civilian Checker?

Der **VGT Civilian System Checker** ist ein kostenloser, Open-Source Windows-Sicherheitsscanner – entwickelt von [VisionGaiaTechnology](https://visiongaiatechnology.de) aus Köln.

Er prüft in Sekunden die **5 kritischsten Sicherheitsvektoren** deines Windows-Systems und gibt dir einen ehrlichen Score – ohne Marketing, ohne Weichspüler.

> **Die unbequeme Wahrheit:** Ein frisch installiertes Windows landet bei 0–20%. Das ist kein Bug. Das ist der Auslieferungszustand.

---

## 🔍 Geprüfte Sicherheitsvektoren

| # | Vektor | Was wird geprüft | Max. Punkte |
|---|--------|-----------------|-------------|
| 1 | 🌐 **Netzwerk-Exposition** | Offene Inbound Firewall Rules | 20 |
| 2 | 🛡️ **Heuristik & Schutz** | Defender Cloud, Anti-Ransomware (CFA), ASR-Regeln | 30 |
| 3 | 🔐 **Identität & Privilegien** | UAC Level & Admin-Konfiguration | 10 |
| 4 | 💾 **Datenverschlüsselung** | BitLocker / VeraCrypt Status | 20 |
| 5 | 👁️ **Privatsphäre** | Windows Telemetrie & DiagTrack | 20 |

---

## 📊 Score-System

```
💎 90–100%  DIAMANT    →  Das System ist eine Festung.
🥇 60–89%   GOLD       →  Akzeptabel, aber lückenhaft.
🔥  0–59%   KRITISCH   →  System ist eine offene Flanke.
```

---

## 🚀 Verwendung

```powershell
# 1. Als Administrator starten (Rechtsklick → Als Administrator ausführen)
# 2. Script ausführen:
.\VGT_Civilian_Checker_v2.2.ps1
```

> **Hinweis:** Das Script benötigt Administrator-Rechte für den vollständigen Scan.  
> Es werden **keine Daten gesendet** – alles läuft lokal auf deinem System.

---

## 🏗️ Architektur

```
VGT Civilian Checker v2.2
├── VGTThermalEngine         → Farb-UI & Score-Rendering
├── Invoke-VGTFirewallAudit  → Netzwerk-Exposition
├── Invoke-VGTDefenderAudit  → Heuristik & ASR
├── Invoke-VGTIdentityAudit  → UAC & Privilegien
├── Invoke-VGTStorageAudit   → BitLocker / VeraCrypt
└── Invoke-VGTTelemetryAudit → Privatsphäre
```

- **Type-Safe** · PowerShell `Set-StrictMode -Version Latest`
- **Deterministisch** · Reproduzierbare Ergebnisse
- **Zero Network** · Keine externen Verbindungen
- **Modular** · Jeder Vektor ist ein isoliertes Modul

---

## 🔒 Civilian vs. SafetySys™ Professional

Dies ist unsere **öffentliche Basisversion**. Sie zeigt dir wo du stehst.

| Feature | Civilian v2.2 | SafetySys™ V19.6 |
|---------|:---:|:---:|
| Sicherheitsvektoren | 5 | **38** |
| Angriffskategorien | 5 | **9** |
| MITRE ATT&CK Mapping | ❌ | ✅ |
| Zertifikatsexport | ❌ | ✅ |
| Kernel BCD Protection | ❌ | ✅ |
| Memory Scrambling | ❌ | ✅ |
| DNSSEC Validation | ❌ | ✅ |
| Tier-Zertifikat (CIVIC→SOVEREIGN) | ❌ | ✅ |
| Preis | **Kostenlos** | **Ab 490€** |

<div align="center">

### Bereit für den echten Audit?

<a href="https://visiongaiatechnology.de">
  <img src="https://img.shields.io/badge/🛡️%20Jetzt%20Professional%20Audit%20anfragen-visiongaiatechnology.de-00d4ff?style=for-the-badge&logoColor=white" height="50"/>
</a>

</div>

---

## ☕ Support

Dieser Scanner ist **kostenlos und Open Source**. Wenn er dir geholfen hat:

<div align="center">

<a href="https://www.paypal.com/paypalme/dergoldenelotus">
  <img src="https://img.shields.io/badge/PayPal-Support%20VisionGaiaTechnology-00457C?style=for-the-badge&logo=paypal&logoColor=white" height="45"/>
</a>

*Jede Unterstützung hilft uns, weitere Open Source Security Tools zu entwickeln.*

</div>

---

## 📄 Lizenz

AGPLv3 License · © 2026 VisionGaia Technology · Köln, Deutschland

---

<div align="center">

**[🌐 Website](https://visiongaiatechnology.de) · [💼 LinkedIn](https://linkedin.com/company/visiongaiatechnology) · [🐙 GitHub](https://github.com/VisionGaiaTechnology)**

*Entwickelt mit 💎 in Köln · Don't fuck with VisionGaiaTechnology*

</div>
