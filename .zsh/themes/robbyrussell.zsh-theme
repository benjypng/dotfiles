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

PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+=' $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
