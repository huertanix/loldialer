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
byte rowPins[ROWS] = {8,7,6,5};
byte colPins[COLS] = {4,3,2};

Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

byte mac[] = {0x90,0xA2,0xDA,0x00,0x68,0x2F}; // Replace with your own MAC address
//byte ip[] = {172,16,0,77}; // replace with your own static IP
//byte gateway[] = {172,16,0,1}; // ...
//byte subnet[] = {255,255,252,0}; // ...
//byte ip[] = {192,168,34,190}; // casa de Giles/Huerta/Rix/Futurist Mike
//byte gateway[] = {192,168,34,1};
//byte subnet[] = {255,255,255,0};
byte ip[] = {192,168,2,2}; // OS X Cybersauce sharing
byte gateway[] = {192,168,2,1};
byte subnet[] = {255,255,255,0};
byte server[] = {192,168,2,1}; // replace with your web server address

// instantiate a network client
Client client(server, 80);
int buttonState = LOW; // soft reset button state
String phoneNumber = "";
String clip = "";
String callBroker = "twilio"; // case-sensitive, only other option is "tropo"

void setup()
{
  // start the serial library:
  Serial.begin(9600);
  // set display brightness
  Serial.print(0x7C, BYTE);
  Serial.print(157, BYTE);
  // set screen size in case LCD gets derpy...
  Serial.print(0xFE, BYTE);
  Serial.print(6, BYTE);
  Serial.print(0xFE, BYTE);
  Serial.print(4, BYTE);
  delay(4000);
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
  ////if (buttonState == HIGH)
  ////{
    // reset softly 
    //softReset(); // FAIL
  ////}
  
  delay(70); // delay loop to keep the LCD from redrawing stuff too much
  
  char keyPressed = keypad.getKey(); // need to check press selection on keypad

  if (keyPressed)
  {
    if (keyPressed == '#') // # and * are reveresed for some reason
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
        Serial.print("i said wut wut");
        selectSecondLine();
        Serial.print("in the *");
        delay(1000);
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
        // proceed to lulz
        if (client.connect())
        {
          selectFirstLine();
          Serial.print("Connected.");
          // replace with your own cgi path...
          client.println("GET /~huertanix/cgi-bin/" + callBroker + "_request.cgi?phone=" + phoneNumber + "&clip=" + clip + " HTTP/1.0");
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
        Serial.print("(full 7 digits)");
      }
    }
  }
}

void clearDisplay() {
  Serial.print(0xFE, BYTE);
  Serial.print(0x01, BYTE);
}

void selectFirstLine() {
  Serial.print(0xFE, BYTE);
  Serial.print(128, BYTE);
   //delay(10);
}

void selectSecondLine() {
  Serial.print(0xFE, BYTE);
  Serial.print(192, BYTE);
}

void softReset() {
  clearDisplay();
  phoneNumber = "";
  clip = "";
}