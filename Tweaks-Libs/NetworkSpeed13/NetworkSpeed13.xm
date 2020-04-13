#import "NetworkSpeed13.h"

#import "SparkColourPickerUtils.h"
#import <Cephei/HBPreferences.h>
#import <ifaddrs.h>
#import <net/if.h>

#define DegreesToRadians(degrees) (degrees * M_PI / 180)

static const long KILOBYTES = 1 << 10;
static const long MEGABYTES = 1 << 20;

static double screenWidth;
static double screenHeight;
static UIDeviceOrientation orientationOld;

__strong static id networkSpeedObject;

static BOOL shouldUpdateSpeedLabel;
static long oldUpSpeed = 0, oldDownSpeed = 0;
typedef struct
{
    uint32_t inputBytes;
    uint32_t outputBytes;
} UpDownBytes;

static HBPreferences *pref;
static BOOL enabled;
static BOOL showAlways;
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
static double updateInterval;

// Got some help from similar network speed tweaks by julioverne & n3d1117

NSString* formatSpeed(long bytes)
{
	if (bytes < KILOBYTES) return @"0K/s";
	else if (bytes < MEGABYTES) return [NSString stringWithFormat:@"%.0fK/s", (double)bytes / KILOBYTES];
	else return [NSString stringWithFormat:@"%.2fM/s", (double)bytes / MEGABYTES];
}

UpDownBytes getUpDownBytes()
{
	@autoreleasepool
	{
		struct ifaddrs *ifa_list = 0, *ifa;
		UpDownBytes upDownBytes;
		upDownBytes.inputBytes = 0;
		upDownBytes.outputBytes = 0;
		
		if (getifaddrs(&ifa_list) == -1) return upDownBytes;

		for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
		{
			if (AF_LINK != ifa->ifa_addr->sa_family || 
				(!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING)) || 
				ifa->ifa_data == 0) continue;
			
			struct if_data *if_data = (struct if_data *)ifa->ifa_data;

			upDownBytes.inputBytes += if_data->ifi_ibytes;
			upDownBytes.outputBytes += if_data->ifi_obytes;
		}
		
		freeifaddrs(ifa_list);
		return upDownBytes;
	}
}

static NSMutableString* formattedString()
{
	@autoreleasepool
	{
		NSMutableString* mutableString = [[NSMutableString alloc] init];
		
		UpDownBytes upDownBytes = getUpDownBytes();
		long upDiff = (upDownBytes.outputBytes - oldUpSpeed) / updateInterval;
		long downDiff = (upDownBytes.inputBytes - oldDownSpeed) / updateInterval;
		oldUpSpeed = upDownBytes.outputBytes;
		oldDownSpeed = upDownBytes.inputBytes;

		if(!showAlways && (upDiff < 2 * KILOBYTES && downDiff < 2 * KILOBYTES) || upDiff > 500 * MEGABYTES && downDiff > 500 * MEGABYTES)
		{
			shouldUpdateSpeedLabel = NO;
			return nil;
		}
		else shouldUpdateSpeedLabel = YES;

		// [mutableString appendString: @"↑99.99M/s ↓99.99M/s"]; (this is for debugging)
		[mutableString appendString: @"↑"];
		[mutableString appendString: formatSpeed(upDiff)];
		[mutableString appendString: @" ↓"];
		[mutableString appendString: formatSpeed(downDiff)];
		
		return [mutableString copy];
	}
}

