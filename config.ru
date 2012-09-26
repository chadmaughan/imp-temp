# .ru files are "rackup files", it feeds an application to Rackup

require './web.rb'

set :database, ENV['HEROKU_POSTGRESQL_ONYX_URL'] || 'postgres://localhost/temperature'

run Sinatra::Application
