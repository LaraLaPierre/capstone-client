require 'unirest'


puts "      Please make a selection"
puts "    [1] See all Calendar Events"
puts "    [2] See one Calendar Event"
puts "    [3] Create a new Calendar Event"
puts "    [4] Update a Calendar Event"
puts "    [5] Destroy a Calendar Event"

user_input = gets.chomp

if user_input == '1'
  response = Unirest.get("http://localhost:3000/calendar_events")
  puts JSON.pretty_generate(response.body)
end
