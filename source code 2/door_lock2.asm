
_InitTimer0:

;door_lock2.c,34 :: 		void InitTimer0(){
;door_lock2.c,35 :: 		OPTION_REG  = 0x86;
	MOVLW      134
	MOVWF      OPTION_REG+0
;door_lock2.c,36 :: 		TMR0  = 100;
	MOVLW      100
	MOVWF      TMR0+0
;door_lock2.c,37 :: 		INTCON  = 0xA0;
	MOVLW      160
	MOVWF      INTCON+0
;door_lock2.c,38 :: 		}
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

;door_lock2.c,40 :: 		void Interrupt(){
;door_lock2.c,41 :: 		if (TMR0IF_bit){
	BTFSS      TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
	GOTO       L_Interrupt0
;door_lock2.c,42 :: 		cnt++;         // Increment counter
	INCF       _cnt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _cnt+1, 1
;door_lock2.c,43 :: 		TMR0IF_bit = 0;
	BCF        TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
;door_lock2.c,44 :: 		TMR0 = 100;
	MOVLW      100
	MOVWF      TMR0+0
;door_lock2.c,45 :: 		}
L_Interrupt0:
;door_lock2.c,46 :: 		}
L_end_Interrupt:
L__Interrupt59:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _Interrupt

_main:

;door_lock2.c,61 :: 		void main() {
;door_lock2.c,63 :: 		TRISA1_bit = 1;            // Logic state from sensor as >> input
	BSF        TRISA1_bit+0, BitPos(TRISA1_bit+0)
;door_lock2.c,64 :: 		TRISA2_bit = 0;            // Red LED as >> output
	BCF        TRISA2_bit+0, BitPos(TRISA2_bit+0)
;door_lock2.c,65 :: 		TRISA3_bit = 0;            // Green LED as >> output
	BCF        TRISA3_bit+0, BitPos(TRISA3_bit+0)
;door_lock2.c,66 :: 		TRISB = 0;                 // All PORTB as >> output
	CLRF       TRISB+0
;door_lock2.c,67 :: 		TRISC = 0;                 // All PORTC as >> output
	CLRF       TRISC+0
;door_lock2.c,68 :: 		TRISD = 1;                 // All PORTD as >> input
	MOVLW      1
	MOVWF      TRISD+0
;door_lock2.c,70 :: 		PORTC = 0;                 // Initially PORTC not active
	CLRF       PORTC+0
;door_lock2.c,72 :: 		lcd_init();                // LCD lib initialize
	CALL       _Lcd_Init+0
;door_lock2.c,73 :: 		keypad_init();             // keypad (3x4) lib initialize
	CALL       _Keypad_Init+0
;door_lock2.c,74 :: 		PWM1_init(1000);           // PWM lib initialize
	BSF        T2CON+0, 0
	BSF        T2CON+0, 1
	MOVLW      124
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;door_lock2.c,76 :: 		Delay_ms(600);
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
;door_lock2.c,77 :: 		lcd_cmd(_LCD_CURSOR_OFF);    // LCD cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;door_lock2.c,78 :: 		lcd_cmd(_LCD_CLEAR);         // LCD clear
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;door_lock2.c,79 :: 		lcd_out(1,6,"START");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_door_lock2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;door_lock2.c,80 :: 		lcd_out(2,3,"Observe motor");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_door_lock2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;door_lock2.c,81 :: 		Delay_ms(2000);
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
;door_lock2.c,82 :: 		PWM1_Start();                // PWM signal ON
	CALL       _PWM1_Start+0
;door_lock2.c,83 :: 		PORTC.B0 = 1;                // Motor ON, rotate right to lock
	BSF        PORTC+0, 0
;door_lock2.c,84 :: 		PWM1_Set_Duty(120);          // Rotation speed
	MOVLW      120
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;door_lock2.c,85 :: 		Delay_ms(500);               // Rotation time
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
;door_lock2.c,86 :: 		PWM1_Stop();                 // PWM signal OFF
	CALL       _PWM1_Stop+0
;door_lock2.c,87 :: 		PORTC.B0 = 0;                // Motor OFF
	BCF        PORTC+0, 0
;door_lock2.c,88 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;door_lock2.c,89 :: 		lcd_out(2,6,"LOCKED");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_door_lock2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;door_lock2.c,90 :: 		PORTA.B2 = 1;                // LED red ON
	BSF        PORTA+0, 2
;door_lock2.c,91 :: 		PORTC.B6 = 1;                // Buzzer ON
	BSF        PORTC+0, 6
;door_lock2.c,92 :: 		Delay_ms(1000);
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
;door_lock2.c,93 :: 		PORTA.B2 = 0;                // LED red OFF
	BCF        PORTA+0, 2
;door_lock2.c,94 :: 		PORTC.B6 = 0;                // Buzzer OFF
	BCF        PORTC+0, 6
;door_lock2.c,95 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;door_lock2.c,96 :: 		lcd_out(1,2,"SENSOR ACTIVE");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_door_lock2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;door_lock2.c,97 :: 		Delay_ms(2000);
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
;door_lock2.c,98 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;door_lock2.c,100 :: 		array=0;  // clears previous charactor data, otherwise it can replace some of "LCD OFF" charators
	CLRF       _array+0
	CLRF       _array+1
;door_lock2.c,101 :: 		point1:
___main_point1:
;door_lock2.c,103 :: 		ADCON1 = 0x0F;                 // Switch OFF ADC all ports
	MOVLW      15
	MOVWF      ADCON1+0
;door_lock2.c,104 :: 		if(PORTA.B1 == 0)            // Check sensor >> 1= person / 0= no person
	BTFSC      PORTA+0, 1
	GOTO       L_main6
;door_lock2.c,106 :: 		Delay_ms(700);          // RA1 pin reads sensor intput
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
;door_lock2.c,107 :: 		lcd_out(2,5,"LCD OFF"); // Turn LCD off to save power
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_door_lock2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;door_lock2.c,108 :: 		Delay_ms(1600);
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
;door_lock2.c,109 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;door_lock2.c,110 :: 		}
L_main6:
;door_lock2.c,111 :: 		do
L_main9:
;door_lock2.c,113 :: 		if(PORTA.B1 == 1)
	BTFSS      PORTA+0, 1
	GOTO       L_main12
