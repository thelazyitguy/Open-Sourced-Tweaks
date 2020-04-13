#import "PerfectBattery13.h"

// --------------------------------------------------------------------------
// ------------------------------ CONSTANTS ---------------------------------
// --------------------------------------------------------------------------

UIColor *const GREEN_BATTERY_COLOR = [UIColor colorWithRed: 0.15 green: 0.68 blue: 0.38 alpha: 1.0f];
UIColor *const YELLOW_BATTERY_COLOR = [UIColor colorWithRed: 0.95 green: 0.77 blue: 0.06 alpha: 1.0f];
UIColor *const ORANGE_BATTERY_COLOR = [UIColor colorWithRed: 0.90 green: 0.49 blue: 0.13 alpha: 1.0f];
UIColor *const RED_BATTERY_COLOR = [UIColor colorWithRed: 0.91 green: 0.30 blue: 0.24 alpha: 1.0f];

// Hide duplicate percentage label from control center
%hook _UIStatusBarStringView

- (void)setText: (NSString *)text
{
    if(![text containsString:@"%"] && ![text containsString:@"Not Charging"]) %orig(text);
}

%end

// hide battery icon, show percentage label instead
%hook _UIBatteryView

%property (nonatomic, retain) UILabel *percentLabel;
%property (nonatomic, retain) UIColor *backupFillColor;

- (instancetype)initWithFrame: (CGRect)frame
{
	self = %orig;
	
	self.percentLabel = [[UILabel alloc]initWithFrame: CGRectMake(0, 0, 40, 12)];
	self.percentLabel.font = [UIFont boldSystemFontOfSize: 14];
	self.percentLabel.adjustsFontSizeToFitWidth = YES;
	self.percentLabel.textAlignment = NSTextAlignmentLeft;
	self.percentLabel.text = [NSString stringWithFormat:@"%.0f%%", floor(self.chargePercent * 100)];
	[self addSubview: self.percentLabel];

	return self;
}

- (void)setChargePercent: (CGFloat)percent
{
	%orig;    
	self.percentLabel.text = [NSString stringWithFormat:@"%.0f%%", floor(percent * 100)];
}

// Update percentage label color in various events
%new
- (void)updatePercentageColor
{
	if (self.chargingState != 0) self.percentLabel.textColor = GREEN_BATTERY_COLOR;
	else if (self.saverModeActive) self.percentLabel.textColor = YELLOW_BATTERY_COLOR;
	else if (self.chargePercent <= 0.15) self.percentLabel.textColor = RED_BATTERY_COLOR;
	else if (self.chargePercent <= 0.25) self.percentLabel.textColor = ORANGE_BATTERY_COLOR;
	else self.percentLabel.textColor = self.backupFillColor;
}

- (void)setChargingState: (long long)arg1
{
	%orig(arg1);
	[self updatePercentageColor];
}

- (void)setSaverModeActive: (BOOL)arg1
{
	%orig(arg1);
	[self updatePercentageColor];
}

- (void)_updateFillLayer
{
	%orig;
	[self updatePercentageColor];
}

// Do not update any color automatically
- (void)_updateFillColor
{

}

- (void)_updateBodyColors
{

}

- (void)_updateBatteryFillColor
{

}

// Return clear fill color but keep a backup of it
- (void)setFillColor: (UIColor *)arg1
{
	self.backupFillColor = arg1;
	%orig([UIColor clearColor]);
}

- (UIColor *)fillColor
{
	return [UIColor clearColor];
}

// Hide body component completely
- (void)setBodyColor:(UIColor *)arg1
{
	%orig([UIColor clearColor]);
}

- (UIColor *)bodyColor
{
	return [UIColor clearColor];
}

// Hide pin component completely
- (void)setPinColor:(UIColor *)arg1
{
	%orig([UIColor clearColor]);
}

- (UIColor *)pinColor
{
	return [UIColor clearColor];
}

- (CAShapeLayer *)pinShapeLayer
{
	return nil;
}

// Hide bolt symbol while charging
- (void)setShowsInlineChargingIndicator:(BOOL)showing
{
	%orig(NO);
}

%end

// Always show orange color when on control center
%hook _UIStaticBatteryView

- (void)updatePercentageColor
{
	self.percentLabel.textColor = ORANGE_BATTERY_COLOR;
}

%end
