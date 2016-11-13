require 'csv'

# Title,Input SKU,Asin,Upc

class DataParser
  def initialize(filename)
    @file = filename
  end

  def parse
    CSV.foreach(@file, headers: true) do |csv_obj|
      title = csv_obj['Title']
      sku_title = csv_obj['Input SKU']
      qty1 = parse_product(title)
      qty2 = parse_product(sku_title)

      matches = qty1 == qty2

      if !matches
        puts title
        puts qty1
        puts qty2
        puts '-----------------'
      end
    end
  end

  private
  def parse_product(input)
    qty = get_qty(input)
    remove_multiplier(normalized_units(qty))
  end

  def get_qty(input)
    stripped_input = input.gsub(/\(|\)/, '')
    qty_regex = /([0-9]+.*)\)?/
    stripped_input.match(qty_regex).to_s.downcase
  end

  def normalized_units(input)
    input.gsub(/-|\s+/, "")
  end

  def remove_multiplier(input)
    if (input.match(/1x/))
      return input.gsub(/1x/, '')
    end
    input
  end
end

test = DataParser.new('test.csv')
test.parse
