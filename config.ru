require './config/environment'
require 'rack/attack'
require './config/initializers/rack_attack'

use Rack::Attack

run Application
