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
      floz: "oz",
      caps: "ea",
      vcaps: "caps",
      ouncejar: "oz",
      ouncepackof: "oz"
    }

    def initialize(input)
      raise ArgumentError, "No qty data available" unless input
      @input = input.downcase

      # if (@input.match(/og/))
      #   puts @input
      #   puts @input.match(Q3_WEIRD_REGEX).captures.to_s
      # end

      parse_input(@input)
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

      # puts
      # puts input
      # puts " matched: #{input.match(FULL_QTY_REGEX)}"
      # puts " matched: #{input.match(/og/)}"
      # puts " matched: #{input.match(NO_MULTIPLIER_REGEX)}"
      # puts " matched: #{input.match(NO_MULTIPLIER_NO_UNITS)}"
      # puts "-----------------"

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
        normalized = @units.gsub(/\-|\s|\.|_/, "")
        @units = EQUIVALENTS[normalized.to_sym] || normalized
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

    def get_multiplier(input)
    end
  end
end
