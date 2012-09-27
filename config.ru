# .ru files are "rackup files", it feeds an application to Rackup

require './web.rb'

set :database, ENV['DATABASE_URL'] || 'postgres://localhost/temperature'

run Sinatra::Application
