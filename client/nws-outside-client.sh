#!/usr/bin/env ruby
require 'open-uri'
require 'nokogiri'
require 'json'
require 'rest_client'
require File.join(File.dirname(__FILE__), 'temp')

doc = Nokogiri::XML(open("http://w1.weather.gov/xml/current_obs/KSLC.xml"))
doc.inspect

value = 0.0
doc.xpath('//temp_f').each do |node|
  value = node.text.to_f
end

temp = Temp.new('outside', value)
puts temp.inspect

json = JSON.generate(temp)
puts json

RestClient.post 'http://cmm-imp-temp.herokuapp.com', json, {:content_type => :json}
