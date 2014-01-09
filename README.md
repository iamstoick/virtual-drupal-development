Vagrant Drupal Development
==========================

Vagrant Drupal Development (VDD) is fully configured and ready to use
development environment built on Linux (Ubuntu 12) with Vagrant, VirbualBox and
Chef Solo provisioner. VDD is virtualized environment, so your base system will
not be changed and remain clean after installation. You can create and delete as
much environments as you wish without any consequences.

Note: VDD works great with 6, 7 and 8 versions of Drupal.

The main goal of the project is to provide easy to use fully functional and
highly customizable Linux based environment for Drupal development.

Setup is very simple, fast and can be performed on Windows, Linux or Mac
platforms. It's simple to clone ready environment to your Laptop or home
computer and then keep it synchronized.

If you don't familiar with Vagrant, please read about it. Documentation is very
simple to read and understand. http://docs.vagrantup.com/v2/

To start VDD you don't need to write your Vagrantfile. All configurations can be
done inside simple JSON configuration file.


Out of the box features
=======================

  * Configured Linux, Apache, MySQL and PHP stack
  * Drush with site aliases
  * PhpMyAdmin
  * Xdebug

TODO:

  * Webgrind
  * Xhprof
  * Mailing system
  * Other development tools and useful software


Getting Started
===============

VDD uses Chef Solo provisioner. It means that your environment is built from
the source code. All you need is to get base system, the latest code and build
your environment.

  1. Install VirtualBox
     https://www.virtualbox.org/wiki/Downloads

  1. Install Vagrant
     http://docs.vagrantup.com/v2/installation/index.html

  1. Install vagrant host updater plugin
     `$ vagrant plugin install vagrant-hostsupdater`

  1. Prepare Vagrant box
     Boxes are the skeleton from which Vagrant machines are constructed.
     They are portable files which can be used by others on any platform that
     runs Vagrant to bring up a working environment.

     Run next command to download and prepare Ubuntu 12 box:
     `$ vagrant box add precise32 http://files.vagrantup.com/precise32.box`


  1. Prepare VDD source code
     Download and unpack VDD source code and place it inside your home
     directory.

  1. Adjust configuration | Copy `config.example.json` to `config.json`
     You can edit `config.json` file to adjust your settings. If you use VDD first
     time it's recommended to leave the original config as is.

  1. Build your environment
     To build your environment execute next command inside your VDD copy:
     `$ vagrant up`

     Vagrant will start to build your environment. You'll see green status
     messages while Chef is configuring the system.

  1. Visit `192.168.44.44` address
     If you didn't change default IP address in `config.json` file you'll see
     VDD's main page. Main page has links to configured sites, development tools
     and list of frequently asked questions. Follow instruction on how to quickly install Drupal

  1. Configure Drupal Code sniffer with Coder module inside bin directory 
     Reference : https://drupal.org/node/1419988

Now you have ready to use virtual development server. By default 1 site
(similar to virtual hosts) is configured: Drupal 7. You always can
add new ones in `config.json` file.

Basic Usage
===========

Inside your VDD copy's directory you can find `data` directory. It's
synchronized with virtual machine. You should place your application's files
inside sub folders with the name of your project. You can edit your application's
files on the host machine using your favorite editor or connect to virtual
machine by SSH. VDD will never delete data from data directory, but you should
backup it.

Vagrant's basic commands (should be executed inside VDD directory):

  * `$ vagrant ssh`
    _SSH into virtual machine._

  * `$ vagrant up`
    _Start virtual machine._

  * `$ vagrant halt`
    _Halt virtual machine._

  * `$ vagrant destroy`
    _Destroy you virtual machine. Source code and content of data directory will
    remain unchangeable. VirtualBox machine instance will be destroyed only. You
    can build your machine again with `vagrant up` command. The command is
    useful if you want to save disk space._

  * `$ vagrant provision`
    _Reconfigure virtual machine after source code change._

  * `$ vagrant reload`
    _Reload virtual machine. Useful when you need to change network or
    synced folder settings._

Official Vagrant site has beautiful documentation.
http://docs.vagrantup.com/v2/

Customizations
==============

You should understand that every time you start virtual machine Vagrant will
fire Chef provisioner. If you want to customize your VDD copy you should do it
right way.

Templates override

If you want to change some configuration files, for example, php.ini you should
override default VDD's template. All templates a located in
`cookbooks/vdd/vdd/templates/default`

All you need is to copy template file into `cookbooks/core/vdd/templates/ubuntu`
directory and edit it.

Writing custom role

If you want to make serious modifications you should write your custom role and
add it in `config.json` file. Please, see `vdd_example.json` file inside roles
directory.

config.json description
=======================

`config.json` is the main configuration file. Data from `config.json` is used to
configure virtual machine. After editing file make sure that your JSON syntax is
valid. http://jsonlint.com/ can help to check it.
  
  * `hostname (string, required)`
    _URL of the machine automatically added to the /etc/hosts if you have vagrant 
    host updater plugin (vagrant plugin install vagrant-hostsupdater)_

  * `ip (string, required)`
    _Static IP address of virtual machine. It is up to the users to make sure
    that the static IP doesn't collide with any other machines on the same
    network. While you can choose any IP you'd like, you should use an IP from
    the reserved private address space._

  * `memory (string, required)`
    _RAM available to virtual machine. Minimum value is 1024._

  * `synced_folder (object of strings, required)`
    _Synced folder configuration._

      * `host_path (string, required)`
        _A path to a directory on the host machine. If the path is relative, it
        is relative to VDD root._

      * `guest_path (string, required)`
        _Must be an absolute path of where to share the folder within the guest
        machine._

      * `use_nfs (boolean, required)`
        _In some cases the default shared folder implementations (such as
        VirtualBox shared folders) have high performance penalties. If you're
        seeing less than ideal performance with synced folders, NFS can offer a
        solution. http://docs.vagrantup.com/v2/synced-folders/nfs._

  * `php (object of strings, required)`
    _PHP configuration._

      * `version (string or false, required)`
        _Desired PHP version. Please, see http://www.php.net/releases for proper
        version numbers. If you would like to use standard Ubuntu package you
        should set number to "false". Example: "version": false._

  * `mysql (object of strings, required)_`
    _MySQL configuration._

      * `server_root_password (string, required)`
        _MySQL server root password._

  * `sites (object ob objects, required)`
    _List of sites (similar to virtual hosts) to configure. At least one site is
    required._

      * `Key (string, required)`
        _Machine name of a site. Name should fit expression '[^a-z0-9_]+'. Will
        be used for creating subdirectory for site, Drush alias name, database
        name, etc._

          * `account_name (string, required)`
            _Drupal administrator user name._

          * `account_pass (string, required)`
            _Drupal administrator password._

          * `account_mail (string, required)`
            _Drupal administrator email._

          * `site_name (string, required)`
            _rupal site name._

          * `site_mail (string, required)`
            _Drupal site email._

  * `xdebug (object of strings, optional)`
    _Xdebug configuration._

    * `remote_host (string, required)`
      _Selects the host where the debug client is running._

  * `git (object of strings, optional)`
    _Git configuration._

  * `custom_roles (array, required)`
    _List of custom roles. Key is required, but can be empty array ([])._

If you find a problem, incorrect comment, obsolete or improper code or such,
please let us know by creating a new issue at
http://drupal.org/project/issues/vdd
