# Elixir + Dynamo Working Build Setup

This gets a working STABLE Elixir + Dynamo build with all dependencies.

The setup uses Chef to manage the installs.

Summary of steps:
 1. Clone repo
 2. Start install
 3. Enjoy Elixr + Dynamo!

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

Testing with Vagrant
--------------------

 * Install VirtualBox
 * Install Vagrant -- http://downloads.vagrantup.com/tags/v1.2.7
 * Download http://dlc.sun.com.edgesuite.net/virtualbox/4.2.16/SHA256SUMS

Then run

```
vagrant plugin install vagrant-omnibus
vagrant up
```

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

