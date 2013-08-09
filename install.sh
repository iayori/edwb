#!/bin/bash

# TODO: add platform checking info.  Seee chef and rvm installers.

##### attributes / variables
myrecipe="recipe.rb"

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
