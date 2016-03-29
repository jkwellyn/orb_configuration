# THIS PROJECT HAS BEEN DEPRECATED
Please use [clean_config](https://github.com/opower/clean_config) instead.

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

```yaml
# config/config.yml
 :foo:
   :bar: 'baz'
```

```ruby
require 'orb_configuration'

class MyClass
  include OrbConfiguration::Configurable

  config = OrbConfiguration::Configuration.instance
  config[:foo][:bar]          # returns 'baz'
  config.foo.bar              # also returns 'baz'
  config.parse_key('foo.bar') # also returns 'baz'
```

### Loading Configuration
If you are using a configurable module/class, you should never have to read from a config file.
Including the `Configurable` module is what initializes the `Configuration` object with the data from `config/config.yml`,
searching up the directory structure for the configuration. Simply include this module and your configuration will be available
with `OrbConfiguration::Configuration.instance`.

If you are using the OrbConfiguration outside of a module or class, there are a few methods available to you
to point OrbConfiguration to your configuration directory.

`add!` allows you to change the directory/file name for your configuration files. OrbConfiguration will still search up the
directory structure for the configuration, but looking for your path/file instead.

`load!` looks for the default directory/file name (`config/config.yml`) but at the same level as the calling directory.

`merge!` allows you to pass in a hash of additional configuration to add to your OrbConfiguration.

### Accessing Configuration
After `include OrbConfiguration::Configurable` you can access your config with: `OrbConfiguration::Configuration.instance`.
`OrbConfiguration::Configuration` is a singleton so you will not be able to call `.new`. Use the `.instance` method instead.
This will have all of your project's configuration and any configuration defined in dependencies.

### Layering Configuration
This data is stored in a `RecursiveOpenStruct` structure, which is similar to `Hash`.
This means you can override the configuration in dependencies by overwriting their key-value pairs.
Also, it's probably a good idea to nest your configuration under some top-level, project-specific key.
This prevents accidental configuration collisions.

Be aware, that this structure does not provide the usual methods like `#keys`, `#values` and others one would expect from `Hash`.
To get access to the underlying `Hash` methods prefix them with `to_hash` or `to_h`, e.g. `config.to_h.values`.
Only the `#keys` method has been enabled for convenience by monkeypatching the ruby class.
The result of this is that if you have a field called `:keys:` in your config file the only way to access it is `config.to_h[:keys]`

## Contributing

#### Contacts
+ John Crimmins (john.crimmins@opower.com)
+ Crystal Hsiung (crystal@opower.com)

#### Process
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
