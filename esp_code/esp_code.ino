//PH sensor
#define phPin 33
int phValue = 0;
float phReading = 0;

//Temperature sensor
#include <OneWire.h>
#include <DallasTemperature.h>
// // GPIO where the DS18B20 is connected to
const int oneWireBus = 15;          
// Setup a oneWire instance to communicate with any OneWire devices
OneWire oneWire(oneWireBus);
// Pass our oneWire reference to Dallas Temperature sensor
DallasTemperature tempSensor(&oneWire);
// // Temperature value
float temperature;

//EC sensor
// #include <Adafruit_ADS1015.h>
#include <DFRobot_ESP_EC.h>
//Pin
#define ecPin 32
DFRobot_ESP_EC ec;
// Adafruit_ADS1115 ads;
float ecVoltage, ecValue = 0;

//Water level sensor
#define wtrLvlPin 34
int waterLvlValue = 0;

//Warer flow
#define wtr_flow  35
long currentMillis = 0;
long previousMillis = 0;
int interval = 1000;
boolean ledState = LOW;
float calibrationFactor = 4.5;
volatile byte pulseCount;
byte pulse1Sec = 0;
float flowRate;
unsigned int flowMilliLitres;
unsigned long totalMilliLitres;

//Power meter
// #include "ZMPT101B.h"
// #include "EmonLib.h"
// EnergyMonitor emon;
// #define vCalibration 106.8
// #define currCalibration 0.52
// float kWh = 0;
// unsigned long lastmillis = millis();

//Servo
#include <Servo.h>
Servo myservo;  // create servo object to control a servo
#define servoPin 18
int pos = 0;    // variable to store the servo position

//Stepper
const int DIR = 12;
const int STEP = 14;
const int  steps_per_rev = 200;

//Relays
#define relay1  19
#define relay2  21
#define relay3  22
#define relay4  23
bool relay1Value = false;
bool relay2Value = false;
bool relay3Value = false;
bool relay4Value = false;

//Conditions
bool isReadSensor = false;
bool isStepperRotate = false;

//WiFi
#define wifiLedPin 5

//Firebase
#include <Arduino.h>
#include <WiFi.h>
#include <FirebaseESP32.h>
// Provide the token generation process info.
#include <addons/TokenHelper.h>
// Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>
/* 1. Define the WiFi credentials */
#define WIFI_SSID "Autobonics_4G"
#define WIFI_PASSWORD "autobonics@27"
// For the following credentials, see examples/Authentications/SignInAsUser/EmailPassword/EmailPassword.ino
/* 2. Define the API Key */
#define API_KEY "AIzaSyBDiMlbgLG4Kp_386T9pONt5VY1xkIXyPI"
/* 3. Define the RTDB URL */
#define DATABASE_URL "https://hydropod-12ef6-default-rtdb.asia-southeast1.firebasedatabase.app/" //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app
/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "sneha@hydropod.com"
#define USER_PASSWORD "12345678"
// Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
unsigned long sendDataPrevMillis = 0;
// Variable to save USER UID
String uid;
//Databse
String path;


unsigned long printDataPrevMillis = 0;

FirebaseData stream;
void streamCallback(StreamData data)
{
  Serial.println("NEW DATA!");

  String p = data.dataPath();

  Serial.println(p);
  printResult(data); // see addons/RTDBHelper.h

  // Serial.println();
  FirebaseJson jVal = data.jsonObject();
  FirebaseJsonData servoFb;
  FirebaseJsonData stepperFb;
  FirebaseJsonData isReadSensorFb;
  FirebaseJsonData r1Fb;
  FirebaseJsonData r2Fb;
  FirebaseJsonData r3Fb;
  FirebaseJsonData r4Fb;

  jVal.get(servoFb, "servo");
  jVal.get(stepperFb, "stepper");
  jVal.get(isReadSensorFb, "isReadSensor");
  jVal.get(r1Fb, "r1");
  jVal.get(r2Fb, "r2");
  jVal.get(r3Fb, "r3");
  jVal.get(r4Fb, "r4");

  if (servoFb.success)
  {
    Serial.println("Success data servoFb");
    int value = servoFb.to<int>();   
    myservo.write(value);
  } 

  if (stepperFb.success)
  {
    Serial.println("Success data stepperRotate");
    bool value = stepperFb.to<bool>(); 
    isStepperRotate = value;  
  }
  if (isReadSensorFb.success)
  {
    Serial.println("Success data isReadSensorFb");
    bool value = isReadSensorFb.to<bool>();   
    isReadSensor = value;
  } 

  //Water pump
  if (r1Fb.success)
  {
    Serial.println("Success data r1Fb");
    bool value = r1Fb.to<bool>();   
    relay1Value = value;
    if(value) {
      digitalWrite(relay1, HIGH);
      delay(500);
      digitalWrite(relay1, LOW);
    }
  } 
  if (r2Fb.success)
  {
    Serial.println("Success data r2Fb");
    bool value = r2Fb.to<bool>();   
    relay2Value = value;
    if(value){
     digitalWrite(relay2, HIGH);
    } else {
      digitalWrite(relay2, LOW);
    }
  } 
  if (r3Fb.success)
  {
    Serial.println("Success data r3Fb");
    bool value = r3Fb.to<bool>();   
    relay3Value = value;
    if(value){
     digitalWrite(relay3, HIGH);
    } else {
      digitalWrite(relay3, LOW);
    }
  } 
  if (r4Fb.success)
  {
    Serial.println("Success data r4Fb");
    bool value = r4Fb.to<bool>();   
    relay4Value = value;
    if(value){
     digitalWrite(relay4, HIGH);
    } else {
      digitalWrite(relay4, LOW);
    }
  } 
}


