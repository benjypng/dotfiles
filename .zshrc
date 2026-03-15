# OS Detection
if [[ "$OSTYPE" == "darwin"* ]]; then
  IS_MACOS=true
else
  IS_MACOS=false
fi

# Homebrew (sets HOMEBREW_PREFIX and adds brew to PATH)
if [[ "$IS_MACOS" == true ]]; then
  [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"   # Apple Silicon
  [[ -x /usr/local/bin/brew ]] && eval "$(/usr/local/bin/brew shellenv)"         # Intel Mac
else
  [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Additional PATH
export PATH="/usr/local/bin:$PATH"
export PATH="$PATH:/sbin"

# NVM
export NVM_DIR="$HOME/.nvm"
_nvm_brew_prefix="$(brew --prefix nvm 2>/dev/null)"
if [[ -s "$_nvm_brew_prefix/nvm.sh" ]]; then
  source "$_nvm_brew_prefix/nvm.sh"
  [[ -s "$_nvm_brew_prefix/etc/bash_completion.d/nvm" ]] && source "$_nvm_brew_prefix/etc/bash_completion.d/nvm"
elif [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
fi
unset _nvm_brew_prefix

# pnpm
if [[ "$IS_MACOS" == true ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="$HOME/.local/share/pnpm"
fi
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Language
export LANG=en_US.UTF-8

# Enable prompt substitution
setopt prompt_subst

# Enable colors
autoload -U colors && colors

# Enable theme
source ~/.zsh/themes/robbyrussell.zsh-theme

# Aliases
alias vim="nvim"
alias c="clear"
alias la="ls -la"
alias py="python3"
alias openclaw="~/.npm-global/bin/openclaw"

# Gif It
source ~/.zsh/custom/gifit.sh

#####################
### PLUGINS START ###
#####################

# Must be after compinit
eval "$(zoxide init zsh)"

# Autosuggestions
_autosuggest_paths=(
  "$(brew --prefix zsh-autosuggestions 2>/dev/null)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
)
for _p in "${_autosuggest_paths[@]}"; do
  [[ -s "$_p" ]] && { source "$_p"; break; }
done
unset _autosuggest_paths _p
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true

# Syntax highlighting — must be at end of .zshrc
_syntax_paths=(
  "$(brew --prefix zsh-syntax-highlighting 2>/dev/null)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
)
for _p in "${_syntax_paths[@]}"; do
  [[ -s "$_p" ]] && { source "$_p"; break; }
done
unset _syntax_paths _p

# macOS/Homebrew-specific paths
if [[ "$IS_MACOS" == true ]] && command -v brew &>/dev/null; then
  _pg_bin="$(brew --prefix postgresql@15 2>/dev/null)/bin"
  [[ -d "$_pg_bin" ]] && export PATH="$_pg_bin:$PATH"
  _lsof_bin="$(brew --prefix lsof 2>/dev/null)/bin"
  [[ -d "$_lsof_bin" ]] && export PATH="$_lsof_bin:$PATH"
  unset _pg_bin _lsof_bin
fi
