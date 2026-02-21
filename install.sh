#!/bin/bash
# ============================================================
#   ComfyUI 一键安装脚本 (Linux / macOS)
#   ComfyUI One-Click Installer for Linux/macOS
#   GitHub: https://github.com/ryantryor/comfyui-installer
# ============================================================

set -e

# ── 颜色定义 ──────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# ── 推广链接（可替换为你自己的联盟链接）──────────────────
LIBLIB_URL="https://www.liblib.art/viphome?referralCode=sW2nzHV5"
ALIYUN_URL="https://www.aliyun.com/minisite/goods?userCode=tdk43jyw"
TENCENT_URL="https://curl.qcloud.com/7EQPRMGF"
RUNPOD_URL="https://runpod.io?ref=ut0jez4s"

# ── 版本信息 ──────────────────────────────────────────────
SCRIPT_VERSION="1.0.0"
COMFYUI_REPO="https://github.com/comfyanonymous/ComfyUI.git"
COMFYUI_MANAGER_REPO="https://github.com/ltdrdata/ComfyUI-Manager.git"

# ── 欢迎横幅 ──────────────────────────────────────────────
print_banner() {
  echo ""
  echo -e "${CYAN}${BOLD}"
  echo "  ██████╗ ██████╗ ███╗   ███╗███████╗██╗   ██╗██╗"
  echo " ██╔════╝██╔═══██╗████╗ ████║██╔════╝╚██╗ ██╔╝██║"
  echo " ██║     ██║   ██║██╔████╔██║█████╗   ╚████╔╝ ██║"
  echo " ██║     ██║   ██║██║╚██╔╝██║██╔══╝    ╚██╔╝  ██║"
  echo " ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║        ██║   ██║"
  echo "  ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝        ╚═╝   ╚═╝"
  echo -e "${NC}"
  echo -e "${BOLD}  ComfyUI 一键安装脚本 v${SCRIPT_VERSION}${NC}"
  echo -e "  GitHub: ${BLUE}https://github.com/ryantryor/comfyui-installer${NC}"
  echo ""
  echo -e "${YELLOW}  💡 没有 GPU？推荐使用云端平台：${NC}"
  echo -e "     🎨 哩布哩布AI（模型平台）: ${BLUE}${LIBLIB_URL}${NC}"
  echo -e "     ⚡ 阿里云（新用户10%折扣）: ${BLUE}${ALIYUN_URL}${NC}"
  echo -e "     🌐 腾讯云:               ${BLUE}${TENCENT_URL}${NC}"
  echo -e "     🚀 RunPod（海外GPU云）:  ${BLUE}${RUNPOD_URL}${NC}"
  echo ""
  echo -e "  ─────────────────────────────────────────────────"
  echo ""
}

# ── 工具函数 ──────────────────────────────────────────────
log_info()    { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
log_step()    { echo -e "\n${CYAN}${BOLD}>>> $1${NC}"; }

confirm() {
  read -rp "$(echo -e "${YELLOW}$1 [y/N]: ${NC}")" ans
  [[ "$ans" =~ ^[Yy]$ ]]
}

# ── 系统检测 ──────────────────────────────────────────────
detect_system() {
  log_step "检测系统环境 / Detecting system..."

  OS=$(uname -s)
  case "$OS" in
    Linux*)  SYSTEM="Linux" ;;
    Darwin*) SYSTEM="Mac" ;;
    *)       log_error "不支持的操作系统: $OS" ;;
  esac
  log_info "操作系统: $SYSTEM"

  # 检测 GPU
  if command -v nvidia-smi &>/dev/null; then
    GPU_INFO=$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -1)
    log_info "检测到 NVIDIA GPU: ${GPU_INFO}"
    HAS_NVIDIA=true
  else
    log_warn "未检测到 NVIDIA GPU，将使用 CPU 模式（速度较慢）"
    log_warn "💡 推荐使用云端服务器: ${ALIYUN_URL}"
    HAS_NVIDIA=false
  fi

  # 检测 Python
  if command -v python3 &>/dev/null; then
    PYTHON_VER=$(python3 --version 2>&1 | awk '{print $2}')
    log_info "Python 版本: $PYTHON_VER"
  else
    log_error "未找到 Python3，请先安装 Python 3.10+"
  fi

  # 检测 Git
  if ! command -v git &>/dev/null; then
    log_error "未找到 Git，请先安装 Git"
  fi
  log_info "Git: $(git --version)"
}

