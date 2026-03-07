# ==============================================================================
# VISIONGAIATECHNOLOGY - CIVILIAN SYSTEM AUDIT v1.1
# ZIEL: Transparenz über die digitale Verwundbarkeit (Phase 1-3)
# STATUS: STANDALONE-DIAGNOSE (KEINE INSTALLATION)
# ==============================================================================

$ErrorActionPreference = "SilentlyContinue"

# VGT COLOR ENGINE
$E = [char]27
$C_VGT = "$E[38;5;201m"; $C_Score = "$E[38;5;45m"; $C_Ok = "$E[38;5;82m"
$C_Warn = "$E[38;5;214m"; $C_Crit = "$E[38;5;196m"; $C_Reset = "$E[0m"

Clear-Host
Write-Host "$C_VGT"
Write-Host "   _   _  ____ _____    ____                                    "
Write-Host "  | | | |/ ___|_   _|  / ___| _   _ _ __  _ __ ___ _ __ ___   ___ "
Write-Host "  | | | | |  _  | |    \___ \| | | | '_ \| '__/ _ \ '_ ` _ \ / _ \"
Write-Host "   \ \_/ / |_| | | |     ___) | |_| | |_) | | |  __/ | | | | |  __/"
Write-Host "    \___/ \____| |_|    |____/ \__,_| .__/|_|  \___|_| |_| |_|\___|"
Write-Host "                                    |_| CIVILIAN AUDIT v1.1 $C_Reset"
Write-Host "================================================================================"

$Score = 0

# --- PHASE 1: DIE OFFENEN TORE (FIREWALL) ---
Write-Host "`n$C_Score[1] ANALYSIERE NETZWERK-EXPOSITION...$C_Reset"
$InboundAllow = (Get-NetFirewallRule -Enabled True -Direction Inbound -Action Allow).Count

if ($InboundAllow -le 15) { 
    $Score += 30 
    $Status = "$C_Ok[STRENG VERSCHLOSSEN]$C_Reset" 
}
elseif ($InboundAllow -le 45) {
    $Score += 15
    $Status = "$C_Warn[GEFÄHRDET]$C_Reset"
}
else { 
    $Status = "$C_Crit[TOTAL-EXPOSITION]$C_Reset" 
}
Write-Host "  [-] Offene Eingangstüren (Rules) : $InboundAllow ($Status)"

# --- PHASE 2: DER WÄCHTER-STATUS (DEFENDER) ---
Write-Host "`n$C_Score[2] ANALYSIERE SCHUTZ-SYSTEME...$C_Reset"
$MP = Get-MpPreference
$ASR_Count = ($MP.AttackSurfaceReductionRules_Ids | Select-Object -Unique).Count

if ($MP.CloudBlockLevel -ge 2) { $Score += 15; $CLevel = "$C_Ok[AKTIV]$C_Reset" } else { $CLevel = "$C_Crit[PASSIV]$C_Reset" }
if ($MP.EnableControlledFolderAccess -eq 1) { $Score += 15; $Rans = "$C_Ok[AKTIV]$C_Reset" } else { $Rans = "$C_Crit[AUS]$C_Reset" }
if ($ASR_Count -ge 10) { $Score += 10; $AsrS = "$C_Ok[GEHÄRTET]$C_Reset" } else { $AsrS = "$C_Crit[DEAKTIVIERT]$C_Reset" }

Write-Host "  [-] Cloud-Intelligenz           : $CLevel"
Write-Host "  [-] Anti-Ransomware (CFA)       : $Rans"
Write-Host "  [-] Hacker-Abwehr (ASR-Regeln)  : $AsrS ($ASR_Count/16)"

# --- PHASE 3: DIE TELEMETRIE-WANZE (PRIVACY) ---
Write-Host "`n$C_Score[3] ANALYSIERE DATEN-ABFLUSS...$C_Reset"
$DiagTrack = Get-Service "DiagTrack"
if ($DiagTrack.StartType -eq "Disabled") { $Score += 30; $DTS = "$C_Ok[GESTOPPT]$C_Reset" } else { $DTS = "$C_Crit[AKTIV]$C_Reset" }
Write-Host "  [-] Telemetrie (Überwachung)    : $DTS"

# --- DAS FINALE URTEIL ---
Write-Host "`n================================================================================"
$Filled = [int]($Score / 5); $Empty = 20 - $Filled
Write-Host -NoNewline " SICHERHEITS-INDEX: ["
Write-Host -NoNewline ("#" * $Filled) -ForegroundColor Green
Write-Host -NoNewline ("-" * $Empty) -ForegroundColor Gray
Write-Host "] $Score%"

if ($Score -ge 90) {
    Write-Host "`n STATUS: VGT-DIAMANT: DAS SYSTEM IST EINE FESTUNG. 💎🛡️" -ForegroundColor Green
}
elseif ($Score -ge 60) {
    Write-Host "`n STATUS: GOLD: AKZEPTABEL, ABER LÜCKENHAFT. ⚠️" -ForegroundColor Yellow
}
else {
    # DER VGT SCHOCK-MODUS
    Write-Host "`n STATUS: KRITISCH - SYSTEM KOMPROMMITTIERT! 🔥💀" -ForegroundColor Red
    Write-Host "--------------------------------------------------------------------------------"
    Write-Host " FATAL: Ihr System ist ein Sicherheitsrisiko für Sie und Dritte." -ForegroundColor Red
    Write-Host " Hacker können diesen PC als 'Sprungbrett' für weitere Angriffe nutzen." -ForegroundColor Red
    Write-Host " Jeder Tastaturanschlag und jede Datei ist potenziell einsehbar." -ForegroundColor Red
    Write-Host " Ein Score von $Score% bedeutet: Sie haben die Kontrolle bereits verloren." -ForegroundColor Red
}
Write-Host "================================================================================"
Write-Host " Beliebige Taste zum Beenden..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null