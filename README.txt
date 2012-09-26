08/19/2012


Install RVM
- see https://rvm.io/rvm/install/

Install the Ruby version you want (on 10.8, required CMD line version of Xcode)
$ rvm install 1.9.3

Use the new version
$ rvm use 1.9.3

If you use 'bash it', your shell will tell you what ruby version you're on

  |ruby-1.9.3-p194| imac in ~/workspaces/imp/temperature
  ± |master ✗| → 

You can run your 'rack' app using shotgun, automatically fork and runs your
most recent code for each request.  More here: http://rtomayko.github.com/shotgun/

$ sudo gem install shotgun
$ shotgun web.rb

You can also set the database connection url on the CLI (I think)
$ DATABASE_URL=postgres://localhost/temperatur; shotgun web.rb

Then open it up on http://localhost:9393
