module ParseAmazonData
  class DataParser
    require 'csv'
    attr_reader :matched, :not_matched

    def initialize(filename)
      @matched = []
      @not_matched = []
      parse(filename)
    end

    def parse(filename)
      CSV.foreach(filename, {headers: true, encoding: 'ISO-8859-1'}) do |csv_obj|
        title = csv_obj['Title']
        sku_title = csv_obj['Input SKU']

        begin
          qty1 = getQty(title)
          qty2 = getQty(sku_title)
        rescue Exception => e
          csv_obj[:check] = e.message
          @not_matched.push(csv_obj)
          next
        end

        matches = qty1 == qty2

        if matches
          @matched.push(csv_obj)
        else
          csv_obj[:check] = "check"
          @not_matched.push(csv_obj)
        end

        # debug_print(csv_obj, qty1, qty2) if !matches
      end
    end

    private
    def getQty(input)
      qty_regex = /([0-9]+.*)\)?/
      og_interference = /og\d/
      utf8_interference = /#x\d+;/
      weird = /og\d\D*(\d*x?\.?\d+\D*)/

      stripped_input = input.gsub(/\(|\)/, '').downcase
      stripped_input = stripped_input.gsub(utf8_interference, "")

      qty_match = if (stripped_input.match(og_interference))
        stripped_input.match(weird).captures.first
      else
        stripped_input.match(qty_regex).to_s
      end

      QuantityExpression.new(qty_match)
    end

    def debug_print(csv_obj, qty1, qty2)
      puts csv_obj['Title']
      puts csv_obj['Input SKU']
      puts qty1
      puts qty2
      puts '-----------------'
    end
  end
end
