module ParseAmazonData
  class DataParser
    require 'csv'

    def self.parse(filename)
      count = 0
      CSV.foreach(filename, headers: true) do |csv_obj|

        title = csv_obj['Title']
        sku_title = csv_obj['Input SKU']

        begin
          qty1 = getQty(title)
          qty2 = getQty(sku_title)
        rescue Exception => e
          csv_obj[:check] = e.message
          next
        end

        matches = qty1 == qty2

        if !matches
          count += 1
          puts title
          puts sku_title
          puts qty1
          puts qty2
          puts '-----------------'
        end
      end
      puts "\nissue count: #{count}\n"
    end

    private
    def self.getQty(input)
      qty_regex = /([0-9]+.*)\)?/
      interference_regex = /og\d/
      weird = /og\d\D*(\d*\.?\d+\D*)/
      stripped_input = input.gsub(/\(|\)/, '').downcase

      qty_match = if (stripped_input.match(interference_regex))
        stripped_input.match(weird).captures.first
      else
        stripped_input.match(qty_regex).to_s
      end

      QuantityExpression.new(qty_match)
    end
  end
end
