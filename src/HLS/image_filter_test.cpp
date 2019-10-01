#include "image_filter.h"
#include "hls_opencv.h"

int main()
{
  int const rows = MAX_HEIGHT;
  int const cols = MAX_WIDTH;

  cv::Mat src = cv::imread(INPUT_IMAGE);
  //cv::Mat gld = cv::imread(GOLDEN_IMAGE);
  cv::Mat dst = src;
  //cv::Mat dst_my = src;

  stream_t stream_in, stream_out;
  cvMat2AXIvideo(src, stream_in);
  image_filter(stream_in, stream_out, 131);
  AXIvideo2cvMat(stream_out, dst);

  cv::imwrite(OUTPUT_IMAGE, dst);

  //cv:absdiff(dst,gld,dst_my);

  //cv::imwrite("diff.bmp", dst_my);


  return 0;
}
