/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"

//GPIO
#include "xgpio.h"
XGpio GpioOutput;
//END GPIO

//I2C to MT9V start
void MT9V_IIC_init();
void MT9V_IIC_set_width(uint8_t data1, uint8_t data2);
void MT9V_IIC_rotate();
void MT9V_IIC_lvds();
void MT9V_IIC_reg(uint8_t delay, uint8_t addr, uint8_t data1, uint8_t data2);

#include "xiic.h"

#define RECEIVE_COUNT	2
#define SEND_COUNT		3

#define SLAVE_ADDRESS		0x48	/* 0b1001 0000 */

XIic Iic; /* The driver instance for IIC Device */

u8 WriteBuffer[SEND_COUNT];	/* Write buffer for writing a page. */
u8 ReadBuffer[RECEIVE_COUNT];	/* Read buffer for reading a page. */

volatile u8 TransmitComplete;
volatile u8 ReceiveComplete;

XIic_Config *ConfigPtr;	/* Pointer to configuration data */
//I2C to MT9V end




int status;
int height;
int width;


int main()
{
	int i = 0;
	int j = 0;

    init_platform();

    print("Hello World\n\r");

    //I2C to MT9V
    {
    	MT9V_IIC_init();
    	MT9V_IIC_set_width(0x02, 0x80);
    	MT9V_IIC_rotate();
    	//LVDS
    	MT9V_IIC_reg(1, 0xB3, 0x00, 0x00);
    	MT9V_IIC_reg(1, 0xB1, 0x00, 0x00);
    	MT9V_IIC_reg(1, 0x0C, 0x00, 0x01);
    	MT9V_IIC_reg(1, 0x0C, 0x00, 0x00);

    }
    //end of I2C to MT9V


    //GPIO
    status = XGpio_Initialize(&GpioOutput, 0);
    XGpio_SetDataDirection(&GpioOutput, 1, 0x0);
    XGpio_DiscreteWrite(&GpioOutput, 1, 160);
    //END GPIO

    cleanup_platform();
    return 0;
}

//I2C to MT9V start
void MT9V_IIC_init(){
	print("\n\rIIC init\n\r");

	//OR via BaseAddr - low level example
	status = XIic_DynInit(XPAR_IIC_0_BASEADDR);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	//new style init
	while (((status = XIic_ReadReg(XPAR_IIC_0_BASEADDR,
				XIIC_SR_REG_OFFSET)) &
				(XIIC_SR_RX_FIFO_EMPTY_MASK |
				XIIC_SR_TX_FIFO_EMPTY_MASK |
				XIIC_SR_BUS_BUSY_MASK)) !=
				(XIIC_SR_RX_FIFO_EMPTY_MASK |
				XIIC_SR_TX_FIFO_EMPTY_MASK)) {

	}
}

void MT9V_IIC_set_width(uint8_t data1, uint8_t data2){
	int i = 0;
	int j = 0;
	//read 0x04 reg
	WriteBuffer[0] = 0x04;
	ReadBuffer[0] = 0x00;
	ReadBuffer[1] = 0x00;


	status = XIic_DynSend(XPAR_IIC_0_BASEADDR, SLAVE_ADDRESS, WriteBuffer, SEND_COUNT-2,XIIC_STOP);
	printf("starus after write = %d\n\r",status);
	status = XIic_DynRecv(XPAR_IIC_0_BASEADDR, SLAVE_ADDRESS, ReadBuffer, RECEIVE_COUNT);
	printf("starus after read = %d\n\r",status);

	printf("ReadBuffer[0] = %08x\n\r",ReadBuffer[0]);
	printf("ReadBuffer[1] = %08x\n\r",ReadBuffer[1]);

	//write 0x04 reg
	WriteBuffer[0] = 0x04;
	WriteBuffer[1] = data1;//0x02
	WriteBuffer[2] = data2;//0x0F
	ReadBuffer[0] = 0x00;
	ReadBuffer[1] = 0x00;

	status = XIic_DynSend(XPAR_IIC_0_BASEADDR, SLAVE_ADDRESS, WriteBuffer, SEND_COUNT,XIIC_STOP);
	printf("starus after write = %d\n\r",status);

	//read 0x04 reg
	//with delay(repeat)
	for(i = 0; i < 200; i++){

	WriteBuffer[0] = 0x04;
	ReadBuffer[0] = 0x00;
	ReadBuffer[1] = 0x00;

	status = XIic_DynSend(XPAR_IIC_0_BASEADDR, SLAVE_ADDRESS, WriteBuffer, SEND_COUNT-2,XIIC_STOP);
	//printf("starus after write = %d\n\r",status);
	status = XIic_DynRecv(XPAR_IIC_0_BASEADDR, SLAVE_ADDRESS, ReadBuffer, RECEIVE_COUNT);
	//printf("starus after read = %d\n\r",status);

	//printf("ReadBuffer[0] = %08x\n\r",ReadBuffer[0]);
	//printf("ReadBuffer[1] = %08x\n\r",ReadBuffer[1]);

	if(ReadBuffer[1] == data2)break;
	}
	printf("ReadBuffer[0] = %08x\n\r",ReadBuffer[0]);
	printf("ReadBuffer[1] = %08x\n\r",ReadBuffer[1]);
	printf("iteration = %d\n\r",i);

	printf("END of set width\n\r");
}

