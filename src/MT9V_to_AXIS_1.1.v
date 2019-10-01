`timescale 1 ns / 1 ps

//rev 1.0 - tlast is long signal instead of 1 clk pulse (ln_reg4 instead of ln_reg2)
//rev 1.1 - P1_delay now constant, no fm_with_P1_delay output, add timing IF (av/hs/vs), with IF is line length independent

module MT9V_to_AXIS(
	pclk,
    data,
    fm,
    ln,
	m_axis_video_tdata,
	m_axis_video_tlast,
	m_axis_video_tready,
	m_axis_video_tuser,
	m_axis_video_tvalid,

	av,
	hs,
	vs
	
	//fm_with_P1_delay
	);

  localparam P1_delay = 71;
	
  input pclk;
  input [7:0]data;
  input fm;
  input ln;
  output [7:0] m_axis_video_tdata;
  output m_axis_video_tlast;
  input m_axis_video_tready;
  output m_axis_video_tuser;
  output m_axis_video_tvalid;

  (* X_INTERFACE_INFO = "xilinx.com:interface:video_timing:2.0 timing_in ACTIVE_VIDEO" *)    
  output av;
  (* X_INTERFACE_INFO = "xilinx.com:interface:video_timing:2.0 timing_in HSYNC" *)  
  output hs;
  (* X_INTERFACE_INFO = "xilinx.com:interface:video_timing:2.0 timing_in VSYNC" *)  
  output vs;
  
  //output fm_with_P1_delay;

  reg fm_reg1;
  reg fm_reg2;
  reg ln_reg1;
  reg ln_reg2;
  reg ln_reg3;
  reg ln_reg4;
  reg [7:0] data_reg1;
  reg [7:0] data_reg2;
  reg flag = 0;
  reg start = 0;
  
  reg [P1_delay + 1:0] fm_with_P1_delay_reg;
  
  reg [15:0] pixcnt1;	//inside frame blank
  reg [15:0] pixcnt2;	//inside frame valid
  reg [15:0] pixcnt3;	//outside frame line 
  reg [15:0] pixcnt_max;
  reg [15:0] linecnt;
  reg hs_reg1 = 1'b0;	//inside frame
  reg hs_reg2 = 1'b0;	//outside frame
  reg vs_reg = 1'b0;
  
  always @(posedge pclk)
  data_reg1 <= #1 data;
  always @(posedge pclk)
  data_reg2 <= #1 data_reg1;
  always @(posedge pclk)
  ln_reg1 <= #1 ln;
  always @(posedge pclk)
  ln_reg2 <= #1 ln_reg1 & (!ln);
  always @(posedge pclk)
  ln_reg3 <= #1 (!ln_reg1) & ln;  
  always @(posedge pclk)
	  if(ln_reg3)
		ln_reg4 <= #1 1'b0;
	  else
		if(ln_reg1 & (!ln))
		ln_reg4 <= #1 1'b1;
		else
		ln_reg4 <= #1 ln_reg4;
  
  always @(posedge pclk)
	  if(ln_reg3)
		flag <= #1 1;
	  else
		if(!fm)
			flag <= #1 0;
		else
			flag <= #1 flag;
  always @(posedge pclk)
  start <= #1 ln_reg3 & (!flag);
  
  always @(posedge pclk)
  fm_reg1 <= #1 fm;
  always @(posedge pclk)
  fm_reg2 <= #1 fm_reg1 & ln_reg1;
  always @(posedge pclk)
  fm_with_P1_delay_reg <= #1 {fm,fm_with_P1_delay_reg[P1_delay + 1:1]};

  
  assign m_axis_video_tdata = data_reg2;
  assign m_axis_video_tlast = ln_reg4;//ln_reg2 - reg2 present 1 clk pulse in the end of line, ln_reg4 - start with reg2 end finish with ln_reg3, many xilinx ip cores has this behaviour.
  assign m_axis_video_tuser = start;
  assign m_axis_video_tvalid = fm_reg2;
  
  //assign fm_with_P1_delay = fm_with_P1_delay_reg[0];
  
  //timing section
  //fm_reg1 & ln_reg1		- aligned av
  //fm_with_P1_delay_reg[0] - aligned fm
  //ln_reg1					- aligned ln

  always @(posedge pclk)
	  if((fm_reg2)|(!fm_with_P1_delay_reg[0]))
		  pixcnt1 <= #1 0;
	  else
		  pixcnt1 <= #1 pixcnt1 + 1;

  always @(posedge pclk)
	  if(pixcnt1 >= 15 & pixcnt1 < 15 + 48)
		  hs_reg1 <= #1 1'b1;
	  else
		  hs_reg1 <= #1 1'b0;
  
  
  always @(posedge pclk)
	  if(!fm_reg2)
		  pixcnt2 <= #1 0;
	  else
		  pixcnt2 <= #1 pixcnt2 + 1;
  
  always @(posedge pclk)
	  if(start) 
		  pixcnt_max <= #1 0;
	  else
		  if(pixcnt_max <= pixcnt2)
			pixcnt_max <= #1 pixcnt2;
		  else
			pixcnt_max <= #1 pixcnt_max;
  
  
  always @(posedge pclk)
	  if(fm_with_P1_delay_reg[0])
		  pixcnt3 <= #1 0;
	  else
		  if(pixcnt3 == pixcnt_max + 93)
			pixcnt3 <= #1 0;
		  else
			pixcnt3 <= #1 pixcnt3 + 1;

  always @(posedge pclk)
	  if(pixcnt3 >= pixcnt_max + 15 & pixcnt3 < pixcnt_max + 15 + 48)
		  hs_reg2 <= #1 1'b1;
	  else
		  hs_reg2 <= #1 1'b0;			
  
//full frame line counter
/*    always @(posedge pclk)
	  if(start) 
		  linecnt <= #1 0;
	  else  
		  if((pixcnt1 == 93) | (pixcnt3 == pixcnt_max + 93))
			linecnt <= #1 linecnt + 1;
		  else
			linecnt <= #1 linecnt;  */

//blank frame line counter			
	always @(posedge pclk)
	  if(fm_with_P1_delay_reg[0]) 
		  linecnt <= #1 0;
	  else  
		  if(pixcnt3 == pixcnt_max + 92)//93 switch to 92 because of vs_reg
			linecnt <= #1 linecnt + 1;
		  else
			linecnt <= #1 linecnt;  

  always @(posedge pclk)
	  if(linecnt == 16'h000a | linecnt == 16'h000b)
		  vs_reg <= #1 1'b1;
	  else
		  vs_reg <= #1 1'b0;			
  
  
  assign hs = hs_reg1 | hs_reg2;
  assign vs = vs_reg;
  assign av = fm_reg2;
  //end timing section
	
	
endmodule
