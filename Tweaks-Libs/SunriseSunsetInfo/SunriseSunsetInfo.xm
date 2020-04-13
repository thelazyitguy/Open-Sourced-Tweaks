#import "SunriseSunsetInfo.h"

#import "SparkColourPickerUtils.h"
#import <Cephei/HBPreferences.h>

#define DegreesToRadians(degrees) (degrees * M_PI / 180)

static float const _3_HOURS = 60 * 60 * 3;

static double screenWidth;
static double screenHeight;
static UIDeviceOrientation orientationOld;

__strong static id sunriseSunsetInfoObject;

NSDateFormatter *dateFormatter;

static HBPreferences *pref;
static BOOL enabled;
static BOOL showSunrise;
static NSString *sunrisePrefix;
static BOOL showSunset;
static NSString *sunsetPrefix;
static NSString *separator;
static double portraitX;
static double portraitY;
static double landscapeX;
static double landscapeY;
static BOOL followDeviceOrientation;
static double width;
static double height;
static long fontSize;
static BOOL boldFont;
static BOOL customColorEnabled;
static UIColor *customColor;
static long alignment;

static NSMutableString* formattedString()
{
	@autoreleasepool
	{
		WAForecastModel *forecastModel = [[%c(WATodayModel) autoupdatingLocationModelWithPreferences: [%c(WeatherPreferences) sharedPreferences] effectiveBundleIdentifier: @"com.apple.weather"] forecastModel];
		
		NSMutableString* mutableString = [[NSMutableString alloc] init];
		if(showSunrise)
		{
			NSDate *sunrise = [forecastModel sunrise];
			[mutableString appendString: [NSString stringWithFormat: @"%@%@", sunrisePrefix, sunrise ? [dateFormatter stringFromDate: sunrise] : @"--"]];
		}
		if(showSunset)
		{
			NSDate *sunset = [forecastModel sunset];
			if([mutableString length] != 0) [mutableString appendString: separator];
			[mutableString appendString: [NSString stringWithFormat: @"%@%@", sunsetPrefix, sunset ? [dateFormatter stringFromDate: sunset] : @"--"]];
		}
		return [mutableString copy];
	}
}

static void orientationChanged()
{
	if(followDeviceOrientation && sunriseSunsetInfoObject) 
		[sunriseSunsetInfoObject updateOrientation];
}

static void loadDeviceScreenDimensions()
{
	UIDeviceOrientation orientation = [[UIApplication sharedApplication] _frontMostAppOrientation];
	if(orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight)
	{
		screenWidth = [[UIScreen mainScreen] bounds].size.height;
		screenHeight = [[UIScreen mainScreen] bounds].size.width;
	}
	else
	{
		screenWidth = [[UIScreen mainScreen] bounds].size.width;
		screenHeight = [[UIScreen mainScreen] bounds].size.height;
	}
}

@implementation SunriseSunsetInfo

	- (id)init
	{
		self = [super init];
		if(self)
		{
			@try
			{
				sunriseSunsetInfoWindow = [[UIWindow alloc] initWithFrame: CGRectMake(0, 0, width, height)];
				[sunriseSunsetInfoWindow setWindowLevel: 1000];
				[sunriseSunsetInfoWindow setHidden: NO];
				[sunriseSunsetInfoWindow setAlpha: 1];
				[sunriseSunsetInfoWindow _setSecure: YES];
				[sunriseSunsetInfoWindow setUserInteractionEnabled: NO];
				[[sunriseSunsetInfoWindow layer] setAnchorPoint: CGPointZero];
				
				sunriseSunsetInfoLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, width, height)];
				[sunriseSunsetInfoLabel setNumberOfLines: 1];
				[(UIView *)sunriseSunsetInfoWindow addSubview: sunriseSunsetInfoLabel];

				[self updateFrame];

				[NSTimer scheduledTimerWithTimeInterval: _3_HOURS target: self selector: @selector(updateText) userInfo: nil repeats: YES];

				CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)&orientationChanged, CFSTR("com.apple.springboard.screenchanged"), NULL, 0);
				CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), NULL, (CFNotificationCallback)&orientationChanged, CFSTR("UIWindowDidRotateNotification"), NULL, CFNotificationSuspensionBehaviorCoalesce);
			}
			@catch (NSException *e) {}
		}
		return self;
	}

	- (void)updateFrame
	{
		[NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(_updateFrame) object: nil];
		[self performSelector: @selector(_updateFrame) withObject: nil afterDelay: 0.3];
	}

	- (void)_updateFrame
	{
		[self updateSunriseSunsetInfoLabelProperties];
		[self updateSunriseSunsetInfoSize];

		orientationOld = nil;
		[self updateOrientation];
	}

	- (void)updateSunriseSunsetInfoLabelProperties
	{
		if(boldFont) [sunriseSunsetInfoLabel setFont: [UIFont boldSystemFontOfSize: fontSize]];
		else [sunriseSunsetInfoLabel setFont: [UIFont systemFontOfSize: fontSize]];

		[sunriseSunsetInfoLabel setTextAlignment: alignment];

		if(customColorEnabled)
			[sunriseSunsetInfoObject updateTextColor: customColor];
	}

	- (void)updateSunriseSunsetInfoSize
	{
		CGRect frame = [sunriseSunsetInfoLabel frame];
		frame.size.width = width;
		frame.size.height = height;
		[sunriseSunsetInfoLabel setFrame: frame];

		frame = [sunriseSunsetInfoWindow frame];
		frame.size.width = width;
		frame.size.height = height;
		[sunriseSunsetInfoWindow setFrame: frame];
	}

	- (void)updateOrientation
	{
		if(!followDeviceOrientation)
		{
			CGRect frame = [sunriseSunsetInfoWindow frame];
			frame.origin.x = portraitX;
			frame.origin.y = portraitY;
			[sunriseSunsetInfoWindow setFrame: frame];
		}
		else
		{
			UIDeviceOrientation orientation = [[UIApplication sharedApplication] _frontMostAppOrientation];
			if(orientation == orientationOld)
				return;
			
			CGAffineTransform newTransform;
			int newLocationX;
			int newLocationY;

			switch (orientation)
			{
				case UIDeviceOrientationLandscapeRight:
				{
					newLocationX = landscapeY;
					newLocationY = screenHeight - landscapeX;
					newTransform = CGAffineTransformMakeRotation(-DegreesToRadians(90));
					break;
				}
				case UIDeviceOrientationLandscapeLeft:
				{
					newLocationX = screenWidth - landscapeY;
					newLocationY = landscapeX;
					newTransform = CGAffineTransformMakeRotation(DegreesToRadians(90));
					break;
				}
				case UIDeviceOrientationPortraitUpsideDown:
				{
					newLocationX = screenWidth - portraitX;
					newLocationY = screenHeight - portraitY;
					newTransform = CGAffineTransformMakeRotation(DegreesToRadians(180));
					break;
				}
				case UIDeviceOrientationPortrait:
				default:
				{
					newLocationX = portraitX;
					newLocationY = portraitY;
					newTransform = CGAffineTransformMakeRotation(DegreesToRadians(0));
					break;
				}
			}

			[UIView animateWithDuration: 0.3f animations:
			^{
				[sunriseSunsetInfoWindow setTransform: newTransform];
				CGRect frame = [sunriseSunsetInfoWindow frame];
				frame.origin.x = newLocationX;
				frame.origin.y = newLocationY;
				[sunriseSunsetInfoWindow setFrame: frame];
				orientationOld = orientation;
			} completion: nil];
		}
	}

	- (void)updateText
	{
		if(sunriseSunsetInfoWindow && sunriseSunsetInfoLabel)
		{
			[sunriseSunsetInfoLabel setText: formattedString()];
		}
	}

	- (void)updateTextColor: (UIColor*)color
	{
		[sunriseSunsetInfoLabel setTextColor: color];
	}

