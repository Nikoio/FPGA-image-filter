`timescale 1 ns / 1 ps

//rev 1.0 - SPLIT

module AXIS_SPLIT#(
  parameter DATA_WIDTH = 1		//in bytes
)(
	s_axis_video_tdata,
	s_axis_video_tlast,
	s_axis_video_tready,
	s_axis_video_tuser,
	s_axis_video_tvalid,

	m_axis_video_0_tdata,
	m_axis_video_0_tlast,
	m_axis_video_0_tready,
	m_axis_video_0_tuser,
	m_axis_video_0_tvalid,
	
	m_axis_video_1_tdata,
	m_axis_video_1_tlast,
	m_axis_video_1_tready,
	m_axis_video_1_tuser,
	m_axis_video_1_tvalid
);


  input [(DATA_WIDTH*8-1):0] s_axis_video_tdata;
  input s_axis_video_tlast;
  output s_axis_video_tready;
  input s_axis_video_tuser;
  input s_axis_video_tvalid;

  output [(DATA_WIDTH*8-1):0] m_axis_video_0_tdata;
  output m_axis_video_0_tlast;
  input  m_axis_video_0_tready;
  output m_axis_video_0_tuser;
  output m_axis_video_0_tvalid;
  
  output [(DATA_WIDTH*8-1):0] m_axis_video_1_tdata;
  output m_axis_video_1_tlast;
  input  m_axis_video_1_tready;
  output m_axis_video_1_tuser;
  output m_axis_video_1_tvalid;  

 
assign s_axis_video_tready 		= 1;
 
assign m_axis_video_0_tdata 	= s_axis_video_tdata;
assign m_axis_video_0_tlast		= s_axis_video_tlast;

assign m_axis_video_0_tuser 	= s_axis_video_tuser;
assign m_axis_video_0_tvalid 	= s_axis_video_tvalid;

assign m_axis_video_1_tdata 	= s_axis_video_tdata;
assign m_axis_video_1_tlast		= s_axis_video_tlast;

assign m_axis_video_1_tuser 	= s_axis_video_tuser;
assign m_axis_video_1_tvalid 	= s_axis_video_tvalid;


endmodule
