#import "PerfectWidgets13.h"

#import <Cephei/HBPreferences.h>
#import "SparkColourPickerUtils.h"

static HBPreferences *pref;
static BOOL hideClock;
static BOOL hideSearchBar;
static BOOL hideWeatherProvided;
static BOOL alwaysExtendedWidgets;
static BOOL hideNewWidgetsAvailable;
static BOOL colorizeBackground;
static BOOL customBackgroundColorEnabled;
static UIColor *customBackgroundColor;
static BOOL colorizeBorder;
static BOOL customBorderColorEnabled;
static UIColor *customBorderColor;
static BOOL tranparentWidgetHeader;
static NSInteger widgetCorner;
static NSInteger borderWidth;

// --------------------------------------------------------------------------
// --------------------- METHODS FOR CHOOSING COLORS ------------------------
// --------------------------------------------------------------------------

// Taken From https://stackoverflow.com/questions/11598043/get-slightly-lighter-and-darker-color-from-uicolor

static UIColor *lighterColorForColor(UIColor *c)
{
    CGFloat r, g, b, a;
	[c getRed: &r green: &g blue: &b alpha: &a];
    return [UIColor colorWithRed: MIN(r + 0.3, 1.0) green: MIN(g + 0.3, 1.0) blue: MIN(b + 0.3, 1.0) alpha: a];
}

static UIColor *darkerColorForColor(UIColor *c)
{
    CGFloat r, g, b, a;
    [c getRed: &r green: &g blue: &b alpha: &a];
    return [UIColor colorWithRed: MAX(r - 0.3, 0.0) green: MAX(g - 0.3, 0.0) blue: MAX(b - 0.3, 0.0) alpha: a];
}

static UIColor *getContrastColorBasedOnBackgroundColor(UIColor *backgroundColor)
{
	const CGFloat *rgb = CGColorGetComponents(backgroundColor.CGColor);
    double luminance = 0.299 * rgb[0] + 0.587 * rgb[1] + 0.114 * rgb[2];
	if(luminance <= 0.5) return lighterColorForColor(backgroundColor);
	else return darkerColorForColor(backgroundColor);
}

@implementation UIImage (UIImageAverageColorAddition)

// Taken from @alextrob: https://github.com/alextrob/UIImageAverageColor

