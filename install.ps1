# ============================================================
#   ComfyUI 一键安装脚本 (Windows PowerShell)
#   ComfyUI One-Click Installer for Windows
#   GitHub: https://github.com/ryantryor/comfyui-installer
# ============================================================
# 使用方法 / Usage:
#   以管理员身份运行 PowerShell，执行：
#   Set-ExecutionPolicy Bypass -Scope Process -Force
#   .\install.ps1

param(
  [string]$InstallPath = "$env:USERPROFILE\ComfyUI"
)

# ── 推广链接（替换为你的联盟链接）───────────────────────
$LIBLIB_URL   = "https://www.liblib.art/viphome?referralCode=sW2nzHV5"
$ALIYUN_URL   = "https://www.aliyun.com/minisite/goods?userCode=tdk43jyw"
$TENCENT_URL  = "https://curl.qcloud.com/7EQPRMGF"
$RUNPOD_URL   = "https://runpod.io?ref=ut0jez4s"

$SCRIPT_VERSION    = "1.0.0"
$COMFYUI_REPO      = "https://github.com/comfyanonymous/ComfyUI.git"
$MANAGER_REPO      = "https://github.com/ltdrdata/ComfyUI-Manager.git"
$PORTABLE_URL      = "https://github.com/comfyanonymous/ComfyUI/releases/latest/download/ComfyUI_windows_portable_nvidia.7z"

# ── 颜色输出 ──────────────────────────────────────────────
function Write-Color {
  param([string]$Text, [string]$Color = "White")
  Write-Host $Text -ForegroundColor $Color
}

function Write-Step  { param([string]$Text); Write-Host "`n>>> $Text`n" -ForegroundColor Cyan }
function Write-OK    { param([string]$Text); Write-Host "[OK] $Text" -ForegroundColor Green }
function Write-Warn  { param([string]$Text); Write-Host "[WARN] $Text" -ForegroundColor Yellow }
function Write-Fail  { param([string]$Text); Write-Host "[ERROR] $Text" -ForegroundColor Red; exit 1 }
function Write-Info  { param([string]$Text); Write-Host "[INFO] $Text" -ForegroundColor White }

# ── 欢迎横幅 ──────────────────────────────────────────────
function Show-Banner {
  Write-Host ""
  Write-Color "  ██████╗ ██████╗ ███╗   ███╗███████╗██╗   ██╗██╗" Cyan
  Write-Color " ██╔════╝██╔═══██╗████╗ ████║██╔════╝╚██╗ ██╔╝██║" Cyan
  Write-Color " ██║     ██║   ██║██╔████╔██║█████╗   ╚████╔╝ ██║" Cyan
  Write-Color " ██║     ██║   ██║██║╚██╔╝██║██╔══╝    ╚██╔╝  ██║" Cyan
  Write-Color " ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║        ██║   ██║" Cyan
  Write-Color "  ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝        ╚═╝   ╚═╝" Cyan
  Write-Host ""
  Write-Color "  ComfyUI 一键安装脚本 v$SCRIPT_VERSION  [Windows]" White
  Write-Host ""
  Write-Color "  💡 没有 GPU？推荐使用云端平台：" Yellow
  Write-Color "     🎨 哩布哩布AI（模型平台）: $LIBLIB_URL" Blue
  Write-Color "     ⚡ 阿里云（新用户10%折扣）: $ALIYUN_URL" Blue
  Write-Color "     🌐 腾讯云: $TENCENT_URL" Blue
  Write-Color "     🚀 RunPod（海外GPU云）:  $RUNPOD_URL" Blue
  Write-Host ""
  Write-Host "  ──────────────────────────────────────────────────"
  Write-Host ""
}

