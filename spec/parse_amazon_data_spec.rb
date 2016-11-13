require 'parse_amazon_data'

describe ParseAmazonData do
  it "should pass this canary test" do
    expect(true).to eql(true)
  end

  it "should require the files correctly" do
    expect(ParseAmazonData.class).to be(Module)
    expect(ParseAmazonData::DataParser.class).to be(Class)
  end

  it "should parse a small csv file" do
    ParseAmazonData::DataParser.parse('./spec/data/10Lines.csv')
  end

end
