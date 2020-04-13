@interface CTDColorUtils : NSObject

/*
 * Gets the most average color from a UIImage
 * @param image - UIImage
 * @return UIColor - the average color
 */
- (UIColor *)getAverageColorFrom:(UIImage *)image;

/*
 * Gets the most average color from a UIImage with a custom alpha
 * @param image - UIImage
 * @param alpha - double
 * @return UIColor - the average color
 */
- (UIColor *)getAverageColorFrom:(UIImage *)image withAlpha:(double)alpha;

/*
 * Gets a readable text colour from the background colour
 * @param backgroundColor - UIColor
 * @return UIColor - the text color
 */
- (UIColor *)readableForegroundColorForBackgroundColor:
    (UIColor *)backgroundColor;

@end