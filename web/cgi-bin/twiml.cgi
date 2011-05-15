#!/usr/bin/env ruby
#Copyright (c) 2011 David Huerta. Distributed under the CDL license: http://supertunaman.com/cdl/

require 'cgi'
require 'rubygems'
require 'twiliolib'

cgi = CGI.new
#NOTE: The Twilio Ruby gem does NOT support passing in POST parameters from a request call, and GET won't work, so this file is sort of not usable
clip = cgi["clip"] + ".mp3" # Assuming mp3, but can be .wav or other formats.  See: http://www.twilio.com/docs/api/2010-04-01/twiml/play
url = "http://whateveryourwebsiteis.com/loldialer/"

@r = Twilio::Response.new
@r.addSay "Hello, you just lost the game", :voice => "woman", :language => "en" # Kick em' while they're down
@r.addPlay url + clip

puts "Content-type: text/xml\n\n"
puts @r.respond