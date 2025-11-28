require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
  "Hello, Sinatra! App updated with reloadaaaer!"
end
