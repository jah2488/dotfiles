PARENT_REPO=`git config --get remote.origin.url`

rm "plugins_list"
echo "PARENT REPO: $PARENT_REPO"
for dir in `ls "$HOME/.vim/bundle/"`
do
  cd "$dir"
  echo "currently in $dir at `pwd`"
  CURRENT_REPO=$(git config --get remote.origin.url)
  echo "Comparing $PARENT_REPO and $CURRENT_REPO"
  if [ "$PARENT_REPO" == "$CURRENT_REPO" ]; then
    echo "empty dir: $dir"
  else
    echo "git clone $CURRENT_REPO" >> $HOME/.vim/bundle/plugins_list
  fi
  cd '..'
done
