# Enable dynamic prompt updates
setopt prompt_subst

# ── Monokai palette ───────────────────────────────────────────────────
# bg #272822  fg #F8F8F2  pink #F92672  rose #EB6F92 (muted pink)
# green #A6E22E  yellow #E6DB74  orange #FD971F  red #FF4757

# Git prompt — block changes color & shape based on state:
#   clean  : green block    branch
#   dirty  : red block      branch ●N  (N = modified files, light fg)
function git_prompt_info() {
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    return
  fi

  local ref=$(git symbolic-ref HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null)
  ref="${ref#refs/heads/}"

  local porcelain=$(git status --porcelain 2>/dev/null)
  if [[ -z "$porcelain" ]]; then
    # Clean: green block, dark text
    echo "%K{#A6E22E}%F{#272822} ${ref} %f%k%F{#A6E22E}%f "
  else
    # Dirty: red block, light text, file count
    local count=$(echo "$porcelain" | wc -l | tr -d ' ')
    echo "%K{#FF4757}%F{#F8F8F2}%B ${ref} ●${count} %b%f%k%F{#FF4757}%f "
  fi
}

# Prompt: arrow + muted-rose directory block + git block
PROMPT='%(?:%F{#A6E22E}%B➜%b%f :%F{#FF4757}%B➜%b%f )%K{#EB6F92}%F{#272822}%B %c %b%f%k%F{#EB6F92}%f $(git_prompt_info)'