- (UIColor*)mergedColor
{
	CGSize size = {1, 1};
	UIGraphicsBeginImageContext(size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetInterpolationQuality(ctx, kCGInterpolationMedium);
	[self drawInRect: (CGRect){.size = size} blendMode: kCGBlendModeCopy alpha: 1];
	uint8_t *data = (uint8_t *)CGBitmapContextGetData(ctx);
	UIColor *color = [UIColor colorWithRed: data[2] / 255.0f green: data[1] / 255.0f blue: data[0] / 255.0f alpha: 1];
	UIGraphicsEndImageContext();
	return color;
}

@end

%group hideSearchBarGroup

	%hook SBSearchBar

	-(void)setFrame:(CGRect)arg1 
	{
		%orig(CGRectMake(0, 0, 0, 55));
	}

	%end

%end

// ------------------------------ ALWAYS EXTENDED WIDGETS ------------------------------

%group alwaysExtendedWidgetsGroup

	%hook WGWidgetPlatterView

	-(void)setShowingMoreContent:(BOOL)arg1
	{
		%orig(YES);
	}

	-(BOOL)isShowingMoreContent
	{
		return YES;
	}

	%end

%end

// ------------------------------ HIDE CLOCK FROM WIDGETS ------------------------------

%group hideClockGroup

	%hook WGWidgetListHeaderView

	- (void)layoutSubviews
	{
		%orig;
		self.hidden = YES;
	}

	%end

%end

// ------------------------------ HIDE "WEATHER INFORMATION PROVIDED BY..." TEXT IN WIDGETS PAGE ------------------------------

%group hideWeatherProvidedGroup

	%hook WGWidgetAttributionView

	- (id)initWithWidgetAttributedString: (id)arg
	{
		return %orig(NULL);
	}

	%end

%end

%group hideNewWidgetsAvailableGroup

	%hook WGWidgetListFooterView

	-(void)_availableWidgetsUpdated:(id)arg1
	{

	}

	%end

%end

// -------------------------- COLORIZE WIDGETS ------------------------------

%group colorizeWidgetsGroup

	%hook WGWidgetPlatterView

	%property(nonatomic, retain) UIColor *bgColor;
	%property(nonatomic, retain) UIColor *borderColor;

	- (void)layoutSubviews
	{
		%orig;

		if (![self listItem]) return;
		
		if(alwaysExtendedWidgets) [self.showMoreButton setHidden: YES];

		[self colorizeWidget];
	}

	-(void)_layoutContentView
	{
		%orig;

		[self colorizeWidget];
	}

	-(void)_configureHeaderViewsIfNecessary
	{
		%orig;

		[self colorizeWidget];
	}

	-(void)_configureBackgroundMaterialViewIfNecessary
	{
		%orig;

		[self colorizeWidget];
	}

	-(void)_layoutHeaderViews
	{
		%orig;

		[self colorizeWidget];
	}

	-(void)_updateHeaderContentViewVisualStyling
	{
		%orig;

		[self colorizeWidget];
	}

	%new
	- (void)colorizeWidget
	{
		MTMaterialView *headerBackgroundView = MSHookIvar<MTMaterialView*>(self, "_headerBackgroundView");
		MTMaterialView *backgroundView = MSHookIvar<MTMaterialView*>(self, "_backgroundView");

		if(backgroundView && headerBackgroundView)
		{
			backgroundView.clipsToBounds = YES;
			backgroundView.layer.cornerRadius = widgetCorner;

			if(tranparentWidgetHeader) headerBackgroundView.alpha = 0;

			if(colorizeBackground)
			{
				if(customBackgroundColorEnabled) self.bgColor = customBackgroundColor;
				else self.bgColor = [self calculateWidgetBgColor];

				if(self.bgColor) 
				{
					backgroundView.backgroundColor = self.bgColor;
					if(!tranparentWidgetHeader) headerBackgroundView.backgroundColor = self.bgColor;
				}
			}

			if(colorizeBorder)
			{
				if(customBorderColorEnabled) self.borderColor = customBorderColor;
				else if(self.bgColor) self.borderColor = getContrastColorBasedOnBackgroundColor(self.bgColor);
				else
				{
					self.bgColor = [self calculateWidgetBgColor];
					if(self.bgColor) self.borderColor = getContrastColorBasedOnBackgroundColor(self.bgColor);
				}

				if(self.borderColor)
				{
					backgroundView.layer.borderColor = self.borderColor.CGColor;
					backgroundView.layer.borderWidth = borderWidth;

					if(!tranparentWidgetHeader)
					{
						headerBackgroundView.layer.borderColor = self.borderColor.CGColor;
						headerBackgroundView.layer.borderWidth = borderWidth;
					}
				}
			}
		}
	}

	%new
	- (UIColor*)calculateWidgetBgColor
	{
		UIColor *c;
		UIImage *appIcon;
		WGPlatterHeaderContentView *headerContentView = MSHookIvar<WGPlatterHeaderContentView*>(self, "_headerContentView");
		if(headerContentView) appIcon = headerContentView.icons[0];
		if(appIcon) c = [appIcon mergedColor];
		return c;
	}

	%end

%end

%ctor
{
	@autoreleasepool
	{
		pref = [[HBPreferences alloc] initWithIdentifier: @"com.johnzaro.perfectwidgets13prefs"];
		[pref registerDefaults:
		@{
			@"alwaysExtendedWidgets": @NO,
			@"hideClock": @NO,
			@"hideSearchBar": @NO,
			@"hideWeatherProvided": @NO,
			@"hideNewWidgetsAvailable": @NO,
			@"colorizeBackground": @NO,
			@"customBackgroundColorEnabled": @NO,
			@"colorizeBorder": @NO,
			@"customBorderColorEnabled": @NO,
			@"borderWidth": @3,
			@"tranparentWidgetHeader": @NO,
			@"widgetCorner": @13
    	}];

		alwaysExtendedWidgets = [pref boolForKey: @"alwaysExtendedWidgets"];
		hideClock = [pref boolForKey: @"hideClock"];
		hideSearchBar = [pref boolForKey: @"hideSearchBar"];
		hideWeatherProvided = [pref boolForKey: @"hideWeatherProvided"];
		hideNewWidgetsAvailable = [pref boolForKey: @"hideNewWidgetsAvailable"];
		colorizeBackground = [pref boolForKey: @"colorizeBackground"];
		customBackgroundColorEnabled = [pref boolForKey: @"customBackgroundColorEnabled"];
		colorizeBorder = [pref boolForKey: @"colorizeBorder"];
		customBorderColorEnabled = [pref boolForKey: @"customBorderColorEnabled"];
		borderWidth = [pref integerForKey: @"borderWidth"];
		tranparentWidgetHeader = [pref boolForKey: @"tranparentWidgetHeader"];
		widgetCorner = [pref integerForKey: @"widgetCorner"];

		if(customBackgroundColorEnabled || customBorderColorEnabled)
		{
			NSDictionary *preferencesDictionary = [NSDictionary dictionaryWithContentsOfFile: @"/var/mobile/Library/Preferences/com.johnzaro.perfectwidgets13prefs.colors.plist"];
			
			customBackgroundColor = [SparkColourPickerUtils colourWithString: [preferencesDictionary objectForKey: @"customBackgroundColor"] withFallback: @"#FF9400"];
			customBorderColor = [SparkColourPickerUtils colourWithString: [preferencesDictionary objectForKey: @"customBorderColor"] withFallback: @"#FF9400"];
		}

		if(alwaysExtendedWidgets) %init(alwaysExtendedWidgetsGroup);
		if(hideClock) %init(hideClockGroup);
		if(hideSearchBar) %init(hideSearchBarGroup);
		if(hideWeatherProvided) %init(hideWeatherProvidedGroup);
		if(hideNewWidgetsAvailable) %init(hideNewWidgetsAvailableGroup);
		%init(colorizeWidgetsGroup);
	}
}