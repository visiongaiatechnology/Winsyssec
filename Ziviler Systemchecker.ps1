<#
.SYNOPSIS
    VISIONGAIATECHNOLOGY - CIVILIAN SYSTEM AUDIT v2.2 (PLATINUM VGT SUPREME)
.DESCRIPTION
    Architektur: Modular, Type-Safe, Deterministisch.
    Zweck: Erweiterter Open-Source Baseline-Check für zivile Windows-Endpunkte.
    Vektoren: Firewall, Defender, Telemetry, UAC, Encryption (BitLocker/VeraCrypt), Updates.
#>
[CmdletBinding()]
param()

# VGT MANDATORY: Strikte Ausführung & sauberes Error-Handling
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ==============================================================================
# 1. KERNEL & UI ENGINE (VGT STATE OF THE ART)
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
        Write-Host "                                    |_| CIVILIAN AUDIT v2.2 $([VGTThermalEngine]::Reset)"
        Write-Host "================================================================================"
        Write-Host " [!] WARNUNG: Dieser Scan bewertet die Widerstandsfähigkeit gegen Angriffe."
        Write-Host " [!] Ein Score von 0% ist bei Standard-Installationen die Regel, nicht die Ausnahme."
    }
}

# ==============================================================================
# 2. AUDIT MODULE (EXPANDED VECTORS)
# ==============================================================================

function Invoke-VGTFirewallAudit {
    [OutputType([int])]
    param()
    Write-Host "`n$([VGTThermalEngine]::Hdr)[1] NETZWERK-EXPOSITION$([VGTThermalEngine]::Reset)"
    
    [int]$scoreYield = 0
    try {
        [int]$InboundAllow = @(Get-NetFirewallRule -Enabled True -Direction Inbound -Action Allow -ErrorAction Stop).Count
        
        if ($InboundAllow -le 15) { 
            $scoreYield = 20 
            Write-Host "  [-] Offene Inbound-Rules        : $InboundAllow $([VGTThermalEngine]::Ok)[STRENG VERSCHLOSSEN]$([VGTThermalEngine]::Reset)"
        } elseif ($InboundAllow -le 45) {
            $scoreYield = 10
            Write-Host "  [-] Offene Inbound-Rules        : $InboundAllow $([VGTThermalEngine]::Warn)[GEFÄHRDET]$([VGTThermalEngine]::Reset)"
        } else { 
            Write-Host "  [-] Offene Inbound-Rules        : $InboundAllow $([VGTThermalEngine]::Crit)[TOTAL-EXPOSITION]$([VGTThermalEngine]::Reset)" 
        }
    } catch {
        Write-Host "  [-] Firewall Audit              : $([VGTThermalEngine]::Crit)[API-ERROR]$([VGTThermalEngine]::Reset)"
    }
    return $scoreYield
}

function Invoke-VGTDefenderAudit {
    [OutputType([int])]
    param()
    Write-Host "`n$([VGTThermalEngine]::Hdr)[2] HEURISTIK & SCHUTZ-SYSTEME$([VGTThermalEngine]::Reset)"
    
    [int]$scoreYield = 0
    try {
        $MP = Get-MpPreference -ErrorAction Stop
        [int]$ASR_Count = @($MP.AttackSurfaceReductionRules_Ids | Select-Object -Unique).Count

        if ($MP.CloudBlockLevel -ge 2) { 
            $scoreYield += 10; Write-Host "  [-] Cloud-Intelligenz           : $([VGTThermalEngine]::Ok)[AKTIV]$([VGTThermalEngine]::Reset)" 
        } else { 
            Write-Host "  [-] Cloud-Intelligenz           : $([VGTThermalEngine]::Crit)[PASSIV]$([VGTThermalEngine]::Reset)" 
        }

        if ($MP.EnableControlledFolderAccess -eq 1) { 
            $scoreYield += 10; Write-Host "  [-] Anti-Ransomware (CFA)       : $([VGTThermalEngine]::Ok)[AKTIV]$([VGTThermalEngine]::Reset)" 
        } else { 
            Write-Host "  [-] Anti-Ransomware (CFA)       : $([VGTThermalEngine]::Crit)[AUS]$([VGTThermalEngine]::Reset)" 
        }

        if ($ASR_Count -ge 10) { 
            $scoreYield += 10; Write-Host "  [-] ASR-Kernel-Regeln           : $([VGTThermalEngine]::Ok)[GEHÄRTET]$([VGTThermalEngine]::Reset) ($ASR_Count/16)" 
        } else { 
            Write-Host "  [-] ASR-Kernel-Regeln           : $([VGTThermalEngine]::Crit)[INAKTIV]$([VGTThermalEngine]::Reset) ($ASR_Count/16)" 
        }
    } catch {
        Write-Host "  [-] Defender Audit              : $([VGTThermalEngine]::Crit)[SYSTEM-API NICHT ERREICHBAR]$([VGTThermalEngine]::Reset)"
    }
    return $scoreYield
}

