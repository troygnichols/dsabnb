
## Goal
We want to build an app to allow supporters to share their homes with others from out
of town and to help supporters on the road find lodging.

## How We're Doing It
* Rails 4.2.5
* Devise/ Omniauth for authentication with Facebook and google
* Geocoder gem to search by zipcode, using Bing geocoding API.
* Bower for front end asset management

## Contributing
Please e-mail dsjoerg@gmail.com.
We would love your help.

## Setting up development
* install [Docker Toolbox](https://www.docker.com/toolbox)
* fork HillaryBNB on github
* `git clone git@github.com:<your github username>/HillaryBNB.git && cd HillaryBNB`
* `docker-compose build`
* `docker-compose up -d web`
* `open "http://$(docker-machine ip default):8080"`
* `git remote add upstream https://github.com/DevProgress/HillaryBNB` so you can keep in sync with original project by running `git pull upstream master`.
* Run tests: `docker-compose run shell bash -c 'bin/rake db:migrate RAILS_ENV=test && RAILS_ENV=test bin/rake'`

## Deploying to Heroku
* install [Heroku Toolbelt](https://toolbelt.heroku.com/)
* `heroku plugins:install heroku-container-tools`
* NOT SURE ABOUT THIS `heroku apps:join --app hillarybnb`
* `heroku container:release`
* `heroku open`

## Setting up facebook/google/bing connections
  #. `cp config/application.yml.example config/application.yml` and set values in config/application.yml.
  #. Set up Facebook Developer account at https://developers.facebook.com
     then get your FACEBOOK_KEY and FACEBOOK_SECRET.
    * Here is a good How-To article:
      * https://goldplugins.com/documentation/wp-social-pro-documentation/how-to-get-an-app-id-and-secret-key-from-facebook/
  #. Set up Google Developer account at https://developers.google.com/
     and get your GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET.
    * Here are two good How-To articles:
      * https://richonrails.com/articles/google-authentication-in-ruby-on-rails/
      * http://wlowry88.github.io/blog/2014/08/02/google-contacts-api-with-oauth-in-rails/
  #. Create Bing Maps key (BING_GEOCODE_ID) at
     https://msdn.microsoft.com/en-us/library/ff428642.aspx


## Why are these in the README:

> USERNAME: "TBD" # Used in config/database.yml file.

> PASSWORD: "TBD" # Used in config/database.yml file.

> IP: "http://localhost:3000/"

> MAILER_URL: "localhost:3000/"

> FACEBOOK_KEY: "TBD" # Used in config/initializers/omniauth.rb file.

> FACEBOOK_SECRET: "TBD" # Used in config/initializers/omniauth.rb file.

> GOOGLE_CLIENT_ID: "TBD" # Used in config/initializers/omniauth.rb file.

> GOOGLE_CLIENT_SECRET: "TBD" # Used in config/initializers/omniauth.rb file.

> BING_GEOCODE_ID: "TBD" # Used in config/initializers/geocoder.rb file.

> SITEURL: 'hillarybnb.com' or whatever your site's URL is

> FB_CAPTION: 'Host a volunteer!'

> CAUSE_NAME: 'Hillary Clinton'

* Only for development:

> MAILGUN_API_KEY:       "TBD"

> MAILGUN_DOMAIN:        "TBD

> MAILGUN_PUBLIC_KEY:    "TBD"

> MAILGUN_SMTP_LOGIN:    "TBD"

> MAILGUN_SMTP_PASSWORD: "TBD"

> MAILGUN_SMTP_PORT:     "587"

> MAILGUN_SMTP_SERVER:   "smtp.mailgun.org"
