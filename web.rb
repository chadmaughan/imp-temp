require 'sinatra'
require 'json'
require 'pg'
require 'uri'
require 'sequel'

# DATABASE_URL
# postgres://username:password@host:port/database_name
url = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost:5432')
puts "URL-> host:#{url.host}, port:#{url.port}, user:#{url.user}, database:#{url.path[1..-1]}"

db = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://localhost:5432')
puts "connected to database"

# HTTP GET
get '/' do
	rows = db.fetch("SELECT id, location, time_stamp AS timestamp, temperature FROM temperature ORDER BY id DESC limit 100")
	rows.all.to_json
end

# HTTP DELETE
delete '/' do
	deletes = db["DELETE FROM temperature WHERE id NOT IN (SELECT id FROM temperature ORDER BY id DESC LIMIT 5000)"]
	count = deletes.delete
	puts "delete count: #{count}"
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
		inserts = db["INSERT INTO temperature (location, temperature, ip) VALUES (?, ?, ?)", data['location'], data['temperature'], request.ip]
		id = inserts.insert
		puts "inserted temperature (id #{id}): #{data['location']}, #{data['temperature']}, from #{request.ip}"
	else
		puts "unknown source location: #{data['location']}"
	end
end