void streamTimeoutCallback(bool timeout)
{
  if (timeout)
    Serial.println("stream timed out, resuming...\n");

  if (!stream.httpConnected())
    Serial.printf("error code: %d, reason: %s\n\n", stream.httpCode(), stream.errorReason().c_str());
}

void IRAM_ATTR pulseCounter() {
  pulseCount++;
}


void setup() {

  Serial.begin(115200);

  //Temperature
  tempSensor.begin();
 
  //EC
  ec.begin();
 
  //Water level
  pinMode(wtrLvlPin, INPUT);
 
  // //Power meter
  // // emon.voltage(35, vCalibration, 1.7); // Voltage: input pin, calibration, phase_shift
  // // emon.current(34, currCalibration); // Current: input pin, calibration.
 
  //Servo
  myservo.attach(servoPin);  // attaches the servo on pin 13 to the servo objec/t

  //Stepper
  pinMode(STEP, OUTPUT);
  pinMode(DIR, OUTPUT);

  //Water flow
  pinMode(wtr_flow, INPUT_PULLUP);
  pulseCount = 0;
  flowRate = 0.0;
  flowMilliLitres = 0;
  totalMilliLitres = 0;
  previousMillis = 0;
  attachInterrupt(digitalPinToInterrupt(wtr_flow), pulseCounter, FALLING);

  //Relay
  pinMode(relay1, OUTPUT);
  pinMode(relay2, OUTPUT);
  pinMode(relay3, OUTPUT);
  pinMode(relay4, OUTPUT);
 
  //WIFI
  pinMode(wifiLedPin, OUTPUT);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  unsigned long ms = millis();
  while (WiFi.status() != WL_CONNECTED)
  {
    digitalWrite(wifiLedPin, LOW);
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  digitalWrite(wifiLedPin, HIGH);
  Serial.println(WiFi.localIP());
  Serial.println();

  //FIREBASE
  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);
  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h

  // Limit the size of response payload to be collected in FirebaseData
  fbdo.setResponseSize(2048);

  Firebase.begin(&config, &auth);

  // Comment or pass false value when WiFi reconnection will control by your code or third party library
  Firebase.reconnectWiFi(true);

  Firebase.setDoubleDigits(5);

  config.timeout.serverResponse = 10 * 1000;

  // Getting the user UID might take a few seconds
  Serial.println("Getting User UID");
  while ((auth.token.uid) == "") {
    Serial.print('.');
    delay(1000);
  }
  // Print user UID
  uid = auth.token.uid.c_str();
  Serial.print("User UID: ");
  Serial.println(uid);

  path = "devices/" + uid + "/reading";

//Stream setup
  if (!Firebase.beginStream(stream, "devices/" + uid + "/data"))
    Serial.printf("sream begin error, %s\n\n", stream.errorReason().c_str());

  Firebase.setStreamCallback(stream, streamCallback, streamTimeoutCallback);
}

void loop() {

  if(isReadSensor){
  
    //PH sensor
    readPH();
  
    //Water level
    readWaterLevel();

    //Temperature
    readTemp();

    //EC
    readEC();

    //WaterFLow
    readWaterFlow();
  
    //Power meter
    // readPower();

    printData();
  }
  
    //Servo
    // runServo();
  
    //Stepper
    stepprRotate();
    // Firebase
    updateData();
}

