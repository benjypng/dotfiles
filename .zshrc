# Path
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Additional PATH
export PATH="$PATH:/sbin"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# pnpm
export PNPM_HOME="/Users/ben/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

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

#####################
### PLUGINS START ###
#####################

# Must be after compinit
eval "$(zoxide init zsh)"

# Autosuggestions (if you want to keep this feature)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true

# This needs to be at the end of .zshrc. RTFM
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# pnpm
export PNPM_HOME="/Users/ben/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
