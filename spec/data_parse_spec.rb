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

  it "should parse a large csv file" do
    ParseAmazonData::DataParser.new('./spec/data/100Lines.csv')
  end

  it "should parse a medium-large csv file and find 11 issues" do
    parsed = ParseAmazonData::DataParser.new('./spec/data/50Lines.csv')
    expect(parsed.not_matched.length).to be(11)
  end
end

# TODO: performance optimization
