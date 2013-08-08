# Elixir + Dynamo Working Build Setup

This gets the most current and *stable* Elixir + Dynamo build with all dependencies.

By stable, we mean a stable working pair with all dependencies.  It may not be
what is labeled stable from those projects, but instead will be as current as
possible though it will unlikely be HEAD.

The setup currently uses Chef to manage the installs.

Installation to Your Local System
-----

### Get the repository:
```
git clone https://github.com/clutchanalytics/elixir-dynamo-working-builds.git
```

### Install
```
  cd elixir-dynamo-working-builds
  # Edit recipe.rb to customize the build
  ./install.sh
```

Installing on a VM via Vagrant
-----

### Install the following if needed:

 * Install VirtualBox
   - https://www.virtualbox.org/wiki/Downloads
 * Install Vagrant 
   - http://downloads.vagrantup.com/tags/v1.2.7
 * Install Vagrant Omnibus
   - run ```vagrant plugin install vagrant-omnibus```


### Get the repository:
```
git clone https://github.com/clutchanalytics/elixir-dynamo-working-builds.git
```

### Install
```
  cd elixir-dynamo-working-builds
  ./install.sh -vm
```

This builds the VM, installs and runs Elixir + Dynamo (above) on the VM.

Author
------

Current team:
 * [Clutch Analytics](https://github.com/clutchanalytics/)
   - [Taylor Carpenter](https://github.com/taylor)
   - [Jim Freeze](https://github.com/jfreeze/)

Original authors:

 * [Chris McClimans](https://github.com/hh)
 * [Taylor Carpenter](https://github.com/taylor)

Contributions
-------------

Submit a pull request

Copyright
---------

Copyright (c) 2013 Clutch Analytics, [MIT LICENSE](https://github.com/clutchanalytics/elixir-dynamo-working-builds/LICENSE) (see [LICENSE] for details)