# ── 安装依赖 ──────────────────────────────────────────────
install_dependencies() {
  log_step "安装系统依赖 / Installing dependencies..."

  if [[ "$SYSTEM" == "Linux" ]]; then
    if command -v apt-get &>/dev/null; then
      sudo apt-get update -qq
      sudo apt-get install -y git python3 python3-pip python3-venv wget curl libgl1 libglib2.0-0
    elif command -v yum &>/dev/null; then
      sudo yum install -y git python3 python3-pip wget curl
    fi
  elif [[ "$SYSTEM" == "Mac" ]]; then
    if ! command -v brew &>/dev/null; then
      log_warn "未找到 Homebrew，跳过系统依赖安装"
    else
      brew install git python3 wget
    fi
  fi
  log_info "依赖安装完成 ✓"
}

# ── 克隆 ComfyUI ──────────────────────────────────────────
clone_comfyui() {
  log_step "下载 ComfyUI / Cloning ComfyUI..."

  INSTALL_DIR="${1:-$HOME/ComfyUI}"
  if [[ -d "$INSTALL_DIR" ]]; then
    log_warn "目录已存在: $INSTALL_DIR"
    if confirm "是否覆盖安装？"; then
      rm -rf "$INSTALL_DIR"
    else
      log_info "跳过克隆，使用已有目录"
      return
    fi
  fi

  git clone --depth=1 "$COMFYUI_REPO" "$INSTALL_DIR"
  INSTALL_DIR="$INSTALL_DIR"
  log_info "ComfyUI 下载完成 ✓ → $INSTALL_DIR"
}

# ── 创建虚拟环境并安装 Python 依赖 ──────────────────────
setup_venv() {
  log_step "配置 Python 虚拟环境 / Setting up venv..."

  cd "$INSTALL_DIR"
  python3 -m venv venv
  source venv/bin/activate

  pip install --upgrade pip -q

  if [[ "$HAS_NVIDIA" == true ]]; then
    log_info "安装 PyTorch (CUDA 版本)..."
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 -q
  else
    log_info "安装 PyTorch (CPU 版本)..."
    pip install torch torchvision torchaudio -q
  fi

  pip install -r requirements.txt -q
  log_info "Python 依赖安装完成 ✓"
}

# ── 安装 ComfyUI Manager ──────────────────────────────────
install_manager() {
  log_step "安装 ComfyUI Manager（插件管理器）..."

  cd "$INSTALL_DIR/custom_nodes"
  if [[ -d "ComfyUI-Manager" ]]; then
    log_info "ComfyUI Manager 已存在，跳过"
  else
    git clone --depth=1 "$COMFYUI_MANAGER_REPO"
    log_info "ComfyUI Manager 安装完成 ✓"
  fi
}

# ── 下载基础模型（可选）───────────────────────────────────
download_models() {
  log_step "模型下载 / Model Download"

  echo ""
  echo -e "${BOLD}请选择要下载的模型（可多选）：${NC}"
  echo "  1) SDXL Base 1.0 (6.5GB) - 推荐"
  echo "  2) SD 1.5 (2GB) - 轻量版"
  echo "  3) Flux.1 Dev (22GB) - 最新高质量"
  echo "  4) 跳过，手动下载 / Skip"
  echo ""
  read -rp "$(echo -e "${YELLOW}请输入选项（如 1 2）: ${NC}")" model_choices

  mkdir -p "$INSTALL_DIR/models/checkpoints"

  for choice in $model_choices; do
    case "$choice" in
      1)
        log_info "下载 SDXL Base..."
        wget -q --show-progress -O "$INSTALL_DIR/models/checkpoints/sd_xl_base_1.0.safetensors" \
          "https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors"
        ;;
      2)
        log_info "下载 SD 1.5..."
        wget -q --show-progress -O "$INSTALL_DIR/models/checkpoints/v1-5-pruned-emaonly.ckpt" \
          "https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt"
        ;;
      3)
        log_warn "Flux.1 Dev 需要 HuggingFace 账号，请参考文档手动下载"
        log_warn "文档: https://github.com/ryantryor/comfyui-installer#flux"
        ;;
      4)
        log_info "跳过模型下载"
        break
        ;;
    esac
  done

  echo ""
  echo -e "${YELLOW}💡 提示：国内用户推荐从 哩布哩布AI 下载模型（更快）：${NC}"
  echo -e "   ${BLUE}${LIBLIB_URL}${NC}"
}

