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
 
 config = OrbConfiguration::Configuration.instance
 config[:foo][:bar] # returns 'baz'
 config.foo.bar # also returns 'baz'
 config.parse_key('foo.bar') #also returns 'baz'
```

`OrbConfiguration::Configuration` is a singleton so you will not be able to call `.new`. Use the `.instance` method instead.

If you need to read configuration from some place other than the conventional location, do this:

```
 require 'orb_configuration'
 
 config = OrbConfiguration::Configuration.instance
 config.read_configuration!(non_conventional_config_path) # Must be a .yml file
 # From now on, all properties will come from the non_conventional_config_path
```

## Contributing

1. Fork it ( "https://github.va.opower.it/opower/orb_configuration" )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
