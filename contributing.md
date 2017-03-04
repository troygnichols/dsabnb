### ATTN: wip rewrite of original `contributing.md` doc

* Rails 4.2.5
* Devise/ Omniauth for authentication with Facebook and google
* Geocoder gem to search by location, using Bing geocoding API.
* Bower for front end asset management
* [Mailcatcher](https://mailcatcher.me) for email in development

## Setting up development
* install ruby, a ruby verion manager, and the `bundler` gem
* clone `dsabnb` on github: `git clone git@github.com:dsausa/dsabnb.git && cd dsabnb`
* `bundle install`
* `mailcatcher` to start mailcatcher in background as a daemon
* `cp config/application.yml.example config/application.yml`
* `bundle exec rake db:create`
* `bundle exec rails server`
* Run tests: `RAILS_ENV=test bundle exec rake db:migrate && rake`
* Populate test data: `bundle exec rake db:reset`

## Contributing Code
Please sign up to our [Rocket Chat](https://dsausa.chat) and subscribe to the `dsabnb` channel to communicate with the team.

* All work is based off of the `master` branch
* Naming conventions for branches
  * if new feature: `feature/<what-the-feature-is>`
    * eg: `feature/add-home-page`
  * if bug fix: `hotfix/<what-is-being-fixed>`
    * eg: `hotfix/fix-banner-alignment-on-ie9`
* for submission
  * make sure branch updated with current state of `master` branch
    * ex: `git pull origin master`
  * make pull requests to `master` branch

## Updating gem versions
* `bundle update [gemname]`

## Modifying schema
* EXAMPLE: `rails generate migration AddAccomodationTypeToHosting accomodation_type:integer`

## Connecting to dev DB
* `be rails db`

## Deploying to Heroku
* install [Heroku Toolbelt](https://toolbelt.heroku.com/)
* `heroku plugins:install heroku-container-tools`
* add a `heroku` remote either through: `heroku create` or adding existing app `git remote add heroku https://git.heroku.com/<app_name>`
* `git push heroku master`

If there are database migrations to be deployed:
* `heroku run rake db:migrate`
* `heroku restart`
* `heroku open`

## Sending daily emails
You should set up the following to run periodically (daily was what BernieBNB did):
* `heroku run rake clear_past_dated_visits`
* `heroku run rake send_new_contacts_digest`
* `heroku run rake send_new_hosts_digest`
*WARNING* do not run `heroku run rake`, it will happily delete the entire database!   <---- TODO fix this so it cant happen in production

## Setup local hostname
Google OAuth only allows hostnames for its OAuth URLs. Setup a local hostname that points to localhost (127.0.0.1)
### Mac
* Alter your `/etc/hosts` and set up a fake hostname hostname for localhost (ex. local.dsabnb.com)
* Visit `local.dsabnb.com:3000` (default port for rails) to verify it works

## Setting up Facebook/Google/Bing/Twitter connections
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
      * Set your redirect URI to the following http://local.dsabnb.com:3000/auth/google_oauth2/callback
    * Direct your localhost to local.dsabnb.com in /etc/hosts (or windows equivalent) to ensure your browser can resolve the callback URI:  `echo 'http://localhost:3000 local.dsabnb.com' >> /etc/hosts`
* Create Bing Maps key (BING_GEOCODE_ID) at
  https://msdn.microsoft.com/en-us/library/ff428642.aspx
* Create a Twitter app to authenticate against
  * See omniauth-twitter [docs](https://github.com/arunagw/omniauth-twitter#before-you-begin) for instructions
  * Set `TWITTER_API_KEY` and `TWITTER_API_SECRET`

## Setting up Mailgun

A mailgun account is required to send the confirmation email when signing up.

* Go to [Mailgun](https://mailgun.com) and sign up for an account
* You will start with a sandbox account with up to 300 emails per day, or you can create a real one with 10k free emails per month.
    * If using the sandbox account, add your own email as an [authorized recipient](https://mailgun.com/app/testing/recipients).
* Go to your sandbox domain page to fill out all the `MAILGUN_*` variables in `config/application.yml`
    * In `config/application.yml`, set MAILER_URL to localhost:3000`
    * Go to the [main page](https://mailgun.com/app/dashboard) and search for `API Keys` to find your public key.
* Restart
* If you see a 400 error from Mailgun, check your [logs](https://mailgun.com/app/logs). Mailgun may disable your account pending business verification; you'll need to contact support to have them enable it or borrow someone else's sandbox credentials if they don't respond.

## When does dsabnb send emails?

As of 20161010, dsabnb.com sends emails nightly.  Every night at 3:30/4am Eastern time we do the following:

For each Hosting Offer registered in the system, if there are any visitors who clicked the "SEND MY CONTACT INFO" button within the past 24 hours, we gather their contact information and email them to the the host. (Note that this means a host may receive multiple emails from us if they have multiple Hosting Offers).  (This logic is in https://github.com/dsausa/dsabnb/blob/master/lib/tasks/send_new_contacts_digest.rake)

For each Visit registered in the system, if there are any new Hosting Offers created within the past 24 hours that are within 20 miles of the Visit's zip code, we email them to the visitor. (Note that this means a visitor may receive multiple emails from us if they have multiple pending Visits).  (This logic is in https://github.com/dsausa/dsabnb/blob/master/lib/tasks/send_new_hosts_digest.rake)
