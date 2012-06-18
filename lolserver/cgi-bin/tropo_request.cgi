#!/usr/bin/env ruby
#Copyright (c) 2011 David Huerta. Distributed under the CDL license: http://supertunaman.com/cdl/

require 'cgi'
require 'net/http'
require 'rubygems'

# Tropo token, swap out with the ones for your account
ACCOUNT_TOKEN = ""

cgi = CGI.new
clip = cgi["clip"]
phone = cgi["phone"]

# Check for valid phone format and clip
if phone =~ /^[\d]{10}$/
  #parms = { :action => 'create', :token => ACCOUNT_TOKEN, :phone => phone, :clip => clip }
  url = URI("http://api.tropo.com/1.0/sessions?action=create&token=#{ACCOUNT_TOKEN}&phone=#{phone}&clip=#{clip}")
  #url.query = URI.encode_www_form(parms) # Ruby drama makes this not work in Ruby 1.8
  #response = Net::HTTP.get_response(url)
  Net::HTTP.get(url)
  
  puts "Content-type: text/html \n\n"
  puts "<html><body>Calling...</body></html>"
else
  puts "Content-type: text/html \n\n"
  puts "<html><body>ERROR: Phone number format not supported.</body></html>"
end