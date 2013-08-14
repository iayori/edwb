#!/bin/bash

sudo rm -rf /opt/depot/edwb-* /etc/profile.d/elixier.sh ~/edwb-install

grep -qs /etc/profile.d/elixier.sh $HOME/.bash_profile
if [ "$?" = 0 ] ; then
  sed -ibak "s/^. .etc.profile.d.elixier.sh//" $HOME/.bash_profile
fi

