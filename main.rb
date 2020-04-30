require "google_maps_service"
require "dotenv"
require "json"

Dotenv.load

gmaps = GoogleMapsService::Client.new(key: ENV['API_KEY'])

json = File.read("data.json")

data = JSON.parse(json)

result = File.open("places.json", "a+")

result.write('[')

data.map! {|d|
    begin 
        location = gmaps.geocode(d["address"]).first[:geometry][:bounds][:northeast]

        result.write('
            {
                "name": "' + d["name"] + '",
                "info": "' + d["info"] + '",
                "address": "' + d["address"] + '",
                "location": {
                    "latitude": ' + location[:lat].to_s + ',
                    "longitude": ' + location[:lng].to_s + '
                },
                "url": "' + d["url"] + '"
            },
        ')
    rescue => e
        puts e.message
    end
}

result.write(']')
