
_InitTimer0:

;Door_lock.c,34 :: 		void InitTimer0(){
;Door_lock.c,35 :: 		OPTION_REG  = 0x86;
	MOVLW      134
	MOVWF      OPTION_REG+0
;Door_lock.c,36 :: 		TMR0  = 100;
	MOVLW      100
	MOVWF      TMR0+0
;Door_lock.c,37 :: 		INTCON  = 0xA0;
	MOVLW      160
	MOVWF      INTCON+0
;Door_lock.c,38 :: 		}
L_end_InitTimer0:
	RETURN
; end of _InitTimer0

_Interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Door_lock.c,40 :: 		void Interrupt(){
;Door_lock.c,41 :: 		if (TMR0IF_bit){
	BTFSS      TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
	GOTO       L_Interrupt0
;Door_lock.c,42 :: 		cnt++;         // Increment counter
	INCF       _cnt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _cnt+1, 1
;Door_lock.c,43 :: 		TMR0IF_bit = 0;
	BCF        TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
;Door_lock.c,44 :: 		TMR0 = 100;
	MOVLW      100
	MOVWF      TMR0+0
;Door_lock.c,45 :: 		}
L_Interrupt0:
;Door_lock.c,46 :: 		}
L_end_Interrupt:
L__Interrupt58:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _Interrupt

_main:

