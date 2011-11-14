loldialer!
==========

loldialer is a project devised by David Huerta at HeatSync Labs to create a means to troll people's phones with Arduino, Ruby, and Twilio.  All this in a tin box with a laser-cut interface.

**NOTE:** This is a weapon of mass-trolling.  Like all technology, it is a tool that is only as good or evil or Beyond Good and Evil as the person using it.

Usage
-----
1. Plug in, dial a number
2. Enter the single-digit ID for the sound clip you picked
3. ???
4. PROFIT!!! 

Install
-------
You must have Ruby 1.8.7 or above installed on a working web server, and also gems and the twiliolib* gem.  You must also provide the sound clips in the clips directory.

Configure your MAC, IP, and Gateway address in loldialer.pde to match your own ethernet shield and network configuration.

Hardware required and links to purchase said hardware can be found on the HeatSync Labs wiki: http://wiki.heatsynclabs.org/wiki/Loldialer

Voice APIs supported include Twilio and Tropo.  You can choose which one to use in loldialer.pde.  Internet-accessible TwiML files (or using twiml.cgi when if someone gets it to work) are required for Twilio use.   The tropo_handler.rb script is required for Tropo use and must be internet-accessible or set up as a hosted file in your Tropo dashboard.

\* Only required if using Twilio

License
-------

Unless where otherwise noted, this code is distributed under the Chicken Dance License (CDL).  Please see the included copy  of the license (LICENSE.txt) for deets and the included example instructions for the chicken dance (DANCE.txt).  Video delivery may be conducted via electronic mail by sending a link to the video file directly or through an HTML5-based online viewer, encoded in *Ogg Theora* format to huertanix at ieee dot org.  Physical video delivery will only be accepted in *HD-DVD* format and must be delivered to the following address:

> David Huerta  
> P.O. Box 2182  
> Tempe, Arizona 85280-2182
