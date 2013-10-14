#
# Author(s): Chris McClimans <chris@hippiehacker.org>,
#            Taylor Carpenter <taylor@codecafe.com>
# License: Released under the MIT License.

##### attributes / variables

edwb_release   = "2"

rebar_release  = '3.0.0'
iex_ver        = '0.10.3-dev'
erl_ver        = '5.10.2' # BEAM version (just for verification purposes)
#erl_ver        = "16B*" # 16B*

#elixir_release = 'bb4874' # or 'v0.10.2-dev'
elixir_release = "edwb-#{edwb_release}" # or 'v0.10.2-dev'
elixir_repo    = 'https://github.com/clutchanalytics/elixir'
#elixir_repo    = 'https://github.com/elixir-lang/elixir'

dynamo_release = "edwb-#{edwb_release}" # or 'elixir-0.10.0'
#dynamo_release = '82aa4c' # or 'elixir-0.10.0'
dynamo_repo    = 'https://github.com/clutchanalytics/dynamo'
#dynamo_repo    = 'https://github.com/elixir-lang/dynamo'

edwb_dir     = "/opt/depot/edwb-#{edwb_release}"
elixir_dir     = File.join(edwb_dir,"elixir")
dynamo_dir     = File.join(edwb_dir,"dynamo")
MIX_ENV = 'test'

case node['platform_family']
when 'rhel'
  pkg_prov = Chef::Provider::Package::Rpm
  packages =  %w{
    git
    wxGTK-gl
    unixODBC
  }  
  erlpkg = 'package_R16B01_centos664_1371569861/esl-erlang-R16B01-1.x86_64.rpm'
when 'debian'
  pkg_prov = Chef::Provider::Package::Dpkg
  packages = %w{
    build-essential
    git-core
    openjdk-7-jre-headless
    libwxgtk2.8-0
  }
  erlpkg = 'package_R16B01_raring64_1371559180/esl-erlang_16.b.1-1~ubuntu~raring_amd64.deb'
when 'mac_os_x'
  # TODO: Maybe use homebrew cookbook -- switch to chef-solo, solist, etc 
  pkg_prov = nil
  #erlpkg = 'package_erlang_R16B01-1_kgadek_2013.06.18_15:23:36/Erlang_R16B01_x86.dmg'
  erlpkg = 'erlang' # homebrew
  packages = []
  #$stderr.puts "#{node['platform_family'].capitalize} #{node['os'].capitalize} support coming soon :)"
when 'arch'
  pkg_prov = Chef::Provider::Package::Pacman
  erlpkg = 'erlang'
  packages = []
  #$stderr.puts "#{node['platform_family'].capitalize} #{node['os'].capitalize} support coming soon :)"
  #return
else
  $stderr.puts "Unsupported platform: #{node['platform_family'].capitalize} #{node['os'].capitalize}"
  return
end

erlpkg_file = '/tmp/esl-erlang.pkgtype'


directory edwb_dir do
  action :create
  recursive true
end

##### chef resources

packages.each do |pkg|
  package pkg
end

# TODO: Maybe switch to using Kerl for erlang installs
#       https://github.com/spawngrid/kerl
#       http://docs.basho.com/riak/1.2.1/tutorials/installation/Installing-Erlang/

if node["platform"] == "mac_os_x"
  execute "Install Homebrew versions" do 
    command "sudo -u #{ENV['SUDO_USER']} brew tap homebrew/versions"
    not_if { ::File.exists?("/usr/local/Library/Taps/homebrew-versions")}
  end

  execute 'Install erlang with Homebrew' do
    # check for running as root
    command "sudo -u #{ENV['SUDO_USER']} brew install erlang"
    #command 'brew install erlang || true'
   # not_if { ::File.exists?("/usr/local/bin/erl")}
    not_if "erl -version 2>&1| grep #{erl_ver}"

    # TODO: make it so we can look for erlang v16B01 etc
    #   1) ERL_CRASH_DUMP_SECONDS=0 erl -shutdown_time 1 -run 'exit(because)'
    #   2) iex --version (or -v) gives both but piping causes erlang to not print
    #   3) maybe kerl?

    #not_if { ::File.exists?("/usr/local/Cellar/erlang")}
    #action :nothing
  end
