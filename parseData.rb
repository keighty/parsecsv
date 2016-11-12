class DataParser
  attr_accessor :must_check, :ok

  def initialize(filename)
    @file = filename
  end

  def parse
    File.open(@file, "r") do |f|
      f.each_line do |line|
        line = line.encode('UTF-8', :invalid => :replace)
        process_line(line)
      end
    end
  end

  private
  def process_line(line)
    identifiers = parse_line(line)
    qty1, qty2 = get_quantities(identifiers)

    if (!qty1 || !qty2)
      puts "no quantities found"
      return
    end

    if(qty1.downcase == qty2.downcase)
    else
      double_parse_quantity(qty1, qty2)
    end
  end

  def parse_line(line)
    if (line.start_with?('"'))
      parse_quote_identifiers(line)
    else
      parse_nonquote_identifiers(line)
    end.values_at(1, 2)
  end

  def parse_quote_identifiers(string)
    string.match(/^(.+?)",(.+?),/)
  end

  def parse_nonquote_identifiers(string)
    string.match(/(.+?),(.+?),/)
  end

  def get_quantities(group)
    group.map do |identifier|
      if matches = parse_quantity(identifier)
        matches[1,2]
      else
        nil
      end
    end.flatten
  end

  def parse_quantity(string)
    # puts string
    # puts string.match(/([0-9]+.*)/)
    puts string.match(/([0-9]+.*)\)?/).to_s
  end

  def double_parse_quantity(qty1, qty2)
    # remove 1x
    if (qty2.has_multiplier?)
      qty2 = qty2.strip_multiplier
    end
    # puts [qty1, qty2].to_s
  end
end

class String
  def has_multiplier?
    self.match(/(\d)x/)
  end

  def strip_multiplier
    if (self.has_multiplier?)
      if self.match(/1x/)
        return self.partition('1x').last
      end
    end
  end
end

# fer_realz = DataParser.new('amazon-upload.csv')
test = DataParser.new('test.csv')
test.parse
# fer_realz.parse
