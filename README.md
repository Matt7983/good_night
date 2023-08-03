Requirement
===

- ruby 3.1.3
- bundler
- docker-compose(To run mysql container)

Get Started
===

## Switch to the desired branch

**We use main branch as demo.**

    $ git switch main

## Install required softwares

### ruby 3.1.3

    $ sudo apt install rbenv(for ubuntu)
    $ brew install rbenv ruby-build(for MacOS)
    $ echo 'eval "$(rbenv init -)"' >> ~/.bashrc #depend on which sh you choose
    $ source ~/.bashrc
    $ rbenv install 3.1.3

### bundler

    $ RBENV_VERSION=3.1.3 gem install bundler

### docker-compose / mysql 5.6

**In this project we provide docker-compose.yml to install mysql.**

    $ sudo apt install docker-compose
    $ docker-compose up -d
    $ docker ps #to check if mysql is running successfully

### install gems
    $ bundle install

## env settings

**If docker-compose runs well, the database.yml settings fit mysql, no need to change.**

## create rails database

    $ bundle exec rake db:create
    $ bundle exec rake db:migrate

## run rails
    # You need to set binding if you connect from other machine
    $ bundle exec rails s

RSpec
===

To run the RSpec locally, follow the steps below:

## create rails database for test env

    $ RAILS_ENV=test bundle exec rake db:create
    $ RAILS_ENV=test bundle exec rake db:migrate

## execute rspec

    $ bundle exec rspec spec

API document
===

## Users

### Follow user

- URL: `{base_url}/users/:user_id/follow`
- Method: `POST`
- Body:
  - `follower_id`: user id that you want to follow.
- Response:
    ```json
    {
        "followed_users": [
            {
                "id": 1,
                "name": "Columbus Zulauf Esq.",
                "created_at": "2023-08-03T11:32:24.638Z",
                "updated_at": "2023-08-03T11:32:24.638Z"
            }
        ]
    }
    ```
- Error:

  ```json
  { "error_code": "FOLLOWER_NOT_FOUND" }
  ```

  | http status | error_code | description |
  | :---------: | :--------: | :---------: |
  | 404 | FOLLOWER_NOT_FOUND | The follower_id is not a valid user id |
  | 409 | FOLLOWER_ALREADY_EXISTS | This user is already followed the follower |

### Unfollow user

- URL: `{base_url}/users/:user_id/unfollow`
- Method: `POST`
- Body:
  - `follower_id`: user id that you want to unfollow.
- Response:
    ```json
    {
        "followed_users": [
            {
                "id": 1,
                "name": "Columbus Zulauf Esq.",
                "created_at": "2023-08-03T11:32:24.638Z",
                "updated_at": "2023-08-03T11:32:24.638Z"
            }
        ]
    }
    ```
- Error:

  ```json
  { "error_code": "USER_NOT_FOLLOWED" }
  ```

  | http status | error_code | description |
  | :---------: | :--------: | :---------: |
  | 404 | USER_NOT_FOLLOWED | The follower is not followed yet |