;door_lock2.c,114 :: 		{  break;  }
	GOTO       L_main10
L_main12:
;door_lock2.c,115 :: 		}while(!PORTA.B1);          // Loop until sensor detect person
	BTFSS      PORTA+0, 1
	GOTO       L_main9
L_main10:
;door_lock2.c,118 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;door_lock2.c,119 :: 		lcd_out(1,1,"Please Input key");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_door_lock2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;door_lock2.c,120 :: 		lcd_out(2,7,"");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_door_lock2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;door_lock2.c,122 :: 		point_timer:
___main_point_timer:
;door_lock2.c,124 :: 		cnt = 0;             // set interrupts count to '0'
	CLRF       _cnt+0
	CLRF       _cnt+1
;door_lock2.c,125 :: 		InitTimer0();        // Interrupt timer start
	CALL       _InitTimer0+0
;door_lock2.c,127 :: 		array=0;  // reset array
	CLRF       _array+0
	CLRF       _array+1
;door_lock2.c,129 :: 		while(1)
L_main13:
;door_lock2.c,131 :: 		do{
L_main15:
;door_lock2.c,132 :: 		if (cnt >= 1500)    // 15s; after 1500 interrupts,(9.984ms x 1500)
	MOVLW      5
	SUBWF      _cnt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main61
	MOVLW      220
	SUBWF      _cnt+0, 0
L__main61:
	BTFSS      STATUS+0, 0
	GOTO       L_main18
;door_lock2.c,134 :: 		if(PORTA.B1==0)           // Sensor logic : '0'
	BTFSC      PORTA+0, 1
	GOTO       L_main19
;door_lock2.c,135 :: 		{ lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;door_lock2.c,136 :: 		goto point1; }        // wait until timer 15s; goto point1
	GOTO       ___main_point1
L_main19:
;door_lock2.c,138 :: 		{ goto point_timer; }   // Sensor logic 1, goto point_timer
	GOTO       ___main_point_timer
;door_lock2.c,139 :: 		}                          //    and loop timer
L_main18:
;door_lock2.c,140 :: 		kp = 0;
	CLRF       _kp+0