@end

%hook SpringBoard

- (void)applicationDidFinishLaunching: (id)application
{
	%orig;

	loadDeviceScreenDimensions();
	if(!sunriseSunsetInfoObject) 
	{
		sunriseSunsetInfoObject = [[SunriseSunsetInfo alloc] init];
		[sunriseSunsetInfoObject updateText];
	}
}

%end

%hook _UIStatusBar

-(void)setForegroundColor: (UIColor*)color
{
	%orig;
	
	if(!customColorEnabled && sunriseSunsetInfoObject && [self styleAttributes] && [[self styleAttributes] imageTintColor]) 
		[sunriseSunsetInfoObject updateTextColor: [[self styleAttributes] imageTintColor]];
}

%end

static void settingsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	if(!pref) pref = [[HBPreferences alloc] initWithIdentifier: @"com.johnzaro.sunrisesunsetinfoprefs"];
	enabled = [pref boolForKey: @"enabled"];
	showSunrise = [pref boolForKey: @"showSunrise"];
	sunrisePrefix = [pref objectForKey: @"sunrisePrefix"];
	showSunset = [pref boolForKey: @"showSunset"];
	sunsetPrefix = [pref objectForKey: @"sunsetPrefix"];
	separator = [pref objectForKey: @"separator"];
	portraitX = [pref floatForKey: @"portraitX"];
	portraitY = [pref floatForKey: @"portraitY"];
	landscapeX = [pref floatForKey: @"landscapeX"];
	landscapeY = [pref floatForKey: @"landscapeY"];
	followDeviceOrientation = [pref boolForKey: @"followDeviceOrientation"];
	width = [pref floatForKey: @"width"];
	height = [pref floatForKey: @"height"];
	fontSize = [pref integerForKey: @"fontSize"];
	boldFont = [pref boolForKey: @"boldFont"];
	customColorEnabled = [pref boolForKey: @"customColorEnabled"];
	alignment = [pref integerForKey: @"alignment"];

	if(customColorEnabled)
	{
		NSDictionary *preferencesDictionary = [NSDictionary dictionaryWithContentsOfFile: @"/var/mobile/Library/Preferences/com.johnzaro.sunrisesunsetinfoprefs.colors.plist"];
		customColor = [SparkColourPickerUtils colourWithString: [preferencesDictionary objectForKey: @"customColor"] withFallback: @"#FF9400"];
	}

	if(sunriseSunsetInfoObject)
	{
		[sunriseSunsetInfoObject updateFrame];
		[sunriseSunsetInfoObject updateText];
	}
}

%ctor
{
	@autoreleasepool
	{
		pref = [[HBPreferences alloc] initWithIdentifier: @"com.johnzaro.sunrisesunsetinfoprefs"];
		[pref registerDefaults:
		@{
			@"enabled": @NO,
			@"showSunrise": @NO,
			@"sunrisePrefix": @"↑",
			@"showSunset": @NO,
			@"sunsetPrefix": @"↓",
			@"separator": @" ",
			@"portraitX": @5,
			@"portraitY": @32,
			@"landscapeX": @5,
			@"landscapeY": @32,
			@"followDeviceOrientation": @NO,
			@"width": @82,
			@"height": @12,
			@"fontSize": @8,
			@"boldFont": @NO,
			@"customColorEnabled": @NO,
			@"alignment": @1,
    	}];

		settingsChanged(NULL, NULL, NULL, NULL, NULL);

		if(enabled)
		{
			dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat: @"H:mm"];

			CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, settingsChanged, CFSTR("com.johnzaro.sunrisesunsetinfoprefs/reloadprefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);

			%init;
		}
	}
}