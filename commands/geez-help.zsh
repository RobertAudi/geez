# Show usage help

geez-help() {
  local name
  local usage
  local helpation=""
  local padding="   "

  if (( $# == 0 )); then
    name="geez - A GitHub repos manager"
    usage="geez command [command options] [arguments...]"

    helpation="COMMANDS"

    local f
    local cmdname
    local synopsis
    local helpline
    for f in $GEEZ_PATH/commands/*.zsh; do
      cmdname="${${f##*-}:t:r}"
      synopsis="$(head -1 $f)"

      if [[ "$synopsis" =~ "^# " ]]; then
        synopsis="- $(echo $synopsis | cut -c3-)"
      else
        synopsis=""
      fi

      helpline="$(printf "%-10s %s" "$cmdname" "$synopsis")"

      helpation="${helpation}\n${padding}${helpline}"
    done
  else
    echo "NOT IMPLEMENTED!!!!!"

    return
  fi

  echo "NAME"
  echo "$padding$name\n"

  echo "USAGE"
  echo "$padding$usage\n"

  echo "$helpation"
}
