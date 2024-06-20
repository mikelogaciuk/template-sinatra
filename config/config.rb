# frozen_string_literal: true

require 'yaml'
require 'erb'

# Load the application configuration
CONFIG = YAML.load(ERB.new(File.read('./config/api-config.yaml')).result)

# Constants
MASTER_USER = CONFIG['api']['user']
MASTER_KEY = CONFIG['api']['key']
DOMAIN_USER = CONFIG['domain']['user']
DOMAIN_PASSWORD = CONFIG['domain']['password']
TARGET_PORT = CONFIG['target']['port']
