require 'minitest/autorun'
require '../parseData'

TEST_DATA_FILES = %w"./test_data/10Lines.csv, ./test_data/50Lines.csv, ./test_data/full_upload.csv"

class DataParserTest < Minitest::Test
  # takes a csv
  def test_parse_10Lines
    assert(false, 'Assertion was false.')
  end
end
