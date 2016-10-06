
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
* fork HillaryBNB on github: `git clone git@github.com:<your github username>/HillaryBNB.git && cd HillaryBNB`
* `cp config/application.yml.example config/application.yml`
* `export RAILS_ENV=development`
* `docker-compose build`
* `docker-compose up -d web`
* `open "http://$(docker-machine ip default):8080"`
* `git remote add upstream https://github.com/DevProgress/HillaryBNB` so you can keep in sync with original project by running `git pull upstream master`.
* Run tests: `RAILS_ENV=test docker-compose run shell bash -c 'bin/rake db:migrate && bin/rake'`
* Rebuild and restart (not always required; DJ unclear on which kind of changes require it): `export RAILS_ENV=development; docker-compose down && docker-compose build && docker-compose up -d web`

## Deploying to Heroku
* install [Heroku Toolbelt](https://toolbelt.heroku.com/)
* `heroku plugins:install heroku-container-tools`
* get application.yml from DJ and put it in config/
* `heroku container:release --app hillarybnb`
* `heroku run rake db:migrate`
* `heroku open --app hillarybnb`

## Sending daily emails
You should set up the following to run periodically (daily was what BernieBNB did):
* `heroku run rake clear_past_dated_visits`
* `heroku run rake send_new_contacts_digest`
* `heroku run rake send_new_hosts_digest`
*WARNING* do not run `heroku run rake`, it will happily delete the entire database!   <---- TODO fix this so it cant happen in production


## Setup local hostname
Google OAuth only allows hostnames for its OAuth URLs. Setup a local hostname that points to your docker machine
### Mac
* Run `docker-machine ip default` to find your docker machine IP
* Copy that into `/etc/hosts` and give it whatever hostname you want (ex. hbnb.com)
* Visit `hbnb.com:8080` to verify it works

## Setting up Facebook/Google/Bing connections
Configure values for the variables below in config/application.yml:
* Set up Facebook Developer account at https://developers.facebook.com
  then get your FACEBOOK_KEY and FACEBOOK_SECRET.
  * Here is a good How-To article:
    * https://goldplugins.com/documentation/wp-social-pro-documentation/how-to-get-an-app-id-and-secret-key-from-facebook/
* Set up Google Developer account at https://developers.google.com/
  and get your GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET.
  * Here are two good How-To articles:
    * https://richonrails.com/articles/google-authentication-in-ruby-on-rails/
    * http://wlowry88.github.io/blog/2014/08/02/google-contacts-api-with-oauth-in-rails/
  * Some instructions
    * In the Google console:
      * Create credentials, which gets you a Client ID and Secret
      * Enable the Google+ API or you will get an invalid credentials error
      * Set your redirect URI to the following http://hbnb.com:8080/auth/google_oauth2/callback
    * Rename your VM to hbnb.com in /etc/hosts (or windows equivalent) to ensure your browser can resolve the callback URI:  `echo '$(docker-machine ip) hbnb.com' >> /etc/hosts`
* Create Bing Maps key (BING_GEOCODE_ID) at
  https://msdn.microsoft.com/en-us/library/ff428642.aspx

## Setting up Mailgun

A mailgun account is required to send the confirmation email when signing up.

* Go to [Mailgun](https://mailgun.com) and sign up for an account
* You will start with a sandbox account with up to 300 emails per day, or you can create a real one with 10k free emails per month.
* Go to your sandbox domain page to fill out all the `MAILGUN_*` variables in `config/application.yml`
* Go to the main page (https://mailgun.com/app/dashboard) and search for `API Keys` to find your public key.
* Restart `docker-compose restart web`

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
