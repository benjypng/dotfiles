# # robbyrussell ZSH Theme (modified version without Oh My Zsh dependencies)
#
# Git prompt function
function git_prompt_info() {
  # Check if we're in a git repository
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    return
  fi

  # Get the current branch name or commit hash
  local ref
  ref=$(git symbolic-ref HEAD 2> /dev/null) || ref=$(git rev-parse --short HEAD 2> /dev/null) || return

  # Remove 'refs/heads/' from the beginning of the branch name
  ref="${ref#refs/heads/}"

  # Check if the working directory is dirty
  local dirty
  if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
    dirty="$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    dirty="$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi

  # Output the git information
  echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref}${dirty}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}
# robbyrussell ZSH Theme - Debug Version

# PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%}"
# PROMPT+=' $(git_prompt_info)'
#
# ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
# ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
# ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# Rose Pine Color Palette
local text='#e0def4'
local love='#eb6f92'
local gold='#f6c177'
local rose='#ea9a97'
local pine='#3e8fb0'
local foam='#9ccfd8'
local iris='#c4a7e7'

PROMPT="%(?:%F{$pine}%1{➜%} :%F{$love}%1{➜%} ) %F{$foam}%c%f"
PROMPT+=' $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%F{$iris}git:(%F{$rose}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f "
ZSH_THEME_GIT_PROMPT_DIRTY="%F{$iris}) %F{$gold}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{$iris})"
