# Elixir + Dynamo Working Build Setup

This gets a working STABLE Elixir + Dynamo build with all dependencies.

The setup uses Chef to manage the installs.

Summary of steps:
 1. Clone repo
 2. Start install
 3. Enjoy Elixr + Dynamo!

Usage
-----

```git clone
To use install http://www.opscode.com/chef/install/ on centos 6 or ubuntu 13.04 

Usually that simply means:

```curl -L https://www.opscode.com/chef/install.sh | sudo bash```

Install GIT if it is not already installed:
 * Ubuntu/Debian: ```sudo apt-get install -y git```
 * Centos: ```sudo yum install -y git```

Download this repo with ```git clone https://github.com/codecafe/coolaid.git```

Edit the coolaid/recipe.rb to specify the versions, branches, tags for the software.

Then let Chef do the rest by running ```chef-apply coolaid/recipe.rb```


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
   - [Jim Freeze](https://github.com/jfreeze/)
   - [Taylor Carpenter](https://github.com/taylor)

Original authors:

 * [Chris McClimans](https://github.com/hh)
 * [Taylor Carpenter](https://github.com/taylor)

Contributions
-------------

Submit a pull request

Copyright
---------

Copyright (c) 2013 Clutch Analytics, CodeCafe [MIT LICENSE](https://github.com/clutchanalytics/elixir-dynamo-working-builds/LICENSE) (see [LICENSE] for details)
