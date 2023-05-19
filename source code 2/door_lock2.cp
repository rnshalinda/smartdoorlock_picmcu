#line 1 "D:/0_Mechatronics/## Classes/#3 Semester/5505ICBTEL-Principles and Applications of Microcontrollers/asg/978727/New folder (2)/source code 2/door_lock2.c"
#line 13 "D:/0_Mechatronics/## Classes/#3 Semester/5505ICBTEL-Principles and Applications of Microcontrollers/asg/978727/New folder (2)/source code 2/door_lock2.c"
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






unsigned cnt;

void InitTimer0(){
 OPTION_REG = 0x86;
 TMR0 = 100;
 INTCON = 0xA0;
 }

void Interrupt(){
 if (TMR0IF_bit){
 cnt++;
 TMR0IF_bit = 0;
 TMR0 = 100;
 }
 }




 unsigned short kp,dl;
 char keypadPort at PORTD;

 char unit_password[]="1234";
 char enter_pswd[3];
 int array,i;
 char x;



void main() {

 TRISA1_bit = 1;
 TRISA2_bit = 0;
 TRISA3_bit = 0;
 TRISB = 0;
 TRISC = 0;
 TRISD = 1;

 PORTC = 0;

 lcd_init();
 keypad_init();
 PWM1_init(1000);

 Delay_ms(600);
 lcd_cmd(_LCD_CURSOR_OFF);
 lcd_cmd(_LCD_CLEAR);
 lcd_out(1,6,"START");
 lcd_out(2,3,"Observe motor");
 Delay_ms(2000);
 PWM1_Start();
 PORTC.B0 = 1;
 PWM1_Set_Duty(120);
 Delay_ms(500);
 PWM1_Stop();
 PORTC.B0 = 0;
 lcd_cmd(_LCD_CLEAR);
 lcd_out(2,6,"LOCKED");
 PORTA.B2 = 1;
 PORTC.B6 = 1;
 Delay_ms(1000);
 PORTA.B2 = 0;
 PORTC.B6 = 0;
 lcd_cmd(_LCD_CLEAR);
 lcd_out(1,2,"SENSOR ACTIVE");
 Delay_ms(2000);
 lcd_cmd(_LCD_CLEAR);

 array=0;
point1:

 ADCON1 = 0x0F;
 if(PORTA.B1 == 0)
 {
 Delay_ms(700);
 lcd_out(2,5,"LCD OFF");
 Delay_ms(1600);
 lcd_cmd(_LCD_CLEAR);
 }
 do
 {
 if(PORTA.B1 == 1)
 { break; }
 }while(!PORTA.B1);


 lcd_cmd(_LCD_CLEAR);
 lcd_out(1,1,"Please Input key");
 lcd_out(2,7,"");

point_timer:

 cnt = 0;
 InitTimer0();

 array=0;

 while(1)
 {
 do{
 if (cnt >= 1500)
 {
 if(PORTA.B1==0)
 { lcd_cmd(_LCD_CLEAR);
 goto point1; }
 else
 { goto point_timer; }
 }
 kp = 0;
 kp = Keypad_Key_Click();
 } while(!kp);

 switch(kp)
 {
 case 1 : x = '3'; enter_pswd[array] = x; break;
 case 2 : x = '2'; enter_pswd[array] = x; break;
 case 3 : x = '1'; enter_pswd[array] = x; break;
 case 5 : x = '6'; enter_pswd[array] = x; break;
 case 7 : x = '4'; enter_pswd[array] = x; break;
 case 6 : x = '5'; enter_pswd[array] = x; break;
 case 9 : x = '9'; enter_pswd[array] = x; break;
 case 10: x = '8'; enter_pswd[array] = x; break;
 case 11: x = '7'; enter_pswd[array] = x; break;
 case 13: x = '#'; enter_pswd[array] = x; break;
 case 14: x = '0'; enter_pswd[array] = x; break;
 case 15: x = '*'; enter_pswd[array] = x; break;
 }
 Lcd_Chr_Cp(x);
 array++;

 if(array>=4)
 {
 Delay_ms(500);
 i = memcmp(unit_password, enter_pswd, 4);
#line 169 "D:/0_Mechatronics/## Classes/#3 Semester/5505ICBTEL-Principles and Applications of Microcontrollers/asg/978727/New folder (2)/source code 2/door_lock2.c"
 if(i==0)
 {
 Delay_ms(500);
 lcd_cmd(_LCD_CLEAR);
 lcd_cmd(_LCD_CURSOR_OFF);
 Lcd_out(1,6,"UNLOCK");
 Lcd_out(1,3,"        ");
 PORTA.B3 = 1;


 PWM1_Start();
 PORTC.B1 = 1;
 PWM1_Set_Duty(200);
 Delay_ms(300);
 PWM1_Stop();
 PORTC.B1 = 0;
 goto point2;
 }
 else
 {
 Delay_ms(100); PORTA.B2 = 1;
 Delay_ms(150); PORTA.B2 = 0;
 Delay_ms(120); PORTA.B2 = 1;
 Delay_ms(150); PORTA.B2 = 0;
 Delay_ms(120); PORTA.B2 = 1;

 lcd_cmd(_LCD_CLEAR);
 Lcd_out(1,3,"Access denied");
 Lcd_out(2,3,"Try again..");
 Delay_ms(1000);
 lcd_cmd(_LCD_CLEAR);
 PORTA.B2 = 0;
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

 do{dl = Keypad_Key_Click();
 }while(!dl);

 if(dl==13)
 {
 Delay_ms(400);
 lcd_cmd(_LCD_CLEAR);
 Lcd_out(1,3,"DOOR LOCKED");
 PORTA.B3 = 0;
 Delay_ms(400);
 PWM1_Start();
 PORTC.B0 = 1;
 PWM1_Set_Duty(200);
 Delay_ms(300);
 PORTC.B0 = 0;
 PWM1_Stop();

 PORTC.B6 = 1;
 PORTA = 0x0C;
 Lcd_out(2,1,"SECURITY ACTIVE");
 Delay_ms(1300);
 PORTA = 0x00;
 PORTC.B6 = 0;
 lcd_cmd(_LCD_CLEAR);

 goto point1;
 }
 else { goto point3; }

}
