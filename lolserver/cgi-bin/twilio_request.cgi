#!/usr/bin/env ruby
#Copyright (c) 2011 David Huerta. Distributed under the CDL license: http://supertunaman.com/cdl/

require 'cgi'
require 'rubygems'
require 'twiliolib'

# Twilio bits, swap out with the ones for your account
API_VERSION = "2010-04-01"
ACCOUNT_SID = ""
ACCOUNT_TOKEN = ""
CALLER_ID = "5555555555"; # Number must be validated with Twilio before using.
# PROTIP: Buy a number from Twilio and set that up to prank them via robocall when they call back to RAEG at you

account = Twilio::RestAccount.new(ACCOUNT_SID, ACCOUNT_TOKEN)

cgi = CGI.new
clip = cgi["clip"]
phone = cgi["phone"] # Should be formated as 10 digits with no special chars

# Check for valid phone format and clip
if phone =~ /^[\d]{10}$/
  request = {
      'From' => CALLER_ID,
      'To' => phone,
      #NOTE: This must be a fully qualified URL accesible from cybersauce
      'Url' => "http://whateveryourwebsiteis.com/lolserver/lulz/#{clip}.xml"
  }

  response = account.request("/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/Calls",'POST', request)
  response.error! unless response.kind_of? Net::HTTPSuccess

  puts "code: %s\nbody: %s" % [response.code, response.body]
  puts "Content-type: text/html \n\n"
  puts "<html><body>Calling...</body></html> \r\n"
else
  puts "Content-type: text/html \n\n"
  puts "<html><body>ERROR: Phone number format not supported.</body></html>"
end
