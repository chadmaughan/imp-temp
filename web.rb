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
		db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost:5432/temperature')
		puts "url: host: #{db.host}, port: #{db.port}, user: #{db.user}, database: #{db.path[1..-1]}"

		if db.user.nil? and db.password.nil?
			puts "no user/password connection"
			conn = PGconn.connect(db.host, '', '',  db.path[1..-1])
		else
			puts "with user/password connection"
			conn = PGconn.connect(db.host, db.port, '', '',  db.path[1..-1], db.user, db.password)
		end

		puts "connected to database"

		conn.prepare('statement', "INSERT INTO temperature (location, temperature) VALUES ($1, $2)")
		conn.exec_prepared('statement', [data['location'], data['temperature']])

		puts "inserted temperature: #{data['location']}, #{data['temperature']}"

	ensure
		puts "closing connection"
		unless conn.nil?
			conn.close
		end
	end

	# output
	puts "insert - #{data['location']}, #{data['temperature']}"
end
