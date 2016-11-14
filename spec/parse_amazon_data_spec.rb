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
    ParseAmazonData::DataParser.parse('./spec/data/1Line.csv')
  end

  describe ParseAmazonData::QuantityExpression do
    describe "basic properties with multiplier, value, and unit" do
      before do
        @input = "2x4oz"
        @qty = ParseAmazonData::QuantityExpression.new(@input)
      end

      it "should assign a multiplier" do
        expect(@qty.multiplier).to eq("2")
      end

      it "should assign a value" do
        expect(@qty.value).to eq("4")
      end

      it "should assign the units" do
        expect(@qty.units).to eq("oz")
      end
    end

    describe "missing multiplier" do
      before do
        @input = "4oz"
        @qty = ParseAmazonData::QuantityExpression.new(@input)
      end

      it "should not assign a multiplier" do
        expect(@qty.multiplier).to eq(nil)
      end

      it "should assign a value" do
        expect(@qty.value).to eq("4")
      end

      it "should assign the units" do
        expect(@qty.units).to eq("oz")
      end
    end

    describe "missing multiplier and units" do
      before do
        @input = "4"
        @qty = ParseAmazonData::QuantityExpression.new(@input)
      end

      it "should not assign a multiplier" do
        expect(@qty.multiplier).to eq(nil)
      end

      it "should assign a value" do
        expect(@qty.value).to eq("4")
      end

      it "should not assign the units" do
        expect(@qty.units).to eq(nil)
      end
    end

    describe "missing multiplier and units" do
      before do
        @input = "4"
        @qty = ParseAmazonData::QuantityExpression.new(@input)
      end

      it "should not assign a multiplier" do
        expect(@qty.multiplier).to eq(nil)
      end

      it "should assign a value" do
        expect(@qty.value).to eq("4")
      end

      it "should not assign the units" do
        expect(@qty.units).to eq(nil)
      end
    end

    describe "no quantities at all" do
      it "should raise an error if no data is found" do
        @input = ""
        expect { ParseAmazonData::QuantityExpression.new(@input) }.to raise_error(RuntimeError, "No qty data available")
      end
    end
  end
end
