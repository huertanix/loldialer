/*
  loldialer - A dialer of lulz
  Copyright (c) 2011 David Huerta. Distributed under the CDL license: http://supertunaman.com/cdl/
 
  Inspired heavily by David A. Mellis's WebClient example and Alexander Brevig's Keypad library example.
*/

#include <SPI.h>
#include <Ethernet.h>
#include <Keypad.h>
#include <SoftwareSerial.h>

 // Attach the serial display's RX line to digital pin 2
SoftwareSerial mySerial(11,10); // pin 9 = TX, pin 10 = RX (unused)

const byte ROWS = 4;
const byte COLS = 3;
const int DELAY_VAL = 2;
const int MAX_SHIFT_VAL = 1023;
const int SOFT_RESET_PIN = 2;

char keys[ROWS][COLS] = {
   {'1','2','3'}
  ,{'4','5','6'}
  ,{'7','8','9'}
  ,{'*','0','#'}
}; // map out the keys

// map out the pins
byte rowPins[ROWS] = {6,5,4,3};
byte colPins[COLS] = {9,8,7};

Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

byte mac[] = {0x90,0xA2,0xDA,0x00,0xDE,0x22};
byte server[] = {50,56,124,136};

// instantiate a network client
EthernetClient client;
String phoneNumber = "";
String clip = "";

void setup()
{
  Serial.begin(9600);
  Serial.println("setting up");
  
  // start the serial library:
  mySerial.begin(9600);
  delay(500);

  // start the Ethernet connection:
  if (Ethernet.begin(mac) == 0) {
    Serial.println("Failed to configure Ethernet using DHCP");
    // no point in carrying on, so do nothing forevermore:
    for(;;)
      ;
  }
  // give the Ethernet shield a second to initialize:
  delay(1000);

  pinMode(SOFT_RESET_PIN,INPUT); //necessary?
  digitalWrite(SOFT_RESET_PIN,HIGH); //pullup resistor
  attachInterrupt(0,softReset, LOW); // use interrupt 0 (pin 2) and run function

  // clear screen
  clearDisplay();
  Serial.println("setup finished");
}

void loop()
{
  
  delay(70); // delay loop to keep the LCD from redrawing stuff too much
  
  char keyPressed = keypad.getKey(); // need to check press selection on keypad
  Serial.print("keyPressed: ");
  Serial.println(keyPressed);
  
  if (keyPressed)
  {
    if (keyPressed == '#') // # and * are reveresed for some reason
    {
      clearDisplay();
      selectFirstLine();
      mySerial.print("THE GAME");
      softReset();
      delay(500);
    }
    else if (keyPressed == '*')
    {
      clearDisplay();
      selectFirstLine();
      mySerial.print("i said wut wut");
      selectSecondLine();
      mySerial.print("in the *");
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
          mySerial.print("Rickroll");
          clip = "rickroll";
          break;
        case '2':
          mySerial.print("Lavaroll");
          clip = "lavaroll";
          break;
        case '3':
          mySerial.print("Keyboard Cat");
          clip = "keyboardcat";
          break;
        case '4':
          mySerial.print("Pirate Song");
          clip = "piratesong";
          break;
        case '5':
          mySerial.print("Fridayroll");
          clip = "fridayroll";
          break;
        case '6':
          mySerial.print("Trololol");
          clip = "trololol";
          break;
        case '7':
          mySerial.print("Banana Phone");
          clip = "bananaphone";
          break;
        case '8':
          mySerial.print("Boxxy"); // OH GOD WHAT HAVE I DONE
          clip = "boxxy";
          break;
        case '9':
          mySerial.print("Badger Badger");
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
        mySerial.print("Trolling option:");
        Serial.println("Trolling option");
      }
      else
      {
        selectFirstLine();
        mySerial.print("Connecting...");
        Serial.println("Connecting...");
        // proceed to lulz
        if (client.connect(server,80))
        {
          selectFirstLine();
          mySerial.print("Connected.");
          Serial.println("Connected.");
          // replace with your own cgi path...
          String troll = "GET /~huertanix/cgi-bin/invoke_lulz.cgi?phone=" + phoneNumber + "&clip=" + clip + " HTTP/1.0";
          Serial.print("Trolling web url: ");
          Serial.println(troll);
          client.println(troll);
          client.println();

          selectSecondLine();
          mySerial.print("Great Success!");
          Serial.println("Great Success");
          delay(5000);
          phoneNumber = "";
          clip = "";
        }
        else
        {
          selectSecondLine();
          mySerial.print("Trying...");
        }
        // close connection to ensure proper re-connect
        client.stop();
      }
    }
    else
    {
      selectFirstLine();
      mySerial.print("Phone number:");
      Serial.println("Phone number:");
      
      if (phoneNumber.length() > 0)
      {
        selectSecondLine();
        mySerial.print(phoneNumber);
      }
    }
  }
}

void clearDisplay() {
  mySerial.write(0xFE);
  mySerial.write(0x01);
}

void selectFirstLine() {
  mySerial.write(0xFE);
  mySerial.write(128);
   //delay(10);
}

void selectSecondLine() {
  mySerial.write(0xFE);
  mySerial.write(192);
}

void softReset() {
  clearDisplay();
  phoneNumber = "";
  clip = "";
}