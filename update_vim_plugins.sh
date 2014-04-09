#!/bin/sh

PLUGINS="$HOME/.vim/bundle/"

IFS=$'\n'
cd $PLUGINS

for plugin in `ls "$PLUGINS/"`
do
  if [ -d "$PLUGINS/$plugin" ]; then
    echo "Updating $plugin"
    cd "$plugin"
    git pull
    cd '..'
  fi
done