;Door_lock.c,56 :: 		void main() {
;Door_lock.c,58 :: 		TRISA1_bit = 1;            // Logic state from sensor as >> input
	BSF        TRISA1_bit+0, BitPos(TRISA1_bit+0)
;Door_lock.c,59 :: 		TRISA2_bit = 0;            // Red LED as >> output
	BCF        TRISA2_bit+0, BitPos(TRISA2_bit+0)
;Door_lock.c,60 :: 		TRISA3_bit = 0;            // Green LED as >> output
	BCF        TRISA3_bit+0, BitPos(TRISA3_bit+0)
;Door_lock.c,61 :: 		TRISB = 0;                 // All PORTB as >> output
	CLRF       TRISB+0
;Door_lock.c,62 :: 		TRISC = 0;                 // All PORTC as >> output
	CLRF       TRISC+0
;Door_lock.c,63 :: 		TRISD = 1;                 // All PORTD as >> input
	MOVLW      1
	MOVWF      TRISD+0
;Door_lock.c,65 :: 		PORTC = 0;                 // Initially PORTC not active
	CLRF       PORTC+0
;Door_lock.c,67 :: 		lcd_init();                // LCD lib initialize
	CALL       _Lcd_Init+0
;Door_lock.c,68 :: 		keypad_init();             // keypad (3x4) lib initialize
	CALL       _Keypad_Init+0
;Door_lock.c,69 :: 		PWM1_init(1000);           // PWM lib initialize
	BSF        T2CON+0, 0
	BSF        T2CON+0, 1
	MOVLW      124
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;Door_lock.c,71 :: 		Delay_ms(600);
	MOVLW      7
	MOVWF      R11+0
	MOVLW      23
	MOVWF      R12+0
	MOVLW      106
	MOVWF      R13+0
L_main1:
	DECFSZ     R13+0, 1
	GOTO       L_main1
	DECFSZ     R12+0, 1
	GOTO       L_main1
	DECFSZ     R11+0, 1
	GOTO       L_main1
	NOP
;Door_lock.c,72 :: 		lcd_cmd(_LCD_CURSOR_OFF);    // LCD cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Door_lock.c,73 :: 		lcd_cmd(_LCD_CLEAR);         // LCD clear
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Door_lock.c,74 :: 		lcd_out(1,6,"START");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Door_lock+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Door_lock.c,75 :: 		lcd_out(2,3,"Observe motor");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_Door_lock+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Door_lock.c,76 :: 		Delay_ms(2000);
	MOVLW      21
	MOVWF      R11+0
	MOVLW      75
	MOVWF      R12+0
	MOVLW      190
	MOVWF      R13+0
L_main2:
	DECFSZ     R13+0, 1
	GOTO       L_main2
	DECFSZ     R12+0, 1
	GOTO       L_main2
	DECFSZ     R11+0, 1
	GOTO       L_main2
	NOP
;Door_lock.c,77 :: 		PWM1_Start();                // PWM signal ON
	CALL       _PWM1_Start+0
;Door_lock.c,78 :: 		PORTC.B0 = 1;                // Motor ON, rotate right to lock
	BSF        PORTC+0, 0
;Door_lock.c,79 :: 		PWM1_Set_Duty(120);          // Rotation speed
	MOVLW      120
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Door_lock.c,80 :: 		Delay_ms(500);               // Rotation time
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main3:
	DECFSZ     R13+0, 1
	GOTO       L_main3
	DECFSZ     R12+0, 1
	GOTO       L_main3
	DECFSZ     R11+0, 1
	GOTO       L_main3
	NOP
	NOP
;Door_lock.c,81 :: 		PWM1_Stop();                 // PWM signal OFF
	CALL       _PWM1_Stop+0
;Door_lock.c,82 :: 		PORTC.B0 = 0;                // Motor OFF
	BCF        PORTC+0, 0
;Door_lock.c,83 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Door_lock.c,84 :: 		lcd_out(2,6,"LOCKED");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_Door_lock+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Door_lock.c,85 :: 		PORTA.B2 = 1;                // LED red ON
	BSF        PORTA+0, 2
;Door_lock.c,86 :: 		PORTC.B6 = 1;                // Buzzer ON
	BSF        PORTC+0, 6
;Door_lock.c,87 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main4:
	DECFSZ     R13+0, 1
	GOTO       L_main4
	DECFSZ     R12+0, 1
	GOTO       L_main4
	DECFSZ     R11+0, 1
	GOTO       L_main4
	NOP
	NOP
;Door_lock.c,88 :: 		PORTA.B2 = 0;                // LED red OFF
	BCF        PORTA+0, 2
;Door_lock.c,89 :: 		PORTC.B6 = 0;                // Buzzer OFF
	BCF        PORTC+0, 6
;Door_lock.c,90 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Door_lock.c,91 :: 		lcd_out(1,2,"SENSOR ACTIVE");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_Door_lock+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Door_lock.c,92 :: 		Delay_ms(2000);
	MOVLW      21
	MOVWF      R11+0
	MOVLW      75
	MOVWF      R12+0
	MOVLW      190
	MOVWF      R13+0
L_main5:
	DECFSZ     R13+0, 1
	GOTO       L_main5
	DECFSZ     R12+0, 1
	GOTO       L_main5
	DECFSZ     R11+0, 1
	GOTO       L_main5
	NOP
;Door_lock.c,93 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Door_lock.c,95 :: 		point1:
___main_point1:
;Door_lock.c,97 :: 		t=0; a=0; b=0; q=0; x=0;
	CLRF       _t+0
	CLRF       _t+1
	CLRF       _a+0
	CLRF       _a+1
	CLRF       _b+0
	CLRF       _b+1
	CLRF       _q+0
	CLRF       _q+1
	CLRF       _x+0
	CLRF       _x+1
;Door_lock.c,98 :: 		ADCON1 = 0x0F;                 // Switch OFF ADC all ports
	MOVLW      15
	MOVWF      ADCON1+0
;Door_lock.c,99 :: 		if(PORTA.B1 == 0)            // Check sensor >> 1= person / 0= no person
	BTFSC      PORTA+0, 1
	GOTO       L_main6
;Door_lock.c,100 :: 		{ Delay_ms(700);          // RA1 pin reads sensor intput
	MOVLW      8
	MOVWF      R11+0
	MOVLW      27
	MOVWF      R12+0
	MOVLW      39
	MOVWF      R13+0
L_main7:
	DECFSZ     R13+0, 1
	GOTO       L_main7
	DECFSZ     R12+0, 1
	GOTO       L_main7
	DECFSZ     R11+0, 1
	GOTO       L_main7
;Door_lock.c,101 :: 		lcd_out(2,5,"LCD OFF"); // Turn LCD off to save power
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_Door_lock+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Door_lock.c,102 :: 		Delay_ms(1600);
	MOVLW      17
	MOVWF      R11+0
	MOVLW      60
	MOVWF      R12+0
	MOVLW      203
	MOVWF      R13+0
L_main8:
	DECFSZ     R13+0, 1
	GOTO       L_main8
	DECFSZ     R12+0, 1
	GOTO       L_main8
	DECFSZ     R11+0, 1
	GOTO       L_main8
;Door_lock.c,103 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Door_lock.c,104 :: 		}
L_main6:
;Door_lock.c,105 :: 		do
L_main9:
;Door_lock.c,107 :: 		if(PORTA.B1 == 1)
	BTFSS      PORTA+0, 1
	GOTO       L_main12
;Door_lock.c,108 :: 		{  break;  }
	GOTO       L_main10
L_main12:
;Door_lock.c,109 :: 		}while(!PORTA.B1);          // Loop until sensor detect person
	BTFSS      PORTA+0, 1
	GOTO       L_main9
