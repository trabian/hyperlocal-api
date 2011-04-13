# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

require ::File.expand_path('../lib/xhr_basic_auth_fix',  __FILE__)

# Remap 401 status codes to 403 to prevent browsers from showing basic auth login popup
use XhrBasicAuthFix

run Api::Application