void MT9V_IIC_rotate(){
	////write


	    	//read 0x0D reg
	    	WriteBuffer[0] = 0x0D;
	    	ReadBuffer[0] = 0x00;
	    	ReadBuffer[1] = 0x00;


	    	status = XIic_DynSend(XPAR_IIC_0_BASEADDR, SLAVE_ADDRESS, WriteBuffer, SEND_COUNT-2,XIIC_STOP);
	    	printf("starus after write = %d\n\r",status);
	    	status = XIic_DynRecv(XPAR_IIC_0_BASEADDR, SLAVE_ADDRESS, ReadBuffer, RECEIVE_COUNT);
	    	printf("starus after read = %d\n\r",status);

	    	printf("ReadBuffer[0] = %08x\n\r",ReadBuffer[0]);
	    	printf("ReadBuffer[1] = %08x\n\r",ReadBuffer[1]);

	    	//write 0x0D reg
	    	WriteBuffer[0] = 0x0D;
	    	WriteBuffer[1] = 0x03;
	    	WriteBuffer[2] = 0x30;
	    	ReadBuffer[0] = 0x00;
	    	ReadBuffer[1] = 0x00;

	    	status = XIic_DynSend(XPAR_IIC_0_BASEADDR, SLAVE_ADDRESS, WriteBuffer, SEND_COUNT,XIIC_STOP);
	    	printf("starus after write = %d\n\r",status);

	    	printf("END of rotate\n\r");
}


void MT9V_IIC_reg(uint8_t delay, uint8_t addr, uint8_t data1, uint8_t data2){
	int i;
	//read 0xB5 reg
	WriteBuffer[0] = addr;
	ReadBuffer[0] = 0x00;
	ReadBuffer[1] = 0x00;


	status = XIic_DynSend(XPAR_IIC_0_BASEADDR, SLAVE_ADDRESS, WriteBuffer, SEND_COUNT-2,XIIC_STOP);
	printf("starus after write = %d\n\r",status);
	status = XIic_DynRecv(XPAR_IIC_0_BASEADDR, SLAVE_ADDRESS, ReadBuffer, RECEIVE_COUNT);
	printf("starus after read = %d\n\r",status);

	printf("ReadBuffer[0] = %08x\n\r",ReadBuffer[0]);
	printf("ReadBuffer[1] = %08x\n\r",ReadBuffer[1]);

	//write 0xB5 reg
	WriteBuffer[0] = addr;
	WriteBuffer[1] = data1;
	WriteBuffer[2] = data2;
	ReadBuffer[0] = 0x00;
	ReadBuffer[1] = 0x00;

	status = XIic_DynSend(XPAR_IIC_0_BASEADDR, SLAVE_ADDRESS, WriteBuffer, SEND_COUNT,XIIC_STOP);
	printf("starus after write = %d\n\r",status);
	//if(delay==1){
		for(i = 0; i < delay; i++)
		printf("................................................................\n\r");
		//}

	printf("was set reg %x\n\r",addr);
}

//I2C to MT9V end

