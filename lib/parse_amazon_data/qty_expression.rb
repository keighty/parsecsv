module ParseAmazonData
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

      parse_input
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

    def parse_input
      if (match = input.match(PACK_MULTIPLIER))
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
