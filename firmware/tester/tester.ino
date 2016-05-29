const int NUM_BUTTONS=10;
const int NUM_AXES=4;
int button_pins[NUM_BUTTONS]={3,5,6,9,10,11,12,13,A4,A5};
int axis_pins[NUM_AXES]={A0,A1,A2,A3};

void setup()
{
  Serial.begin(57600);
  for(int ii=0;ii<NUM_BUTTONS;++ii)
    pinMode(button_pins[ii],INPUT_PULLUP);
  for(int ii=0;ii<NUM_AXES;++ii)
    pinMode(axis_pins[ii],INPUT);
}

void loop()
{
  for(int ii=0;ii<NUM_AXES;++ii)
  {
    Serial.print(analogRead(axis_pins[ii]));
    Serial.print("\t");
  }
  for(int ii=0;ii<NUM_BUTTONS;++ii)
  {
    Serial.print(digitalRead(button_pins[ii]));
    Serial.print("\t");
  }
  Serial.println("");
}
