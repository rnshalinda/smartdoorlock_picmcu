#line 1 "D:/0_Mechatronics/## Classes/#3 Semester/5505ICBTEL-Principles and Applications of Microcontrollers/asg/978727/door lock/source code/Door_lock.c"
#line 13 "D:/0_Mechatronics/## Classes/#3 Semester/5505ICBTEL-Principles and Applications of Microcontrollers/asg/978727/door lock/source code/Door_lock.c"
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
 int t,a,b,q,x;


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

point1:

 t=0; a=0; b=0; q=0; x=0;
 ADCON1 = 0x0F;
 if(PORTA.B1 == 0)
 { Delay_ms(700);
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
 case 1 : kp = 51; q+=b*3; break;
 case 2 : kp = 50; b+=a+2; break;
 case 3 : kp = 49; a+=1; break;
 case 5 : kp = 54; break;
 case 7 : kp = 52; x+=q-4; break;
 case 6 : kp = 53; break;
 case 9 : kp = 57; break;
 case 10 : kp = 56; break;
 case 11 : kp = 55; break;
 case 13 : kp = 35; break;
 case 14 : kp = 48; break;
 case 15 : kp = 42; break;
 }
 Lcd_Chr_Cp(kp);
 t++;
 if(t>=4)
 {
 if(x==5)
 {
 Delay_ms(500);
 lcd_cmd(_LCD_CLEAR);
 lcd_cmd(_LCD_CURSOR_OFF);
 Lcd_out(1,6,"DOOR");
 PORTA.B3 = 1;
 Lcd_out(2,5,"UNLOCKED");

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
