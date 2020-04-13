#import "MSHFAudioDelegate.h"
#import "MSHFAudioProcessing.h"
#import "MSHFAudioProcessingDelegate.h"
#import "MSHFAudioSource.h"
#import <UIKit/UIKit.h>

#define MSHFPreferencesIdentifier @"me.conorthedev.mitsuhaforever"

@interface MSHFView : UIView <MSHFAudioDelegate, MSHFAudioProcessingDelegate> {
  NSUInteger cachedLength;
  NSUInteger cachedNumberOfPoints;
  long long silentSince;
  long long lastUpdate;
  bool MSHFHidden;
  int bufferLog2;
  FFTSetup fftSetup;
  float *window;
}

@property(nonatomic, assign) BOOL shouldUpdate;
@property(nonatomic, assign) BOOL disableBatterySaver;
@property(nonatomic, assign) BOOL autoHide;
@property(nonatomic, assign) int numberOfPoints;

@property(nonatomic, assign) double gain;
@property(nonatomic, assign) double limiter;

@property(nonatomic, assign) CGFloat waveOffset;
@property(nonatomic, assign) CGFloat sensitivity;

@property(nonatomic, strong) CADisplayLink *displayLink;
@property(nonatomic, assign) CGPoint *points;

@property(nonatomic, strong) UIColor *calculatedColor;
@property(nonatomic, strong) UIColor *waveColor;
@property(nonatomic, strong) UIColor *subwaveColor;

@property(nonatomic, retain) MSHFAudioSource *audioSource;
@property(nonatomic, retain) MSHFAudioProcessing *audioProcessing;

- (void)updateWaveColor:(UIColor *)waveColor
           subwaveColor:(UIColor *)subwaveColor;

- (void)start;
- (void)stop;

- (void)configureDisplayLink;

- (void)initializeWaveLayers;
- (void)resetWaveLayers;
- (void)redraw;

- (void)updateBuffer:(float *)bufferData withLength:(int)length;

- (void)setSampleData:(float *)data length:(int)length;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame
                  audioSource:(MSHFAudioSource *)audioSource;

@end
