`timescale 1 ns / 1 ps

//rev 1.0 - av working! problem was in VTC clock (it should be the same with vidin and vidout cores)

module  ZYBO_RGB
   (
   av,
   data,
   //hb,  
   //vb,
   //hs,   
   //vs,
   RED,
   GREEN,
   BLUE
   );
	
	input av;
	input [23:0] data;
	//input hb;	
	//input vb;
	//input hs;
	//input vs;


	output [4:0] RED;
	output [5:0] GREEN;
	output [4:0] BLUE;
	
	assign RED 		= av ? data[23:19] 	: 0;
	assign GREEN 	= av ? data[7:2] 	: 0;
	assign BLUE 	= av ? data[15:11] 	: 0;	
  
endmodule
