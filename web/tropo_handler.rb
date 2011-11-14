call('tel:+1' + $phone, { 
  :onAnswer => lambda { |event| 
    say "You just lost the game http://www.whateveryourwebsiteis.com/loldialer/lulz/#{$clip}.mp3"
    hangup
  }
})
