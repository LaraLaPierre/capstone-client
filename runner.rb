
require 'unirest'
require 'date'

@get_weather_api ="https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22chicago%2C%20il%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"

response = Unirest.get(@get_weather_api)

channel = response.body["query"]["results"]["channel"]
location_city = channel["location"]["city"]
location_state = channel["location"]["region"]
temp = channel["item"]["condition"]["temp"]
units = channel["units"]["temperature"]
condition = channel["item"]["condition"]["text"]

  puts " "
  puts "Welcome to your Calendar App!! "
  puts "===============================" 

while true 
  
  puts " "
  puts "Today is " + DateTime.now.strftime("%A %B %e %Y ")
  puts "The weather in #{location_city} is #{temp}#{units} and #{condition}"
  puts "===============================" 
  puts "Please select an option from the menu below"
  puts " "
  puts "    [1] See all Calendar Events"
  puts "    [2] See one Calendar Event"
  puts "        [a] Search Events by Name"
  puts "        [b] Search Events by Date"
  puts "        [c] Search Events by Location"
  puts "    [3] Create a new Calendar Event"
  puts "    [4] Update a Calendar Event"
  puts "    [5] Destroy a Calendar Event"
  puts "    [signup] Sign up for an account"
  puts "    [login] Log in to your account"
  puts "    [logout] Log out of your account"
  puts "    [q] to exit your Calendar App"


  user_input = gets.chomp

  if user_input == '1'
    response = Unirest.get("http://localhost:3000/calendar_events")
    puts JSON.pretty_generate(response.body)

  elsif user_input == '2'

    print " Enter a Calendar Event Id:  " 
    input_id = gets.chomp

    event_response = Unirest.get("http://localhost:3000/calendar_events/#{input_id}")
    
    puts JSON.pretty_generate(event_response.body)
    puts "*" * 110

  elsif user_input == 'a'
    print "Enter an Event name to search by: "
    search_term = gets.chomp

    calendar_events = Unirest.get("http://localhost:3000/calendar_events?name=#{search_term}")

    puts calendar_events.body

  elsif user_input == 'b'
    print "Enter an Event date to search by (YYYY-MM-DD): "
      search_term = gets.chomp

      calendar_events = Unirest.get("http://localhost:3000/calendar_events?date=#{search_term}")
      puts calendar_events.body

  elsif user_input == 'c'
    print "Enter a Location to search by: "
      search_term = gets.chomp

      calendar_events = Unirest.get("http://localhost:3000/calendar_events?location=#{search_term}")
      puts calendar_events.body

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

      print "Choose an event category: "
      puts "[1] Relaxing [2] Learning [3] Entertaining "
      client_params[:category_id] = gets.chomp

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

  elsif user_input == "signup"
          puts "Signup!"
          puts
          client_params = {}

          print "Name: "
          client_params[:name] = gets.chomp
          
          print "Email: "
          client_params[:email] = gets.chomp

          print "Location - please enter your zipcode: "
          client_params[:location] = gets.chomp
          
          print "Password: "
          client_params[:password] = gets.chomp
          
          print "Password confirmation: "
          client_params[:password_confirmation] = gets.chomp
          
          response = Unirest.post("http://localhost:3000/users", parameters: client_params)
          puts JSON.pretty_generate(response.body) 

  elsif user_input == "login"
          puts "Login"
          puts
          print "Email: "
          user_email = gets.chomp
          print "Password: "
          user_password = gets.chomp

          response = Unirest.post(
                                  "http://localhost:3000/user_token", 
                                  parameters: {
                                                auth: {email: user_email, password: user_password}
                                              }
                                  )

          # puts JSON.pretty_generate(response.body) #optional

          jwt = response.body["jwt"]
          Unirest.default_header("Authorization", "Bearer #{jwt}")

  elsif user_input == "logout"
    jwt = ""
    Unirest.clear_default_headers

  elsif user_input == "q"
    puts "*" * 110
    puts "*" * 110
    puts "Have a beautiful day!"
    puts "*" * 110
    exit
  end
end 