# ── 系统检测 ──────────────────────────────────────────────
function Detect-System {
  Write-Step "检测系统环境 / Detecting system..."

  # Windows 版本
  $osVersion = (Get-WmiObject Win32_OperatingSystem).Caption
  Write-Info "操作系统: $osVersion"

  # 检测 NVIDIA GPU
  try {
    $gpu = (Get-WmiObject Win32_VideoController | Where-Object { $_.Name -like "*NVIDIA*" }).Name
    if ($gpu) {
      Write-OK "检测到 NVIDIA GPU: $gpu"
      $script:HasNVIDIA = $true
    } else {
      Write-Warn "未检测到 NVIDIA GPU，将使用 CPU 模式"
      Write-Warn "💡 推荐使用云端服务器: $ALIYUN_URL"
      $script:HasNVIDIA = $false
    }
  } catch {
    $script:HasNVIDIA = $false
  }

  # 检测 Python
  try {
    $pyVer = python --version 2>&1
    Write-OK "Python: $pyVer"
    $script:HasPython = $true
  } catch {
    Write-Warn "未检测到 Python，将引导安装"
    $script:HasPython = $false
  }

  # 检测 Git
  try {
    $gitVer = git --version 2>&1
    Write-OK "Git: $gitVer"
    $script:HasGit = $true
  } catch {
    Write-Warn "未检测到 Git"
    $script:HasGit = $false
  }
}

# ── 安装依赖工具 ─────────────────────────────────────────
function Install-Prerequisites {
  Write-Step "安装必要工具 / Installing prerequisites..."

  # 安装 Git
  if (-not $script:HasGit) {
    Write-Info "正在安装 Git..."
    $gitInstaller = "$env:TEMP\GitInstaller.exe"
    $gitUrl = "https://github.com/git-for-windows/git/releases/latest/download/Git-2.43.0-64-bit.exe"
    Invoke-WebRequest -Uri $gitUrl -OutFile $gitInstaller -UseBasicParsing
    Start-Process -Wait -FilePath $gitInstaller -ArgumentList "/VERYSILENT /NORESTART"
    Write-OK "Git 安装完成"
  }

  # 安装 Python（如果没有）
  if (-not $script:HasPython) {
    Write-Info "正在安装 Python 3.11..."
    $pyInstaller = "$env:TEMP\python-installer.exe"
    $pyUrl = "https://www.python.org/ftp/python/3.11.9/python-3.11.9-amd64.exe"
    Invoke-WebRequest -Uri $pyUrl -OutFile $pyInstaller -UseBasicParsing
    Start-Process -Wait -FilePath $pyInstaller -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1"
    Write-OK "Python 安装完成"
  }
}

# ── 安装 ComfyUI ─────────────────────────────────────────
function Install-ComfyUI {
  Write-Step "下载并安装 ComfyUI / Installing ComfyUI..."

  # 选择安装方式
  Write-Host ""
  Write-Color "请选择安装方式：" Yellow
  Write-Host "  1) 一键便携包（推荐新手）- 含 Python + PyTorch，约 5GB"
  Write-Host "  2) Git 源码安装（推荐进阶）- 可自定义"
  Write-Host ""
  $choice = Read-Host "请输入选项 [1/2]（默认1）"
  if (-not $choice) { $choice = "1" }

  switch ($choice) {
    "1" {
      Write-Info "下载 ComfyUI 便携包..."
      $zipPath = "$env:TEMP\ComfyUI_portable.7z"

      # 检查是否有7zip
      if (-not (Test-Path "C:\Program Files\7-Zip\7z.exe")) {
        Write-Info "正在安装 7-Zip..."
        $szInstaller = "$env:TEMP\7z_installer.exe"
        Invoke-WebRequest -Uri "https://www.7-zip.org/a/7z2408-x64.exe" -OutFile $szInstaller -UseBasicParsing
        Start-Process -Wait -FilePath $szInstaller -ArgumentList "/S"
      }

      Invoke-WebRequest -Uri $PORTABLE_URL -OutFile $zipPath -UseBasicParsing
      & "C:\Program Files\7-Zip\7z.exe" x $zipPath -o"$env:USERPROFILE" -y
      $script:InstallDir = "$env:USERPROFILE\ComfyUI_windows_portable\ComfyUI"
      Write-OK "便携包安装完成"
    }
    "2" {
      if (Test-Path $InstallPath) {
        $confirm = Read-Host "目录已存在，是否覆盖安装？[y/N]"
        if ($confirm -eq "y") { Remove-Item $InstallPath -Recurse -Force }
        else { $script:InstallDir = $InstallPath; return }
      }
      Write-Info "克隆 ComfyUI 源码..."
      git clone --depth=1 $COMFYUI_REPO $InstallPath
      $script:InstallDir = $InstallPath

      # 创建虚拟环境
      Write-Info "创建 Python 虚拟环境..."
      python -m venv "$InstallPath\venv"
      & "$InstallPath\venv\Scripts\activate.ps1"

      # 安装 PyTorch
      if ($script:HasNVIDIA) {
        Write-Info "安装 PyTorch CUDA 版本..."
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 -q
      } else {
        Write-Info "安装 PyTorch CPU 版本..."
        pip install torch torchvision torchaudio -q
      }
      pip install -r "$InstallPath\requirements.txt" -q
      Write-OK "依赖安装完成"
    }
  }
}

