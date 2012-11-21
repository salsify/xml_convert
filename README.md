# XmlConvert

XmlConvert is a Ruby implementation of the [.NET XmlConvert class](http://msdn.microsoft.com/en-us/library/e2104c2x.aspx). It encodes and decodes XML names, giving you an easy way to create NCName-compliant names from arbitrary strings.

## Installation

Add this line to your application's Gemfile:

    gem 'xml_convert'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xml_convert

## Usage

### Encoding

Encode a name:

```ruby
encoded_name = XmlConvert.encode_name("My Name") # "My_x0020_Name"
```

Encode a local name, escaping colons as well:

```ruby
encoded_name = XmlConvert.encode_name("Foo: Bar") # "Foo_x003a__x0020_Bar"
```

### Decoding

Any of the above [Encoding examples](#encoding) can be reversed with `XmlConvert.decode(name)`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
