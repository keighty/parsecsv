require 'parse_amazon_data'

describe ParseAmazonData::QuantityExpression do
  it "should raise an error if no data is found" do
    input = ""
    expect { ParseAmazonData::QuantityExpression.new(input) }.to raise_error(RuntimeError, "No qty data available")
  end

  it "should throw an error with null input" do
    input = nil
    expect { ParseAmazonData::QuantityExpression.new(input) }.to raise_error(ArgumentError, "No qty data available")
  end

  describe "normalize units" do
    it "should remove all hyphens and white space from unit expressions" do
      input = "2-ounce a-Doodles"
      units = ParseAmazonData::QuantityExpression.new(input).units
      expect(units).to eql('oz')
    end
  end
end