static void orientationChanged()
{
	if(followDeviceOrientation && networkSpeedObject) 
		[networkSpeedObject updateOrientation];
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

@implementation NetworkSpeed

	- (id)init
	{
		self = [super init];
		if(self)
		{
			@try
			{
				networkSpeedWindow = [[UIWindow alloc] initWithFrame: CGRectMake(0, 0, width, height)];
				[networkSpeedWindow setWindowLevel: 1000];
				[networkSpeedWindow setHidden: NO];
				[networkSpeedWindow setAlpha: 1];
				[networkSpeedWindow _setSecure: YES];
				[networkSpeedWindow setUserInteractionEnabled: NO];
				[[networkSpeedWindow layer] setAnchorPoint: CGPointZero];
				
				networkSpeedLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, width, height)];
				[networkSpeedLabel setNumberOfLines: 1];
				[(UIView *)networkSpeedWindow addSubview: networkSpeedLabel];

				[self updateFrame];

				[NSTimer scheduledTimerWithTimeInterval: updateInterval target: self selector: @selector(updateText) userInfo: nil repeats: YES];

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
		[self updateNetworkSpeedLabelProperties];
		[self updateNetworkSpeedSize];

		orientationOld = nil;
		[self updateOrientation];
	}

	- (void)updateNetworkSpeedLabelProperties
	{
		if(boldFont) [networkSpeedLabel setFont: [UIFont boldSystemFontOfSize: fontSize]];
		else [networkSpeedLabel setFont: [UIFont systemFontOfSize: fontSize]];

		[networkSpeedLabel setTextAlignment: alignment];

		if(customColorEnabled)
			[networkSpeedObject updateTextColor: customColor];
	}

	- (void)updateNetworkSpeedSize
	{
		CGRect frame = [networkSpeedLabel frame];
		frame.size.width = width;
		frame.size.height = height;
		[networkSpeedLabel setFrame: frame];

		frame = [networkSpeedWindow frame];
		frame.size.width = width;
		frame.size.height = height;
		[networkSpeedWindow setFrame: frame];
	}

	- (void)updateOrientation
	{
		if(!followDeviceOrientation)
		{
			CGRect frame = [networkSpeedWindow frame];
			frame.origin.x = portraitX;
			frame.origin.y = portraitY;
			[networkSpeedWindow setFrame: frame];
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
				[networkSpeedWindow setTransform: newTransform];
				CGRect frame = [networkSpeedWindow frame];
				frame.origin.x = newLocationX;
				frame.origin.y = newLocationY;
				[networkSpeedWindow setFrame: frame];
				orientationOld = orientation;
			} completion: nil];
		}
	}

	- (void)updateText
	{
		if(networkSpeedWindow && networkSpeedLabel)
		{
			if(![[%c(SBCoverSheetPresentationManager) sharedInstance] isPresented])
			{
				NSString *speed = formattedString();
				if(shouldUpdateSpeedLabel)
				{
					[networkSpeedWindow setHidden: NO];
					[networkSpeedLabel setText: speed];
				}
				else [networkSpeedWindow setHidden: YES];
			}
			else [networkSpeedWindow setHidden: YES];
		}
	}

	- (void)updateTextColor: (UIColor*)color
	{
		[networkSpeedLabel setTextColor: color];
	}

@end

%hook SpringBoard

- (void)applicationDidFinishLaunching: (id)application
{
	%orig;

	loadDeviceScreenDimensions();
	if(!networkSpeedObject) 
		networkSpeedObject = [[NetworkSpeed alloc] init];
}

%end

%hook _UIStatusBar

-(void)setForegroundColor: (UIColor*)color
{
	%orig;
	
	if(!customColorEnabled && networkSpeedObject && [self styleAttributes] && [[self styleAttributes] imageTintColor]) 
		[networkSpeedObject updateTextColor: [[self styleAttributes] imageTintColor]];
}

%end

static void settingsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	if(!pref) pref = [[HBPreferences alloc] initWithIdentifier: @"com.johnzaro.networkspeed13prefs"];
	enabled = [pref boolForKey: @"enabled"];
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
	showAlways = [pref boolForKey: @"showAlways"];
	updateInterval = [pref doubleForKey: @"updateInterval"];

	if(customColorEnabled)
	{
		NSDictionary *preferencesDictionary = [NSDictionary dictionaryWithContentsOfFile: @"/var/mobile/Library/Preferences/com.johnzaro.networkspeed13prefs.colors.plist"];
		customColor = [SparkColourPickerUtils colourWithString: [preferencesDictionary objectForKey: @"customColor"] withFallback: @"#FF9400"];
	}

	if(networkSpeedObject)
		[networkSpeedObject updateFrame];
}

%ctor
{
	@autoreleasepool
	{
		pref = [[HBPreferences alloc] initWithIdentifier: @"com.johnzaro.networkspeed13prefs"];
		[pref registerDefaults:
		@{
			@"enabled": @NO,
			@"showAlways": @NO,
			@"portraitX": @292,
			@"portraitY": @32,
			@"landscapeX": @735,
			@"landscapeY": @32,
			@"followDeviceOrientation": @NO,
			@"width": @82,
			@"height": @12,
			@"fontSize": @8,
			@"boldFont": @NO,
			@"customColorEnabled": @NO,
			@"alignment": @1,
			@"updateInterval": @1.0
    	}];

		settingsChanged(NULL, NULL, NULL, NULL, NULL);

		if(enabled)
		{
			CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, settingsChanged, CFSTR("com.johnzaro.networkspeed13prefs/reloadprefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);

			%init;
		}
	}
}