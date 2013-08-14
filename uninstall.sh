#!/bin/bash

echo "Removing edwb installed software under /opt/depot/edwb-*"
sudo rm -rf /opt/depot/edwb-*

echo "Removing system profile entries"
sudo rm -v /etc/profile.d/elixier.sh

echo "Removing entry from $HOME/.bash_profile"
grep -qs /etc/profile.d/elixier.sh $HOME/.bash_profile
if [ "$?" = 0 ] ; then
  sed -ibak "s/^. .etc.profile.d.elixier.sh//" $HOME/.bash_profile
fi

mypath=$(dirname $0)
[[ "$mypath" = "." ]] && mypath=`pwd`

echo "You can remove the install directory at $mypath/$me"
