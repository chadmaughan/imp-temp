#!/usr/bin/env ruby
require 'json'
require 'rest_client'

class Temp
        def initialize(location, temperature)
                @location = location
                @temperature = temperature
        end

        def to_json(*a)
                {
                        "location" => @location,
                        "temperature" => @temperature
                }.to_json(*a)
        end

        attr_reader :location
        attr_reader :temperature
end

value = `/home/chad/temper1/temper1 -uF | awk -F, '{print $2}'`.gsub(/\s+/, "").to_f

temp = Temp.new('basement', value)
puts temp.inspect

json = JSON.generate(temp)
puts json

RestClient.post 'http://10.3.2.183:9393', json, {:content_type => :json}
