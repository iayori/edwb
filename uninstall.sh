#!/bin/bash

echo "Removing edwb installed software"
sudo rm -rf /opt/depot/edwb-* ~/edwb-install

echo "Removing system profile entries"
sudo rm /etc/profile.d/elixier.sh

echo "Removing entry from $HOME/.bash_profile"
grep -qs /etc/profile.d/elixier.sh $HOME/.bash_profile
if [ "$?" = 0 ] ; then
  sed -ibak "s/^. .etc.profile.d.elixier.sh//" $HOME/.bash_profile
fi

