# Go to the repo directory

geez-look() {
  if (( $# == 0 )); then
    echo "$fg[red]You need to specify a repo to look at!$reset_color"
    return 1
  fi

  if (( $# > 1 )); then
    echo "$fg[red]You can only look at one repo at a time!$reset_color"
    return 1
  fi

  local repo="$1"
  if [[ "$repo" =~ "^(git@github.com:|https://github.com/)[a-zA-Z0-9-]+/[a-zA-Z0-9.-]+(.git)?$" ]]; then
    repo="${${repo#*github.com(/|:)}%.git}"
  elif [[ "$repo" =~ "^[a-zA-Z0-9.-]+$" ]]; then
    local username="$(command git config github.user)"
    local exitcode=$?

    if (( $exitcode == 0 && ${#username} > 0 )) && [[ -d "$GEEZ_REPOS_PATH/$username/$repo" ]]; then
      repo="$username/$repo"
    else
      local matches
      matches=( $(command find "$GEEZ_REPOS_PATH" -type d -mindepth 1 -maxdepth 2 -iname "*${repo}*") )
      local count=${#matches}

      if (( $count == 0 )); then
        echo "$fg[red]Repo not found!$reset_color"
        return 1
      elif (( $count > 1 )); then
        echo "$fg[red]Too many matching repos!$reset_color"
        return 1
      else
        repo="${${matches[1]}#$GEEZ_REPOS_PATH/}"

        if ! [[ "$repo" =~ "/" ]]; then
          matches=( $(command find "${matches[1]}" -type d -depth 1) )

          if (( ${#matches} > 1 )); then
            echo "$fg[red]Too many matching repos!$reset_color"
            return 1
          else
            repo="${${matches[1]}#$GEEZ_REPOS_PATH/}"
          fi
        fi
      fi
    fi
  fi

  local repodir="$GEEZ_REPOS_PATH/$repo"

  if ! [[ -d "$repodir" ]]; then
    echo "$fg[red]Repo not found!$reset_color"
    return 1
  fi

  cd $repodir
}
