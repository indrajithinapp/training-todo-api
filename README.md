# training-todo-api

TODO API for React Training.

This project uses SQLite as the DB

## Installation

Install the following requirements

### Requirements
- Crystal 1.13.1
- Shards

### Setup

Run the following commands to install dependencies

```sh
shards install
```
## Usage

```sh
shards run
```
## Development

There are four main files in the project

#### training-todo-api.cr

This is the main file, which is responsible for routing, authentication and db connections but is spread between other three files

#### auth.cr

This is where we generates JWT tokens and decoding

#### user.cr

User Model file. Main functionality is to interact with SQLlite DB for login and registration

#### todo.cr

Main todo functionality is handled here. You can find various method for CRUD operations for TODO

#### config/database.cr

Make Database configurations here

## Contributing

1. Fork it (<https://github.com/indrajithinapp/training-todo-api/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Indrajith K L](https://github.com/indrajithinapp) - creator and maintainer
