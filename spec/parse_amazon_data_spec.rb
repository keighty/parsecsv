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
    # ParseAmazonData::DataParser.parse('./spec/data/1Line.csv')
  end

  it "should parse a medium csv file" do
    # ParseAmazonData::DataParser.parse('./spec/data/10Lines.csv')
  end

  it "should parse a medium-large csv file" do
    # ParseAmazonData::DataParser.parse('./spec/data/50Lines.csv')
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

      it "should assign a multiplier when given a X" do
        input = "2X40Oz"
        multiplier = ParseAmazonData::QuantityExpression.new(input).multiplier
        expect(multiplier).to eql("2")
      end
    end

    describe "case/packs" do
      it "should recognize pack of syntax" do
        input = "16-Ounce Glass Pack of 6"
        case_qty = ParseAmazonData::QuantityExpression.new(input).case_qty
        expect(case_qty).to eql("6")
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
        input = ""
        expect { ParseAmazonData::QuantityExpression.new(input) }.to raise_error(RuntimeError, "No qty data available")
      end
    end

    describe "handle nil input" do
      it "should throw an error with null input" do
        input = nil
        expect { ParseAmazonData::QuantityExpression.new(input) }.to raise_error(ArgumentError, "No qty data available")
      end
    end

    describe "normalize units" do
      it "should remove all hyphens from unit expressions" do
        input = "2-Pack"
        units = ParseAmazonData::QuantityExpression.new(input).units
        expect(units.match(/-/)).to eql(nil)
      end

      it "should remove all whitespace from unit expressions" do
        input = "2 Pack"
        units = ParseAmazonData::QuantityExpression.new(input).units
        expect(units.match(/\s/)).to eql(nil)
      end

      it "should remove all hyphens and white space from unit expressions" do
        input = "2-Pack a-Doodles"
        units = ParseAmazonData::QuantityExpression.new(input).units
        expect(units).to eql('packadoodles')
      end
    end

    describe "==" do
      describe "compare units" do
        it "count == pack" do
          input1 = "2-pack"
          input2 = "2 count"

          qty1 = ParseAmazonData::QuantityExpression.new(input1)
          qty2 = ParseAmazonData::QuantityExpression.new(input2)

          expect(qty1 == qty2).to be(true)
        end

        it "fz == oz" do
          input1 = "2fz"
          input2 = "2 Oz"

          qty1 = ParseAmazonData::QuantityExpression.new(input1)
          qty2 = ParseAmazonData::QuantityExpression.new(input2)

          expect(qty1 == qty2).to be(true)
        end

        it "pack == Pack" do
          input1 = "2-pack"
          input2 = "2 Pack"

          qty1 = ParseAmazonData::QuantityExpression.new(input1)
          qty2 = ParseAmazonData::QuantityExpression.new(input2)

          expect(qty1 == qty2).to be(true)
        end

        it "pack == Pack" do
          input1 = "2-oz"
          input2 = "2 Pack"

          qty1 = ParseAmazonData::QuantityExpression.new(input1)
          qty2 = ParseAmazonData::QuantityExpression.new(input2)

          expect(qty1 == qty2).to be(false)
        end
      end

      describe "compare quantities" do
        it "decimal ounce == 1x decimal oz" do
          input1 = "0.5 Ounce"
          input2 = "1x.5 OZ"

          qty1 = ParseAmazonData::QuantityExpression.new(input1)
          qty2 = ParseAmazonData::QuantityExpression.new(input2)

          expect(qty1 == qty2).to be(true)
        end

        it "2count != 1-pack" do
          input1 = "2-pack"
          input2 = "1 count"

          qty1 = ParseAmazonData::QuantityExpression.new(input1)
          qty2 = ParseAmazonData::QuantityExpression.new(input2)

          expect(qty1 == qty2).to be(false)
        end

        it "2fz != 1oz" do
          input1 = "2fz"
          input2 = "1 Oz"

          qty1 = ParseAmazonData::QuantityExpression.new(input1)
          qty2 = ParseAmazonData::QuantityExpression.new(input2)

          expect(qty1 == qty2).to be(false)
        end

        it "1 pack != 2 Pack" do
          input1 = "1-pack"
          input2 = "2 Pack"

          qty1 = ParseAmazonData::QuantityExpression.new(input1)
          qty2 = ParseAmazonData::QuantityExpression.new(input2)

          expect(qty1 == qty2).to be(false)
        end

        it "1x == no multiplier" do
          input1 = "22 FZ"
          input2 = "1x22Oz"

          qty1 = ParseAmazonData::QuantityExpression.new(input1)
          qty2 = ParseAmazonData::QuantityExpression.new(input2)

          expect(qty1 == qty2).to be(true)
        end

        it "1x != 10x" do
          input1 = "2x10 FZ"
          input2 = "1x20 Oz"

          qty1 = ParseAmazonData::QuantityExpression.new(input1)
          qty2 = ParseAmazonData::QuantityExpression.new(input2)

          expect(qty1 == qty2).to be(false)
        end

        # it "1x == 1" do
        #   input1 = "5-pack"
        #   input2 = "5x50oz"
        # 
        #   qty1 = ParseAmazonData::QuantityExpression.new(input1)
        #   qty2 = ParseAmazonData::QuantityExpression.new(input2)
        # 
        #   expect(qty1 == qty2).to be(true)
        # end

        # it "case_12 == 12 pack" do
        #   input1 = "1.59 oz case_12"
        #   input2 = "1.59 oz 12 pack"
        # 
        #   qty1 = ParseAmazonData::QuantityExpression.new(input1)
        #   qty2 = ParseAmazonData::QuantityExpression.new(input2)
        # 
        #   expect(qty1 == qty2).to be(true)
        # end
      end
    end
  end
end
