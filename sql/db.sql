-- URL on guide here
-- 	https://devcenter.heroku.com/articles/heroku-postgresql

-- -----------------

-- add free posgres to app
--	heroku addons:add heroku-postgresql:dev

-- get information about the db (the url variable is the first line, i.e. - HEROKU_POSTGRESQL_ONYX_URL)
--	heroku pg:info

-- get the credentials
--  heroku pg:credentials

-- check the ENV variable
--  heroku config:get DATABASE_URL

-- if your DB is not set at the DATABASE_URL
--  heroku pg:promote HEROKU_POSTGRESQL_ONYX_URL

-- connect to PSQL
--	heroku pg:psql
CREATE TABLE temperature (
	id SERIAL, 
	ip VARCHAR(20),
	location VARCHAR(20),
	time_stamp TIMESTAMP DEFAULT now(),
	temperature REAL
);
