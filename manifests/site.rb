
$host_name = "project-node"

node $host_name do

    # Set all the variables we can calculate
    # from the project configuration file.
    server_settings = {
        'host_name' => "megacorp-node",
        'server_admin_email' => "webmaster@theteam.co.uk",
        'mysql_root_password' => Config['mysql_root_password'],
    }


    include djangoapp

    djangoapp::instance { "megacorp_project":
        staging => {"production": "",
                    "staging": ""},
        
        client_name' => "megacorp",
        project_name' => Config['project_name'],
        python_project_name' => Config['python_project_name'],
        domains' => Config['domains'],
        static_url' => Config['static_url'],
        media_url' => Config['media_url'],

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
