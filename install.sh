#!/bin/bash

# TODO: add platform checking info.  Seee chef and rvm installers.

##### attributes / variables
myrecipe="recipe.rb"

kernel_name=$(uname -s)
## FUNCTIONS

eecho() {
  echo $@ 1>&2
}

have_bin() {
  binname="$1"
  altpath="$2"
  eecho "looking for $binname"
  found="$(which "$binname" 2> /dev/null)"
  ([[ -n "$found" ]] ||
    ([[ -n "$altpath" ]] && [[ -x "$altpath/$binname" ]]))
}

install_homebrew() {
  ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
}

case $kernel_name in
  Darwin)
    # TODO: check for gcc
    # see the command line installer gcc stuff
    if [ ! -d /usr/local/Cellar ] ; then
      install_homebrew
    fi
    ;;
esac


have_bin git
if [ "$1" = 1 ] ; then
  case $kernel_name in
    Darwin)
      echo "Installing git"
      ;;
    Linux)
      echo "Install GIT and try again"
      ;;
    *)
      echo "Install GIT and try again"
      ;;
  esac
fi

## Install Chef
have_bin chef-apply /opt/chef/bin
if [ $? = 1 ] ; then
  echo -n "Press ENTER to download and install Chef or CTRL-C to exit"
  read resp
  sudo true
  #curl -L https://www.opscode.com/chef/install.sh | sudo bash

  have_bin chef-apply /opt/chef/bin
  if [ $? = 1 ] ; then
    eecho "Failed to find or install Chef!"
    exit 1
  fi
fi

chef_apply=`which chef-apply 2> /dev/null || echo /opt/chef/bin/chef-apply`

echo "Starting the install of all other components including Elixir and Dynamo!"
sudo $chef_apply $myrecipe
