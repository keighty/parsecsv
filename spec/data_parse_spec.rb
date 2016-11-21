require 'parse_amazon_data'

describe ParseAmazonData do
  it "should pass this canary test" do
    expect(true).to eql(true)
  end

  it "should parse a small csv file" do
    ParseAmazonData::DataParser.new('./spec/data/1Line.csv')
  end

  it "should parse a medium csv file" do
    ParseAmazonData::DataParser.new('./spec/data/10Lines.csv')
  end

  it "should parse a medium-large csv file" do
    ParseAmazonData::DataParser.new('./spec/data/50Lines.csv')
  end
end

# TODO: COMPARE_NONEQUAL_TEST_CASES
# TODO: finish api for parse data
# TODO: performance optimization
