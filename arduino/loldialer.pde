/*
  loldialer - A dialer of lulz
  Copyright (c) 2011 David Huerta. Distributed under the CDL license: http://supertunaman.com/cdl/
 
  Inspired heavily by David A. Mellis's WebClient example and Alexander Brevig's Keypad library example.
*/

#include <SPI.h>
#include <Ethernet.h>
#include <Keypad.h>

const int LCDdelay = 1;
const byte ROWS = 4;
const byte COLS = 3;

char keys[ROWS][COLS] = {
   {'1','2','3'}
  ,{'4','5','6'}
  ,{'7','8','9'}
  ,{'#','0','*'}
}; // map out the keys

// idk :<
byte rowPins[ROWS] = {5,4,3,2};
byte colPins[COLS] = {8,7,6};

Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

byte mac[] = {0x90,0xA2,0xDA,0x00,0x17,0x1A}; // Replace with your own MAC address
byte ip[] = {172,16,0,77}; // Replace with your own static IP
byte gateway[] = {172,16,0,1}; // ...
byte subnet[] = {255,255,252,0}; // ...
byte server[] = {192,168,34,127}; // ...

// Instantiate a network client
Client client(server, 80);
String phoneNumber = "";
String clip = "";
// Something to keep track of the call state...
boolean called = false;

void setup()
{
  // start the serial library:
  Serial.begin(9600);
  // set screen size in case LCD gets derpy...
  //Serial.print(0xFE, BYTE);
  //Serial.print(6, BYTE);
  //Serial.print(0xFE, BYTE);
  //Serial.print(4, BYTE);
  delay(4000);

  // start the Ethernet connection:
  Ethernet.begin(mac, ip, gateway, subnet);

  // clear screen
  clearDisplay();
}

void loop()
{
  char keyPressed = keypad.getKey(); // need to check press selection on keypad

  if (keyPressed)
  {
    if (keyPressed == '#')
    {
      clearDisplay();
      Serial.println("LOLDONGS");
    }
    else if (keyPressed == '*')
    {
      clearDisplay();
      Serial.println("i said wut wut");
      Serial.println("in the *");
    }
    else
    {
      // Check for complete number
      if (phoneNumber.length() == 10)
      { 
        // Determine which sound clip to play
        switch (keyPressed) 
        {
        case '1':
          Serial.println("Rickroll");
          clip = "rickroll";
          break;
        case '2':
          Serial.println("Lavaroll");
          clip = "lavaroll";
          break;
        case '3':
          Serial.println("Keyboard Cat");
          clip = "keyboardcat";
          break;
        case '4':
          Serial.println("Pirate Song");
          clip = "piratesong";
          break;
        case '5':
          Serial.println("Fridayroll");
          clip = "fridayroll";
          break;
        case '6':
          Serial.println("Trololol");
          clip = "trololol";
          break;
        case '7':
          Serial.println("Banana Phone");
          clip = "bananaphone";
          break;
        case '8':
          Serial.println("Boxxy"); // OH GOD WHAT HAVE I DONE
          clip = "boxxy";
          break;
        case '9':
          Serial.println("Badger Badger");
          clip = "badgerbadgermushroom";
          break;
        }
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
        Serial.println("Choose a clip:");
      }
      else
      {
        Serial.println("Connecting...");
        // Proceed to lulz
        if (client.connect())
        {
          Serial.println("Connected.");
          // Replace with your own cgi path...
          client.println("GET /~huertanix/cgi-bin/invoke_lulz.cgi?phone=" + phoneNumber + "&clip=" + clip + " HTTP/1.0");
          client.println();

          Serial.println("Great Success!");
          delay(5000);
          phoneNumber = "";
          clip = "";
        }
        else
        {
          Serial.println("Trying...");
        }

        if (!client.connected())
        {
          client.stop();
        }
      }
    }
    else
    {
      Serial.println("Enter a number:");
      Serial.println(phoneNumber);
    }
  }
}

void clearDisplay() {
  Serial.print(0xFE, BYTE);
  Serial.print(0x01, BYTE);
  //delay(LCDdelay);
}