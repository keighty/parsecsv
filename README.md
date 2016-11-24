# ParseAmazonData

An application for parsing CSV data in the format: `Title,Input SKU,Asin,Upc...`, where Title and Input SKU are strings that contain some expression of quantity.

Examples:
```
Title,Input SKU,Asin,Upc
Deboles Organic Artichoke Angel Hair ( 12x8 OZ),DeBoles Artichoke Angel Hair (12x8 Oz),B001O8NPYU,087336633409
"EARTH FRIENDLY STAIN &amp; ODOR REMOVER,SPRY, 22 FZ",Earth Friendly Stain And Odor Remover (1x22Oz),B007JT96IC,749174097071

```

## Usage

```ruby
parsed_data = ParseAmazonData::DataParser.new('./path/to/data.csv')
parsed_data.matched
parsed_data.not_matched
```

## User Interface

This library is available for demo at https://parse-amazon-data.herokuapp.com/ 
