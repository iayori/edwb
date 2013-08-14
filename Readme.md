# Elixir + Dynamo Working Build Setup

This gets the most current and *stable* Elixir + Dynamo build with all dependencies.

By stable, we mean a stable working pair with all dependencies.  It may not be
what is labeled stable from those projects, but instead will be as current as
possible though it will unlikely be HEAD.

The setup currently uses Chef to manage the installs.

Installation to Your Local System
---------------------------------

## Install the pre-requisites

OS X:
 1. Install Build tools
   - [XCode](https://itunes.apple.com/us/app/xcode/id497799835)
   - [Command Line Tools](https://developer.apple.com/downloads)
   - https://github.com/kennethreitz/osx-gcc-installer

## Quick Install

```bash <(curl -fsSL https://raw.github.com/clutchanalytics/edwb/master/install.sh)``` 

## Slightly Longer Install

### Get the repository:

```
git clone https://github.com/clutchanalytics/edwb.git
```

### Install

```
  cd edwb
  # Edit recipe.rb to customize the build
  ./install.sh
```

Installing on a VM via Vagrant
------------------------------

### Install the following if needed:

 * Install VirtualBox
   - https://www.virtualbox.org/wiki/Downloads
 * Install Vagrant 
   - http://downloads.vagrantup.com/tags/v1.2.7
 * Install Vagrant Omnibus
   - run ```vagrant plugin install vagrant-omnibus```


### Get the repository:
```
git clone https://github.com/clutchanalytics/edwb.git
```

### Install
```
  cd edwb
  ./install.sh -vm
```

This builds the VM, installs and runs Elixir + Dynamo (above) on the VM.

## Create first app and test!


```
mix dynamo /tmp/mydynamo
cd /tmp/mydynamo
MIX_ENV=test mix do deps.get, test
mix server
```

Open http://localhost:4000/

---

Author
------

Current Authors:
 * [Clutch Analytics](https://github.com/clutchanalytics/)
   - [Taylor Carpenter](https://github.com/taylor)
   - [Jim Freeze](https://github.com/jfreeze/)

Originally based on work from
 * [Chris McClimans](https://github.com/hh) -- [Elixir-coolaid](https://github.com/codcafe/elixir-coolaid)
 * [Taylor Carpenter](https://github.com/taylor)
 * [Watson](https://github.com/wavell) and [Ayori](https://github.com/iayori) (walk-thru documentaion created at LSRC 2013)

Contributions
-------------

Submit a pull request

Copyright
---------

Copyright (c) 2013 Clutch Analytics, [MIT LICENSE](https://raw.github.com/clutchanalytics/elixir-dynamo-working-builds/master/LICENSE)

