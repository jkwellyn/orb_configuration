#orb_configuration

A simple configuration library for Ruby projects.

## Installation

Add this line to your application's Gemfile:

gem 'orb_configuration'

And then execute:

$ bundle install

Or install it yourself as:

$ gem install 'orb_configuration'

## Usage

By convention, configuration lives in a single file: `config/config.yml`.

You can put any data you want in this file and access that data in one of three ways:
 
``` 
# config/config.yml
 :foo:
   :bar: 'baz'
   
 # =======================
 # Ruby code...
 
 require 'orb_configuration'
 
 class MyClass
   include OrbConfiguration::Configurable
 
   config = OrbConfiguration::Configuration.instance
   config[:foo][:bar] # returns 'baz'
   config.foo.bar # also returns 'baz'
   config.parse_key('foo.bar') #also returns 'baz'
```
### Loading Configuration
You should never have to read from a config file. Including the `Configurable` module is what initializes the `Configuration` 
object with the data from `config/config.yml`. 
Simply include this module and your configuration will be available with `OrbConfiguration::Configuration.instance`.

### Accessing Configuration
After `include OrbConfiguration::Configurable` you can access your config with: `OrbConfiguration::Configuration.instance`.
`OrbConfiguration::Configuration` is a singleton so you will not be able to call `.new`. Use the `.instance` method instead.
This will have all of your project's configuration and any configuration defined in dependencies.

### Layering Configuration
This data is stored in a structure similar to Hash. This means you can override the configuration in dependencies by overwriting 
their key-value pairs. Also, it's probably a good idea to nest your configuration under some top-level, project-specific key.
This prevents accidental configuration collisions.

## Contributing

#### Contacts
+ John Crimmins (john.crimmins@opower.com)
+ Crystal Hsiung (crystal@opower.com)

#### Process
1. Fork it ( "https://github.va.opower.it/auto/orb_configuration" )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
