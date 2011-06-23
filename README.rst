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
Installation
=========

You'll probably want to check this out in your project directory somewhere,
perhaps::

$ git clone 

There is a sample config.yml file in the project root, copy this - editing it
to your preferences and place it in the manifests directory::

$ cp ./config-sample.yml ./manifests/config.yml

Then to run Vagrant and provision your server, be in the project root and run::

$ vagrant up

If running for the first time, this will download the base lucid64 box from
the Vagrant website.


