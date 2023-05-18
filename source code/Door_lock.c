 /*
   -------------------------------------------------------------------
   *********  Project : Smart Door lock security system  *********
   -------------------------------------------------------------------
   Author  - [ github - rnshalinda ]
   Created - 11/07/2022
   Programming - mikroC PRO V7.2.0
   Simulation - Proteus V8.0
   mcu - PIC16F877A
*/

// Specify LCD pins
     sbit LCD_RS at RB5_bit;
     sbit LCD_En at RB6_bit;
     sbit LCD_D4 at RB0_bit;
     sbit LCD_D5 at RB1_bit;
     sbit LCD_D6 at RB2_bit;
     sbit LCD_D7 at RB3_bit;

     sbit LCD_RS_Direction at TRISB2_bit;
     sbit LCD_EN_Direction at TRISB6_bit;
     sbit LCD_D4_Direction at TRISB0_bit;
     sbit LCD_D5_Direction at TRISB1_bit;
     sbit LCD_D6_Direction at TRISB2_bit;
     sbit LCD_D7_Direction at TRISB3_bit;

/* ========================================================================== */

//Timer0
//Prescaler 1:128; TMR0 Preload = 100; Actual Interrupt Time : 9.984 ms
//Place/Copy this part in declaration section
unsigned cnt;  // This is the counter variable which will extend desired period

void InitTimer0(){
  OPTION_REG  = 0x86;
  TMR0  = 100;
  INTCON  = 0xA0;
}

void Interrupt(){
  if (TMR0IF_bit){
    cnt++;         // Increment counter
    TMR0IF_bit = 0;
    TMR0 = 100;
  }
}

/* ========================================================================== */

// Define variable types
     unsigned short kp,dl;      // Keypad input store variable
     char keypadPort at PORTD;  // Declare keypad port
     int t,a,b,q,x;             // Used to check password

