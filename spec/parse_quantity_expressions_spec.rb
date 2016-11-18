require 'parse_amazon_data'

questionable_cases = [
  "6g dark golden blonde hair color 1xkit",
  "1x2 count",
  "18 bag"
]
test_cases = {
  # case => [multiplier, value, units, case]
  "2 oz" => ["1", "2", "oz", nil],
  "2oz" => ["1", "2", "oz", nil],
  "4 fluid ounce" => ["1", "4", "oz", nil],
  "2x5oz" => ["2", "5", "oz", nil],
  "2x5-oz" => ["2", "5", "oz", nil],
  "3" => ["1", "3", nil, nil],
  "5-pack" => ["5", nil, nil, "pack"],
  "6 pack" => ["6", nil, nil, "pack"],
  "100 ea" => ["1", "100", "ea", nil],
  "1x100 caps" => ["1", "100", "ea", nil],
  "12.7 oz pack of 6" => ["6", "12.7", "oz", "pack"],
  "6x12.7 fz" => ["6", "12.7", "oz", nil],
  "4.3-ounce jar" => ["1", "4.3", "oz", nil],
  "1x4.7oz" => ["1", "4.7", "oz", nil],
  "50mg capsules, 60 count" => ["60", "50", "mg", "count"]
}

def validate_qty_object(qty, obj=[])
  expect(qty.multiplier).to eql(obj.shift)
  expect(qty.value).to eql(obj.shift)
  expect(qty.units).to eql(obj.shift)
  expect(qty._case).to eql(obj.shift)
end

describe "parse a variety of quantities" do
  test_cases.each do |test_case, validation|
    it "should parse #{test_case}" do
      qty = ParseAmazonData::QuantityExpression.new(test_case)
      validate_qty_object(qty, validation)
    end
  end

  # it "should parse 50mg capsules, 60 count" do
  #   input = 
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