L_main10:
;Door_lock.c,111 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Door_lock.c,112 :: 		lcd_out(1,1,"Please Input key");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_Door_lock+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Door_lock.c,113 :: 		lcd_out(2,7,"");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_Door_lock+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Door_lock.c,115 :: 		point_timer:
___main_point_timer:
;Door_lock.c,117 :: 		cnt = 0;             // set interrupts count to '0'
	CLRF       _cnt+0
	CLRF       _cnt+1
;Door_lock.c,118 :: 		InitTimer0();        // Interrupt timer start
	CALL       _InitTimer0+0
;Door_lock.c,120 :: 		while(1)
L_main13:
;Door_lock.c,122 :: 		do{
L_main15:
;Door_lock.c,123 :: 		if (cnt >= 1500)    // 15s; after 1500 interrupts,(9.984ms x 1500)
	MOVLW      5
	SUBWF      _cnt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main60
	MOVLW      220
	SUBWF      _cnt+0, 0
L__main60:
	BTFSS      STATUS+0, 0
	GOTO       L_main18
;Door_lock.c,125 :: 		if(PORTA.B1==0)           // Sensor logic : '0'
	BTFSC      PORTA+0, 1
	GOTO       L_main19
;Door_lock.c,126 :: 		{ lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Door_lock.c,127 :: 		goto point1; }        // wait until timer 15s; goto point1
	GOTO       ___main_point1
L_main19:
;Door_lock.c,129 :: 		{ goto point_timer; }   // Sensor logic 1, goto point_timer
	GOTO       ___main_point_timer
;Door_lock.c,130 :: 		}                          //    and loop timer
L_main18:
;Door_lock.c,131 :: 		kp = 0;
	CLRF       _kp+0
;Door_lock.c,132 :: 		kp = Keypad_Key_Click();     // store key code in kp variable
	CALL       _Keypad_Key_Click+0
	MOVF       R0+0, 0
	MOVWF      _kp+0
;Door_lock.c,133 :: 		} while(!kp);                // loop until key click
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main15
;Door_lock.c,135 :: 		switch(kp) // when key click assign value to kp
	GOTO       L_main21
;Door_lock.c,137 :: 		/* 3 */   case 1  : kp = 51; q+=b*3; break;   // q = 9
L_main23:
	MOVLW      51
	MOVWF      _kp+0
	MOVF       _b+0, 0
	MOVWF      R0+0
	MOVF       _b+1, 0
	MOVWF      R0+1
	MOVLW      3
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	ADDWF      _q+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _q+1, 1
	GOTO       L_main22
;Door_lock.c,138 :: 		/* 2 */   case 2  : kp = 50; b+=a+2; break;   // b = 3
L_main24:
	MOVLW      50
	MOVWF      _kp+0
	MOVLW      2
	ADDWF      _a+0, 0
	MOVWF      R0+0
	MOVF       _a+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDWF      _b+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _b+1, 1
	GOTO       L_main22
;Door_lock.c,139 :: 		/* 1 */   case 3  : kp = 49; a+=1;   break;   // a = 1
L_main25:
	MOVLW      49
	MOVWF      _kp+0
	INCF       _a+0, 1
	BTFSC      STATUS+0, 2
	INCF       _a+1, 1
	GOTO       L_main22
;Door_lock.c,140 :: 		/* 6 */   case 5  : kp = 54;         break;
L_main26:
	MOVLW      54
	MOVWF      _kp+0
	GOTO       L_main22
;Door_lock.c,141 :: 		/* 4 */   case 7  : kp = 52; x+=q-4; break;   // x = 5
L_main27:
	MOVLW      52
	MOVWF      _kp+0
	MOVLW      4
	SUBWF      _q+0, 0
	MOVWF      R0+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _q+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDWF      _x+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _x+1, 1
	GOTO       L_main22
