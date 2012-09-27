-- information here
-- 	https://devcenter.heroku.com/articles/heroku-postgresql

-- add free posgres to app
--	heroku addons:add heroku-postgresql:dev

-- get information about the db
--	heroku pg:info
-- the url variable is the first line
-- ie - HEROKU_POSTGRESQL_ONYX_URL

-- get the credentials
-- heroku pg:credentials

-- connect to PSQL
--	heroku pg:psql
CREATE TABLE temperature (
	id SERIAL, 
	location VARCHAR(20),
	time_stamp TIMESTAMP DEFAULT now(),
	temperature REAL
);
