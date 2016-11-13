module ParseAmazonData
  class DataParser
    require 'csv'

    def self.parse(filename)
      CSV.foreach(filename, headers: true) do |csv_obj|
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
    def self.parse_product(input)
      qty = get_qty(input)
      remove_multiplier(normalized_units(qty))
    end

    def self.get_qty(input)
      stripped_input = input.gsub(/\(|\)/, '')
      qty_regex = /([0-9]+.*)\)?/
      stripped_input.match(qty_regex).to_s.downcase
    end

    def self.normalized_units(input)
      input.gsub(/-|\s+/, "")
    end

    def self.remove_multiplier(input)
      if (input.match(/1x/))
        return input.gsub(/1x/, '')
      end
      input
    end
  end
end