// Operating Code
void main() {

     TRISA1_bit = 1;            // Logic state from sensor as >> input
     TRISA2_bit = 0;            // Red LED as >> output
     TRISA3_bit = 0;            // Green LED as >> output
     TRISB = 0;                 // All PORTB as >> output
     TRISC = 0;                 // All PORTC as >> output
     TRISD = 1;                 // All PORTD as >> input

     PORTC = 0;                 // Initially PORTC not active

     lcd_init();                // LCD lib initialize
     keypad_init();             // keypad (3x4) lib initialize
     PWM1_init(1000);           // PWM lib initialize

         Delay_ms(600);
         lcd_cmd(_LCD_CURSOR_OFF);    // LCD cursor off
         lcd_cmd(_LCD_CLEAR);         // LCD clear
         lcd_out(1,6,"START");
         lcd_out(2,3,"Observe motor");
         Delay_ms(2000);
         PWM1_Start();                // PWM signal ON
         PORTC.B0 = 1;                // Motor ON, rotate right to lock
         PWM1_Set_Duty(120);          // Rotation speed
         Delay_ms(500);               // Rotation time
         PWM1_Stop();                 // PWM signal OFF
         PORTC.B0 = 0;                // Motor OFF
         lcd_cmd(_LCD_CLEAR);
         lcd_out(2,6,"LOCKED");
         PORTA.B2 = 1;                // LED red ON
         PORTC.B6 = 1;                // Buzzer ON
         Delay_ms(1000);
         PORTA.B2 = 0;                // LED red OFF
         PORTC.B6 = 0;                // Buzzer OFF
         lcd_cmd(_LCD_CLEAR);
         lcd_out(1,2,"SENSOR ACTIVE");
         Delay_ms(2000);
         lcd_cmd(_LCD_CLEAR);

point1:

     t=0; a=0; b=0; q=0; x=0;
     ADCON1 = 0x0F;                 // Switch OFF ADC all ports
       if(PORTA.B1 == 0)            // Check sensor >> 1= person / 0= no person
          { Delay_ms(700);          // RA1 pin reads sensor intput
            lcd_out(2,5,"LCD OFF"); // Turn LCD off to save power
            Delay_ms(1600);
            lcd_cmd(_LCD_CLEAR);
            }
       do
         {
          if(PORTA.B1 == 1)
           {  break;  }
         }while(!PORTA.B1);          // Loop until sensor detect person

      lcd_cmd(_LCD_CLEAR);
      lcd_out(1,1,"Please Input key");
      lcd_out(2,7,"");

point_timer:

     cnt = 0;             // set interrupts count to '0'
     InitTimer0();        // Interrupt timer start

     while(1)
     {
         do{
            if (cnt >= 1500)    // 15s; after 1500 interrupts,(9.984ms x 1500)
             {
               if(PORTA.B1==0)           // Sensor logic : '0'
                 { lcd_cmd(_LCD_CLEAR);
                   goto point1; }        // wait until timer 15s; goto point1
                else
                 { goto point_timer; }   // Sensor logic 1, goto point_timer
              }                          //    and loop timer
            kp = 0;
            kp = Keypad_Key_Click();     // store key code in kp variable
            } while(!kp);                // loop until key click

              switch(kp) // when key click assign value to kp
    /*Keypad*/ {
      /* 3 */   case 1  : kp = 51; q+=b*3; break;   // q = 9
      /* 2 */   case 2  : kp = 50; b+=a+2; break;   // b = 3
      /* 1 */   case 3  : kp = 49; a+=1;   break;   // a = 1
      /* 6 */   case 5  : kp = 54;         break;
      /* 4 */   case 7  : kp = 52; x+=q-4; break;   // x = 5
      /* 5 */   case 6  : kp = 53;         break;
      /* 9 */   case 9  : kp = 57;         break;
      /* 8 */   case 10 : kp = 56;         break;
      /* 7 */   case 11 : kp = 55;         break;
      /* # */   case 13 : kp = 35;         break;
      /* 0 */   case 14 : kp = 48;         break;
      /* * */   case 15 : kp = 42;         break;
                }
                Lcd_Chr_Cp(kp); //display key press at current cursor position
                t++;
                if(t>=4)        // count until 4 pin input
                {
                 if(x==5)       // if pin matched do this part
                  {
                      Delay_ms(500);
                      lcd_cmd(_LCD_CLEAR);
                      lcd_cmd(_LCD_CURSOR_OFF);
                      Lcd_out(1,6,"DOOR");
                      PORTA.B3 = 1;
                      Lcd_out(2,5,"UNLOCKED");

                      PWM1_Start();            // Motor(Left - Unlock)
                      PORTC.B1 = 1;
                      PWM1_Set_Duty(200);
                      Delay_ms(300);
                      PWM1_Stop();
                      PORTC.B1 = 0;
                      goto point2;
                  }
                  else           // if pin wrong do this part
                  {
                      Delay_ms(100);  PORTA.B2 = 1;   // Red LED blink
                      Delay_ms(150);  PORTA.B2 = 0;
                      Delay_ms(120);  PORTA.B2 = 1;
                      Delay_ms(150);  PORTA.B2 = 0;
                      Delay_ms(120);  PORTA.B2 = 1;   // LED stay ON

                      lcd_cmd(_LCD_CLEAR);
                      Lcd_out(1,3,"Access denied");
                      Lcd_out(2,3,"Try again..");
                      Delay_ms(1000);
                      lcd_cmd(_LCD_CLEAR);
                      PORTA.B2 = 0;                  // Red LED OFF
                      goto point1;
                  }
                 }
     }
point2:
       Delay_ms(3000);
       dl=0;
point3:
       lcd_cmd(_LCD_CLEAR);
       Lcd_out(1,1,"Door open. Lock?");
       Lcd_out(2,1,"Press: #");

       do{dl = Keypad_Key_Click();     // Accept # key to lock
         }while(!dl);

          if(dl==13)    // dl = 13 is # symbol in ASCII
          {
            Delay_ms(400);
            lcd_cmd(_LCD_CLEAR);
            Lcd_out(1,3,"DOOR LOCKED");
            PORTA.B3 = 0;
            Delay_ms(400);
            PWM1_Start();                // Motor (Right - Locked)
            PORTC.B0 = 1;
            PWM1_Set_Duty(200);
            Delay_ms(300);
            PORTC.B0 = 0;
            PWM1_Stop();

            PORTC.B6 = 1;                   // Buzzer
            PORTA = 0x0C;                   // Both Red & Green LED ON
            Lcd_out(2,1,"SECURITY ACTIVE");
            Delay_ms(1300);
            PORTA = 0x00;                   // Both Red & Green LED OFF
            PORTC.B6 = 0;
            lcd_cmd(_LCD_CLEAR);

            goto point1;
          }
          else { goto point3; }

}