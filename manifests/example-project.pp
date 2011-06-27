
$client_name = ""
$project_name = ""

# Server settings.
$host_name = "vagrant-node"
$server_admin_email = "webmaster@theteam.co.uk"
$mysql_root_password = 'f2f23r3cwef'

include djangoapp

djangoapp::instance { "megacorp_project":
    $domains => {"production": "",
                "staging": ""},

    
    client_name' => "megacorp",
    project_name' => Config['project_name'],
    python_project_name' => Config['python_project_name'],
    domains' => Config['domains'],
    static_url' => Config['static_url'],
    media_url' => Config['media_url'],
