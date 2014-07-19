# Clone a git repo

geez-get() {
  local opt_force
  opt_force=()

  zparseopts -K -D -E f=opt_force -force=opt_force
  local force=${#opt_force}

  local repo

  if (( $# == 0 )); then
    repo="$(pbpaste)"
  else
    repo="$1"
  fi

  if ! [[ "$repo" =~ "^(git@github.com:|https://github.com/)[a-zA-Z0-9-]+/[a-zA-Z0-9.-]+.git$" ]]; then
    if [[ "$repo" =~ "^[a-zA-Z0-9-]+/[a-zA-Z0-9.-]+$" ]]; then
      repo="git@github.com:${repo%%.git}.git"
    elif [[ "$repo" =~ "^[a-zA-Z0-9.-]+$" ]]; then
      local username="$(command git config github.user)"
      local exitcode=$?

      if (( $exitcode == 0 && ${#username} > 0 )); then
        repo="git@github.com:${username}/${repo%%.git}.git"
      else
        echo "$fg[red]If you want to clone your own repos, you need to add your GitHub username to the git config file!$reset_color"
        return 1
      fi
    fi
  fi

  local repodir="$GEEZ_REPOS_PATH/${${repo#*github.com(/|:)}%.git}"

  if [[ -d "$repodir" ]]; then
    if (( $force == 0 )); then
      echo "$fg[red]You already cloned this repo!$reset_color"
      return 1
    else
      command rm -rf $repodir
    fi
  fi

  command git clone --recursive $repo $repodir > /dev/null 2>&1

  local exitcode=$?

  if (( $exitcode > 0 )); then
    echo "$fg[red]An error occured while trying to clone the repo!$reset_color"
    return $exitcode
  fi

  echo "$fg[green]Repo cloned!$reset_color"
}