elsif node["platform_family"] == "arch"
  package erlpkg do
    provider pkg_prov
    not_if "erl -version 2>&1| grep #{erl_ver}"
  end
elsif node["os"] == "linux"
  # From https://www.erlang-solutions.com/downloads/download-erlang-otp
  remote_file erlpkg_file do
    source 'https://elearning.erlang-solutions.com/couchdb/rbingen_adapter/' + erlpkg
  end

  package 'esl-erlang' do
    source erlpkg_file
    provider pkg_prov
    not_if "erl -version 2>&1| grep #{erl_ver}"
  end
else
  # never should get here
  $stderr.puts "Unsupported platform: #{node['platform_family'].capitalize} #{node['os'].capitalize}"
  return
end

git elixir_dir do
  repository elixir_repo
  reference elixir_release
end

bash 'Compile and Test Elixer' do
  code <<-EOC
  make test
  EOC
  cwd elixir_dir
  timeout nil
  returns [0,2] # does the below help us understand why 2 is returned?
# Finished in 1.5 seconds (1.2s on load, 0.3s on tests)
# 93 tests, 0 failures
# ==> doctest (exunit)
# STDERR: Killed
# make: *** [test_doc_test] Error 137
# ---- End output of "bash"  "/tmp/chef-script20130807-25188-15hc020" ----
# Ran "bash"  "/tmp/chef-script20130807-25188-15hc020" returned 2
  creates "#{elixir_dir}/lib/elixir/ebin/elixir.app"
end

# TODO: see if pulling in rebar is needed as it is in the elixir repo now
if node["platform"] == "mac_os_x"
  execute 'Install rebar with Homebrew' do
    command "sudo -u #{ENV['SUDO_USER']} brew install rebar"
    not_if { ::File.exists?("/usr/local/bin/rebar")}
  end
else
  git "#{Chef::Config[:file_cache_path]}/rebar" do
    repository 'https://github.com/rebar/rebar.git'
    reference rebar_release
    notifies :run, 'execute[make rebar]'
  end

  execute 'make rebar' do
    command './bootstrap && chmod 0755 rebar'
    action :nothing
    #notifies :run, 'file[chmod rebar]'
    cwd "#{Chef::Config[:file_cache_path]}/rebar"
  end

  file "chmod rebar" do
    path "#{Chef::Config[:file_cache_path]}/rebar/rebar"
    mode 0755
    notifies :run, "link[rebar link]"
  end

  link "rebar link" do
    target_file "#{elixir_dir}/bin/rebar"
    to "#{Chef::Config[:file_cache_path]}/rebar/rebar"
  end
end

git dynamo_dir do
  repository dynamo_repo
  reference dynamo_release
  notifies :run, 'execute[make dynamo]'
end

execute 'make dynamo' do
  # warning... this uses git:// remotes http_proxies won't work
  # || true because many tests fail.. make make w/o tests?
  #command 'mix do deps.get, test || true'
  command 'mix do deps.get, test'
  environment ({
    'MIX_ENV' => MIX_ENV,
    'PATH' => "#{ENV['PATH']}:#{elixir_dir}/bin"
  })
  returns [0,1] # some https tests are failing with connection refused
  action :nothing
  cwd dynamo_dir
end

directory '/etc/profile.d' do
  action :create
  recursive true
end

# TODO: deal with existing contnets! 
file '/etc/profile.d/elixier.sh' do
  content <<-EOE
export PATH="$PATH:#{elixir_dir}/bin"
export MIX_PATH="$MIX_PATH:#{dynamo_dir}/ebin"
EOE
  action :create
  notifies :run, 'bash[Add elixir.sh to .bash_profile for OS X]'
end

bash "Add elixir.sh to .bash_profile for OS X" do
  code <<-EOC
  grep -qs /etc/profile.d/elixier.sh $HOME/.bash_profile
  if [ ! "$?" = 0 ] ; then
    echo ". /etc/profile.d/elixier.sh" | tee -a $HOME/.bash_profile
  fi
EOC
  #action :nothing
  only_if { node["platform"] == "mac_os_x" } # /etc/profile.d/* is read on most other platforms... Exceptions?
end
