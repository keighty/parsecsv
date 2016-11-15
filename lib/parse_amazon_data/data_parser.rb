module ParseAmazonData
  class DataParser
    require 'csv'

    def self.parse(filename)
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
          puts title
          puts qty1
          puts qty2
          puts '-----------------'
        end
      end
    end

    private
    def self.getQty(input)
      qty_regex = /([0-9]+.*)\)?/
      stripped_input = input.gsub(/\(|\)/, '')

      qty = stripped_input.match(qty_regex).to_s
      QuantityExpression.new(qty)
    end

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
    attr_reader :multiplier, :value, :units, :input
    FULL_QTY_REGEX = /(\d+)[x|X](\d*\.?\d+)(\D+)/
    PACK_MULTIPLIER = /pack of (\d+)/
    NO_MULTIPLIER_REGEX = /(\d*\.?\d+)(\D+)/
    NO_MULTIPLIER_NO_UNITS = /(\d+)/

    EQUIVALENTS = {
      pack: "count",
      packof: "pack",
      count: "pack",
      fz: "oz",
      fluidounce: "oz",
      ounce: "oz",
      floz: "oz"
    }

    def initialize(input)
      raise ArgumentError, "No qty data available" unless input
      @input = input

      parse_input(input)
      normalize_value
      normalize_units
    end

    def ==(other)
      if multiplier_match?(other)
        if value_match?(other)
          if units_match?(other)
            return true
          end
        end
      elsif multiplier_value_match?(other)
        return true
      end
      return false
    end

    def to_s
      "multiplier: #{multiplier}, value: #{value}, units: #{units}"
    end

    private

    def parse_input(input)
      if (match = input.downcase.match(PACK_MULTIPLIER))
        @multiplier = match.captures.first
      end

      if (match = input.match(FULL_QTY_REGEX))
        @multiplier, @value, @units = match.captures
        @multiplier = nil if @multiplier == "1"
      elsif (match = input.match(NO_MULTIPLIER_REGEX))
        @value, @units = match.captures
      elsif (match = input.match(NO_MULTIPLIER_NO_UNITS))
        @value = match.captures.first
      else
        raise RuntimeError, "No qty data available"
      end
    end

    def normalize_value
      if @value.match(/^\./)
        @value = "0" + @value
      end
    end

    def normalize_units
      if @units
        normalized = @units.gsub(/\-|\s/, "").downcase
        @units = EQUIVALENTS[normalized] || normalized
      end
    end

    def multiplier_match?(other)
      multiplier == other.multiplier
    end

    def value_match?(other)
      value == other.value
    end

    def units_match?(other)
      units == other.units || EQUIVALENTS[units.to_sym] == other.units
    end

    def multiplier_value_match?(other)
      multiplier == other.value || value == other.multiplier
    end
  end
end
