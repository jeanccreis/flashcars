require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'] || :development)

require 'dotenv/load'

require 'sinatra/base'
require 'json'
require 'active_record'
require 'active_support/cache'
require 'active_support/core_ext/numeric/time'
require 'yaml'

# Configure ActiveRecord
db_config = YAML.load_file(File.join(__dir__, 'database.yml'))
environment = ENV['RACK_ENV'] || 'development'
ActiveRecord::Base.establish_connection(db_config[environment])

# Require all application files
Dir[File.join(__dir__, '../app/helpers', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, '../app/models', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, '../app/services', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, '../app/controllers', '*.rb')].each { |file| require file }

# Main application class
class Application < Sinatra::Base
  configure do
    set :root, File.expand_path('..', __dir__)
    set :public_folder, File.join(root, 'public')
    enable :sessions
    set :session_secret, ENV['SESSION_SECRET'] || 'dev_secret_key'
  end

  configure :development do
    register Sinatra::Reloader
  end

  # JSON helper
  helpers do
    def json_response(data, status = 200)
      content_type :json
      halt status, data.to_json
    end

    def parse_json_body
      body = request.body.read
      request.body.rewind rescue nil
      return {} if body.nil? || body.empty?
      JSON.parse(body)
    rescue JSON::ParserError => e
      halt 400, json_response({ error: 'Invalid JSON format', details: e.message }, 400)
    end
  end

  # Include helpers
  helpers AuthenticationHelper
  helpers RateLimitHelper

  # Health check endpoint
  get '/health' do
    json_response({ status: 'ok', timestamp: Time.now.to_i })
  end

  # JSON parsing error handler
  error JSON::ParserError do
    json_response({ error: 'Invalid JSON format in request body' }, 400)
  end

  # ActiveRecord errors
  error ActiveRecord::RecordNotFound do
    json_response({ error: 'Record not found' }, 404)
  end

  error ActiveRecord::RecordInvalid do |e|
    json_response({ error: 'Validation failed', details: e.record.errors.full_messages }, 422)
  end

  # 404 handler
  not_found do
    json_response({ error: 'Not found' }, 404)
  end

  # Generic error handler
  error do
    json_response({ error: 'Internal server error' }, 500)
  end
end
