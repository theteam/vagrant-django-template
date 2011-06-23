# Load application configuration
require 'yaml'
 
CONFIG = YAML.load_file("config.yml") unless defined? CONFIG

node CONFIG['host_name'] do

    # Set all the variables we can calculate
    # from the project configuration file.
    settings = {
        'client_name' => CONFIG['client_name'],
        'project_name' => CONFIG['project_name'],
        'python_project_name' => CONFIG['python_project_name'],
        'domains' => CONFIG['domains'],
        'static_url' => CONFIG['static_url'],
        'media_url' => CONFIG['media_url'],
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
    include 'apache2'
    include 'logrotate'
    include 'memcached'
    include 'mysql'
    include 'nginx'
    include 'python2'
end
