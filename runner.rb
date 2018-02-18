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

elsif user_input == '2'
  puts " Enter a Calendar Event Id"
  input_id = gets.chomp 
  response = Unirest.get("http://localhost:3000/calendar_events/#{input_id}")
  puts JSON.pretty_generate(response.body)

elsif user_input == '3'
  client_params = {}

    print "Event Name: "
    client_params[:name] = gets.chomp

    print "Event Date: "
    client_params[:event_date] = gets.chomp

    print "Event Time: "
    client_params[:event_time] = gets.chomp

    print "Event Location: "
    client_params[:location] = gets.chomp

    client_params

    response = Unirest.post("http://localhost:3000/calendar_events", parameters: client_params)

    if response.code == 200
      puts "Here is your new Calendar Event "
      puts JSON.pretty_generate(response.body)

    elsif response.code == 422
      errors = response.body["errors"]
      puts JSON.pretty_generate(errors)
      
    else response.code == 401
      puts JSON.pretty_generate(response.body)
    end

elsif user_input == "4"
  puts "Enter a Calendar Event Id "
  input_id = gets.chomp 

  calendar_event = Unirest.get("http://localhost:3000/calendar_events/#{input_id}").body
  

  client_params = {}

    print "Name (#{calendar_event["name"]}): "
    client_params[:name] = gets.chomp

    print "Event Date (#{calendar_event["event_date"]}): "
    client_params[:event_date] = gets.chomp

    print "Event Time (#{calendar_event["event_time"]}): "
    client_params[:event_time] = gets.chomp

    print "Location (#{calendar_event["location"]}): "
    client_params[:location] = gets.chomp

    client_params.delete_if { |key, value| value.empty? }
    client_params

  response = Unirest.patch("http://localhost:3000/calendar_events/#{input_id}", parameters: client_params)

  if response.code == 200
      puts "==================================="
      puts "Here is your new Calendar Event "
      puts JSON.pretty_generate(response.body)

    elsif response.code == 422
      errors = response.body["errors"]
      puts JSON.pretty_generate(errors)
      
    else response.code == 401
      puts JSON.pretty_generate(response.body)
    end

elsif user_input == "5"
  puts "Enter a Calendar Event Id "
  input_id = gets.chomp 

  response = Unirest.delete("http://localhost:3000/calendar_events/#{input_id}")
  if response.code == 200
    puts "Your event has been removed."
  end 

end


