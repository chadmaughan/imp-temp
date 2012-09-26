require 'sinatra'
require 'json'
require 'pg'
require 'uri'

get '/' do
	"HTTP GET"
end

post '/' do

	# in case someone already read it
	request.body.rewind

	# get the request body content
	body = request.body.read

	# parse it
	data = JSON.parse body
	puts "recieved: #{data}"

	# connect to the database
	begin
		# DATABASE_URL
		# postgres://username:password@host:port/database_name
		db = URI.parse(ENV['HEROKU_POSTGRESQL_ONYX_URL'] || 'postgres://localhost/temperature')
		puts "db: " + db.inspect

		conn = PGconn.connect(db.host, '', '',  db.path[1..-1])
		puts "connected to database #{db.host}, #{db.path}"

		conn.prepare('statement', "INSERT INTO temperature (location, temperature) VALUES ($1, $2)")
		conn.exec_prepared('statement', [data['location'], data['temperature']])
		puts "inserted temperature: #{data['location']}, #{data['temperature']}"
	ensure
		puts "closing connection"
		conn.close
	end

	# output
	puts "insert - #{data['location']}, #{data['temperature']}"
end
