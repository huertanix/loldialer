/*

loldialer - a dialer of lulz

David H
November 22nd, 2010

Inspired heavily by David A. Mellis's WebClient example and Alexander Brevig's Keypad library example.

*/

#include <SPI.h>
#include <Ethernet.h>
#include <Keypad.h>

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

byte mac[] = {  0x90, 0xA2, 0xDA, 0x00, 0x17, 0x1A };
byte ip[] = { 172,16,2,200 };
byte server[] = { 172,16,2,134 }; // No DNS for you! This is dotbloom.com

// Instantiate a network client
Client client(server, 80);
String phoneNumber = String("0000000000");
String clip = String();

void setup() {
  // start the Ethernet connection:
  Ethernet.begin(mac, ip);
  // start the serial library:
  Serial.begin(9600);
  // clear screen
  //lcdCommandTiem();
  //Serial.print(0x01, BYTE);
  clearDisplay();
  
  // give the Ethernet shield a second to initialize:
  delay(2000);
  Serial.println("Connecting...");

  // if you get a connection, report back via serial:
  if (client.connect()) {
    clearDisplay();
    Serial.println("Enter a number:");
    //Serial.println("and press #");
  } 
  else {
    clearDisplay();
    // fffffffuuuuuuu-
    Serial.println("Connection FAIL!");
  }
}

void loop() {
  if (client.connected())
  {
    clearDisplay();
    Serial.println("HAY GUISE!");
    // I AM THE GALACTIC INQUISITOR IGNORE ME
    client.println("GET /~huertanix/loldialer/cgi-bin/invoke_lulz.cgi?phone=555-555-5555&clip=" + clip + " HTTP/1.0");
    client.println();
    char c = client.read();
    Serial.print(c);
    // END LULZ
    /*** UNCOMMENT WHEN STUFF WORKS
    char keyPressed = keypad.getKey(); // need to check press selection on keypad

    // clear screen and redraw to reflect current application state
    clearDisplay();

    // Check for complete number
    if (phoneNumber.charAt(0) != '0') {
      // Determine which sound clip to play
      switch (keyPressed) {
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
          Serial.println("BILLY MAYS");
          clip = "BILLYMAYS";
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
    
      // Make a HTTP request:
      client.println("GET http://192.168.1.42/loldialer/cgi-bin?number=555-555-5555&clip=" + clip + " HTTP/1.0"); // Use a web server that the Arduino can access on the local network, or figure out how to configure ethernet shield for public cybersauces...
      client.println();
      // Proceed to lulz
      Serial.println("Calling...");
    }
    else {
      //for (int x=0; x < phoneNumber.length(); x++) {
        // find the first zero
        //if (phoneNumber.charAt(x) == '0') {
          String updatedNumber = String();
        
          // display the number as its being built; new char at the end
          for (int y=0; y < phoneNumber.length(); y++) {
            if (y == phoneNumber.length() -1) { // zeroindexlol
              updatedNumber[y] = keyPressed;
            }
            if (y == phoneNumber.length()) {
              // OSHI-
              break;
            }
            else {
              // shift the other chars over to make room for the one the user entered
              updatedNumber[y] = phoneNumber[y-1];
            }
          }
          
          // update the phone number
          phoneNumber = updatedNumber;
          
          Serial.println("Enter a number:");
          Serial.println(phoneNumber);
          //break;
        //}
      //}
    } ***/
  }
}

void lcdCommandTiem()
{
  Serial.print(0xFE, BYTE);
}

void clearDisplay() {
   lcdCommandTiem();
   Serial.print(0x01, BYTE);
}
