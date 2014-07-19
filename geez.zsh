#######################################
#######################################
###     ____                        ###
###    / ___|   ___    ___   ____   ###
###   | |  _   / _ \  / _ \ |_  /   ###
###   | |_| | |  __/ |  __/  / /    ###
###    \____|  \___|  \___| /___|   ###
###                                 ###
#######################################
#######################################

export GEEZ_REPOS_PATH="$HOME/.geez.repos.d"

! [[ -d $GEEZ_REPOS_PATH ]] && command mkdir -p $GEEZ_REPOS_PATH

export GEEZ_PATH="$(builtin cd $(command dirname $0) ; command pwd -P)"

for f in $GEEZ_PATH/commands/*.zsh; do
  source $f
done

geez() {
  if (( $# == 0 )); then
    geez-help

    return 1
  fi

  if [[ "$1" =~ "^-h\$|^(--)?help\$" ]]; then
    geez-help

    return 0
  fi

  if [[ "$1" =~ "^-v\$|^(--)?version\$" ]]; then
    geez-version

    return 0
  fi

  if [[ "$1" =~ "^-" ]]; then
    echo "$fg[red]geez: Invalid option ${1}$reset_color"

    geez-help

    return 1
  fi

  local cmd="geez-$1"
  shift

  if ! type $cmd > /dev/null; then
    echo "$fg[red]geez: No such command ${1}$reset_color"

    geez-help

    return 1
  fi

  eval $cmd $@
}