;Door_lock.c,142 :: 		/* 5 */   case 6  : kp = 53;         break;
L_main28:
	MOVLW      53
	MOVWF      _kp+0
	GOTO       L_main22
;Door_lock.c,143 :: 		/* 9 */   case 9  : kp = 57;         break;
L_main29:
	MOVLW      57
	MOVWF      _kp+0
	GOTO       L_main22
;Door_lock.c,144 :: 		/* 8 */   case 10 : kp = 56;         break;
L_main30:
	MOVLW      56
	MOVWF      _kp+0
	GOTO       L_main22
;Door_lock.c,145 :: 		/* 7 */   case 11 : kp = 55;         break;
L_main31:
	MOVLW      55
	MOVWF      _kp+0
	GOTO       L_main22
;Door_lock.c,146 :: 		/* # */   case 13 : kp = 35;         break;
L_main32:
	MOVLW      35
	MOVWF      _kp+0
	GOTO       L_main22
;Door_lock.c,147 :: 		/* 0 */   case 14 : kp = 48;         break;
L_main33:
	MOVLW      48
	MOVWF      _kp+0
	GOTO       L_main22
;Door_lock.c,148 :: 		/* * */   case 15 : kp = 42;         break;
L_main34:
	MOVLW      42
	MOVWF      _kp+0
	GOTO       L_main22
;Door_lock.c,149 :: 		}
L_main21:
	MOVF       _kp+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_main23
	MOVF       _kp+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_main24
	MOVF       _kp+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_main25
	MOVF       _kp+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_main26
	MOVF       _kp+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_main27
	MOVF       _kp+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_main28
	MOVF       _kp+0, 0
	XORLW      9
	BTFSC      STATUS+0, 2
	GOTO       L_main29
	MOVF       _kp+0, 0
	XORLW      10
	BTFSC      STATUS+0, 2
	GOTO       L_main30
	MOVF       _kp+0, 0
	XORLW      11
	BTFSC      STATUS+0, 2
	GOTO       L_main31
	MOVF       _kp+0, 0
	XORLW      13
	BTFSC      STATUS+0, 2
	GOTO       L_main32
	MOVF       _kp+0, 0
	XORLW      14
	BTFSC      STATUS+0, 2
	GOTO       L_main33
	MOVF       _kp+0, 0
	XORLW      15
	BTFSC      STATUS+0, 2
	GOTO       L_main34
L_main22:
;Door_lock.c,150 :: 		Lcd_Chr_Cp(kp); //display key press at current cursor position
	MOVF       _kp+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;Door_lock.c,151 :: 		t++;
	INCF       _t+0, 1
	BTFSC      STATUS+0, 2
	INCF       _t+1, 1
;Door_lock.c,152 :: 		if(t>=4)        // count until 4 pin input
	MOVLW      128
	XORWF      _t+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main61
	MOVLW      4
	SUBWF      _t+0, 0
L__main61:
	BTFSS      STATUS+0, 0
	GOTO       L_main35
;Door_lock.c,154 :: 		if(x==5)       // if pin matched do this part
	MOVLW      0
	XORWF      _x+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main62
	MOVLW      5
	XORWF      _x+0, 0
L__main62:
	BTFSS      STATUS+0, 2
	GOTO       L_main36
;Door_lock.c,156 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main37:
	DECFSZ     R13+0, 1
	GOTO       L_main37
	DECFSZ     R12+0, 1
	GOTO       L_main37
	DECFSZ     R11+0, 1
	GOTO       L_main37
	NOP
	NOP
;Door_lock.c,157 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Door_lock.c,158 :: 		lcd_cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Door_lock.c,159 :: 		Lcd_out(1,6,"DOOR");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr8_Door_lock+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Door_lock.c,160 :: 		PORTA.B3 = 1;
	BSF        PORTA+0, 3
;Door_lock.c,161 :: 		Lcd_out(2,5,"UNLOCKED");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr9_Door_lock+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Door_lock.c,163 :: 		PWM1_Start();            // Motor(Left - Unlock)
	CALL       _PWM1_Start+0
;Door_lock.c,164 :: 		PORTC.B1 = 1;
	BSF        PORTC+0, 1
;Door_lock.c,165 :: 		PWM1_Set_Duty(200);
	MOVLW      200
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Door_lock.c,166 :: 		Delay_ms(300);
	MOVLW      4
	MOVWF      R11+0
	MOVLW      12
	MOVWF      R12+0
	MOVLW      51
	MOVWF      R13+0
