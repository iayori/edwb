# Elixir + Dynamo Working Build Setup

This gets the most current and *stable* Elixir + Dynamo build with all dependencies.

By stable we mean a stable working pair with all dependencies.  It may not be
what is labeled stable from those projects, but instead will be as current as
possible though it will unlikely be HEAD.

Summary of steps:
 1. Clone repo
 2. Run installer
 3. Enjoy a stable Elixr + Dynamo setup!

The setup currently uses Chef to manage the installs.

Installation
-----

Get the repository:
```
git clone https://github.com/clutchanalytics/elixir-dynamo-working-builds.git
```

```
  cd elixir-dynamo-working-builds
  ./install.sh
```

Edit the recipe.rb to specify the versions, branches, tags for the software.

Installing on VM via Vagrant
----------------------------

 * Install VirtualBox
   - https://www.virtualbox.org/wiki/Downloads
 * Install Vagrant 
   - http://downloads.vagrantup.com/tags/v1.2.7
 * Download Image List
   - http://dlc.sun.com.edgesuite.net/virtualbox/4.2.16/SHA256SUMS
 * Install Vagrant Omnibus
   - run ```vagrant plugin install vagrant-omnibus```

TODO: Create vm-setup.sh which does above

Then run

```
vagrant up
```

which configures the VM and runs the Elixir+Dynamo installer (above) on the VM.

Author
------

Current Authors:
 * [Clutch Analytics](https://github.com/clutchanalytics/)
   - [Taylor Carpenter](https://github.com/taylor)
   - [Jim Freeze](https://github.com/jfreeze/)

Originally based on work from
 * [Chris McClimans](https://github.com/hh) -- [Elixir-coolaid](https://github.com/codcafe/elixir-coolaid)
 * [Taylor Carpenter](https://github.com/taylor)

Contributions
-------------

Submit a pull request

Copyright
---------

Copyright (c) 2013 Clutch Analytics, [MIT LICENSE](https://github.com/clutchanalytics/elixir-dynamo-working-builds/LICENSE) (see [LICENSE] for details)

