/*
    
*/

/******************************************************************************
 
 */


#include "main.h"
#include "fsmc_fpga.h"
#include "user.h"
#include "console.h"


#define  NUMB_PARAM 8
int msg_massiv[NUMB_PARAM];

/*Queue*/

extern char bufer_cons_out[SIZE_CONS_OUT];
extern CONFIG_MSG Config_Msg;

extern uint8 DATA_BUFF_A[TX_RX_MAX_BUF_SIZE]; 




/*******************************************************************/
void InitAll()
{
		CONSOLE_USART_INIT();
		console_send("\r\n\r\nDevice_start\r");

		LED_INIT();
		
		
		#ifdef EEPROM
			I2C_EE_INIT();
			if (ReadConfig()==TRUE)	console_send("\nEEPROM start\r");
			else console_send("\nEEPROM is not connect \r\n parameters is enabled by default\r");
		#else
				SettingsDefault();
				CheckAndWriteVersion();
			  PrintVersion(bufer_cons_out);
				console_send(bufer_cons_out);
				
			
		#endif

			WIZ_GPIO_Install();

			WIZ_Config();
			console_send("\nWIZNET start\r");
	
	
}
 
 
 

 
/*******************************************************************/
int main(void)

{
  InitAll();
		
	socket(0, Sn_MR_TCP, Config_Msg.port_science, 0);

	while(1)
	{
		 if (motor_tcps( 0,Config_Msg.port_science,msg_massiv,NUMB_PARAM)==TRUE) ReadParameter( DATA_BUFF_A,msg_massiv ,1);

	}
}
