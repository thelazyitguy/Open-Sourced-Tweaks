#import "MSHFAudioProcessingDelegate.h"
#import <Accelerate/Accelerate.h>

@interface MSHFAudioProcessing : NSObject {
  int bufferLog2;
  FFTSetup fftSetup;
  float *window;
  UInt32 numberOfFrames;
  float fftNormFactor;
  int numberOfFramesOver2;
  float *outReal;
  float *outImaginary;
  COMPLEX_SPLIT output;
  float *out;
}

@property(nonatomic, assign) bool fft;
@property(nonatomic, retain) id<MSHFAudioProcessingDelegate> delegate;

- (id)initWithBufferSize:(int)bufferSize;
- (void)process:(float *)data withLength:(int)length;

@end