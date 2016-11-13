require 'test_helper'

SMALL_DATA = "./test_data/10Lines.csv"
MEDIUM_DATA = "./test_data/50Lines.csv"
LARGE_DATA = "./test_data/full_upload.csv"

class DataParserTest < Minitest::Test
  def class_takes_a_filename
    DataParser.new(SMALL_DATA)
    # test.parse
  end

  def test_parse_10Lines
    assert(false, 'Assertion was false.')
  end
end