L_main38:
	DECFSZ     R13+0, 1
	GOTO       L_main38
	DECFSZ     R12+0, 1
	GOTO       L_main38
	DECFSZ     R11+0, 1
	GOTO       L_main38
	NOP
	NOP
;Door_lock.c,167 :: 		PWM1_Stop();
	CALL       _PWM1_Stop+0
;Door_lock.c,168 :: 		PORTC.B1 = 0;
	BCF        PORTC+0, 1
;Door_lock.c,169 :: 		goto point2;
	GOTO       ___main_point2
;Door_lock.c,170 :: 		}
L_main36:
;Door_lock.c,173 :: 		Delay_ms(100);  PORTA.B2 = 1;   // Red LED blink
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main40:
	DECFSZ     R13+0, 1
	GOTO       L_main40
	DECFSZ     R12+0, 1
	GOTO       L_main40
	DECFSZ     R11+0, 1
	GOTO       L_main40
	NOP
	BSF        PORTA+0, 2
;Door_lock.c,174 :: 		Delay_ms(150);  PORTA.B2 = 0;
	MOVLW      2
	MOVWF      R11+0
	MOVLW      134
	MOVWF      R12+0
	MOVLW      153
	MOVWF      R13+0
L_main41:
	DECFSZ     R13+0, 1
	GOTO       L_main41
	DECFSZ     R12+0, 1
	GOTO       L_main41
	DECFSZ     R11+0, 1
	GOTO       L_main41
	BCF        PORTA+0, 2
;Door_lock.c,175 :: 		Delay_ms(120);  PORTA.B2 = 1;
	MOVLW      2
	MOVWF      R11+0
	MOVLW      56
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main42:
	DECFSZ     R13+0, 1
	GOTO       L_main42
	DECFSZ     R12+0, 1
	GOTO       L_main42
	DECFSZ     R11+0, 1
	GOTO       L_main42
	BSF        PORTA+0, 2
;Door_lock.c,176 :: 		Delay_ms(150);  PORTA.B2 = 0;
	MOVLW      2
	MOVWF      R11+0
	MOVLW      134
	MOVWF      R12+0
	MOVLW      153
	MOVWF      R13+0
L_main43:
	DECFSZ     R13+0, 1
	GOTO       L_main43
	DECFSZ     R12+0, 1
	GOTO       L_main43
	DECFSZ     R11+0, 1
	GOTO       L_main43
	BCF        PORTA+0, 2
;Door_lock.c,177 :: 		Delay_ms(120);  PORTA.B2 = 1;   // LED stay ON
	MOVLW      2
	MOVWF      R11+0
	MOVLW      56
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main44:
	DECFSZ     R13+0, 1
	GOTO       L_main44
	DECFSZ     R12+0, 1
	GOTO       L_main44
	DECFSZ     R11+0, 1
	GOTO       L_main44
	BSF        PORTA+0, 2
;Door_lock.c,179 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Door_lock.c,180 :: 		Lcd_out(1,3,"Access denied");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr10_Door_lock+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Door_lock.c,181 :: 		Lcd_out(2,3,"Try again..");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr11_Door_lock+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Door_lock.c,182 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main45:
	DECFSZ     R13+0, 1
	GOTO       L_main45
	DECFSZ     R12+0, 1
	GOTO       L_main45
	DECFSZ     R11+0, 1
	GOTO       L_main45
	NOP
	NOP
;Door_lock.c,183 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Door_lock.c,184 :: 		PORTA.B2 = 0;                  // Red LED OFF
	BCF        PORTA+0, 2
;Door_lock.c,185 :: 		goto point1;
	GOTO       ___main_point1
;Door_lock.c,187 :: 		}
L_main35:
;Door_lock.c,188 :: 		}
	GOTO       L_main13
;Door_lock.c,189 :: 		point2:
___main_point2:
;Door_lock.c,190 :: 		Delay_ms(3000);
	MOVLW      31
	MOVWF      R11+0
	MOVLW      113
	MOVWF      R12+0
	MOVLW      30
	MOVWF      R13+0
L_main46:
	DECFSZ     R13+0, 1
	GOTO       L_main46
	DECFSZ     R12+0, 1
	GOTO       L_main46
	DECFSZ     R11+0, 1
	GOTO       L_main46
	NOP
