require 'Unirest'

response = Unirest.get("https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22chicago%2C%20il%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")

channel = response.body["query"]["results"]["channel"]
location_city = channel["location"]["city"]
location_state = channel["location"]["region"]
temp = channel["item"]["condition"]["temp"]
units = channel["units"]["temperature"]
condition = channel["item"]["condition"]["text"]

puts "Today in #{location_city},#{location_state}, it is #{temp}#{units} and #{condition}"
# p units
# p temp
# p location_state
# p condition