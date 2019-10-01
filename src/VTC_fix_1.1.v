`timescale 1 ns / 1 ps

//rev 1.0 - add timing IF pass-through
//rev 1.1 - change hb_count in equation for short lines (160x120 and etc.) support

module VTC_fix #(
  parameter FIX_LENGTH = 4
)
   (pclk,
	av_in,
	hb_in,
	hs_in,
	vb_in,
	vs_in,
	vtg_ce_in,
	av_out,
	hb_out,
	hs_out,
	vb_out,
	vs_out,
	vtg_ce_out
	);
	

  input pclk;
  input vtg_ce_in;
  output vtg_ce_out;  
  
  (* X_INTERFACE_INFO = "xilinx.com:interface:video_timing:2.0 timing_in ACTIVE_VIDEO" *)  
  input av_in;
  (* X_INTERFACE_INFO = "xilinx.com:interface:video_timing:2.0 timing_in HBLANK" *)
  input hb_in;
  (* X_INTERFACE_INFO = "xilinx.com:interface:video_timing:2.0 timing_in HSYNC" *)
  input hs_in;
  (* X_INTERFACE_INFO = "xilinx.com:interface:video_timing:2.0 timing_in VBLANK" *)
  input vb_in;
  (* X_INTERFACE_INFO = "xilinx.com:interface:video_timing:2.0 timing_in VSYNC" *)
  input vs_in;  
  


  (* X_INTERFACE_INFO = "xilinx.com:interface:video_timing:2.0 timing_out ACTIVE_VIDEO" *)  
  output av_out;
  (* X_INTERFACE_INFO = "xilinx.com:interface:video_timing:2.0 timing_out HBLANK" *)  
  output hb_out;
  (* X_INTERFACE_INFO = "xilinx.com:interface:video_timing:2.0 timing_out HSYNC" *)  
  output hs_out;
  (* X_INTERFACE_INFO = "xilinx.com:interface:video_timing:2.0 timing_out VBLANK" *)  
  output vb_out;
  (* X_INTERFACE_INFO = "xilinx.com:interface:video_timing:2.0 timing_out VSYNC" *)  
  output vs_out;
  
	
  
  reg [15:0] hb_count = 0;
  reg [15:0] vb_count = 0;
  reg [3:0]  fix_reg = 4'b1111;
  
  always @(posedge pclk)
  if(hb_in)
  hb_count <= #1 0;
  else
  hb_count <= #1 hb_count + 1;

  always @(posedge pclk)
  if(vs_in)
	vb_count <= #1 0;
  else
	if(hb_count==16'h80)//was h280
		vb_count <= #1 vb_count + 1;  
	else
		vb_count <= #1 vb_count;

  always @(posedge pclk)
  if(vb_count==8'h0007 & hb_count==16'h7E) //was h27E
											//if 280 vtc_ce is disabled during hblank signal
											//if 27F too
											//if 27E - at the end of line!
											//7E - for short lines (160x120 and etc.)
	fix_reg <= #1 4'b0111;
  else
	fix_reg <= #1 {1'b1,fix_reg[3:1]};
  
  assign vtg_ce_out = &fix_reg&vtg_ce_in;	//with FIX
  //assign vtg_ce_out = vtg_ce_in;			//wo FIX
  
  assign av_out = av_in;
  assign hb_out = hb_in;
  assign hs_out = hs_in;
  assign vb_out = vb_in;
  assign vs_out = vs_in;
  
endmodule
