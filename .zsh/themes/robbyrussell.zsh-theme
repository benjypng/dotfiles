# Enable dynamic prompt updates
setopt prompt_subst

# Minimal Git Status Function
function git_prompt_info() {
  # Only run if inside a git repo
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    return
  fi

  # Get branch name or short SHA
  local ref=$(git symbolic-ref HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null)
  ref="${ref#refs/heads/}"

  # Add a space before the X if the repo is dirty
  local status_marker=""
  if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
    status_marker=" %F{yellow}✗"
  fi

  # Output: git:(main) ✗ 
  echo "%F{blue}git:(%F{red}${ref}%F{blue})%f${status_marker} "
}

# Prompt Construction
# %c = current folder only | %f = reset color
PROMPT='%(?:%F{green}➜ :%F{red}➜ ) %F{cyan}%c%f $(git_prompt_info)'
