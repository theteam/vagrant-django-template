
$host_name = "project-node"

node $host_name do

    # Set all the variables we can calculate
    # from the project configuration file.
    settings = {
        'host_name' => "megacorp-node",
        'server_admin_email' => Config['server_admin_email'],
        'client_name' => Config['client_name'],
        'project_name' => Config['project_name'],
        'python_project_name' => Config['python_project_name'],
        'domains' => Config['domains'],
        'static_url' => Config['static_url'],
        'media_url' => Config['media_url'],
        'mysql_root_password' => Config['mysql_root_password'],
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

    # Include the sites for this machine
    include 'sites'
end
