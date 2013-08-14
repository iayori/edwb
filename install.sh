#!/bin/bash

# TODO: add platform checking info.  Seee chef and rvm installers.

##### attributes / variables
myrecipe="recipe.rb"
repourl="https://github.com/clutchanalytics/edwb.git"

VERBOSE=0
[[ "$1" = "-v" ]] &&
  VERBOSE=1 && shift

kernel_name=$(uname -s)

chef_opts=""

########################################################################
## Utility FUNCTIONS

eecho() {
  echo $@ 1>&2
}

have_bin() {
  binname="$1"
  altpath="$2"
  [[ $VERBOSE = 1 ]] && eecho "looking for $binname"
  found="$(which "$binname" 2> /dev/null)"
  ([[ -n "$found" ]] ||
    ([[ -n "$altpath" ]] && [[ -x "$altpath/$binname" ]]))
}

########################################################################
## System package manager

pkgmr=""
case $kernel_name in
  Darwin)
    pkgmgr="brew"
    ;;
  Linux)
    have_bin pacman
    if [ "$?" = "0" -a -z "$pkgmgr" ] ; then
      pkgmgr="pacman"
    else
      have_bin apt-get
    fi

    if [ "$?" = "0" -a -z "$pkgmgr" ] ; then
      pkgmgr="apt-get"
    else
      have_bin yum
    fi
    if [ "$?" = "0" -a -z "$pkgmgr" ] ; then
      pkgmgr="yum"
    fi
    ;;
  *)
    eecho "Unsupported Platform: $kernel_name"
    ;;
esac


########################################################################
## Installer functions


# TODO: maybe use chef recipe
install_homebrew() {
  [[ -x /usr/local/bin/brew ]] && return
  [[ -n "$DRYRUN" ]] && return
  echo "Installing homebrew via https://raw.github.com/mxcl/homebrew/go"

  ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)" &&
    brew doctor
  if [ ! $? = 0 -o ! -x /usr/local/bin/brew ] ; then
    eecho "ERROR: Problem installing Homebrew!"
    exit 1
  fi
}

install_chef() {
  ## Install Chef
  have_bin chef-apply /opt/chef/bin
  if [ $? = 1 ] ; then
    echo "Installing Chef..."
    [ -n "$DRYRUN" ] && return

    echo "getting the chef"

    sudo true &&
      curl -L https://www.opscode.com/chef/install.sh | sudo bash

    have_bin chef-apply /opt/chef/bin
    if [ $? = 1 -a -z "$DRYRUN" ] ; then
      eecho "ERROR: Problem finding/installing Chef!"
      exit 1
    fi
  fi
}

install_osx_java() {
  if [ ! -f /System/Library/Frameworks/JavaVM.framework/JavaVM ] ; then
    # For Lion simply run java to have a pop-up happen for install
    java -version
  fi
}


########################################################################
## Parse args

while [ true ] ; do
  case $1 in
    -vm)
      echo "Coming soon"
      exit 0
      ;;
    *)
      shift
      ;;
  esac
  [[ -z "$1" ]] && break
done


########################################################################
## Setup the basics

case $kernel_name in
  Darwin)
    if [ -z `which gcc` ] ; then
      eecho "No compiler found.  Please install XCode or Command Line Tools"
      exit 1
    fi

    install_osx_java
    install_homebrew
    ;;
esac

have_bin git
if [ "$1" = 1 ] ; then
  case $kernel_name in
    Darwin)
      echo "Installing git"
      brew install git
      ;;
    Linux)
      echo "Installing git"
      $pkgmgr install -y git
      ;;
    *)
      echo "Install GIT and try again"
      ;;
  esac
fi

install_chef

### Clone our repo, setup chef, and run it

repodir="$HOME/edwb-install"

if [ -d "$repodir" ] ; then
  echo "Using existing installer checkout"
  cd "$repodir" && git pull
else
  git clone "$repourl" "$repodir"
fi

cd $repodir

chef_apply=`which chef-apply 2> /dev/null || echo /opt/chef/bin/chef-apply`

[[ "$VERBOSE" = 1 ]] &&
  chef_opts="$chef_opts -v"

echo "Running chef-apply"
[ -z "$DRYRUN" ] &&
  sudo $chef_apply $myrecipe
