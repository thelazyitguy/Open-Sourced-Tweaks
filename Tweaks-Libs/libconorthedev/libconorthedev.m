#import "public/libconorthedev.h"

/*
 * A class to provide useful functions to do with UIColor
 */
@implementation CTDColorUtils

/*
 * Gets the most average color from a UIImage
 * @param image - UIImage
 * @return UIColor - the average color
 */
- (UIColor *)getAverageColorFrom:(UIImage *)image {
  CGSize size = {1, 1};
  UIGraphicsBeginImageContext(size);
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSetInterpolationQuality(ctx, kCGInterpolationMedium);

  [image drawInRect:(CGRect){.size = size} blendMode:kCGBlendModeCopy alpha:1];

  uint8_t *data = (uint8_t *)CGBitmapContextGetData(ctx);

  UIColor *color = [UIColor colorWithRed:data[2] / 255.0f
                                   green:data[1] / 255.0f
                                    blue:data[0] / 255.0f
                                   alpha:1];

  UIGraphicsEndImageContext();
  return color;
}

/*
 * Gets the most average color from a UIImage with a custom alpha
 * @param image - UIImage
 * @param alpha - double
 * @return UIColor - the average color
 */
- (UIColor *)getAverageColorFrom:(UIImage *)image withAlpha:(double)alpha {
  CGSize size = {1, 1};
  UIGraphicsBeginImageContext(size);
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSetInterpolationQuality(ctx, kCGInterpolationMedium);

  [image drawInRect:(CGRect){.size = size} blendMode:kCGBlendModeCopy alpha:1];

  uint8_t *data = (uint8_t *)CGBitmapContextGetData(ctx);

  UIColor *color = [UIColor colorWithRed:data[2] / 255.0f
                                   green:data[1] / 255.0f
                                    blue:data[0] / 255.0f
                                   alpha:alpha];

  UIGraphicsEndImageContext();
  return color;
}

/*
 * Gets a readable text colour from the background colour
 * @param backgroundColor - UIColor
 * @return UIColor - the text color
 */
- (UIColor *)readableForegroundColorForBackgroundColor:
    (UIColor *)backgroundColor {
  size_t count = CGColorGetNumberOfComponents(backgroundColor.CGColor);
  const CGFloat *componentColors =
      CGColorGetComponents(backgroundColor.CGColor);

  CGFloat darknessScore = 0;
  if (count == 2) {
    darknessScore = (((componentColors[0] * 255) * 299) +
                     ((componentColors[0] * 255) * 587) +
                     ((componentColors[0] * 255) * 114)) /
                    1000;
  } else if (count == 4) {
    darknessScore = (((componentColors[0] * 255) * 299) +
                     ((componentColors[1] * 255) * 587) +
                     ((componentColors[2] * 255) * 114)) /
                    1000;
  }

  if (darknessScore >= 125) {
    return [UIColor blackColor];
  }

  return [UIColor whiteColor];
}
@end