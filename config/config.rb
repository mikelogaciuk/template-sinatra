# frozen_string_literal: true

require 'yaml'
require 'erb'

# Load the application configuration
CONFIG = YAML.load(ERB.new(File.read('./config/application.yaml')).result)
MASTER_KEY = CONFIG['api']['key']
MASTER_USER = CONFIG['api']['user']
