<#
.SYNOPSIS
    VISIONGAIATECHNOLOGY - CIVILIAN SYSTEM AUDIT v2.0 (PLATINUM EDITION)
.DESCRIPTION
    Architektur: Modular, Type-Safe, Deterministisch.
    Zweck: Open-Source Baseline-Check für zivile Windows-Endpunkte.
#>
[CmdletBinding()]
param()

# VGT MANDATORY: Strikte Ausführung & sauberes Error-Handling
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ==============================================================================
# 1. KERNEL & UI ENGINE
# ==============================================================================
class VGTThermalEngine {
    static [string] $E = [char]27
    static [string] $VGT   = "$([VGTThermalEngine]::E)[38;5;201m"
    static [string] $Hdr   = "$([VGTThermalEngine]::E)[38;5;45m"
    static [string] $Ok    = "$([VGTThermalEngine]::E)[38;5;82m"
    static [string] $Warn  = "$([VGTThermalEngine]::E)[38;5;214m"
    static [string] $Crit  = "$([VGTThermalEngine]::E)[38;5;196m"
    static [string] $Reset = "$([VGTThermalEngine]::E)[0m"

    static [void] RenderHeader() {
        Clear-Host
        Write-Host [VGTThermalEngine]::VGT -NoNewline
        Write-Host "   _   _  ____ _____    ____                                    "
        Write-Host "  | | | |/ ___|_   _|  / ___| _   _ _ __  _ __ ___ _ __ ___   ___ "
        Write-Host "  | | | | |  _  | |    \___ \| | | | '_ \| '__/ _ \ '_ ` _ \ / _ \"
        Write-Host "   \ \_/ / |_| | | |     ___) | |_| | |_) | | |  __/ | | | | |  __/"
        Write-Host "    \___/ \____| |_|    |____/ \__,_| .__/|_|  \___|_| |_| |_|\___|"
        Write-Host "                                    |_| CIVILIAN AUDIT v2.0 $([VGTThermalEngine]::Reset)"
        Write-Host "================================================================================"
    }
}

# ==============================================================================
# 2. AUDIT MODULE (ISOLIERTE VEKTOREN)
# ==============================================================================

function Invoke-VGTFirewallAudit {
    [OutputType([int])]
    param()
    Write-Host "`n$([VGTThermalEngine]::Hdr)[1] ANALYSIERE NETZWERK-EXPOSITION...$([VGTThermalEngine]::Reset)"
    
    [int]$scoreYield = 0
    try {
        [int]$InboundAllow = @(Get-NetFirewallRule -Enabled True -Direction Inbound -Action Allow -ErrorAction Stop).Count
        
        if ($InboundAllow -le 15) { 
            $scoreYield = 30 
            Write-Host "  [-] Offene Inbound-Rules        : $InboundAllow $([VGTThermalEngine]::Ok)[STRENG VERSCHLOSSEN]$([VGTThermalEngine]::Reset)"
        } elseif ($InboundAllow -le 45) {
            $scoreYield = 15
            Write-Host "  [-] Offene Inbound-Rules        : $InboundAllow $([VGTThermalEngine]::Warn)[GEFÄHRDET]$([VGTThermalEngine]::Reset)"
        } else { 
            Write-Host "  [-] Offene Inbound-Rules        : $InboundAllow $([VGTThermalEngine]::Crit)[TOTAL-EXPOSITION]$([VGTThermalEngine]::Reset)" 
        }
    } catch {
        Write-Host "  [-] Firewall Audit              : $([VGTThermalEngine]::Crit)[FEHLER: ZUGRIFF VERWEIGERT / DIENST OFFLINE]$([VGTThermalEngine]::Reset)"
    }
    return $scoreYield
}

