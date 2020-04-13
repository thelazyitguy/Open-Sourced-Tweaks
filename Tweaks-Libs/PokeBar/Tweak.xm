//SecondEight1/Liberato Aguilar 2020
//Credits to u/deiimox for post, u/miracoz for preview image, u/WeGotATenNiner for frame image.
//Font credit to Jackster Productions at https://www.fontspace.com/pokemon-gb-font-f9621

#include "CoreText/CTFontManager.h"

@interface PLPlatterView : UIView
@end
@interface PLTitledPlatterView : PLPlatterView
@end
@interface NCNotificationShortLookView : PLTitledPlatterView
@end
@interface NCNotificationViewControllerView : UIView
@end
@interface BSUIEmojiLabelView : UIView
@property UIColor *textColor;
@property UIFont *font;
@property NSString *text;
@end
@interface NCNotificationContentView : UIView
- (UILabel *)_secondaryLabel;
- (UILabel *)_primaryLabel;
- (UILabel *)_primarySubtitleLabel;
- (BSUIEmojiLabelView *)_summaryLabel;
@end
@interface NCNotificationListView : UIScrollView
@end
@interface PLPlatterHeaderContentView : UIView
- (UILabel *) titleLabel;
- (UILabel *) dateLabel;
@end
@interface PLShadowView : UIImageView
@end
@interface BSUIDefaultDateLabel : UILabel
@end
@interface BSUIRelativeDateLabel : BSUIDefaultDateLabel
@end
@interface UIUserInterfaceStyleArbiter : NSObject
+(id)sharedInstance;
-(long long)currentStyle;
@end

%hook NCNotificationShortLookView
- (void)_setGrabberVisible:(BOOL) ret {
  %orig(ret);

  UIImage *background = [UIImage imageWithContentsOfFile:@"/var/mobile/icon/background.png"];
  UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
  imageView.frame = self.frame;
  imageView.hidden = NO;

  [self addSubview:imageView];

  for (UIView *view in self.subviews){
    if([view isKindOfClass:%c(MTMaterialView)]) {
      view.hidden = YES;
    }
  }
}

- (void)layoutSubviews {
  %orig;
  // UIUserInterfaceStyleArbiter *modeStyleArbiter = [%c(UIUserInterfaceStyleArbiter) sharedInstance];
  // long long style = modeStyleArbiter.currentStyle;
  // if(style == 1){
  //   UIColor *white = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
  //   self.backgroundColor = white;
  // }
  // else if(style == 2){
  //   UIColor *black = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
  //   self.backgroundColor = black;
  // }
  UIColor *white = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
  self.backgroundColor = white;

  for (UIView *view in self.subviews){
    if([view isKindOfClass:%c(UIImageView)]) {
      CGRect newFrame2 = self.frame;
      if(newFrame2.size.width == 339 || newFrame2.size.width == 359){
        newFrame2.origin.x -= 12;
        newFrame2.origin.y -= 7;
        newFrame2.size.width += 20;
        newFrame2.size.height += 12;

        view.frame = newFrame2;
      }
      else {
        newFrame2.origin.x -= 21;
        newFrame2.origin.y -= 7;
        newFrame2.size.width += 40;
        newFrame2.size.height += 12;

        view.frame = newFrame2;
      }
    }
  }
}
%end

%hook NCNotificationViewControllerView
- (void)setFrame:(CGRect) frame {
  CGRect newFrame = frame;
  newFrame.size.width = 339;
  newFrame.origin.x = 10;
  return %orig(newFrame);
}
%end

%hook NCNotificationContentView
-(void)layoutSubviews {
  %orig;
  NSString *imgFilePath = [NSString stringWithFormat:@"/var/mobile/icon/PokemonGb-RAeo.ttf"];
  NSURL *fontUrl = [NSURL fileURLWithPath:imgFilePath];
  CGDataProviderRef fontDataProvider =  CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
  CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
  CGDataProviderRelease(fontDataProvider);
  CTFontManagerRegisterGraphicsFont(fontRef, NULL);
  NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
  UIFont *fonts = [UIFont fontWithName:fontName size:13.0];
  UIFont *fonts2 = [UIFont fontWithName:fontName size:12.0];
  UIFont *fonts3 = [UIFont fontWithName:fontName size:10.0];
  self._primaryLabel.font = fonts;
  self._secondaryLabel.font = fonts2;
  self._primarySubtitleLabel.font = fonts;
  self._summaryLabel.font = fonts3;

  // if(self._primaryLabel.text != nil){
  //   self._primaryLabel.text = @"Test Notification";
  // }
  // if(self._secondaryLabel.text != nil){
  //   self._secondaryLabel.text = @"This is a test notification!";
  // }
  // if(self._primarySubtitleLabel.text != nil){
  //   self._primarySubtitleLabel.text = @"Test";
  // }

  @try {
    NSMutableString *secondary = [NSMutableString string];
    [secondary appendString:self._secondaryLabel.text];
    [secondary appendString:@"\n\n\n"];
    NSString *secondarytext = secondary;
    self._secondaryLabel.text = secondarytext;
  }
  @catch (NSException * e) {
   NSLog(@"Exception: %@", e);
  }
  @finally {
     NSLog(@"finally");
  }

  self._secondaryLabel.lineBreakMode = 2;
  CGRect newFrame2 = self._summaryLabel.frame;
  newFrame2.origin.y += 10;
  self._summaryLabel.frame = newFrame2;
}
%end

%hook PLPlatterHeaderContentView
-(void)layoutSubviews {
  %orig;
  NSString *imgFilePath = [NSString stringWithFormat:@"/var/mobile/icon/PokemonGb-RAeo.ttf"];
  NSURL *fontUrl = [NSURL fileURLWithPath:imgFilePath];
  CGDataProviderRef fontDataProvider =  CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
  CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
  CGDataProviderRelease(fontDataProvider);
  CTFontManagerRegisterGraphicsFont(fontRef, NULL);
  NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
  UIFont *fonts = [UIFont fontWithName:fontName size:10.0];

  UILabel *title = MSHookIvar<UILabel *>(self, "_titleLabel");
  UILabel *date = MSHookIvar<UILabel *>(self, "_dateLabel");
  title.font = fonts;
  date.font = fonts;

  CGRect newFrame = self.frame;
  newFrame.origin.y += 3;
  self.frame = newFrame;
}
%end

%hook PLShadowView
-(void)layoutSubviews {
  %orig;
  self.hidden = YES;
}
%end
