/*
  loldialer - A dialer of lulz
  Copyright (c) 2012 David Huerta. Distributed under the CDL license: http://supertunaman.com/cdl/
 
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
byte rowPins[ROWS] = {8,7,6,5};
byte colPins[COLS] = {4,3,2};

Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

byte mac[] = {0x90,0xA2,0xDA,0x00,0x68,0x2F}; // replace with your own MAC address
byte server[] = {192,168,2,1}; // replace with your web server address

// instantiate a network client
EthernetClient client;
int buttonState = LOW; // soft reset button state
String phoneNumber = "";
String clip = "";
String callBroker = "twilio"; // case-sensitive, only other option is "tropo"

void setup()
{
  // start the serial library:
  Serial.begin(9600);
  // set display brightness
  Serial.write(0x7C);
  Serial.write(157);
  // set screen size in case LCD gets derpy...
  Serial.write(0xFE);
  Serial.write(6);
  Serial.write(0xFE);
  Serial.write(4);
  delay(4000);
  // start the Ethernet connection:
  Ethernet.begin(mac);
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
  ////if (buttonState == HIGH)
  ////{
    // reset softly 
    //softReset(); // FAIL
  ////}
  
  delay(80); // delay loop to keep the LCD from redrawing stuff too much
  
  char keyPressed = keypad.getKey(); // need to check press selection on keypad

  if (keyPressed)
  {
    if (keyPressed == '#') // # and * are reversed for some reason
    {
      clearDisplay();
      selectFirstLine();
      Serial.print("THE GAME");
      delay(500);
      softReset();
    }
    else if (keyPressed == '*')
    {
      // check for complete number
      if (phoneNumber.length() == 10)
      {
        selectSecondLine();
        Serial.print("1. Rickroll     ");
        delay(1000);
        selectSecondLine();
        Serial.print("2. Benny Lava   ");
        delay(1000);
        selectSecondLine();
        Serial.print("3. Keyboard Cat ");
        delay(1000);
        selectSecondLine();
        Serial.print("4. Pirate Song  ");
        delay(1000);
        selectSecondLine();
        Serial.print("5. Fridayroll   ");
        delay(1000);
        selectSecondLine();
        Serial.print("6. Trololol     ");
        delay(1000);
        selectSecondLine();
        Serial.print("7. Banana Phone ");
        delay(1000);
        selectSecondLine();
        Serial.print("8. Boxxy        ");
        delay(1000);
        selectSecondLine();
        Serial.print("9. Badger Badger");
        delay(1000);
        selectSecondLine();
        Serial.print("0. Nyan Cat     ");
        delay(1000);
      }
      else
      {
        selectFirstLine();
        Serial.print("Made in PHX+NYC ");
        selectSecondLine();
        Serial.print("By David Huerta ");
        delay(2000);
      }
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
          Serial.print("1. Rickroll     ");
          clip = "rickroll";
          break;
        case '2':
          Serial.print("2. Benny Lava   ");
          clip = "lavaroll";
          break;
        case '3':
          Serial.print("3. Keyboard Cat ");
          clip = "keyboardcat";
          break;
        case '4':
          Serial.print("4. Pirate Song  ");
          clip = "piratesong";
          break;
        case '5':
          Serial.print("5. Fridayroll   ");
          clip = "fridayroll";
          break;
        case '6':
          Serial.print("6. Trololol     ");
          clip = "trololol";
          break;
        case '7':
          Serial.print("7. Banana Phone ");
          clip = "bananaphone";
          break;
        case '8':
          Serial.print("8. Boxxy        "); // OH GOD WHAT HAVE I DONE
          clip = "boxxy";
          break;
        case '9':
          Serial.print("9. Badger Badger");
          clip = "badgerbadgermushroom";
          break;
        case '0':
          Serial.print("0. Nyan Cat     ");
          clip = "nyancat";
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
        selectSecondLine();
        Serial.print("Press * to list");
      }
      else
      {
        delay(1000); // NEW NEW NEW NEW
        
        selectFirstLine();
        Serial.print("Connecting...");
        
        client.stop();
        
        // proceed to lulz
        if (client.connect(server, 80))
        {
          selectFirstLine();
          Serial.print("Connected.");
          // replace with your own cgi path...
          client.println("GET /~lolserver/cgi-bin/" + callBroker + "_request.cgi?phone=" + phoneNumber + "&clip=" + clip + " HTTP/1.0");
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
      
      selectSecondLine();
      if (phoneNumber.length() > 0)
      {
        Serial.print(phoneNumber);
      }
      else
      {
        Serial.print("(full 10 digits)");
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
  Serial.write(0xFE);
  Serial.write(192);
}

void softReset() {
  clearDisplay();
  phoneNumber = "";
  clip = "";
}
