# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="mh"

alias vim="mvim -v"
alias emacs="/usr/local/Cellar/emacs/24.5/bin/emacs"


# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
#plugins=(git rails ruby osx brew compleat cp gem vi-mode)

source $ZSH/oh-my-zsh.sh

#source ~/._rust

# Customize to your needs...
fpath=(~/.zsh/completion $fpath)

#allow comments
setopt interactivecomments

# beeps are annoying
setopt NO_BEEP

# completion
autoload -U compinit
compinit

# automatically enter directories without cd
#setopt auto_cd

# use vim as an editor
export EDITOR=vim

# aliases
if [ -e "$HOME/.aliases" ]; then
  source "$HOME/.aliases"
fi

# vi mode
bindkey -v
bindkey "^F" vi-cmd-mode
bindkey jj vi-cmd-mode

# use incremental search
bindkey "^R" history-incremental-search-backward

# add some readline keys back
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

# handy keybindings
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey -s "^T" "^[Isudo ^[A" # "t" for "toughguy"
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

# expand functions in the prompt
setopt prompt_subst

#{{{ History Stuff

# Where it gets saved
HISTFILE=~/.history

# Remember about a years worth of history (AWESOME)
SAVEHIST=10000
HISTSIZE=10000

# Don't overwrite, append!
setopt APPEND_HISTORY

# Write after each command
# setopt INC_APPEND_HISTORY

# Killer: share history between multiple shells
setopt SHARE_HISTORY

# If I type cd and then cd again, only save the last one
setopt HIST_IGNORE_DUPS
# ignore duplicate history entries
setopt histignoredups

# Even if there are commands inbetween commands that are the same, still only save the last one
# For dealing with students I may want repeats out of order
# setopt HIST_IGNORE_ALL_DUPS

# Pretty    Obvious.  Right?
setopt HIST_REDUCE_BLANKS

# If a line starts with a space, don't save it.
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE

# When using a hist thing, make a newline show the change before executing it.
setopt HIST_VERIFY

# Save the time and how long a command ran
setopt EXTENDED_HISTORY

setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

#}}}

export PATH=$PATH:~/android/android-sdk-macosx/tools
export PATH=$PATH:~/android/android-sdk-macosx/platform-tools
export ANDROID_HOME=~/android/android-sdk-macosx

# look for ey config in project dirs
export EYRC=./.eyrc

# automatically pushd
setopt auto_pushd
export dirstacksize=5

# awesome cd movements from zshkit
setopt AUTOCD
setopt AUTOPUSHD PUSHDMINUS PUSHDSILENT PUSHDTOHOME
setopt cdablevars

# Try to correct command line spelling
setopt CORRECT CORRECT_ALL

# Enable extended globbing
setopt EXTENDED_GLOB

# Homebrew Autocomplete
fpath=($HOME/.zsh/func $fpath)
typeset -U fpath

# Load RVM function

#Get size of given directory
#no directory given defaults to current directory;
sizeOf() {
  if [ "$*" = "" ]
    then
      du -sh .
    else
      du -sh "$*"
  fi
}

#Execute code inside rails console then exit.
rce() {
  expect -c "
    spawn rails c
    expect -re \".? >.?\";
    send \"$*\r\n\";
    expect -re \".? >.?\";
    send \"exit\r\n\";
    set timeout -1;"
}

#Create Command based on last command
new_command() {
  if [ "${@[-1]}" = "" ]
    then
      echo "Command needs a name"
    else
      if [ "${@[-2]}" = "" ]
        then
          echo "Command body needed"
        else
          echo ${@}
          (echo -e '#!/bin/bash\n'${@[-2]} > ~/bin/"${@[-1]}") && chmod 755 ~/bin/"${@[-1]}"
      fi
  fi
}

#find all routes with
rw() {
  echo 'be rake routes | grep $*'
  be rake routes | grep "$*"
}

rails_new() {
  echo 'rails new should run'
}

#fuzzy find file to open in vim
vop() {
  echo 'vim -o $(find * -type f | selecta)'
  vim -o $(find * -type f | selecta)
}

#fuzzy find process to kill by name
fkill() {
  echo 'ps | selecta | awk "{print $1}" | xargs kill'
  ps | selecta | awk '{print $1}' | xargs kill
}

#Open all files that contain search term from ack in vim splits
vack() {
  echo 'vim -o `ack -l $SEARCHTERM`'
  vim -o `ack -l $*`
}

#Open all files that match given pattern in current repo in vim splits
vfind() {
  vim -o `find . -name $*`
}

serve() {
  port="${1:-9000}"
  ruby -run -e httpd . -p $port
}

hist-log() {
  tail -f ~/.history | sed 's/^.*;/ /'
}

last-out() {
  tail -n 1 ~/.hist-out
}

anim-img() {
  clear && mkdir /tmp/anim-img && convert -coalesce $1 /tmp/anim-img/out%05d.png && for f in /tmp/anim-img/*; do printf '\e[H'; imgcat $f; done && rm -rf /tmp/anim-img/
}


#display markdown file in terminal; requires https://www.npmjs.com/package/nd
cat-md() {
  cat $1 | nd
}

#open-app Completions {
_open-app_complete() {
  local word completions
  word="$1"
  completions="$(open-app --auto-complete "${word}")"
  reply=( "${(ps:\n:)completions}" )
}
compctl -K _open-app_complete open-app
#} open-app Completions


#local bin/git
export PATH=~/.bin:~/.bin/git-2.2.1:$PATH

#Haskell
export PATH=~/.bin:/usr/local/bin:/usr/local/sbin:~/Library/Haskell/bin:$PATH
#ANTLR
export CLASSPATH=".:/usr/local/lib/antlr-4.1-complete.jar:$CLASSPATH"
#Elm
export PATH=~/.cabal/bin:$PATH

echo "Update Plugins? (y/n) "
read   RESPONSE
if [ "$RESPONSE" = "y" ]; then
   echo "Updating homebrew, vim plugins, haxelib, and rvm "; brew update; sh ~/update_vim_plugins.sh; haxelib upgrade; rvm get stable;
else
   echo "fine";
fi

# Pump up the ruby vm
export RUBY_GC_HEAP_INIT_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_HEAP_FREE_MIN=500000

#Haxe Path
export HAXE_STD_PATH="/usr/local/lib/haxe/std"

#Mono Path
export MONO_GAC_PREFIX="/usr/local"

eval "$(homework setup -)"



source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
. `brew --prefix`/etc/profile.d/z.sh


export PATH=~/bin:$PATH



alias sz="source ~/.zshrc"
alias ez="subl ~/.zshrc"



export PATH="$HOME/.rvm/bin:$PATH" # Add RVM to PATH for scripting
rvm use 2.2.0
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
