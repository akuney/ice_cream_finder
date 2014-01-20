require 'nokogiri'
require 'rest-client'
require 'addressable/uri'
require 'json'

puts "Enter your address:"
user_address = gets.chomp

lat_long_url = Addressable::URI.new(
  :scheme => "https",
  :host => "maps.googleapis.com",
  :path => "maps/api/geocode/json",
  :query_values => {:address => user_address, :sensor => false}
).to_s

address_json = RestClient.get(lat_long_url)
address_hash = JSON.parse(address_json)

geometry_hash = address_hash["results"].first["geometry"]
lat = geometry_hash["location"]["lat"]
lng = geometry_hash["location"]["lng"]
location_string = "#{lat},#{lng}"

API_KEY = "AIzaSyAgUCoAExomRGnxAOUlO8WHXgTky4gzB0A"

find_nearby_url = Addressable::URI.new(
  :scheme => "https",
  :host => "maps.googleapis.com",
  :path => "maps/api/place/nearbysearch/json",
  :query_values => {
    :key => API_KEY,
    :location => location_string,
    :radius => 500,
    :sensor => false,
    :keyword => "ice cream"}
).to_s

find_nearby_json = RestClient.get(find_nearby_url)
find_nearby_hash = JSON.parse(find_nearby_json)

nearby_results_array = find_nearby_hash["results"]

nearby_results_array.map! do |result|
 {
  name: result["name"],
  lat: result["geometry"]["location"]["lat"],
  lng: result["geometry"]["location"]["lng"]
 }
end

puts "Your nearby ice cream places:"

nearby_results_array.each_with_index do |result, i|
  puts "#{i}: #{result[:name]}"
end

puts "Which ice cream place do you want directions to?"

choice = gets.chomp.to_i
destination_string =
"#{nearby_results_array[choice][:lat]}, #{nearby_results_array[choice][:lng]}"


directions_url = Addressable::URI.new(
  :scheme => "https",
  :host => "maps.googleapis.com",
  :path => "maps/api/directions/json",
  :query_values => {:origin => location_string, :destination => destination_string,
    :sensor => false}
).to_s

directions_json = RestClient.get(directions_url)
directions_hash = JSON.parse(directions_json)

steps_array = directions_hash["routes"].first["legs"].first["steps"]

puts "Directions:"

steps_array.each do |step|
  instructions = step["html_instructions"]
  parsed_instructions = Nokogiri::HTML(instructions)
  puts parsed_instructions.text
end


