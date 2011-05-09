/*
loldialer - a dialer of lulz

David Huerta
November 22nd, 2010

Inspired heavily by David A. Mellis's WebClient example and Alexander Brevig's Keypad library example.
*/

#include <SPI.h>
#include <Ethernet.h>
#include <Keypad.h>

const int LCDdelay = 1;
const byte ROWS = 4;
const byte COLS = 3;

char keys[ROWS][COLS] = {
  {'1','2','3'},
  {'4','5','6'},
  {'7','8','9'},
  {'#','0','*'}
}; // map out the keys

// idk :<
byte rowPins[ROWS] = {5,4,3,2};
byte colPins[COLS] = {8,7,6};

Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

byte mac[] = { 0x90,0xA2,0xDA,0x00,0x17,0x1A }; // USE YOUR OWN MAC ADDRESS OR ALL CAPS RAEG WILL ENSUE
//byte ip[] = { 172,16,0,59 };
//byte gateway[] = { 172,16,0,1 }; // GP
byte ip[] = { 192,168,34,197 };
byte gateway[] = { 192,168,34,1 }; // House full of Californian expats

//byte server[] = { 174,132,153,107 }; // No DNS for you!
byte server[] = { 192,168,34,127 };

// Instantiate a network client
Client client(server, 80);
String phoneNumber = "";
String clip = "";
// Something to keep track of the call state...
boolean called = false;

void setup() 
{
  //Serial.print(0xFE, BYTE);
  //Serial.print(6, BYTE);
  //Serial.print(0xFE, BYTE);
  //Serial.print(4, BYTE); // Set screen size in case it gets derpy
  
  // start the Ethernet connection:
  Ethernet.begin(mac, ip, gateway);
  // start the serial library:
  Serial.begin(9600);
  delay(1000);
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
      Serial.print("LOLDONGS");
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
        
        // if you get a connection, report back via serial:
        if (clip != "")
        {
          // Proceed to lulz
          //Serial.println("Calling...");
          if (client.connect())
          {
            // I AM THE GALACTIC INQUISITOR IGNORE ME
            client.println("GET /~huertanix/loldialer/cgi-bin/invoke_lulz.cgi?phone=" + phoneNumber + "&clip=" + clip + " HTTP/1.0");
            client.println();
            
            Serial.println("Trolled for Great Justice!");
            phoneNumber = "";
            clip = "";
          } // WORKS?
          else
          {
            if (!client.connected())
            {
              Serial.println();
              Serial.println("Disconnecting...");
              client.stop();
            }
          }
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
        Serial.print("Choose a clip:\n");
      }
      else
      {
        Serial.print("Connecting...");
      }
    }
    else
    {
      Serial.print("Enter a number:\n");
      Serial.print(phoneNumber);
    }
  }
}

void clearDisplay() {
  Serial.print(0xFE, BYTE);
  Serial.print(0x01, BYTE);
  //delay(LCDdelay);
}