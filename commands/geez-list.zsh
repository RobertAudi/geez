# List cloned repos

geez-list() {
  local repos
  repos=( $(command find $GEEZ_REPOS_PATH -type d -name ".git") )

  if (( ${#repos} == 0 )); then
    echo "$fg[yellow]You did not clone any repos yet$reset_color"
    return 0
  fi

  echo "$fg[green]Found ${#repos} repos$reset_color"

  local repo
  for repo in $repos; do
    echo "${${repo#$GEEZ_REPOS_PATH/}%/.git}"
  done
}
