=======================
Vagrant Django Template
=======================

Vagrant configuration for a Django machine at theTeam, using Puppet.

Please note that this is experimental and not ready for production...yet.

Based on:

- http://vagrantup.com/
- http://rcrowley.org/talks/django-2010-11-17/
- https://github.com/stefanfoulis/vagrant-django-playground
- https://gist.github.com/701221
- http://projects.puppetlabs.com/projects/puppet/wiki/Puppet_Patterns

=========
Usage
=========

To run the VM, cd to the directory containing the Vagrantfile and run::

$ vagrant up

If running for the first time, this will download the base lucid64 box from
the Vagrant website.
