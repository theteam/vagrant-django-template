# Load application configuration
require 'yaml'
 
CONFIG = YAML.load_file("config.yml") unless defined? CONFIG
