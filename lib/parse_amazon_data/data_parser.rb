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

  class QuantityExpression
    attr_reader :multiplier, :value, :units
    FULL_QTY_REGEX = /(\d+)x(\d+)(\D+)/
    NO_MULTIPLIER_REGEX = /(\d+)(\D+)/
    NO_MULTIPLIER_NO_UNITS = /(\d+)/

    EQUIVALENTS = {
      pack: "count",
      count: "pack",
      fz: "oz",
      oz: "fz"
    }

    def initialize(input)
      raise "No qty data available" unless input

      parse_input(input)
      normalize_units
    end

    def ==(other)
      if multiplier == other.multiplier
        if value == other.value
          if units == other.units || EQUIVALENTS[units.to_sym] == other.units
            return true
          end
        end
      end
      return false
    end

    private

    def parse_input(input)
      if (match = input.match(FULL_QTY_REGEX))
        @multiplier, @value, @units = match.captures
        if (@multiplier == "1")
          @multiplier = nil
        end
      elsif (match = input.match(NO_MULTIPLIER_REGEX))
        @value, @units = match.captures
      elsif (match = input.match(NO_MULTIPLIER_NO_UNITS))
        @value = match.captures.first
      else
        raise "No qty data available"
      end
    end

    def normalize_units
      if @units
        @units = @units.gsub(/\-|\s*/, "").downcase
      end
    end
  end
end
