# Load application configuration
require 'yaml'
 
CONFIG = YAML.load_file("config.yml") unless defined? CONFIG

node CONFIG['host_name'] do

    # Set all the variables we can calculate
    # from the project configuration file.
    settings = {
        'host_name' => CONFIG['host_name'],
        'server_admin_email' => CONFIG['server_admin_email'],
        'client_name' => CONFIG['client_name'],
        'project_name' => CONFIG['project_name'],
        'python_project_name' => CONFIG['python_project_name'],
        'domains' => CONFIG['domains'],
        'static_url' => CONFIG['static_url'],
        'media_url' => CONFIG['media_url'],
        'mysql_root_password' => CONFIG['mysql_root_password'],
    }

    settings['full_project_name'] = "#{settings['client_name']}_#{settings['project_name']}"
    settings['project_path'] = "/opt/#{settings['client_name']}/#{settings['project_name']}/"
    settings['static_path'] = "#{settings['project_path']}current/#{settings['python_project_name']}/static/"
    settings['media_path'] = "#{settings['project_path']}attachments/"

    # Set them in the puppet scope for use
    # lower down the manifest chain.
    settings.each do |key, value|
        scope.setvar(key, value)
    end
    
    include 'aptitude'
    include 'iptables'
    include 'logrotate'
    include 'denyhosts'
    include 'apache2'
    include 'nginx'
    include 'memcached'
    include 'mysql'
    include 'python2'
end
