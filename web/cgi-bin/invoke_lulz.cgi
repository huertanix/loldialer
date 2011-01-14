#!/usr/bin/env ruby

require 'cgi'
require 'rubygems'
require 'twiliolib'

# Twilio bits, swap out with the ones for your account
API_VERSION = '2010-04-01'
ACCOUNT_SID = ''
ACCOUNT_TOKEN = ''
CALLER_ID = '5555555555'; # Number must be validated with Twilio before using.
# PROTIP: Buy a number from Twilio and set that up to prank them via robocall when they call back to RAEG at you

account = Twilio::RestAccount.new(ACCOUNT_SID, ACCOUNT_TOKEN)

cgi = CGI.new
soundClip = cgi['clip']
phoneNumber = cgi['phone']

# TODO: Check for valid phone format and clip
requestDeets = {
    'From' => CALLER_ID,
    'To' => phoneNumber,
     #NOTE: This must be a fully qualified URL accesible from cybersauce
    'Url' => 'http://whateveryourwebsiteis.com/loldialer/cgi-bin/twiml.cgi?clip=' + soundClip,
}

response = account.request("/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/Calls",'POST', requestDeets)

response.error! unless response.kind_of? Net::HTTPSuccess

puts "code: %s\nbody: %s" % [response.code, response.body]
puts "Content-type: text/html \r\n\r\n"
puts "<html><body>Calling...</body></html> \r\n"