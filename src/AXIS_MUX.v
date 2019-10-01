`timescale 1 ns / 1 ps

//rev 1.0 - MUX

module AXIS_MUX#(
  parameter DATA_WIDTH = 1		//in bytes
)(
	s_axis_video_0_tdata,
	s_axis_video_0_tlast,
	s_axis_video_0_tready,
	s_axis_video_0_tuser,
	s_axis_video_0_tvalid,

	s_axis_video_1_tdata,
	s_axis_video_1_tlast,
	s_axis_video_1_tready,
	s_axis_video_1_tuser,
	s_axis_video_1_tvalid,	
	
	m_axis_video_tdata,
	m_axis_video_tlast,
	m_axis_video_tready,
	m_axis_video_tuser,
	m_axis_video_tvalid,
	
	selector
);


  input [(DATA_WIDTH*8-1):0] s_axis_video_0_tdata;
  input s_axis_video_0_tlast;
  output s_axis_video_0_tready;
  input s_axis_video_0_tuser;
  input s_axis_video_0_tvalid;

  input [(DATA_WIDTH*8-1):0] s_axis_video_1_tdata;
  input s_axis_video_1_tlast;
  output s_axis_video_1_tready;
  input s_axis_video_1_tuser;
  input s_axis_video_1_tvalid;  
  
  output [(DATA_WIDTH*8-1):0] m_axis_video_tdata;
  output m_axis_video_tlast;
  input  m_axis_video_tready;
  output m_axis_video_tuser;
  output m_axis_video_tvalid;

  input selector;
  

assign m_axis_video_tdata 		= selector ? s_axis_video_1_tdata 	: s_axis_video_0_tdata;
assign m_axis_video_tlast		= selector ? s_axis_video_1_tlast 	: s_axis_video_0_tlast;
assign s_axis_video_0_tready 	= 1;//selector ? 0 						: m_axis_video_tready;
assign s_axis_video_1_tready 	= 1;//selector ? m_axis_video_tready 	: 0;
assign m_axis_video_tuser 		= selector ? s_axis_video_1_tuser 	: s_axis_video_0_tuser;
assign m_axis_video_tvalid 		= selector ? s_axis_video_1_tvalid 	: s_axis_video_0_tvalid;



endmodule
