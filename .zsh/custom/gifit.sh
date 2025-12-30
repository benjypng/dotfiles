gifit() {
  local input="$1"

  if [[ -z "$input" ]]; then
    echo "Usage: gifit <video-file>"
    return 1
  fi

  if [[ ! -f "$input" ]]; then
    echo "File not found: $input"
    return 1
  fi

  local output="${input%.*}.gif"

  ffmpeg -i "$input" \
    -vf "scale=720:-1" \
    -r 12 \
    -f gif - | \
  gifsicle --optimize=3 --delay=8 --loopcount=0 --colors 128 > "$output"

  echo "Created $output"
}