function Invoke-VGTIdentityAudit {
    [OutputType([int])]
    param()
    Write-Host "`n$([VGTThermalEngine]::Hdr)[3] IDENTITÄT & PRIVILEGIEN$([VGTThermalEngine]::Reset)"
    
    [int]$scoreYield = 0
    try {
        # Check UAC Level (ConsentPromptBehaviorAdmin: 0 = No, 5 = Highest)
        $UAC = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin"
        if ($UAC.ConsentPromptBehaviorAdmin -eq 2 -or $UAC.ConsentPromptBehaviorAdmin -eq 5) {
            $scoreYield += 10; Write-Host "  [-] Benutzerkontensteuerung     : $([VGTThermalEngine]::Ok)[STRIKT]$([VGTThermalEngine]::Reset)"
        } else {
            Write-Host "  [-] Benutzerkontensteuerung     : $([VGTThermalEngine]::Crit)[SCHWACH]$([VGTThermalEngine]::Reset)"
        }
    } catch {
        Write-Host "  [-] Identity Audit              : $([VGTThermalEngine]::Crit)[REGISTRY-ERROR]$([VGTThermalEngine]::Reset)"
    }
    return $scoreYield
}

function Invoke-VGTStorageAudit {
    [OutputType([int])]
    param()
    Write-Host "`n$([VGTThermalEngine]::Hdr)[4] DATEN-VERSCHLÜSSELUNG$([VGTThermalEngine]::Reset)"
    
    [int]$scoreYield = 0
    [bool]$protected = $false
    [string]$method = ""

    # Vektor A: BitLocker (Nativ)
    try {
        $BL = Get-BitLockerVolume -MountPoint "C:" -ErrorAction SilentlyContinue
        if ($null -ne $BL -and $BL.ProtectionStatus -eq 'On') {
            $protected = $true
            $method = "BitLocker"
        }
    } catch {}

    # Vektor B: VeraCrypt (Third-Party / Forensic Shield)
    if (-not $protected) {
        try {
            $VCProc = Get-Process "VeraCrypt" -ErrorAction SilentlyContinue
            $VCDriver = Get-Service "veracrypt" -ErrorAction SilentlyContinue
            if ($null -ne $VCProc -or $null -ne $VCDriver) {
                $protected = $true
                $method = "VeraCrypt"
            }
        } catch {}
    }

    if ($protected) {
        $scoreYield = 20
        Write-Host "  [-] Verschlüsselung ($method)    : $([VGTThermalEngine]::Ok)[AKTIV]$([VGTThermalEngine]::Reset)"
    } else {
        Write-Host "  [-] Verschlüsselung             : $([VGTThermalEngine]::Crit)[INAKTIV]$([VGTThermalEngine]::Reset)"
    }
    return $scoreYield
}

function Invoke-VGTTelemetryAudit {
    [OutputType([int])]
    param()
    Write-Host "`n$([VGTThermalEngine]::Hdr)[5] PRIVATSPHÄRE & TELEMETRIE$([VGTThermalEngine]::Reset)"
    
    [int]$scoreYield = 0
    try {
        $DiagTrack = Get-Service -Name "DiagTrack" -ErrorAction SilentlyContinue
        if ($null -eq $DiagTrack -or $DiagTrack.StartType -eq "Disabled") { 
            $scoreYield = 20; Write-Host "  [-] Windows Überwachung         : $([VGTThermalEngine]::Ok)[GESTOPPT]$([VGTThermalEngine]::Reset)" 
        } else { 
            Write-Host "  [-] Windows Überwachung         : $([VGTThermalEngine]::Crit)[AKTIV (DATENABFLUSS)]$([VGTThermalEngine]::Reset)" 
        }
    } catch {
        $scoreYield = 20; Write-Host "  [-] Windows Überwachung         : $([VGTThermalEngine]::Ok)[ELIMINIERT]$([VGTThermalEngine]::Reset)"
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
$TotalScore += Invoke-VGTIdentityAudit
$TotalScore += Invoke-VGTStorageAudit
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
    Write-Host " ANALYSE: Ihr System befindet sich im Auslieferungszustand." -ForegroundColor Red
    Write-Host " Es gibt keinen wirksamen Schutz gegen moderne Ransomware oder Exploit-Ketten." -ForegroundColor Red
    Write-Host " Jeder Score unter 40% bedeutet: Sie arbeiten auf einer 'Open Shell'." -ForegroundColor Red
    Write-Host " VGT Empfehlung: Omega Hardening Protocol einleiten." -ForegroundColor DarkGray
}

Write-Host "================================================================================"
Write-Host " VGT Execution abgeschlossen. Beliebige Taste zum Beenden..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
