
@interface _UIStatusBar : UIView 
@property (nonatomic, assign) NSInteger orientation;
@end 

@interface _UIStatusBarStringView : UILabel 
@end


@interface _UIStatusBarCellularSignalView : UIView
@end



%hook _UIStatusBarCellularSignalView

// %orig(CGRectMake(31, 24, frame.size.width, frame.size.height));


- (void)layoutSubviews
{
    %orig;
    @try
    {
        _UIStatusBar *bar = (_UIStatusBar *)self.superview.superview;
        if (UIDeviceOrientationIsLandscape(bar.orientation))
        {
            [self setFrame:CGRectMake(27, 20, self.frame.size.width, self.frame.size.height)];
            return;
        }
    }
    @catch (NSException *ex)
    {

    }
}

%end


%hook _UIStatusBarStringView

- (BOOL)prefersBaselineAlignment
{
    return NO;
}

- (void)layoutSubviews
{
    %orig;
    @try
    {
        _UIStatusBar *bar = (_UIStatusBar *)self.superview.superview;
        if (UIDeviceOrientationIsLandscape(bar.orientation))
        {
            [self setFrame:CGRectMake(18, 35, self.frame.size.width, self.frame.size.height)];
            return;
        }
    }
    @catch (NSException *ex)
    {

    }
}


%end
*/