# ── 安装 ComfyUI Manager ──────────────────────────────────
function Install-Manager {
  Write-Step "安装 ComfyUI Manager（插件管理器）..."

  $managerPath = "$($script:InstallDir)\custom_nodes\ComfyUI-Manager"
  if (Test-Path $managerPath) {
    Write-Info "ComfyUI Manager 已存在，跳过"
  } else {
    git clone --depth=1 $MANAGER_REPO $managerPath
    Write-OK "ComfyUI Manager 安装完成"
  }
}

# ── 创建桌面快捷方式 ──────────────────────────────────────
function Create-Shortcut {
  Write-Step "创建桌面快捷方式 / Creating desktop shortcut..."

  # 创建启动脚本
  $launcherPath = "$($script:InstallDir)\..\start_comfyui.bat"
  $launcherContent = @"
@echo off
title ComfyUI
cd /d "$($script:InstallDir)"
echo 正在启动 ComfyUI...
echo 浏览器访问: http://127.0.0.1:8188
echo.

if exist venv\Scripts\activate.bat (
  call venv\Scripts\activate.bat
  python main.py --listen 127.0.0.1 --port 8188
) else (
  python_embeded\python.exe -s main.py --listen 127.0.0.1 --port 8188
)
pause
"@
  Set-Content -Path $launcherPath -Value $launcherContent -Encoding UTF8

  # 创建桌面快捷方式
  $WshShell = New-Object -ComObject WScript.Shell
  $Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\ComfyUI.lnk")
  $Shortcut.TargetPath = $launcherPath
  $Shortcut.Description = "启动 ComfyUI AI 绘图工具"
  $Shortcut.Save()
  Write-OK "桌面快捷方式创建完成"
}

# ── 完成提示 ──────────────────────────────────────────────
function Show-Done {
  Write-Host ""
  Write-Color "  ╔══════════════════════════════════════════╗" Green
  Write-Color "  ║     ComfyUI 安装成功！Installation OK!   ║" Green
  Write-Color "  ╚══════════════════════════════════════════╝" Green
  Write-Host ""
  Write-Color "  📂 安装目录: $($script:InstallDir)" Cyan
  Write-Color "  🚀 双击桌面 ComfyUI 图标即可启动" Cyan
  Write-Color "  🌐 浏览器访问: http://127.0.0.1:8188" Cyan
  Write-Host ""
  Write-Color "  ─── 推荐资源 / Recommended Resources ──────" White
  Write-Color "  🎨 模型下载（哩布哩布AI）:      $LIBLIB_URL" Blue
  Write-Color "  🚀 GPU云（RunPod 海外）:        $RUNPOD_URL" Blue
  Write-Color "  ⚡ 云服务器（阿里云 10%折扣）: $ALIYUN_URL" Blue
  Write-Color "  🌐 云服务器（腾讯云）:         $TENCENT_URL" Blue
  Write-Host ""
  Write-Color "  ⭐ 如果脚本对你有帮助，请给 GitHub 仓库点个 Star！" Yellow
  Write-Color "  https://github.com/ryantryor/comfyui-installer" Blue
  Write-Host ""
  Read-Host "按任意键退出 / Press any key to exit"
}

# ── 主流程 ────────────────────────────────────────────────
Show-Banner
Detect-System
Install-Prerequisites
Install-ComfyUI
Install-Manager
Create-Shortcut
Show-Done