;Door_lock.c,191 :: 		dl=0;
	CLRF       _dl+0
;Door_lock.c,192 :: 		point3:
___main_point3:
;Door_lock.c,193 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Door_lock.c,194 :: 		Lcd_out(1,1,"Door open. Lock?");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr12_Door_lock+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Door_lock.c,195 :: 		Lcd_out(2,1,"Press: #");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr13_Door_lock+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Door_lock.c,197 :: 		do{dl = Keypad_Key_Click();     // Accept # key to lock
L_main47:
	CALL       _Keypad_Key_Click+0
	MOVF       R0+0, 0
	MOVWF      _dl+0
;Door_lock.c,198 :: 		}while(!dl);
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main47
;Door_lock.c,200 :: 		if(dl==13)    // dl = 13 is # symbol in ASCII
	MOVF       _dl+0, 0
	XORLW      13
	BTFSS      STATUS+0, 2
	GOTO       L_main50
;Door_lock.c,202 :: 		Delay_ms(400);
	MOVLW      5
	MOVWF      R11+0
	MOVLW      15
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_main51:
	DECFSZ     R13+0, 1
	GOTO       L_main51
	DECFSZ     R12+0, 1
	GOTO       L_main51
	DECFSZ     R11+0, 1
	GOTO       L_main51
;Door_lock.c,203 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Door_lock.c,204 :: 		Lcd_out(1,3,"DOOR LOCKED");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr14_Door_lock+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Door_lock.c,205 :: 		PORTA.B3 = 0;
	BCF        PORTA+0, 3
;Door_lock.c,206 :: 		Delay_ms(400);
	MOVLW      5
	MOVWF      R11+0
	MOVLW      15
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_main52:
	DECFSZ     R13+0, 1
	GOTO       L_main52
	DECFSZ     R12+0, 1
	GOTO       L_main52
	DECFSZ     R11+0, 1
	GOTO       L_main52
;Door_lock.c,207 :: 		PWM1_Start();                // Motor (Right - Locked)
	CALL       _PWM1_Start+0
;Door_lock.c,208 :: 		PORTC.B0 = 1;
	BSF        PORTC+0, 0
;Door_lock.c,209 :: 		PWM1_Set_Duty(200);
	MOVLW      200
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Door_lock.c,210 :: 		Delay_ms(300);
	MOVLW      4
	MOVWF      R11+0
	MOVLW      12
	MOVWF      R12+0
	MOVLW      51
	MOVWF      R13+0
L_main53:
	DECFSZ     R13+0, 1
	GOTO       L_main53
	DECFSZ     R12+0, 1
	GOTO       L_main53
	DECFSZ     R11+0, 1
	GOTO       L_main53
	NOP
	NOP
;Door_lock.c,211 :: 		PORTC.B0 = 0;
	BCF        PORTC+0, 0
;Door_lock.c,212 :: 		PWM1_Stop();
	CALL       _PWM1_Stop+0
;Door_lock.c,214 :: 		PORTC.B6 = 1;                   // Buzzer
	BSF        PORTC+0, 6
;Door_lock.c,215 :: 		PORTA = 0x0C;                   // Both Red & Green LED ON
	MOVLW      12
	MOVWF      PORTA+0
;Door_lock.c,216 :: 		Lcd_out(2,1,"SECURITY ACTIVE");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr15_Door_lock+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Door_lock.c,217 :: 		Delay_ms(1300);
	MOVLW      14
	MOVWF      R11+0
	MOVLW      49
	MOVWF      R12+0
	MOVLW      148
	MOVWF      R13+0
L_main54:
	DECFSZ     R13+0, 1
	GOTO       L_main54
	DECFSZ     R12+0, 1
	GOTO       L_main54
	DECFSZ     R11+0, 1
	GOTO       L_main54
	NOP
;Door_lock.c,218 :: 		PORTA = 0x00;                   // Both Red & Green LED OFF
	CLRF       PORTA+0
;Door_lock.c,219 :: 		PORTC.B6 = 0;
	BCF        PORTC+0, 6
;Door_lock.c,220 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Door_lock.c,222 :: 		goto point1;
	GOTO       ___main_point1
;Door_lock.c,223 :: 		}
L_main50:
;Door_lock.c,224 :: 		else { goto point3; }
	GOTO       ___main_point3
;Door_lock.c,226 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
