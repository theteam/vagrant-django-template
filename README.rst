===============================
Vagrant Django Template for EC2
===============================

A Vagrant configuration for a Django-centric machine at theTeam, utilising 
Puppet manifests for provisioning.

The Aim
-------

The aim is to have a single way of provisioning both local virtual 
development environments using Vagrant & Virtualbox while also at the same
time building in such a way that the same Puppet manifests can be used
to provision the staging & production Amazon EC2 environments.

The project should be able to be replicated on a per-project basis to
best work with the needs of a digital agency, and therefore should be 
as reusable as possible.


About & Current Status
----------------------

Under development by the theTeam, London, this project is currently still
at an experimental phase and as such shoud not be used in production...yet.

The various modules are currently suited to our needs and our needs only but
this could change with future development. If you wish to use it, you will
most likely be best off forking the project and tailing it to your own 
requirements; if however you're after a box per the spec below - this will
get you going with a working Django environment very quickly.

The Stack
---------

*Distro*: Ubuntu Server 10.04 LTS.

*Web Servers*: Nginx fronting Apache2.

*Cache*: Memcached.

#TODO in more detail.


====================
Installation & Usage
====================

*NOTE*: There are missing files for security reasons, the following files will
need to be added before the Puppet manifests can be considered to be valid.

modules/deployment/files/ssh/authorized_keys
modules/deployment/files/ssh/known_hosts
modules/deployment/files/ssh/id_rsa
modules/deployment/files/ssh/id_rsa.pub

They are standard SSH home directory files that we require for deployment
(cloning from github etc, etc). For more on them, read the OpenSSH client docs.

1) Build a local Vagrant development box
----------------------------------------

Requirements: Vagrant & Virtualbox 4.x. So for Vagrant (it's a Ruby gem)::

$ gem install vagrant

or, if you're using RVM (if not, why not?)::

$ rvm 1.9.2 gem install vagrant

This will install the vagrant gem and it's dependencies.

Then checkout this project and put it somewhere, remembering the path
to the modules directory.::

$ git clone git://github.com/theteam/vagrant-django-template.git

You will then need to set an environment variable to this modules path
called PUPPET_MODULES_PATH. In Linux this can be done as follows (put it in
your bashrc or bash_profile for persistence):::

$ export PUPPET_MODULES_PATH=/home/user/src/vagrant-django-template/modules

#TODO

2) Build an Amazon EC2 instance
-------------------------------

#TODO

==============
With Thanks to
==============

We have taken inspiration and teachings from various parts of the web in
building this, here are just a few of the resources we used to pull this 
together:

- http://vagrantup.com/
- http://rcrowley.org/talks/django-2010-11-17/
- https://github.com/stefanfoulis/vagrant-django-playground
- https://gist.github.com/701221
- http://projects.puppetlabs.com/projects/puppet/wiki/Puppet_Patterns
- http://bitfieldconsulting.com/puppet-and-mysql-create-databases-and-users
- http://journal.uggedal.com/deploying-wsgi-applications-with-puppet/
