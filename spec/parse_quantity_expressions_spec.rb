require 'parse_amazon_data'

QUESTIONABLE_PARSING_CASES = [
  "6g dark golden blonde hair color 1xkit",
  "1x2 count",
  "18 bag",
  "40 gal. fits all brita boxed",
  "1x1ct"
]

QUESTIONABLE_EQUALITY_CASES = [
  ["2-pack", "1x2 count"]
]

# case => [multiplier, value, units, case]
PARSE_TEST_CASES = {
  "4x 2.254 oz" => ["4", "2.254", "oz", nil],
  "5x" => ["5", nil, nil, nil],
  "2 oz" => ["1", "2", "oz", nil],
  "2oz" => ["1", "2", "oz", nil],
  "2.254 oz" => ["1", "2.254", "oz", nil],
  "6x2.24 oz" => ["6", "2.24", "oz", nil],
  "16 ounce" => ["1", "16", "oz", nil],
  "4 fluid ounce" => ["1", "4", "oz", nil],
  "9 fl oz" => ["1", "9", "oz", nil],
  "9.9 fl oz" => ["1", "9.9", "oz", nil],
  "19 fl. oz." => ["1", "19", "oz", nil],
  "2x5oz" => ["2", "5", "oz", nil],
  "2x.5oz" => ["2", "0.5", "oz", nil],
  "2x .5oz" => ["2", "0.5", "oz", nil],
  "0.5oz" => ["1", "0.5", "oz", nil],
  "2x5-oz" => ["2", "5", "oz", nil],
  "3" => ["1", "3", nil, nil],
  "5-pack" => ["5", nil, nil, "pack"],
  "6 pack" => ["6", nil, nil, "pack"],
  "100 ea" => ["1", "100", "ea", nil],
  "1x100 caps" => ["1", "100", "ea", nil],
  "12.7 oz pack of 6" => ["6", "12.7", "oz", "pack"],
  "16-Ounce Glass Pack of 6" => ["6", "16", "oz", "pack"],
  "8-ounce pack of 6" => ["6", "8", "oz", "pack"],
  "6x12.7 fz" => ["6", "12.7", "oz", nil],
  "4.3-ounce jar" => ["1", "4.3", "oz", nil],
  "1x4.7oz" => ["1", "4.7", "oz", nil],
  "50mg capsules, 60 count" => ["60", "50", "mg", "count"],
  "1x2.5oz" => ["1", "2.5", "oz", nil],
  "5 bars" => ["1", "5", "bars", nil],
  "1x2 Count)" => ["2", nil, nil, "count"],
  ".7 oz - Case of 8" => ["8", "0.7", "oz", "case"],
  "Case of 8 (.7 oz)" => ["8", "0.7", "oz", "case"],
}

COMPARE_EQUAL_TEST_CASES = [
  ["22 fz", "1x22oz"],
  ["8 oz", "1x8 oz"],
  ["4 fluid ounce", "4 oz"],
  ["100 ea", "1x100 caps"],
  ["12.7 oz pack of 6", "6x12.7 fz"],
  ["16 fz", "16 fl oz"],
  ["8-ounce pack of 6", "6x8 oz"],
  ["2.25 oz", "1x2.25oz"],
  ["5 bars", "1x5 bars"],
  ["3-ounce bag pack of 12", "12x3 oz"],
  ["48x5/1.5 OZ", "240 per pack"],
  ["48x5/1.5 OZ", "240 per pack -- 1 each"],
  ["12 oz 6 pk", "6x12Oz"],
  ["12 oz 6 pk", "6x12Oz"].reverse,
]

COMPARE_NONEQUAL_TEST_CASES = [
  ["10 oz", "12x10 oz"],
  ["5-pack", "12x5oz"],
]

def validate_qty_object(qty, obj=[])
  expect(qty.multiplier).to eql(obj.shift)
  expect(qty.value).to eql(obj.shift)
  expect(qty.units).to eql(obj.shift)
  expect(qty._case).to eql(obj.shift)
end

describe "parse a variety of quantities" do
  PARSE_TEST_CASES.each do |test_case, validation|
    it "should parse #{test_case}" do
      qty = ParseAmazonData::QuantityExpression.new(test_case)

      validate_qty_object(qty, validation)
    end
  end
end

describe "compare a variety of equal quantities" do
  COMPARE_EQUAL_TEST_CASES.each do |test_case|
    it "should parse #{test_case.to_s}" do
      qty1 = ParseAmazonData::QuantityExpression.new(test_case[0])
      qty2 = ParseAmazonData::QuantityExpression.new(test_case[1])

      expect(qty1 == qty2).to be(true)
    end
  end
end

describe "compare a variety of non-equal quantities" do
  COMPARE_NONEQUAL_TEST_CASES.each do |test_case|
    it "should parse #{test_case.to_s}" do
      qty1 = ParseAmazonData::QuantityExpression.new(test_case[0])
      qty2 = ParseAmazonData::QuantityExpression.new(test_case[1])

      expect(qty1 == qty2).to be(false)
    end
  end
end
