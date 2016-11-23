module ParseAmazonData
  class QuantityExpression
    attr_reader :multiplier, :value, :units, :_case, :input
    FULL_QTY = /(\d+)[x|X]\s?(\d*\.?\d+)(\D+)/ # 2x1.57 ounces
    PRE_PACK_MULTIPLIER = /pack\D*(\d+)/
    POST_PACK_MULTIPLIER = /(\d+)\s*\D*pack/
    COUNT_MULTIPLIER = /(\d+)\s*\D*count/
    PRE_CASE_MULTIPLIER = /case\D*(\d+)/
    POST_CASE_MULTIPLIER = /(\d+)\D+case/
    ONLY_MULTIPLIER = /(\d+)[x|X]/
    NO_MULTIPLIER = /(\d*\.?\d+)(\D+)/
    NO_MULTIPLIER_NO_UNITS = /(\d+)/

    EQUIVALENTS = {
      pack: "count",
      count: "pack",
      fz: "oz",
      fluidounce: "oz",
      ounce: "oz",
      floz: "oz",
      caps: "ea",
      vcaps: "caps",
      mgcapsules: "mg",
    }

    def initialize(input)
      raise ArgumentError, "No qty data available" unless input

      @input = input
      @multiplier = "1"
      sanitize_input

      parse_case_multiplier
      parse_input
      normalize_value
      normalize_units
    end

    def ==(other)
      return true if multiplier_match?(other) && value_match?(other) && units_match?(other)
      return true if multiplier_match?(other) && case_match?(other)
      return true if multiplier_value_match?(other)
      return false
    end

    def to_s
      "multiplier: #{multiplier}, value: #{value}, units: #{units}, case: #{_case}"
    end

    private

    def sanitize_input
      @input = input.downcase.gsub(/of/, '') # "pack of" "case of"
    end

    def parse_input
      if (match = input.match(FULL_QTY))
        @multiplier, @value, @units = match.captures
      elsif (match = input.match(ONLY_MULTIPLIER))
        @multiplier = match.captures.first unless @multiplier != "1"
      elsif (match = input.match(NO_MULTIPLIER))
        @value, @units = match.captures
      elsif (match = input.match(NO_MULTIPLIER_NO_UNITS))
        @value = match.captures.first
      end

      if !(value || units || _case || multiplier != "1")
        raise RuntimeError, "No qty data available"
      end
    end

    def parse_case_multiplier
      if (match = input.match(PRE_PACK_MULTIPLIER))
        @multiplier = match.captures.first
        @input = @input.gsub(PRE_PACK_MULTIPLIER, "")
        @_case = "pack"
      elsif (match = input.match(POST_PACK_MULTIPLIER))
        @multiplier = match.captures.first
        @input = @input.gsub(POST_PACK_MULTIPLIER, "")
        @_case = "pack"
      elsif (match = input.match(PRE_CASE_MULTIPLIER))
        @multiplier = match.captures.first
        @input = @input.gsub(PRE_CASE_MULTIPLIER, "")
        @_case = "case"
      elsif (match = input.match(POST_CASE_MULTIPLIER))
        @multiplier = match.captures.first
        @input = @input.gsub(POST_CASE_MULTIPLIER, "")
        @_case = "case"
      elsif (match = input.match(COUNT_MULTIPLIER))
        @multiplier = match.captures.first
        @input = @input.gsub(COUNT_MULTIPLIER, "")
        @_case = "count"
      end
    end

    def normalize_value
      if value && value.match(/^\./) # .5 == 0.5
        @value = "0" + value
      end
    end

    def normalize_units
      if @units
        normalized = @units.gsub(/\-|\s|\.|_|,/, "")
        normalized = normalized.gsub(/ounce\D+/, "oz")
        @units = EQUIVALENTS[normalized.to_sym] || normalized
      end
    end

    def multiplier_match?(other)
      multiplier == other.multiplier
    end

    def case_match?(other)
      return true if _case == other._case
      if (_case)
        return EQUIVALENTS[_case.to_sym] == other._case
      end
    end

    def value_match?(other)
      value == other.value
    end

    def units_match?(other)
      return false unless units
      units == other.units || EQUIVALENTS[units.to_sym] == other.units
    end

    def multiplier_value_match?(other)
      this_multiplied = multiplier.to_i * (value || 1).to_i
      other_multiplied = other.multiplier.to_i * (other.value || 1).to_i

      this_multiplied == other_multiplied
    end

    def debug_print(other=nil)
      test_input = other ? other.input : input
      puts "_________________"
      puts test_input
      puts " matched case: #{test_input.match(PRE_CASE_MULTIPLIER) || test_input.match(POST_CASE_MULTIPLIER)}"
      puts " matched pack: #{test_input.match(PRE_PACK_MULTIPLIER) || test_input.match(POST_PACK_MULTIPLIER)}"
      puts " matched count: #{test_input.match(COUNT_MULTIPLIER)}"
      puts " matched full qty: #{test_input.match(FULL_QTY)}"
      puts " matched only multiplier: #{test_input.match(ONLY_MULTIPLIER)}"
      puts " matched no multiplier: #{test_input.match(NO_MULTIPLIER)}"
      puts " matched no units: #{test_input.match(NO_MULTIPLIER_NO_UNITS)}"
      puts "-----------------"
    end
  end
end
