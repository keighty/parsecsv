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
      # puts csv_obj['Input SKU']
      # csv_obj['foo'] = 'bar'
    end
  end

  private
  def parse_product(input)
    qty = get_qty(input)
    multiplied_qty = parse_multiplier(qty)
    multiplied_qty
  end

  def get_qty(input)
    input.gsub(/\(|\)/, '').match(/([0-9]+.*)\)?/).to_s.downcase
  end

  def parse_multiplier(input)
    input.gsub(/1x/, '')
  end
end

test = DataParser.new('test.csv')
test.parse
