require 'parse_amazon_data'

describe "parse a variety of quantities" do
  it "no multiplier" do
    input = "2 oz"
    qty = ParseAmazonData::QuantityExpression.new(input)

    expect(qty.multiplier).to eql("1")
    expect(qty.value).to eql("2")
    expect(qty.units).to eql("oz")
    expect(qty._case).to eql(nil)
  end

  it "with multiplier" do
    input = "2x5oz"
    qty = ParseAmazonData::QuantityExpression.new(input)

    expect(qty.multiplier).to eql("2")
    expect(qty.value).to eql("5")
    expect(qty.units).to eql("oz")
    expect(qty._case).to eql(nil)
  end

  it "with no multiplier and no units" do
    input = "2"
    qty = ParseAmazonData::QuantityExpression.new(input)

    expect(qty.multiplier).to eql("1")
    expect(qty.value).to eql("2")
    expect(qty.units).to eql(nil)
    expect(qty._case).to eql(nil)
  end

  # it "should parse 2-pack" do
  #   input = "2-pack"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 1x2 count" do
  #   input = "1x2 count"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 8 oz" do
  #   input = "8 oz"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 1x8 oz" do
  #   input = "1x8 oz"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 6g,dk gldn bln, 5.28 fz" do
  #   input = "6g,dk gldn bln, 5.28 fz"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 6g dark golden blonde hair color 1xkit" do
  #   input = "6g dark golden blonde hair color 1xkit"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 4 oz" do
  #   input = "4 oz"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 1x4oz" do
  #   input = "1x4oz"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 10 oz" do
  #   input = "10 oz"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 12x10 oz" do
  #   input = "12x10 oz"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 5-pack" do
  #   input = "5-pack"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 12x5oz" do
  #   input = "12x5oz"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 4 fluid ounce" do
  #   input = "4 fluid ounce"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 4 oz" do
  #   input = "4 oz"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 18 bag" do
  #   input = "18 bag"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 1x18 bag" do
  #   input = "1x18 bag"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 100 ea" do
  #   input = "100 ea"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 1x100 caps" do
  #   input = "1x100 caps"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 12.7 oz pack of 6" do
  #   input = "12.7 oz pack of 6"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 6x12.7 fz" do
  #   input = "6x12.7 fz"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 3 oz" do
  #   input = "3 oz"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 12x3oz" do
  #   input = "12x3oz"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 4.3-ounce jar" do
  #   input = "4.3-ounce jar"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 1x4.3oz" do
  #   input = "1x4.3oz"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # 
  # it "should parse 50mg capsules, 60 count" do
  #   input = "50mg capsules, 60 count"
  #   qty = ParseAmazonData::QuantityExpression.new(input)
  #   expect(qty).to eql()
  # end
  # input1 = "22 fz"
  # input2 = "1x22oz"
  # 
  # input1 = "2-pack"
  # input2 = "1x2 count"
  # 
  # input1 = "8 oz"
  # input2 = "1x8 oz"
  # 
  # input1 = "6g,dk gldn bln, 5.28 fz"
  # input2 = "6g dark golden blonde hair color 1xkit"
  # 
  # input1 = "10 oz"
  # input2 = "12x10 oz"
  # 
  # input1 = "5-pack"
  # input2 = "12x5oz"
  # 
  # input1 = "4 fluid ounce"
  # input2 = "4 oz"
  # 
  # input1 = "100 ea"
  # input2 = "1x100 caps"
  # 
  # input1 = "12.7 oz pack of 6"
  # input2 = "6x12.7 fz"
end
