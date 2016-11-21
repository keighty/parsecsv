# ParseAmazonData

NOTE: This gem is as yet unpublished
A library for parsing CSV data in the format: `Title,Input SKU,Asin,Upc`, where Title and Input SKU are strings that contain some expression of quantity.

Examples:
```
Title,Input SKU,Asin,Upc
Deboles Organic Artichoke Angel Hair ( 12x8 OZ),DeBoles Artichoke Angel Hair (12x8 Oz),B001O8NPYU,087336633409
"EARTH FRIENDLY STAIN &amp; ODOR REMOVER,SPRY, 22 FZ",Earth Friendly Stain And Odor Remover (1x22Oz),B007JT96IC,749174097071

```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'parse_amazon_data'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install parse_amazon_data

## Usage

```ruby
parsed_data = ParseAmazonData::DataParser.new('./path/to/data.csv')
parsed_data.matched
parsed_data.not_matched
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/parse_amazon_data/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