function Invoke-VGTDefenderAudit {
    [OutputType([int])]
    param()
    Write-Host "`n$([VGTThermalEngine]::Hdr)[2] ANALYSIERE HEURISTIK & SCHUTZ-SYSTEME...$([VGTThermalEngine]::Reset)"
    
    [int]$scoreYield = 0
    try {
        $MP = Get-MpPreference -ErrorAction Stop
        [int]$ASR_Count = @($MP.AttackSurfaceReductionRules_Ids | Select-Object -Unique).Count

        if ($MP.CloudBlockLevel -ge 2) { 
            $scoreYield += 15; Write-Host "  [-] Cloud-Intelligenz           : $([VGTThermalEngine]::Ok)[AKTIV]$([VGTThermalEngine]::Reset)" 
        } else { 
            Write-Host "  [-] Cloud-Intelligenz           : $([VGTThermalEngine]::Crit)[PASSIV]$([VGTThermalEngine]::Reset)" 
        }

        if ($MP.EnableControlledFolderAccess -eq 1) { 
            $scoreYield += 15; Write-Host "  [-] Anti-Ransomware (CFA)       : $([VGTThermalEngine]::Ok)[AKTIV]$([VGTThermalEngine]::Reset)" 
        } else { 
            Write-Host "  [-] Anti-Ransomware (CFA)       : $([VGTThermalEngine]::Crit)[AUS]$([VGTThermalEngine]::Reset)" 
        }

        if ($ASR_Count -ge 10) { 
            $scoreYield += 10; Write-Host "  [-] ASR-Kernel-Regeln           : $([VGTThermalEngine]::Ok)[GEHÄRTET]$([VGTThermalEngine]::Reset) ($ASR_Count/16)" 
        } else { 
            Write-Host "  [-] ASR-Kernel-Regeln           : $([VGTThermalEngine]::Crit)[DEAKTIVIERT]$([VGTThermalEngine]::Reset) ($ASR_Count/16)" 
        }
    } catch {
        Write-Host "  [-] Defender Audit              : $([VGTThermalEngine]::Crit)[SYSTEM-API NICHT ERREICHBAR]$([VGTThermalEngine]::Reset)"
    }
    return $scoreYield
}

function Invoke-VGTTelemetryAudit {
    [OutputType([int])]
    param()
    Write-Host "`n$([VGTThermalEngine]::Hdr)[3] ANALYSIERE DATEN-ABFLUSS (TELEMETRIE)...$([VGTThermalEngine]::Reset)"
    
    [int]$scoreYield = 0
    try {
        $DiagTrack = Get-Service -Name "DiagTrack" -ErrorAction Stop
        if ($DiagTrack.StartType -eq "Disabled") { 
            $scoreYield = 30; Write-Host "  [-] Windows Überwachung         : $([VGTThermalEngine]::Ok)[PHYSISCH GESTOPPT]$([VGTThermalEngine]::Reset)" 
        } else { 
            Write-Host "  [-] Windows Überwachung         : $([VGTThermalEngine]::Crit)[AKTIV (DATENABFLUSS)]$([VGTThermalEngine]::Reset)" 
        }
    } catch {
        # Wenn der Dienst physisch gelöscht wurde (VGT Omega Verhalten), werten wir es als sicher.
        $scoreYield = 30
        Write-Host "  [-] Windows Überwachung         : $([VGTThermalEngine]::Ok)[DIENST ELIMINIERT]$([VGTThermalEngine]::Reset)"
    }
    return $scoreYield
}

# ==============================================================================
# 3. MAIN EXECUTION KERNEL
# ==============================================================================
[VGTThermalEngine]::RenderHeader()

[int]$TotalScore = 0
$TotalScore += Invoke-VGTFirewallAudit
$TotalScore += Invoke-VGTDefenderAudit
$TotalScore += Invoke-VGTTelemetryAudit

# SCORE RENDERING
Write-Host "`n================================================================================"
[int]$Filled = [math]::Floor($TotalScore / 5)
[int]$Empty = 20 - $Filled

Write-Host -NoNewline " SICHERHEITS-INDEX: ["
Write-Host -NoNewline ("#" * $Filled) -ForegroundColor Green
Write-Host -NoNewline ("-" * $Empty) -ForegroundColor Gray
Write-Host "] $TotalScore%"

if ($TotalScore -ge 90) {
    Write-Host "`n STATUS: VGT-DIAMANT: DAS SYSTEM IST EINE FESTUNG. 💎🛡️" -ForegroundColor Green
} elseif ($TotalScore -ge 60) {
    Write-Host "`n STATUS: GOLD: AKZEPTABEL, ABER LÜCKENHAFT. ⚠️" -ForegroundColor Yellow
} else {
    Write-Host "`n STATUS: KRITISCH - SYSTEM KOMPROMMITTIERT! 🔥💀" -ForegroundColor Red
    Write-Host "--------------------------------------------------------------------------------"
    Write-Host " FATAL: Ihr System ist ein Sicherheitsrisiko für Sie und Dritte." -ForegroundColor Red
    Write-Host " Ein Score von $TotalScore% bedeutet: Die Systemarchitektur bietet null Widerstand." -ForegroundColor Red
    Write-Host " Jeder Hacker kann diesen PC als Pivot-Punkt für das Netzwerk nutzen." -ForegroundColor Red
    Write-Host " Erwägen Sie ein professionelles VGT-Audit: https://visiongaiatechnology.de" -ForegroundColor DarkGray
}

Write-Host "================================================================================"
Write-Host " VGT Execution abgeschlossen. Beliebige Taste zum Beenden..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
