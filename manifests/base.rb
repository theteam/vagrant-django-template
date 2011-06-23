# Load application configuration
require 'yaml'
 
CONFIG = YAML.load_file("config.yml") unless defined? CONFIG

node CONFIG['host_name'] do
    include aptitude
    include apache2
    include logrotate
    include memcached
    include mysql
    include nginx 
    include python2
end
