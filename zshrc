# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="avit"

# use vim as an editor
export VISUAL='vim'
export EDITOR=vim



alias vim="mvim -v"
alias emacs="/usr/local/Cellar/emacs/24.5/bin/emacs"

# Make nested directories and cd into them.
mkdircd() {
  mkdir -p -- "$1" && cd -P -- "$1"
}

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
#plugins=(git rails ruby osx brew compleat cp gem vi-mode)

source $ZSH/oh-my-zsh.sh

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

#ALL THE COLORS
export TERM='xterm-256color'

# POWERLINE ZSH THEME (goodnight sweet prince)
#function powerline_precmd() {
#  export PS1="$(~/.zsh/powerline-shell/powerline-shell.py $? --shell zsh 2> /dev/null)"
#}
#
#function install_powerline_precmd() {
#  for s in "${precmd_functions[@]}"; do
#    if [ "$s" = "powerline_precmd" ]; then
#      return
#    fi
#  done
#  precmd_functions+=(powerline_precmd)
#}
#
#install_powerline_precmd


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

# Android dev stuff
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


#make ruby project scaffold
proj.rb() {
  mkdir lib bin spec;
  touch readme.md
  touch spec/spec_helper.rb
}

#make elm project scaffold
proj.elm() {
  mkdir src test;
  touch README.md
  touch Main.elm
  cat <<EOF > Main.elm
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)

main : Element
main =
    collage 200 200
        [ rotate (degrees 20) (toForm (show "Hello World!")) ]
EOF
  elm-reactor &
  open http://localhost:8000/Main.elm
  %
}


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
# - This is silly and not needed, but expect -c is awesome
# - Keeping it so I don't forget expect works
rce() {
  expect -c "
    spawn rails c
    expect -re \".? >.?\";
    send \"$*\r\n\";
    expect -re \".? >.?\";
    send \"exit\r\n\";
    set timeout -1;"
}

#find all routes with
rw() {
  echo 'be rake routes | grep $*'
  be rake routes | grep "$*"
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

# Serve the current directory up as a website
serve() {
  port="${1:-9000}"
  ruby -run -e httpd . -p $port
}

# Give me all the history
hist-log() {
  tail -f ~/.history | sed 's/^.*;/ /'
}

# Last command
last-out() {
  tail -n 1 ~/.hist-out
}

# Display an animated gif on the command line
anim-img() {
  clear && mkdir /tmp/anim-img && convert -coalesce $1 /tmp/anim-img/out%05d.png && for f in /tmp/anim-img/*; do printf '\e[H'; imgcat $f; done && rm -rf /tmp/anim-img/
}

# Mkdir and cd into it
mkcd() {
  mkdir -p $1 && cd $1
}

#display markdown file in terminal; requires https://www.npmjs.com/package/nd
cat-md() {
  cat $1 | nd
}

#Hide all desktop icons/files/folders
hide-desktop() {
  defaults write com.apple.finder CreateDesktop -bool false && killall Finder;
}
#Hide all desktop icons/files/folders
show-desktop() {
  defaults write com.apple.finder CreateDesktop -bool true && killall Finder;
}

# useful aliases (kinda)
alias chrome='/usr/bin/open -a "/Applications/Google Chrome.app"'
alias themoreyouknow="chrome 'http://ak-hdl.buzzfed.com/static/2015-02/1/20/enhanced/webdr02/anigif_enhanced-buzz-20392-1422840785-34.gif'"
alias tmyk='themoreyouknow'

google() {
  chrome 'http://google.com?q='$1
}

lmgtfy() {
  chrome 'http://lmgtfy.com/?q='$1
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
   echo "Updating homebrew, vim plugins, haxelib, and rvm "; brew update; sh ~/.bin/update_vim_plugins.sh; haxelib upgrade; rvm get stable;
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


code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}

rails-t () {
  rails new $1 -d=postgresql -m https://raw.githubusercontent.com/tiy-austin-ror-may2015/tiy-template/master/template.rb
}

new-luxe () {
  cp -r /usr/local/Cellar/haxe/3.1.2/lib/haxe/lib/luxe/git/samples/empty $1 && cd $1 && echo "Done"
}
alias proj.luxe='new-luxe $1'

# Remove right prompt
export RPROMPT=''
export COMMAND_PROMPT='hi'

alias ez='vim ~/.zshrc'
alias sz='source ~/.zshrc; echo "zshrc reloaded"'

alias tiy='cd ~/tiy'

export PATH=~/bin:$PATH # Add local bin directory
export PATH="$HOME/.rvm/bin:$PATH" # Add RVM to PATH for scripting
#export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH="$PATH:/usr/local/opt/llvm/bin/"
export PATH=/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin:"${PATH}"
source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
. `brew --prefix`/etc/profile.d/z.sh

