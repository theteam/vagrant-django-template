puts "harrow"
puts __FILE__
$: << File.dirname(__FILE__) + '..'
require File.expand_path('../config/app_config', __FILE__)

node CONFIG['host_name'] do
    include aptitude
    include apache2
    include logrotate
    include memcached
    include mysql
    include nginx 
    include python2
end
