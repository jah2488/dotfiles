# adds the current branch name in green
git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null)
  if [[ -n $ref ]]; then
    echo "[%{$fg_bold[green]%}${ref#refs/heads/}%{$reset_color%}]"
  fi
}

# when in a git repo directory.
# check the local branch sha against the repo and show me
git_status() {
  if [ -d .git ]; then
    LOCAL=$(git rev-parse --short @)
    REMOTE=$(git rev-parse --short @{u})
    if [ $LOCAL = $REMOTE ]; then
      echo "[%{$fg_bold[green]%}✔%{$reset_color%}]"
    else
      echo "[%{$fg_bold[red]%}×%{$reset_color%}]"
    fi;
  fi;
}

# makes color constants available
autoload -U colors
colors

# enable colored output from ls, etc
export CLICOLOR=1

# expand functions in the prompt
setopt prompt_subst

# prompt
export PS1='$(git_prompt_info)$(git_status)[${SSH_CONNECTION+"%{$fg_bold[green]%}%n@%m:"}%{$fg_bold[blue]%}%~%{$reset_color%}] '


### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