;door_lock2.c,141 :: 		kp = Keypad_Key_Click();     // store key code in kp variable
	CALL       _Keypad_Key_Click+0
	MOVF       R0+0, 0
	MOVWF      _kp+0
;door_lock2.c,142 :: 		} while(!kp);                // loop until key click
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main15
;door_lock2.c,144 :: 		switch(kp) // when key click assign value to kp
	GOTO       L_main21
;door_lock2.c,146 :: 		/* 3 */   case 1 : x = '3'; enter_pswd[array] = x;  break;
L_main23:
	MOVLW      51
	MOVWF      _x+0
	MOVF       _array+0, 0
	ADDLW      _enter_pswd+0
	MOVWF      FSR
	MOVLW      51
	MOVWF      INDF+0
	GOTO       L_main22
;door_lock2.c,147 :: 		/* 2 */   case 2 : x = '2'; enter_pswd[array] = x;  break;
L_main24:
	MOVLW      50
	MOVWF      _x+0
	MOVF       _array+0, 0
	ADDLW      _enter_pswd+0
	MOVWF      FSR
	MOVLW      50
	MOVWF      INDF+0
	GOTO       L_main22
;door_lock2.c,148 :: 		/* 1 */   case 3 : x = '1'; enter_pswd[array] = x;  break;
L_main25:
	MOVLW      49
	MOVWF      _x+0
	MOVF       _array+0, 0
	ADDLW      _enter_pswd+0
	MOVWF      FSR
	MOVLW      49
	MOVWF      INDF+0
	GOTO       L_main22
;door_lock2.c,149 :: 		/* 6 */   case 5 : x = '6'; enter_pswd[array] = x;  break;
L_main26:
	MOVLW      54
	MOVWF      _x+0
	MOVF       _array+0, 0
	ADDLW      _enter_pswd+0
	MOVWF      FSR
	MOVLW      54
	MOVWF      INDF+0
	GOTO       L_main22
;door_lock2.c,150 :: 		/* 4 */   case 7 : x = '4'; enter_pswd[array] = x;  break;
L_main27:
	MOVLW      52
	MOVWF      _x+0
	MOVF       _array+0, 0
	ADDLW      _enter_pswd+0
	MOVWF      FSR
	MOVLW      52
	MOVWF      INDF+0
	GOTO       L_main22
;door_lock2.c,151 :: 		/* 5 */   case 6 : x = '5'; enter_pswd[array] = x;  break;
L_main28:
	MOVLW      53
	MOVWF      _x+0
	MOVF       _array+0, 0
	ADDLW      _enter_pswd+0
	MOVWF      FSR
	MOVLW      53
	MOVWF      INDF+0
	GOTO       L_main22
;door_lock2.c,152 :: 		/* 9 */   case 9 : x = '9'; enter_pswd[array] = x;  break;
L_main29:
	MOVLW      57
	MOVWF      _x+0
	MOVF       _array+0, 0
	ADDLW      _enter_pswd+0
	MOVWF      FSR
	MOVLW      57
	MOVWF      INDF+0
	GOTO       L_main22
;door_lock2.c,153 :: 		/* 8 */   case 10: x = '8'; enter_pswd[array] = x;  break;
L_main30:
	MOVLW      56
	MOVWF      _x+0
	MOVF       _array+0, 0
	ADDLW      _enter_pswd+0
	MOVWF      FSR
	MOVLW      56
	MOVWF      INDF+0
	GOTO       L_main22
;door_lock2.c,154 :: 		/* 7 */   case 11: x = '7'; enter_pswd[array] = x;  break;
L_main31:
	MOVLW      55
	MOVWF      _x+0
	MOVF       _array+0, 0
	ADDLW      _enter_pswd+0
	MOVWF      FSR
	MOVLW      55
	MOVWF      INDF+0
	GOTO       L_main22
