require 'parse_amazon_data'

describe ParseAmazonData do
  it "should pass this canary test" do
    expect(true).to eql(true)
  end

  it "should parse a small csv file" do
    # ParseAmazonData::DataParser.parse('./spec/data/1Line.csv')
  end

  it "should parse a medium csv file" do
    # ParseAmazonData::DataParser.parse('./spec/data/10Lines.csv')
  end

  it "should parse a medium-large csv file" do
    # ParseAmazonData::DataParser.parse('./spec/data/50Lines.csv')
  end
end
