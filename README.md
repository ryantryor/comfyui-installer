<!-- SEO META: ComfyUI install tutorial one-click installer windows linux mac | ComfyUI 一键安装脚本 Windows Linux Mac 教程 manga anime AI comic workflow -->

<div align="center">

# ⚡ ComfyUI One-Click Installer

**The easiest way to install ComfyUI · 最简单的 ComfyUI 安装方式**

[![Stars](https://img.shields.io/github/stars/ryantryor/comfyui-installer?style=social)](https://github.com/ryantryor/comfyui-installer/stargazers)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-blue)](#)
[![Website](https://img.shields.io/badge/🌐_Tutorial_Site-ryantryor.github.io-7c6fee)](https://ryantryor.github.io/comfyui-installer/)

**🌐 Language / 语言切换**

[🇺🇸 English](#-english-documentation) · [🇨🇳 中文文档](#-中文文档)

</div>

---

## 🇺🇸 English Documentation

> **Keywords**: ComfyUI install | ComfyUI windows installer | ComfyUI one click | ComfyUI setup tutorial | ComfyUI manga workflow | AI comic generator | stable diffusion ComfyUI

### What is this?

A one-click installer for [ComfyUI](https://github.com/comfyanonymous/ComfyUI) — the most powerful Stable Diffusion / Flux UI — with pre-built **AI manga & comic workflows** included.

✅ Auto-detects NVIDIA GPU  ✅ Installs ComfyUI Manager  ✅ Downloads manga-style models  ✅ Windows + Linux + macOS

---

### ☁️ No GPU? Run on Cloud (Recommended)

> Skip local setup entirely — launch ComfyUI on a GPU cloud server in minutes:

| Platform | Best For | Promo |
|----------|----------|-------|
| 🚀 **[RunPod](https://runpod.io?ref=ut0jez4s)** | Global users | From $0.2/hr · Persistent storage |
| ⚡ **[Aliyun](https://www.aliyun.com/minisite/goods?userCode=tdk43jyw)** | China users | 10% off for new users |
| 🌐 **[Tencent Cloud](https://curl.qcloud.com/7EQPRMGF)** | China users | New user discounts |
| 🎨 **[Liblib AI](https://www.liblib.art/viphome?referralCode=sW2nzHV5)** | Model platform | Largest Chinese SD community |

---

### 🚀 Quick Install

> 📖 **Full tutorial with screenshots** → [ryantryor.github.io/comfyui-installer](https://ryantryor.github.io/comfyui-installer/)

**Linux / macOS** (one command):
```bash
curl -sSL https://raw.githubusercontent.com/ryantryor/comfyui-installer/main/install.sh | bash
```

**Windows** (PowerShell, run as Administrator):
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
irm https://raw.githubusercontent.com/ryantryor/comfyui-installer/main/install.ps1 | iex
```

**Download workflows + manga models:**
```bash
bash download_models.sh
```

---

### 🎬 AI Manga / Comic Workflows Included

| Workflow | Use Case | Level |
|----------|----------|-------|
| `manga_character.json` | Generate manga-style characters | ⭐ Beginner |
| `manga_storyboard.json` | Batch storyboard generation | ⭐⭐ Easy |
| `coloring_workflow.json` | Auto-color line art | ⭐⭐ Easy |
| `consistent_character.json` | Character consistency (IP-Adapter) | ⭐⭐⭐ Medium |
| `batch_scene.json` | Batch scene generation | ⭐⭐⭐ Medium |

---

### ⚙️ Features

- 🖥️ **Cross-platform**: Windows / Linux / macOS
- 🔍 **Auto GPU detection**: NVIDIA CUDA or CPU fallback
- 🧩 **ComfyUI Manager** pre-installed (plugin management)
- 🎨 **Manga model pack**: 5 popular anime/manga checkpoint options
- 📦 **Portable mode** (Windows): no Python required
- 🚀 **Desktop shortcut** created automatically (Windows)
- 🌐 **HuggingFace mirror** for faster downloads in China

---

### 🛠️ Requirements

| | Minimum | Recommended |
|-|---------|-------------|
| GPU | CPU only (slow) | NVIDIA 8GB+ VRAM |
| RAM | 8 GB | 16 GB+ |
| Storage | 10 GB | 50 GB+ (for models) |
| Python | 3.10+ | 3.11 |

---

### ❓ FAQ

<details>
<summary>CUDA out of memory error?</summary>

Add `--lowvram` or `--cpu` flag when launching:
```bash
python main.py --lowvram
```
Or use a cloud GPU: [RunPod](https://runpod.io?ref=ut0jez4s)

</details>

<details>
<summary>Downloads too slow in China?</summary>

Built-in HuggingFace mirror (`hf-mirror.com`) is used automatically. For models, try:
- [Liblib AI](https://www.liblib.art/viphome?referralCode=sW2nzHV5) — China's largest model community

</details>

<details>
<summary>Can I use it without a GPU?</summary>

Yes, but it's slow (several minutes per image). Recommend cloud GPU:
- [RunPod](https://runpod.io?ref=ut0jez4s): from $0.2/hr
- [Aliyun](https://www.aliyun.com/minisite/goods?userCode=tdk43jyw): 10% off new users

</details>

---

### 📦 Recommended Resources

| Resource | Link | Notes |
|----------|------|-------|
| GPU Cloud | [RunPod](https://runpod.io?ref=ut0jez4s) | Global, from $0.2/hr |
| GPU Cloud | [Aliyun](https://www.aliyun.com/minisite/goods?userCode=tdk43jyw) | China, 10% off new users |
| GPU Cloud | [Tencent Cloud](https://curl.qcloud.com/7EQPRMGF) | China, new user deals |
| Models | [Liblib AI](https://www.liblib.art/viphome?referralCode=sW2nzHV5) | Largest CN model community |

---

### 🤝 Contributing

PRs welcome! See [CONTRIBUTING.md](CONTRIBUTING.md)

⭐ **Star this repo** if it helped you!

---

<br>

---

## 🇨🇳 中文文档

> **关键词**: ComfyUI 安装教程 | ComfyUI 一键安装 Windows | ComfyUI 安装脚本 | ComfyUI 漫画工作流 | AI漫剧制作 | AI漫画生成 | Stable Diffusion ComfyUI 教程

### 这是什么？

[ComfyUI](https://github.com/comfyanonymous/ComfyUI) 一键安装脚本，预置 **AI漫剧 / 漫画工作流模板**，全平台支持。

✅ 自动检测 NVIDIA GPU  ✅ 内置 ComfyUI Manager  ✅ 一键下载漫画风格模型  ✅ Windows + Linux + macOS

---

### ☁️ 没有本地 GPU？推荐云端运行

> 告别本地配置烦恼，一键在云端启动 ComfyUI：

| 平台 | 适合人群 | 优惠 |
|------|---------|------|
| 🚀 **[RunPod](https://runpod.io?ref=ut0jez4s)** | 全球用户 | 最低 $0.2/小时，稳定持久存储 |
| ⚡ **[阿里云](https://www.aliyun.com/minisite/goods?userCode=tdk43jyw)** | 国内用户 | **新用户专享10%折扣** |
| 🌐 **[腾讯云](https://curl.qcloud.com/7EQPRMGF)** | 国内用户 | 新用户专属特惠 |
| 🎨 **[哩布哩布AI](https://www.liblib.art/viphome?referralCode=sW2nzHV5)** | 模型平台 | 国内最大SD模型社区，VIP专属入口 |

---

### 🚀 快速安装

> 📖 **图文详细教程** → [ryantryor.github.io/comfyui-installer](https://ryantryor.github.io/comfyui-installer/)

**Linux / macOS**（一行命令）：
```bash
curl -sSL https://raw.githubusercontent.com/ryantryor/comfyui-installer/main/install.sh | bash
```

**Windows**（以管理员身份打开 PowerShell）：
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
irm https://raw.githubusercontent.com/ryantryor/comfyui-installer/main/install.ps1 | iex
```

**下载漫画模型和工作流：**
```bash
bash download_models.sh
```

---

### 🎬 内置 AI漫剧 / 漫画工作流

| 工作流文件 | 用途 | 难度 |
|----------|------|------|
| `manga_character.json` | 漫画风格人物生成 | ⭐ 入门 |
| `manga_storyboard.json` | 分镜批量生成 | ⭐⭐ 初级 |
| `coloring_workflow.json` | 线稿自动上色 | ⭐⭐ 初级 |
| `consistent_character.json` | 人物一致性保持（IP-Adapter）| ⭐⭐⭐ 中级 |
| `batch_scene.json` | 场景批量生成 | ⭐⭐⭐ 中级 |

---

### ⚙️ 功能特点

- 🖥️ **全平台**：Windows / Linux / macOS 全部支持
- 🔍 **智能检测**：自动识别 NVIDIA GPU，无GPU自动切换 CPU 模式
- 🧩 **预装 ComfyUI Manager**：插件、节点一键管理
- 🎨 **漫画模型包**：5个热门动漫/漫画大模型可选下载
- 📦 **便携包模式**（Windows）：无需提前安装 Python
- 🚀 **桌面快捷方式**：Windows 安装后自动创建
- 🌐 **HuggingFace 国内镜像**：自动加速模型下载

---

### 🛠️ 系统需求

| | 最低配置 | 推荐配置 |
|-|---------|---------|
| GPU | 仅CPU（出图慢）| NVIDIA 8GB+ 显存 |
| 内存 | 8 GB | 16 GB+ |
| 硬盘 | 10 GB | 50 GB+（存模型用）|
| Python | 3.10+ | 3.11 |

---

### ❓ 常见问题

<details>
<summary>报错 CUDA out of memory（显存不足）？</summary>

启动时加参数 `--lowvram`：
```bash
python main.py --lowvram
```
或使用云端 GPU 解决显存问题：[RunPod](https://runpod.io?ref=ut0jez4s) · [阿里云](https://www.aliyun.com/minisite/goods?userCode=tdk43jyw)

</details>

<details>
<summary>模型下载太慢？</summary>

脚本已内置 HuggingFace 国内镜像加速（`hf-mirror.com`）。也可直接在国内平台使用：
- [哩布哩布AI](https://www.liblib.art/viphome?referralCode=sW2nzHV5)：国内最大漫画模型社区

</details>

<details>
<summary>没有 GPU 也能用吗？</summary>

可以，但 CPU 出图很慢（每张需数分钟）。推荐使用云端：
- [RunPod](https://runpod.io?ref=ut0jez4s)：最低 $0.2/小时，全球可用
- [阿里云](https://www.aliyun.com/minisite/goods?userCode=tdk43jyw)：新用户10%折扣
- [腾讯云](https://curl.qcloud.com/7EQPRMGF)：新用户专属特惠

</details>

<details>
<summary>安装后如何启动 ComfyUI？</summary>

- **Linux/Mac**：`bash ~/ComfyUI/start.sh`
- **Windows**：双击桌面的 `ComfyUI` 快捷方式
- 打开浏览器访问：`http://127.0.0.1:8188`

</details>

---

### 📦 推荐资源

| 类型 | 平台 | 链接 | 优惠 |
|-----|------|------|------|
| GPU云服务器 | RunPod | [立即使用](https://runpod.io?ref=ut0jez4s) | 最低 $0.2/h，全球 |
| GPU云服务器 | 阿里云 | [立即使用](https://www.aliyun.com/minisite/goods?userCode=tdk43jyw) | **新用户10%折扣** |
| GPU云服务器 | 腾讯云 | [立即使用](https://curl.qcloud.com/7EQPRMGF) | 新用户专属优惠 |
| 模型社区 | 哩布哩布AI | [立即使用](https://www.liblib.art/viphome?referralCode=sW2nzHV5) | VIP 专属入口 |

---

### 🤝 贡献

欢迎 PR 和 Issue！

⭐ **如果这个脚本帮助了你，请点个 Star！** 这是对作者最大的支持 🙏

[🔝 回到顶部](#-comfyui-one-click-installer)