void updateData(){
  if (Firebase.ready() && (millis() - sendDataPrevMillis > 5000 || sendDataPrevMillis == 0))
  {
    sendDataPrevMillis = millis();
    FirebaseJson json;
    json.set("ph", phReading);
    json.set("wtr_level", waterLvlValue);
    json.set("temp", temperature);
    json.set("flowRate", flowRate);
    json.set("ec", ecValue);
    json.set("totalMilliLitres", totalMilliLitres);
    json.set(F("ts/.sv"), F("timestamp"));
    Serial.printf("Set json... %s\n", Firebase.RTDB.set(&fbdo, path.c_str(), &json) ? "ok" : fbdo.errorReason().c_str());
    Serial.println("");
  }
}

void printData(){
  if (millis() - printDataPrevMillis > 2000 || printDataPrevMillis == 0)
  {
    printDataPrevMillis = millis();
    //PH
    Serial.print("PH: ");
    Serial.print(phValue);
    Serial.print(" | ");
    Serial.println(phReading);
    //Water level
    Serial.print("Water level: ");
    Serial.println(waterLvlValue);
    //Temperature
    Serial.print("Temperature:");
    Serial.print(temperature, 2);
    Serial.println("ºC");
    // Print the flow rate for this second in litres / minute
    Serial.print("Flow rate: ");
    Serial.print(int(flowRate));  // Print the integer part of the variable
    Serial.print("L/min");
    Serial.println("\t");       // Print tab space
    // Print the cumulative total of litres flowed since starting
    Serial.print("Output Liquid Quantity: ");
    Serial.print(totalMilliLitres);
    Serial.print("mL / ");
    Serial.print(totalMilliLitres / 1000);
    Serial.println("L");
    //Print EC
    Serial.print("EC:");
    Serial.println(ecValue);
  }
}

void readPH(){
  phValue = analogRead(phPin);
  float voltage = phValue*(3.3/4095.0);
  phReading =((3.3*voltage)-1);
} 

void readTemp(){
  tempSensor.requestTemperatures();
  temperature = tempSensor.getTempCByIndex(0);  // read your temperature sensor to execute temperature compensation
}

void readEC(){
  ecVoltage = analogRead(ecPin);
  ecValue = ec.readEC(ecVoltage, temperature); // convert voltage to EC with temperature compensation
}

void readWaterLevel(){
  waterLvlValue = analogRead(wtrLvlPin);
}

void readWaterFlow(){
  currentMillis = millis();
  if (currentMillis - previousMillis > interval) {
    
    pulse1Sec = pulseCount;
    pulseCount = 0;

    // Because this loop may not complete in exactly 1 second intervals we calculate
    // the number of milliseconds that have passed since the last execution and use
    // that to scale the output. We also apply the calibrationFactor to scale the output
    // based on the number of pulses per second per units of measure (litres/minute in
    // this case) coming from the sensor.
    flowRate = ((1000.0 / (millis() - previousMillis)) * pulse1Sec) / calibrationFactor;
    previousMillis = millis();

    // Divide the flow rate in litres/minute by 60 to determine how many litres have
    // passed through the sensor in this 1 second interval, then multiply by 1000 to
    // convert to millilitres.
    flowMilliLitres = (flowRate / 60) * 1000;

    // Add the millilitres passed in this second to the cumulative total
    totalMilliLitres += flowMilliLitres;
  }
}

// void readPower(){
//   emon.calcVI(20, 2000);
//   Serial.print("Vrms: ");
//   Serial.print(emon.Vrms, 2);
//   Serial.print("V");
//   Serial.print("\tIrms: ");
//   Serial.print(emon.Irms, 4);
//   Serial.print("A");
   
//   Serial.print("\tPower: ");
//   Serial.print(emon.apparentPower, 4);
//   Serial.print("W");

//   Serial.print("\tkWh: ");
//   kWh = kWh + emon.apparentPower*(millis()-lastmillis)/3600000000.0;
//   Serial.print(kWh, 4);
//   Serial.println("kWh");
//   lastmillis = millis();
// }

void stepprRotate(){
  digitalWrite(DIR, HIGH);

   if(isStepperRotate)
  {
    digitalWrite(STEP, HIGH);
    delayMicroseconds(3000);
    digitalWrite(STEP, LOW);
    delayMicroseconds(3000);
  }
}