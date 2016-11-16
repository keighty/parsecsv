module ParseAmazonData
  class QuantityExpression
    attr_reader :multiplier, :value, :units, :case, :case_qty, :input
    FULL_QTY_REGEX = /(\d+)[x|X](\d*\.?\d+)(\D+)/ # 2x1.57 ounces
    PRE_PACK_MULTIPLIER = /pack\D*(\d+)/
    POST_PACK_MULTIPLIER = /(\d+)\s*\D*pack/
    CASE_MULTIPLIER = /case\D*(\d+)/
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

      sanitize_input

      parse_case_multiplier
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

    def sanitize_input
      @input = input.gsub(/of/, '') # "pack of" "case of"
    end

    def parse_input
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

    def parse_case_multiplier
      if (match = input.match(CASE_MULTIPLIER))
        @case_qty = match.captures.first
        @case = "case"
      elsif (match = input.match(PRE_PACK_MULTIPLIER) || input.match(POST_PACK_MULTIPLIER))
        @case_qty = match.captures.first
        @case = "pack"
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

    def debug_print(other=nil)
      test_input = other ? other.input : input
      puts "_________________"
      puts test_input
      puts " matched full qty: #{test_input.match(FULL_QTY_REGEX)}"
      puts " matched case: #{test_input.match(CASE_MULTIPLIER)}"
      puts " matched pack: #{test_input.match(PRE_PACK_MULTIPLIER) || test_input.match(POST_PACK_MULTIPLIER)}"
      puts " matched no multiplier: #{test_input.match(NO_MULTIPLIER_REGEX)}"
      puts " matched no units: #{test_input.match(NO_MULTIPLIER_NO_UNITS)}"
      puts "-----------------"
    end
  end
end
