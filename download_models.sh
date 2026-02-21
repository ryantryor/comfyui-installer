#!/bin/bash
# ============================================================
#   ComfyUI 模型一键下载脚本 - 漫画向
#   ComfyUI Model Downloader - Manga/Anime Edition
#   GitHub: https://github.com/ryantryor/comfyui-installer
# ============================================================

set -e

# ── 推广链接 ──────────────────────────────────────────────
LIBLIB_URL="https://www.liblib.art/viphome?referralCode=sW2nzHV5"
ALIYUN_URL="https://www.aliyun.com/minisite/goods?userCode=tdk43jyw"

# ── 颜色 ──────────────────────────────────────────────────
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'
BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'

COMFYUI_DIR="${1:-$HOME/ComfyUI}"
MODELS_DIR="$COMFYUI_DIR/models"

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

# ── 模型列表（漫画/AI漫剧向）─────────────────────────────

# HuggingFace 镜像（国内加速）
HF_MIRROR="https://hf-mirror.com"  # 国内用户使用

declare -A MODELS=(
  # 大模型 Checkpoints
  ["animagine-xl-3.1"]="$HF_MIRROR/cagliostrolab/animagine-xl-3.1/resolve/main/animagine-xl-3.1.safetensors|checkpoints|Animagine XL 3.1 - 高质量二次元大模型 (5GB)"
  ["kohaku-xl"]="$HF_MIRROR/KBlueLeaf/Kohaku-XL-Epsilon/resolve/main/kohaku-xl-epsilon-rev2.safetensors|checkpoints|Kohaku XL - 日系漫画风格 (6GB)"
  ["counterfeit-v30"]="$HF_MIRROR/gsdf/Counterfeit-V3.0/resolve/main/CounterfeitV30_v30.safetensors|checkpoints|Counterfeit V3 - 精细动漫风格 (2GB)"

  # LoRA
  ["anime-lineart-lora"]="$HF_MIRROR/YOUR_REPO/anime-lineart/resolve/main/anime_lineart.safetensors|loras|线稿风格 LoRA"
  ["manga-style-lora"]="$HF_MIRROR/YOUR_REPO/manga-style/resolve/main/manga_style_v2.safetensors|loras|漫画黑白风格 LoRA"

  # ControlNet
  ["controlnet-openpose"]="$HF_MIRROR/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose.pth|controlnet|OpenPose 姿态控制"
  ["controlnet-lineart"]="$HF_MIRROR/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart.pth|controlnet|线稿控制"

  # VAE
  ["vae-anime"]="$HF_MIRROR/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors|vae|标准 VAE"
)

# ── 显示菜单 ──────────────────────────────────────────────
show_menu() {
  echo ""
  echo -e "${CYAN}${BOLD}═══ ComfyUI 漫画模型下载器 ═══${NC}"
  echo ""
  echo -e "${YELLOW}💡 国内用户提示：模型可直接在 哩布哩布AI 在线使用，无需本地下载${NC}"
  echo -e "   ${BLUE}${LIBLIB_URL}${NC}"
  echo ""
  echo -e "${BOLD}可下载的模型：${NC}"
  echo ""

  local i=1
  declare -g MODEL_KEYS=()
  for key in "${!MODELS[@]}"; do
    IFS='|' read -r url subdir desc <<< "${MODELS[$key]}"
    echo "  $i) $desc"
    MODEL_KEYS+=("$key")
    ((i++))
  done

  echo ""
  echo "  a) 全部下载 / Download All"
  echo "  q) 退出 / Quit"
  echo ""
}

# ── 下载单个模型 ──────────────────────────────────────────
download_model() {
  local key="$1"
  IFS='|' read -r url subdir desc <<< "${MODELS[$key]}"
  local filename=$(basename "$url" | cut -d'?' -f1)
  local dest="$MODELS_DIR/$subdir/$filename"

  mkdir -p "$MODELS_DIR/$subdir"

  if [[ -f "$dest" ]]; then
    log_warn "已存在，跳过: $filename"
    return
  fi

  log_info "下载: $desc"
  log_info "URL: $url"
  wget -q --show-progress --continue -O "$dest" "$url" || {
    log_warn "下载失败: $filename"
    log_warn "请尝试手动下载或使用镜像站"
    return 1
  }
  log_info "完成: $filename ✓"
}

# ── 主流程 ────────────────────────────────────────────────
main() {
  show_menu

  read -rp "$(echo -e "${YELLOW}请输入选项（多个用空格分隔，如 1 3 5）: ${NC}")" choices

  if [[ "$choices" == "q" ]]; then
    echo "退出"; exit 0
  fi

  if [[ "$choices" == "a" ]]; then
    for key in "${MODEL_KEYS[@]}"; do
      download_model "$key"
    done
  else
    for num in $choices; do
      idx=$((num-1))
      if [[ $idx -ge 0 && $idx -lt ${#MODEL_KEYS[@]} ]]; then
        download_model "${MODEL_KEYS[$idx]}"
      else
        log_warn "无效选项: $num"
      fi
    done
  fi

  echo ""
  echo -e "${GREEN}${BOLD}下载完成！${NC}"
  echo -e "模型目录: ${CYAN}$MODELS_DIR${NC}"
  echo ""
  echo -e "${YELLOW}💡 更多模型推荐 / 云服务器：${NC}"
  echo -e "   🎨 哩布哩布AI（模型社区）: ${BLUE}${LIBLIB_URL}${NC}"
  echo -e "   ⚡ 阿里云（10%新用户折扣）: ${BLUE}${ALIYUN_URL}${NC}"
}

main "$@"
