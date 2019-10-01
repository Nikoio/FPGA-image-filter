`timescale 1 ns / 1 ps

//rev 1.0 - add "set_property IOB TRUE [get_ports {data[*] fm ln}]" to xdc for correct register placement (inside IOB)

module  MT9V_REG
   (
   pclk,
   data_in,   
   fm_in,
   ln_in,  
   data_out, 
   fm_out,
   ln_out  
   );
	
	input pclk;
	input [7:0] data_in;	
	input fm_in;
	input ln_in;	
	output [7:0] data_out;	
	output fm_out;
	output ln_out;	

	reg [7:0] data;
	reg fm;
	reg ln;	

	always @(posedge pclk)
	data <= #1 data_in;
	always @(posedge pclk)
	fm	 <= #1 fm_in;
	always @(posedge pclk)
	ln	 <= #1 ln_in;

	assign data_out = data;
	assign fm_out 	= fm;
	assign ln_out 	= ln;
  
endmodule
