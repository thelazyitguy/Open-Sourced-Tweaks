@interface CSTeachableMomentsContainerView { }
@property (nonatomic,retain) UIView * controlCenterGrabberView;
@end

%hook UIStatusBar_Modern
-(void)setAlpha:(CGFloat)arg1 {
  %orig(0.0); // makes status bar transparent on lock screen
}

%end

%hook CSTeachableMomentsContainerView
- (void)layoutSubviews {
    [self.controlCenterGrabberView setHidden:YES];
    return %orig;
}
%end