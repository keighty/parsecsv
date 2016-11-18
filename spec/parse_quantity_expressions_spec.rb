require 'parse_amazon_data'

questionable_cases = [
  "6g dark golden blonde hair color 1xkit",
  "1x2 count",
  "18 bag"
]
PARSE_TEST_CASES = {
  # case => [multiplier, value, units, case]
  "5x" => ["5", nil, nil, nil],
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

COMPARE_EQUAL_TEST_CASES = [
  # ["2-pack", "1x2 count"],
  ["22 fz", "1x22oz"],
  ["8 oz", "1x8 oz"],
  ["4 fluid ounce", "4 oz"],
  ["100 ea", "1x100 caps"],
  ["12.7 oz pack of 6", "6x12.7 fz"]
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