# ── 创建启动脚本 ──────────────────────────────────────────
create_launcher() {
  log_step "创建启动脚本 / Creating launcher..."

  LAUNCHER="$INSTALL_DIR/start.sh"
  cat > "$LAUNCHER" <<EOF
#!/bin/bash
# ComfyUI 启动脚本
cd "$(dirname "\$0")"
source venv/bin/activate
echo "正在启动 ComfyUI..."
echo "浏览器访问: http://127.0.0.1:8188"
python main.py --listen 0.0.0.0 --port 8188 \$@
EOF
  chmod +x "$LAUNCHER"
  log_info "启动脚本创建完成: $LAUNCHER ✓"
}

# ── 安装漫画工作流包（可选）──────────────────────────────
install_manga_workflows() {
  if confirm "是否安装 AI漫剧工作流模板包？"; then
    log_step "下载漫画工作流模板..."
    mkdir -p "$INSTALL_DIR/user/default/workflows"
    # 从 GitHub release 下载工作流包
    wget -q --show-progress -O /tmp/manga-workflows.zip \
      "https://github.com/ryantryor/comfyui-installer/releases/latest/download/manga-workflows.zip" \
      && unzip -q /tmp/manga-workflows.zip -d "$INSTALL_DIR/user/default/workflows/" \
      || log_warn "工作流下载失败，可稍后手动安装"
    log_info "漫画工作流安装完成 ✓"
  fi
}

# ── 完成提示 ──────────────────────────────────────────────
print_done() {
  echo ""
  echo -e "${GREEN}${BOLD}"
  echo "  ╔══════════════════════════════════════════╗"
  echo "  ║     ComfyUI 安装成功！Installation OK!   ║"
  echo "  ╚══════════════════════════════════════════╝"
  echo -e "${NC}"
  echo -e "  📂 安装目录: ${CYAN}$INSTALL_DIR${NC}"
  echo -e "  🚀 启动命令: ${CYAN}bash $INSTALL_DIR/start.sh${NC}"
  echo -e "  🌐 访问地址: ${CYAN}http://127.0.0.1:8188${NC}"
  echo ""
  echo -e "${BOLD}  ─── 推荐资源 / Recommended Resources ──────────${NC}"
  echo -e "  🎨 模型下载（哩布哩布AI）:     ${BLUE}${LIBLIB_URL}${NC}"
  echo -e "  🚀 GPU云（RunPod 海外）:       ${BLUE}${RUNPOD_URL}${NC}"
  echo -e "  ⚡ 云服务器（阿里云 10%折扣）: ${BLUE}${ALIYUN_URL}${NC}"
  echo -e "  🌐 云服务器（腾讯云）:         ${BLUE}${TENCENT_URL}${NC}"
  echo -e "  📖 使用教程:               ${BLUE}https://github.com/ryantryor/comfyui-installer/wiki${NC}"
  echo ""
  echo -e "  ⭐ 如果脚本对你有帮助，请给 GitHub 仓库点个 Star！"
  echo -e "  ${BLUE}https://github.com/ryantryor/comfyui-installer${NC}"
  echo ""
}

# ── 主流程 ────────────────────────────────────────────────
main() {
  print_banner

  echo -e "${BOLD}ComfyUI 将安装到哪里？${NC}"
  read -rp "$(echo -e "${YELLOW}安装路径 [默认: $HOME/ComfyUI]: ${NC}")" custom_dir
  INSTALL_DIR="${custom_dir:-$HOME/ComfyUI}"

  detect_system
  install_dependencies
  clone_comfyui "$INSTALL_DIR"
  setup_venv
  install_manager
  download_models
  install_manga_workflows
  create_launcher
  print_done
}

main "$@"
