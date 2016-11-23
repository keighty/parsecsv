# myapp.rb
require 'sinatra'
require 'csv'
require './lib/parse_amazon_data'

set :haml, :format => :html5

get '/' do
  haml :index
end

# titleA
# qtyA
# titleB
# qtyB
# orig

post "/" do
  input_filename = 'uploads/temp.csv'
  matched_output_filename = 'downloads/matched.csv'
  not_matched_output_filename = 'downloads/not_matched.csv'

  File.open(input_filename, "w") do |f|
    f.write(params['myfile'][:tempfile].read)
  end

  parsed_data = ParseAmazonData::DataParser.new(input_filename)
  @matched = parsed_data.matched
  @unmatched = parsed_data.not_matched

  File.open(matched_output_filename, "w") do |file|
    @matched.each do |item|
      file.write(item[:orig])
    end
  end

  File.open(not_matched_output_filename, "w") do |file|
    @unmatched.each do |item|
      file.write(item[:orig])
    end
  end

  haml :download
end
