/*
  loldialer - A dialer of lulz
  Copyright (c) 2011 David Huerta. Distributed under the CDL license: http://supertunaman.com/cdl/
 
  Inspired heavily by David A. Mellis's WebClient example and Alexander Brevig's Keypad library example.
*/

#include <SPI.h>
#include <Ethernet.h>
#include <Keypad.h>

const byte ROWS = 4;
const byte COLS = 3;
const int DELAY_VAL = 2;
const int MAX_SHIFT_VAL = 1023;
const int SOFT_RESET_PIN = 12;

char keys[ROWS][COLS] = {
   {'1','2','3'}
  ,{'4','5','6'}
  ,{'7','8','9'}
  ,{'*','0','#'}
}; // map out the keys

// map out the pins
byte rowPins[ROWS] = {5,4,3,2};
byte colPins[COLS] = {8,7,6};

Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

byte mac[] = {0x90,0xA2,0xDA,0x00,0xDE,0x22};
byte ip[] = {172,22,110,97}; 
byte gateway[] = {172,22,110,1};
byte subnet[] = {255,255,254,0};
byte server[] = {50,56,124,136};

// instantiate a network client
EthernetClient client;
int buttonState = 0; // soft reset button state
String phoneNumber = "";
String clip = "";

void setup()
{
  // start the serial library:
  Serial.begin(9600);
  delay(500);
  // start the Ethernet connection:
  Ethernet.begin(mac, ip, gateway, subnet);
  // set up soft reset button
  pinMode(SOFT_RESET_PIN, INPUT);
  ////attachInterrupt(0, softReset, CHANGE);
  // clear screen
  clearDisplay();
}

void loop()
{
  ////digitalWrite(softResetPin, LOW);
  // read the state of the reset button value:
  buttonState = digitalRead(SOFT_RESET_PIN);
  
  // check if the pushbutton is pressed (HIGH)
  if (buttonState == HIGH)
  {
    // reset softly
    softReset();
  }
  
  delay(70); // delay loop to keep the LCD from redrawing stuff too much
  
  char keyPressed = keypad.getKey(); // need to check press selection on keypad

  if (keyPressed)
  {
    if (keyPressed == '#') // # and * are reveresed for some reason
    {
      clearDisplay();
      selectFirstLine();
      Serial.print("THE GAME");
      softReset();
      delay(500);
    }
    else if (keyPressed == '*')
    {
      clearDisplay();
      selectFirstLine();
      Serial.print("i said wut wut");
      selectSecondLine();
      Serial.print("in the *");
      delay(1000);
    }
    else
    {
      // check for complete number
      if (phoneNumber.length() == 10)
      {
        selectSecondLine();
        // determine which sound clip to play
        switch (keyPressed) 
        {
        case '1':
          Serial.print("Rickroll");
          clip = "rickroll";
          break;
        case '2':
          Serial.print("Lavaroll");
          clip = "lavaroll";
          break;
        case '3':
          Serial.print("Keyboard Cat");
          clip = "keyboardcat";
          break;
        case '4':
          Serial.print("Pirate Song");
          clip = "piratesong";
          break;
        case '5':
          Serial.print("Fridayroll");
          clip = "fridayroll";
          break;
        case '6':
          Serial.print("Trololol");
          clip = "trololol";
          break;
        case '7':
          Serial.print("Banana Phone");
          clip = "bananaphone";
          break;
        case '8':
          Serial.print("Boxxy"); // OH GOD WHAT HAVE I DONE
          clip = "boxxy";
          break;
        case '9':
          Serial.print("Badger Badger");
          clip = "badgerbadgermushroom";
          break;
        }
        
        delay(3000);
      }
      else
      {
        phoneNumber = phoneNumber + keyPressed;
      }
    }
  }
  else
  {
    clearDisplay();
    if (phoneNumber.length() == 10)
    {
      if (clip == "")
      {
        selectFirstLine();
        Serial.print("Trolling option:");
      }
      else
      {
        selectFirstLine();
        Serial.print("Connecting...");
        // proceed to lulz
        if (client.connect(server,80))
        {
          selectFirstLine();
          Serial.print("Connected.");
          // replace with your own cgi path...
          client.println("GET /~huertanix/cgi-bin/invoke_lulz.cgi?phone=" + phoneNumber + "&clip=" + clip + " HTTP/1.0");
          client.println();

          selectSecondLine();
          Serial.print("Great Success!");
          delay(5000);
          phoneNumber = "";
          clip = "";
        }
        else
        {
          selectSecondLine();
          Serial.print("Trying...");
        }
        // close connection to ensure proper re-connect
        client.stop();
      }
    }
    else
    {
      selectFirstLine();
      Serial.print("Phone number:");
      
      if (phoneNumber.length() > 0)
      {
        selectSecondLine();
        Serial.print(phoneNumber);
      }
    }
  }
}

void clearDisplay() {
  Serial.write(0xFE);
  Serial.write(0x01);
}

void selectFirstLine() {
  Serial.write(0xFE);
  Serial.write(128);
   //delay(10);
}

void selectSecondLine() {
  Serial.write(0xFE,);
  Serial.write(192);
}

void softReset() {
  clearDisplay();
  phoneNumber = "";
  clip = "";
}