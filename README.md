[![Build Status](https://secure.travis-ci.org/avh4/system_keychain.png?branch=master)](http://travis-ci.org/avh4/system_keychain)
[![Code Climate](https://codeclimate.com/github/avh4/system_keychain.png)](https://codeclimate.com/github/avh4/system_keychain)
[![Dependency Status](https://gemnasium.com/avh4/system_keychain.png)](https://gemnasium.com/avh4/system_keychain)

## How it works

When you use `Keychain.authorize` or `Keychain.authorize_url`, you provide two things: a human-readable description of your app (so users can know what the entries are if they manually inspect their keychain), and a URL that uniquely identifies the resource you are storing credentials for.

1. The provided URL is used to search for stored credentials in the system keychain.
2. If no credentials are found, the user is asked to enter them.
3. The provided block is executed with the credentials.
4. If your block raises a `StandardError`, the credentials will be removed from the keychain and the user is asked to enter credentials again.
5. If your block completes successfully, the return value of your block is returned.

## Installation [![Gem Version](https://badge.fury.io/rb/system_keychain.png)](http://badge.fury.io/rb/system_keychain)

```bash
gem install system_keychain
```

## Usage

`system_keychain` supports three basic scenarios:

1. Creating a connection object
2. Running code that needs the username/password
3. Using "scheme://user:password@hostname/..." URLs

### Creating a connection object

This is most commonly used when you need to create a database connection, but can be used in any other case where you create some kind of connection object that needs a username/password to initialize.

```ruby
require 'system_keychain'

@db = Keychain.authorize("My Cool App", "myapp") do |user, pass|
  MyDatabaseEngine.connect(user, pass)
end
```

### Running code that needs the username/password

Any code that needs a username/password can be executed in the `Keychain.authorize` block:

```ruby
require 'system_keychain'

Keychain.authorize("My Cool App", "myapp") do |user, pass|
  puts `curl -u "#{user}:#{pass}" http://secure.example.com`
end
```

### Using "scheme://user:password@hostname/..." URLs

`Keychain.authorize_url` can be used to insert the username/password into a give URL:

```ruby
require 'system_keychain'

@db = Keychain.authorize_url("My Cool App", "https://myapp.iriscouch.com/mydb") do |auth_url|
  CouchRest.database!(auth_url)
end
```

This will work with any URL scheme (not just `http:` and `https:`):

```ruby
require 'system_keychain'

@db = Keychain.authorize_url("My Cool App", "postgres://localhost:5432/mydb") do |auth_url|
  Sequel.connect(auth_url)
end
```

