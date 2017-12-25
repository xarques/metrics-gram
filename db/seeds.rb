require "open-uri"
require "yaml"

# Dir.foreach("db/locations") do |file|
#   file_path = "db/locations/#{file}"
#   if file_path.end_with?(".yml") && File.file?(file_path)
#     location = YAML.load(open(file_path).read)
#     c = Location.create!(location)
#     puts "  Add Locations #{file}: #{c.city}"
#   end
# end

Location.destroy_all
# 1 Roles
puts "Creating locations..."
file = "db/locations.yml"
locations = YAML.load(open(file).read)

locations["locations"].each do |location|
  l = Location.create!(location)
  puts "  Add Location: #{l.city}"
end
puts "#{Location.count} locations have been created"
