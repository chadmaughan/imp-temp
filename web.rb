require 'sinatra'
require 'json'
require 'pg'
require 'uri'

# HTTP GET
get '/' do
	"HTTP GET"
end

# HTTP POST
post '/' do

	# in case someone already read it
	request.body.rewind

	# get the request body content
	body = request.body.read

	# parse it
	data = JSON.parse body
	puts "recieved: #{data}"

	# log the user ip
	ip = env['HTTP_X_REAL_IP'] ||= env['REMOTE_ADDR']
	puts "user ip: #{request.ip} (or heroku header ip: #{ip})"

	# connect to the database
	begin

		# DATABASE_URL
		# postgres://username:password@host:port/database_name
		db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost:5432/temperature')
		puts "url: host: #{db.host}, port: #{db.port}, user: #{db.user}, database: #{db.path[1..-1]}"

		# connection to localhost doesn't have credentials, use two separate connection calls 
		if db.user.nil? and db.password.nil?
			puts "no user/password connection"
			conn = PGconn.connect(db.host, '', '',  db.path[1..-1])
		else
			puts "with user/password connection"
			conn = PGconn.connect(db.host, db.port, '', '',  db.path[1..-1], db.user, db.password)
		end

		puts "connected to database"

		# manually set the electric imp location
		#	recieved: {"value"=>23.5, "target"=>"305ef09ab7860666", "channel"=>1}
		if not data['channel'].nil?
			puts "'channel' set in JSON, setting to 'loft' location and associating imp value"
			data['location'] = "loft";
			data['temperature'] = data['value']
		else
			puts "location set: #{data['location']}"
		end

		# only insert from 'outside', 'basement', 'loft'
		if ['temp','basement','loft','outside'].include? data['location']

			conn.prepare('statement', "INSERT INTO temperature (location, temperature, ip) VALUES ($1, $2, $3)")
			conn.exec_prepared('statement', [data['location'], data['temperature'], request.ip])
		
			puts "inserted temperature: #{data['location']}, #{data['temperature']}, from #{request.ip}"
		else
			puts "unknown source location: #{data['location']}"
		end
	ensure
		puts "closing connection"
		unless conn.nil?
			conn.close
		end
	end
end
