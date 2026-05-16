#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/benjypng/dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
NVM_VERSION="${NVM_VERSION:-v0.40.1}"

SUDO=""
if [[ $EUID -ne 0 ]] && command -v sudo >/dev/null 2>&1; then
  SUDO="sudo"
fi

install_packages() {
  local pkgs=(zsh neovim zoxide zsh-autosuggestions zsh-syntax-highlighting git curl)

  if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew >/dev/null 2>&1; then
      echo "Homebrew not found. Install from https://brew.sh first." >&2
      exit 1
    fi
    brew install "${pkgs[@]}"
  elif command -v dnf >/dev/null 2>&1; then
    $SUDO dnf install -y "${pkgs[@]}"
  elif command -v pacman >/dev/null 2>&1; then
    $SUDO pacman -Syu --needed --noconfirm "${pkgs[@]}"
  else
    echo "Unsupported system. This script supports macOS, Fedora, and Arch only." >&2
    exit 1
  fi
}

install_nvm() {
  if [[ -d "$HOME/.nvm" ]]; then
    return
  fi
  PROFILE=/dev/null bash -c \
    "curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash"
}

clone_dotfiles() {
  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    git -C "$DOTFILES_DIR" fetch --depth=1 origin
    git -C "$DOTFILES_DIR" reset --hard origin/HEAD
  else
    rm -rf "$DOTFILES_DIR"
    git clone --depth=1 "$DOTFILES_REPO" "$DOTFILES_DIR"
  fi
}

link() {
  local src="$1" dst="$2"
  rm -rf "$dst"
  ln -s "$src" "$dst"
  echo "linked $dst -> $src"
}

link_configs() {
  mkdir -p "$HOME/.config"
  link "$DOTFILES_DIR/.zshrc"       "$HOME/.zshrc"
  link "$DOTFILES_DIR/.zsh"         "$HOME/.zsh"
  link "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
}

set_default_shell() {
  local zsh_bin
  zsh_bin="$(command -v zsh)"
  if [[ "${SHELL:-}" == "$zsh_bin" ]]; then
    return
  fi
  if ! grep -qx "$zsh_bin" /etc/shells 2>/dev/null; then
    echo "$zsh_bin" | $SUDO tee -a /etc/shells >/dev/null || true
  fi
  chsh -s "$zsh_bin" || echo "Could not chsh automatically. Run: chsh -s $zsh_bin"
}

install_packages
install_nvm
clone_dotfiles
link_configs
set_default_shell

echo
echo "Done. Start zsh now with: exec zsh"
