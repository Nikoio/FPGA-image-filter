#include "image_filter.h"

void image_filter(stream_t& stream_in, stream_t& stream_out, char threshold)
{
#pragma HLS DATAFLOW
#pragma HLS INTERFACE axis register both port=stream_out
#pragma HLS INTERFACE axis register both port=stream_in


  int const rows = MAX_HEIGHT;
  int const cols = MAX_WIDTH;
  rgb_img_t img0(rows, cols);
  rgb_img_t img1(rows, cols);
  rgb_img_t img2(rows, cols);

  ch_img_t img0g(rows, cols);
  ch_img_t img1g(rows, cols);
  ch_img_t img2g(rows, cols);

  ch_img_t img_r(rows, cols);
  ch_img_t img_g(rows, cols);
  ch_img_t img_b(rows, cols);
  ch_img_t img_rr(rows, cols);
  ch_img_t img_gg(rows, cols);
  ch_img_t img_bb(rows, cols);


//#pragma HLS stream depth=1300 variable=img_b.data_stream
//#pragma HLS stream depth=1300 variable=img_g.data_stream
//#pragma HLS stream depth=1300 variable=img_r.data_stream
//this pragma needed for FIFO instance
//otherwise 3 streams cannot be synchronized
//because 1 has longer processing than other 2

//original
//  const char coefficients[3][3] = { { 0, 0, 0},
//                                    { 0, 1, 0},
//                                    { 0, 0, 0} };

//Sobel
//  const char coefficients[3][3] = { {-1,-2,-1},
//                                    { 0, 0, 0},
//                                    { 1, 2, 1} };

//sharp
//  const ap_fixed<16,4,AP_RND> coefficients[3][3] = { { -0.1, -0.1, -0.1},
//                                    				   { -0.1,    2, -0.1},
//													   { -0.1, -0.1, -0.1} };

//even more sharp
  const ap_fixed<16,4,AP_RND> coefficients[3][3] = { { 1,  1, 1},
                                    				 { 1, -7, 1},
													 { 1,  1, 1} };

//blur
//    const ap_fixed<16,4,AP_RND> coefficients[3][3] = { { 0.1, 0.1, 0.1},
//                                      				   { 0.1, 0.1, 0.1},
//  													   { 0.1, 0.1, 0.1} };

//brightness
//      const ap_fixed<16,4,AP_RND> coefficients[3][3] = { { -0.1, 0.2, -0.1},
//                                       				      { 0.2,   3,  0.2},
//													      {-0.1, 0.2, -0.1} };

//darkness
//      const ap_fixed<16,4,AP_RND> coefficients[3][3] = { { -0.1, 0.1, -0.1},
//                                       				      { 0.1, 0.5,  0.1},
//													      {-0.1, 0.1, -0.1} };

//emboss
//      const ap_fixed<16,4,AP_RND> coefficients[3][3] = { { -1, -1,  0},
//                                       				     { -1,  0,  1},
//													     {  0,  1,  1} };




  hls::AXIvideo2Mat(stream_in, img0);

  //hls::Window<3,3,char> kernel;
  hls::Window<3,3,ap_fixed<16,4,AP_RND> > kernel;
  for (int i=0;i<3;i++){
     for (int j=0;j<3;j++){
        kernel.val[i][j]=coefficients[i][j];
     }
  }
  hls::Point_<int> anchor = hls::Point_<int>(-1,-1);

  //color ver
  hls::Filter2D(img0,img1,kernel,anchor);
  //investigate Filter2D function in C:\Xilinx\Vivado\2017.3\include\hls\hls_video_imgproc.h
  
  //one channel ver
  //hls::Split(img0, img_b, img_g, img_r);
  //hls::Filter2D(img_r,img_rr,kernel,anchor);
  //hls::Zero(img_g, img_gg);
  //hls::Zero(img_b, img_bb);
  //hls:Merge(img_bb, img_gg, img_rr, img1);

  //grayscale ver
  //hls::CvtColor<HLS_RGB2GRAY>(img0, img0g);
  //hls::Filter2D(img0g,img1g,kernel,anchor);
  //hls::Sobel<1,0,3>(img0g, img1g);
  //hls::Sobel<0,1,3>(img0g, img1g);
  //hls::CvtColor<HLS_GRAY2RGB>(img1g, img1);


  hls::Mat2AXIvideo(img1, stream_out);
}