;door_lock2.c,155 :: 		/* # */   case 13: x = '#'; enter_pswd[array] = x;  break;
L_main32:
	MOVLW      35
	MOVWF      _x+0
	MOVF       _array+0, 0
	ADDLW      _enter_pswd+0
	MOVWF      FSR
	MOVLW      35
	MOVWF      INDF+0
	GOTO       L_main22
;door_lock2.c,156 :: 		/* 0 */   case 14: x = '0'; enter_pswd[array] = x;  break;
L_main33:
	MOVLW      48
	MOVWF      _x+0
	MOVF       _array+0, 0
	ADDLW      _enter_pswd+0
	MOVWF      FSR
	MOVLW      48
	MOVWF      INDF+0
	GOTO       L_main22
;door_lock2.c,157 :: 		/* * */   case 15: x = '*'; enter_pswd[array] = x;  break;
L_main34:
	MOVLW      42
	MOVWF      _x+0
	MOVF       _array+0, 0
	ADDLW      _enter_pswd+0
	MOVWF      FSR
	MOVLW      42
	MOVWF      INDF+0
	GOTO       L_main22
;door_lock2.c,158 :: 		}
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
;door_lock2.c,159 :: 		Lcd_Chr_Cp(x);  // display key press at current cursor position
	MOVF       _x+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;door_lock2.c,160 :: 		array++;        // add 1 to current array count
	INCF       _array+0, 1
	BTFSC      STATUS+0, 2
	INCF       _array+1, 1
;door_lock2.c,162 :: 		if(array>=4)
	MOVLW      128
	XORWF      _array+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main62
	MOVLW      4
	SUBWF      _array+0, 0
L__main62:
	BTFSS      STATUS+0, 0
	GOTO       L_main35
;door_lock2.c,164 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main36:
	DECFSZ     R13+0, 1
	GOTO       L_main36
	DECFSZ     R12+0, 1
	GOTO       L_main36
	DECFSZ     R11+0, 1
	GOTO       L_main36
	NOP
	NOP
;door_lock2.c,165 :: 		i = memcmp(unit_password, enter_pswd, 4);
	MOVLW      _unit_password+0
	MOVWF      FARG_memcmp_s1+0
	MOVLW      _enter_pswd+0
	MOVWF      FARG_memcmp_s2+0
	MOVLW      4
	MOVWF      FARG_memcmp_n+0
	MOVLW      0
	MOVWF      FARG_memcmp_n+1
	CALL       _memcmp+0
	MOVF       R0+0, 0
	MOVWF      _i+0
	MOVF       R0+1, 0
	MOVWF      _i+1
;door_lock2.c,169 :: 		if(i==0)       // if pin matched do this part
	MOVLW      0
	XORWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main63
	MOVLW      0
	XORWF      R0+0, 0
L__main63:
	BTFSS      STATUS+0, 2
	GOTO       L_main37
;door_lock2.c,171 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
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
;door_lock2.c,172 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;door_lock2.c,173 :: 		lcd_cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;door_lock2.c,174 :: 		Lcd_out(1,6,"UNLOCK");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr8_door_lock2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;door_lock2.c,175 :: 		Lcd_out(1,3,"        ");  // without this there is an error with LCD charactor placement
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr9_door_lock2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;door_lock2.c,176 :: 		PORTA.B3 = 1;
	BSF        PORTA+0, 3
;door_lock2.c,179 :: 		PWM1_Start();            // Motor(Left - Unlock)
	CALL       _PWM1_Start+0
;door_lock2.c,180 :: 		PORTC.B1 = 1;
	BSF        PORTC+0, 1
;door_lock2.c,181 :: 		PWM1_Set_Duty(200);
	MOVLW      200
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;door_lock2.c,182 :: 		Delay_ms(300);
	MOVLW      4
	MOVWF      R11+0
	MOVLW      12
	MOVWF      R12+0
	MOVLW      51
	MOVWF      R13+0
L_main39:
	DECFSZ     R13+0, 1
	GOTO       L_main39
	DECFSZ     R12+0, 1
	GOTO       L_main39
	DECFSZ     R11+0, 1
	GOTO       L_main39
	NOP
	NOP
