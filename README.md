# Secateurs

Secateurs is a tool to manage Elasticsearch Index Template.

[![wercker status](https://app.wercker.com/status/7090ad6286de2e46db8d6d84b3242a09/s "wercker status")](https://app.wercker.com/project/bykey/7090ad6286de2e46db8d6d84b3242a09) [![Code Climate](https://codeclimate.com/github/daichirata/secateurs/badges/gpa.svg)](https://codeclimate.com/github/daichirata/secateurs)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'secateurs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install secateurs

## Usage

### Commands

```sh
$ secateurs help
Commands:
  secateurs apply FILE      # apply index template file.
  secateurs export          # export index template to local file.
  secateurs help [COMMAND]  # Describe available commands or one specific command
```

### Apply

```sh
$ secateurs help apply
Usage:
  secateurs apply FILE

Options:
  -h, [--host=HOST]
                                   # Default: localhost
  -p, [--port=N]
                                   # Default: 9200
  -f, [--format=FORMAT]
                                   # Default: ruby
                                   # Possible values: ruby, json, yaml
      [--color], [--no-color]
                                   # Default: true
      [--dry-run], [--no-dry-run]
      [--verbose], [--no-verbose]

apply index template file.
```

```sh
$ secateurs apply Templatefile

$ secateurs apply --dry-run Templatefile.json

$ secateurs apply --format json Templatefile.json
```

### Export

```sh
$ secateurs help export
Usage:
  secateurs export

Options:
  -h, [--host=HOST]
                                   # Default: localhost
  -p, [--port=N]
                                   # Default: 9200
  -f, [--format=FORMAT]
                                   # Default: ruby
                                   # Possible values: ruby, json, yaml
  -o, [--output=OUTPUT]

      [--split], [--no-split]
      [--verbose], [--no-verbose]

export index template to local.
```

```sh
$ secateurs export > Templatefile

$ secateurs export -o Templatefile

$ secateurs export --format json > Templatefile.json

$ secateurs export --split -o templates/Templatefile

$ ls templates/*
Templatefile
template_1.rb
template_2.rb

$ cat templates/Templatefile
include_template "template_1"
include_template "template_2"
```

## DSL Statements

See [rails/jbuilder](https://github.com/rails/jbuilder).

## Index Template Examples

### Ruby DSL

```ruby
define_template "template_1" do
  template "te*"

  settings do
    index do
      number_of_shards "1"
    end
  end

  mappings do
    type1 do
      _source do
        enabled false
      end

      properties do
        set! "@timestamp" do
          type "date"
        end

        created_at do
          format "EEE MMM dd HH:mm:ss Z YYYY"
          type "date"
        end

        host_name do
          index "not_analyzed"
          type "string"
        end
      end
    end
  end
end
```

### JSON

```json
{
  "template_1": {
    "template": "te*",
    "settings": {
      "index": {
        "number_of_shards": "1"
      }
    },
    "mappings": {
      "type1": {
        "_source": {
          "enabled": false
        },
        "properties": {
          "@timestamp": {
            "type": "date"
          },
          "created_at": {
            "format": "EEE MMM dd HH:mm:ss Z YYYY",
            "type": "date"
          },
          "host_name": {
            "index": "not_analyzed",
            "type": "string"
          }
        }
      }
    }
  }
}
```

### YAML

```yaml
---
template_1:
  template: te*
  settings:
    index:
      number_of_shards: '1'
  mappings:
    type1:
      _source:
        enabled: false
      properties:
        "@timestamp":
          type: date
        created_at:
          format: EEE MMM dd HH:mm:ss Z YYYY
          type: date
        host_name:
          index: not_analyzed
          type: string
```

### Partial Template

```ruby
def test_props(key)
  set! key do
    test true
  end
end
# or 
test_props2 = -> {
  test2 true
}
# or 
test_props3 = ->(json) {
  json.test3 true
}

define_template "template_1" do
  template "te*"
  
  mappings do
    partial! method(:test_props), "test-key"

    type1 do
      partial! test_props2
    end
    
    type2 do
      test_props3.(self)
    end
  end
end
```

### Including Template

```ruby
include_template "/path/to/template_file"

# You can include a template by relative path.
include_template "templae_1"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/daichirata/secateurs.

