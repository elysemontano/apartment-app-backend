# Setup Process
Documentation process followed: [Authenticate User with Devise Gem and Devise JWT in React Application by Villy Siu](https://medium.com/@villysiu/authenticate-user-with-devise-gem-and-devise-jwt-in-react-application-1-2-a869477a2cb3)

Create Rails app:
`$ rails new apartment-app-backend -d postgresql -T`
`$ cd apartment-app-backend`

Add rack cors, devise, devise-jwt, and dotenv-rails to gemfile
```ruby
gem 'rack-cors'
gem 'devise'
gem 'devise-jwt'
gem 'dotenv-rails', groups: [:development, :test]
```

Run `$ bundle`

## Setup CORS
CORS which stands for Cross-Origin Resource Sharing. Our React frontend and Rails backend applications are running on two different servers. We have to tell the Rails app that (while in development) it is okay to accept requests from any outside domain.  

Along with allowing requests, we will need to send a JWT token to the frontend through the headers.  

Add a file to the config/initializers directory named cors.rb and add the following code to the new file:
```ruby
# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3001'
    resource '*',
    headers: ["Authorization"],
    expose: ["Authorization"],
    methods: [:get, :post, :put, :patch, :delete, :options, :head],
    max_age: 600
  end
end
```

Next we will setup a private controller (I think we may be able to skip this, but not sure just yet)
`$ rails generate controller private test`

Replace code with:
```ruby
# api/app/controllers/private_controller.rb
class PrivateController < ApplicationController
  before_action :authenticate_user!
  def test
    render json: {
      message: "This is a secret message. You are seeing it because you have successfully logged in." 
    }
  end
end
```

## Setup Devise
First we need to generate some devise files and folders:

`$ rails generate devise:install`
`$ rails generate devise User`
`$ rails db:migrate`

Set up the default url options for the Devise mailer in our development environment. Add the following code near the other mailer options:

```ruby
# config/environments/development.rb
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

We will also need to ensure that devise does not use flash messages since this is an API.  

```ruby
# api/config/initializers/devise.rb
config.navigational_formats = []
```

## Controllers and Routes
We need access to some additional files that devise has available to handle sign ups and logins.

`$ $ rails g devise:controllers users -c registrations sessions`

We will replace the code in the registrations controller and sessions controller:

```ruby
# app/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  def create
    build_resource(sign_up_params)
    resource.save
    sign_in(resource_name, resource)
    render json: resource
  end
end
```

```ruby
# app/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  respond_to :json
  private
  def respond_with(resource, _opts = {})
    render json: resource
  end
  def respond_to_on_destroy
    render json: { message: "Logged out." }
  end
end
```

We also need to update the devise routes:

```ruby
# api/config/routes
Rails.application.routes.draw do
  get 'private/test'
  devise_for :users, 
    path: '', 
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    },
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }
end
```

## Secret Key
We will need a secret key to create a JWT token.  We can generate this by running:
`$ bundle exec rake secret`

Then we can create a .env file in the root and add the key:
```ruby
# api/.env
DEVISE_JWT_SECRET_KEY=<your_rake_secret>
```

**Make sure to add .env to gitignore as this should not be shared over git!**


## Configure Devise-JWT
We will need to add the following to devise.rb
```ruby
# api/config/initializers/devise.rb
config.jwt do |jwt|
    jwt.secret = ENV['DEVISE_JWT_SECRET_KEY']
    jwt.dispatch_requests = [
      ['POST', %r{^/login$}],
    ]
    jwt.revocation_requests = [
      ['DELETE', %r{^/logout$}]
    ]
    jwt.expiration_time = 5.minutes.to_i
  end
```

## Revocation
There are several ways to revoke a token with devise-jwt.  For this process and the documentation I followed, I used Denylist.

First we need to create a denylist table

`$ rails generate model create_jwt_denylist`

Update the migration file with:
```ruby
# api/db/migrate/[date]_create_jwt_denylist.rb
def change
  create_table :jwt_denylist do |t|
    t.string :jti, null: false
    t.datetime :exp, null: false
  end
  add_index :jwt_denylist, :jti
end
```

Let's migrate!
`$ rails db:migrate`

We also need to update our JwtDenylist model with the following contents:

```ruby
# api/app/models/jwt_denylist.rb
class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist
  self.table_name = 'jwt_denylist'
end
```

We also need to update the user model so that it can use JWT tokens

```ruby
# api/app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
end
```

Lastly, we can start our server and check that the backend is working properly.

`$ rails s`

and navigate to `http://localhost:3000/private/test`