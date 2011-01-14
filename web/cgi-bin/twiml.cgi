#!/usr/bin/env ruby

require 'cgi'
require 'rubygems'
require 'twiliolib'

cgi = CGI.new
audioClip = cgi['clip'] + ".mp3" # assuming mp3, but can be .wav or other formats.  See: http://www.twilio.com/docs/api/2010-04-01/twiml/play
audioBaseUrl = "http://whateveryourwebsiteis.com/loldialer/lulz/"

@r = Twilio::Response.new
@r.addSay "Hello, you just lost the game", :voice => "woman", :language => "en" # kick em' while they're down
@r.addPlay audioBaseUrl + audioClip

#puts "Content-type: text/xml \r\n\r\n" # might be causing issues?

puts @r.respond