;door_lock2.c,183 :: 		PWM1_Stop();
	CALL       _PWM1_Stop+0
;door_lock2.c,184 :: 		PORTC.B1 = 0;
	BCF        PORTC+0, 1
;door_lock2.c,185 :: 		goto point2;
	GOTO       ___main_point2
;door_lock2.c,186 :: 		}
L_main37:
;door_lock2.c,189 :: 		Delay_ms(100);  PORTA.B2 = 1;   // Red LED blink
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main41:
	DECFSZ     R13+0, 1
	GOTO       L_main41
	DECFSZ     R12+0, 1
	GOTO       L_main41
	DECFSZ     R11+0, 1
	GOTO       L_main41
	NOP
	BSF        PORTA+0, 2
;door_lock2.c,190 :: 		Delay_ms(150);  PORTA.B2 = 0;
	MOVLW      2
	MOVWF      R11+0
	MOVLW      134
	MOVWF      R12+0
	MOVLW      153
	MOVWF      R13+0
L_main42:
	DECFSZ     R13+0, 1
	GOTO       L_main42
	DECFSZ     R12+0, 1
	GOTO       L_main42
	DECFSZ     R11+0, 1
	GOTO       L_main42
	BCF        PORTA+0, 2
;door_lock2.c,191 :: 		Delay_ms(120);  PORTA.B2 = 1;
	MOVLW      2
	MOVWF      R11+0
	MOVLW      56
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main43:
	DECFSZ     R13+0, 1
	GOTO       L_main43
	DECFSZ     R12+0, 1
	GOTO       L_main43
	DECFSZ     R11+0, 1
	GOTO       L_main43
	BSF        PORTA+0, 2
;door_lock2.c,192 :: 		Delay_ms(150);  PORTA.B2 = 0;
	MOVLW      2
	MOVWF      R11+0
	MOVLW      134
	MOVWF      R12+0
	MOVLW      153
	MOVWF      R13+0
L_main44:
	DECFSZ     R13+0, 1
	GOTO       L_main44
	DECFSZ     R12+0, 1
	GOTO       L_main44
	DECFSZ     R11+0, 1
	GOTO       L_main44
	BCF        PORTA+0, 2
;door_lock2.c,193 :: 		Delay_ms(120);  PORTA.B2 = 1;   // LED stay ON
	MOVLW      2
	MOVWF      R11+0
	MOVLW      56
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main45:
	DECFSZ     R13+0, 1
	GOTO       L_main45
	DECFSZ     R12+0, 1
	GOTO       L_main45
	DECFSZ     R11+0, 1
	GOTO       L_main45
	BSF        PORTA+0, 2
;door_lock2.c,195 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;door_lock2.c,196 :: 		Lcd_out(1,3,"Access denied");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr10_door_lock2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;door_lock2.c,197 :: 		Lcd_out(2,3,"Try again..");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr11_door_lock2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;door_lock2.c,198 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main46:
	DECFSZ     R13+0, 1
	GOTO       L_main46
	DECFSZ     R12+0, 1
	GOTO       L_main46
	DECFSZ     R11+0, 1
	GOTO       L_main46
	NOP
	NOP
;door_lock2.c,199 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;door_lock2.c,200 :: 		PORTA.B2 = 0;                  // Red LED OFF
	BCF        PORTA+0, 2
;door_lock2.c,201 :: 		goto point1;
	GOTO       ___main_point1
;door_lock2.c,203 :: 		}
L_main35:
;door_lock2.c,204 :: 		}
	GOTO       L_main13
;door_lock2.c,205 :: 		point2:
___main_point2:
;door_lock2.c,206 :: 		Delay_ms(3000);
	MOVLW      31
	MOVWF      R11+0
	MOVLW      113
	MOVWF      R12+0
	MOVLW      30
	MOVWF      R13+0
L_main47:
	DECFSZ     R13+0, 1
	GOTO       L_main47
	DECFSZ     R12+0, 1
	GOTO       L_main47
	DECFSZ     R11+0, 1
	GOTO       L_main47
	NOP
