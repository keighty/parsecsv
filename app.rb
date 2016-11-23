# myapp.rb
require 'sinatra'
require 'csv'
require './lib/parse_amazon_data'

set :haml, :format => :html5

get '/' do
  haml :index
end

# titleA qtyA titleB qtyB orig
INPUT_FILENAME = 'uploads/temp.csv'
MATCHED_FILENAME = 'downloads/matched.csv'
UNMATCHED_FILENAME = 'downloads/not_matched.csv'

post "/" do
  File.open(INPUT_FILENAME, "w") do |f|
    f.write(params['myfile'][:tempfile].read)
  end

  parsed_data = ParseAmazonData::DataParser.new(INPUT_FILENAME)
  @matched = parsed_data.matched
  @unmatched = parsed_data.not_matched

  File.open(MATCHED_FILENAME, "w") do |file|
    @matched.each do |item|
      file.write(item[:orig])
    end
  end

  File.open(UNMATCHED_FILENAME, "w") do |file|
    @unmatched.each do |item|
      file.write(item[:orig])
    end
  end

  haml :download
end

post "/addItem" do
  request_content = request.body.read
  addToCSV(MATCHED_FILENAME, request_content)
end

def addToCSV(file, content)
  File.open(file, "a") do |file|
    file.puts(content)
  end
end
