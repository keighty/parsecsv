# myapp.rb
require 'sinatra'

set :haml, :format => :html5

get '/' do
  haml :index
end

post "/" do
  File.open('uploads/' + params['myfile'][:filename], "w") do |f|
    f.write(params['myfile'][:tempfile].read)
  end
  return "The file was successfully uploaded!"
end