;door_lock2.c,207 :: 		dl=0;
	CLRF       _dl+0
;door_lock2.c,208 :: 		point3:
___main_point3:
;door_lock2.c,209 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;door_lock2.c,210 :: 		Lcd_out(1,1,"Door open. Lock?");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr12_door_lock2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;door_lock2.c,211 :: 		Lcd_out(2,1,"Press: #");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr13_door_lock2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;door_lock2.c,213 :: 		do{dl = Keypad_Key_Click();     // Accept # key to lock
L_main48:
	CALL       _Keypad_Key_Click+0
	MOVF       R0+0, 0
	MOVWF      _dl+0
;door_lock2.c,214 :: 		}while(!dl);
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main48
;door_lock2.c,216 :: 		if(dl==13)    // dl = 13 is # symbol in ASCII
	MOVF       _dl+0, 0
	XORLW      13
	BTFSS      STATUS+0, 2
	GOTO       L_main51
;door_lock2.c,218 :: 		Delay_ms(400);
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
;door_lock2.c,219 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;door_lock2.c,220 :: 		Lcd_out(1,3,"DOOR LOCKED");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr14_door_lock2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;door_lock2.c,221 :: 		PORTA.B3 = 0;
	BCF        PORTA+0, 3
;door_lock2.c,222 :: 		Delay_ms(400);
	MOVLW      5
	MOVWF      R11+0
	MOVLW      15
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_main53:
	DECFSZ     R13+0, 1
	GOTO       L_main53
	DECFSZ     R12+0, 1
	GOTO       L_main53
	DECFSZ     R11+0, 1
	GOTO       L_main53
;door_lock2.c,223 :: 		PWM1_Start();                // Motor (Right - Locked)
	CALL       _PWM1_Start+0
;door_lock2.c,224 :: 		PORTC.B0 = 1;
	BSF        PORTC+0, 0
;door_lock2.c,225 :: 		PWM1_Set_Duty(200);
	MOVLW      200
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;door_lock2.c,226 :: 		Delay_ms(300);
	MOVLW      4
	MOVWF      R11+0
	MOVLW      12
	MOVWF      R12+0
	MOVLW      51
	MOVWF      R13+0
L_main54:
	DECFSZ     R13+0, 1
	GOTO       L_main54
	DECFSZ     R12+0, 1
	GOTO       L_main54
	DECFSZ     R11+0, 1
	GOTO       L_main54
	NOP
	NOP
;door_lock2.c,227 :: 		PORTC.B0 = 0;
	BCF        PORTC+0, 0
;door_lock2.c,228 :: 		PWM1_Stop();
	CALL       _PWM1_Stop+0
;door_lock2.c,230 :: 		PORTC.B6 = 1;                   // Buzzer
	BSF        PORTC+0, 6
;door_lock2.c,231 :: 		PORTA = 0x0C;                   // Both Red & Green LED ON
	MOVLW      12
	MOVWF      PORTA+0
;door_lock2.c,232 :: 		Lcd_out(2,1,"SECURITY ACTIVE");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr15_door_lock2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;door_lock2.c,233 :: 		Delay_ms(1300);
	MOVLW      14
	MOVWF      R11+0
	MOVLW      49
	MOVWF      R12+0
	MOVLW      148
	MOVWF      R13+0
L_main55:
	DECFSZ     R13+0, 1
	GOTO       L_main55
	DECFSZ     R12+0, 1
	GOTO       L_main55
	DECFSZ     R11+0, 1
	GOTO       L_main55
	NOP
;door_lock2.c,234 :: 		PORTA = 0x00;                   // Both Red & Green LED OFF
	CLRF       PORTA+0
;door_lock2.c,235 :: 		PORTC.B6 = 0;
	BCF        PORTC+0, 6
;door_lock2.c,236 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;door_lock2.c,238 :: 		goto point1;
	GOTO       ___main_point1
;door_lock2.c,239 :: 		}
L_main51:
;door_lock2.c,240 :: 		else { goto point3; }
	GOTO       ___main_point3
;door_lock2.c,242 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
