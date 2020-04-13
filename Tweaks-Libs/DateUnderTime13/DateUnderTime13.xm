#import "DateUnderTime13.h"

#import <Cephei/HBPreferences.h>

static UIFont *font1;
static UIFont *font2;

static NSDateFormatter *formatter1;
static NSDateFormatter *formatter2;

static NSMutableAttributedString *finalString;

static HBPreferences *pref;
static BOOL enabled;
static NSString *format1;
static long fontSize1;
static BOOL bold1;
static NSString *format2;
static long fontSize2;
static BOOL bold2;
static NSString *locale;
static long alignment;
static BOOL hideLocationIndicator;

%hook _UIStatusBarStringView

- (void)applyStyleAttributes: (id)arg1
{
	if(!(self.text != nil && [self.text containsString: @":"])) %orig;
}

-(void)setText: (NSString*)text
{
	if([text containsString: @":"])
	{
		@autoreleasepool
		{
			NSDate *nowDate = [NSDate date];

			[finalString setAttributedString: [[NSAttributedString alloc] initWithString: [formatter1 stringFromDate: nowDate] attributes: @{ NSFontAttributeName: font1 }]];
			[finalString appendAttributedString: [[NSAttributedString alloc] initWithString: [formatter2 stringFromDate: nowDate] attributes: @{ NSFontAttributeName: font2 }]];

			self.textAlignment = alignment;
			self.numberOfLines = 2;
			self.attributedText = finalString;
		}
	}
	else %orig(text);
}

%end

%group hideLocationIndicatorGroup

	%hook _UIStatusBarIndicatorLocationItem

	- (id)applyUpdate: (id)arg1 toDisplayItem: (id)arg2
	{
		return nil;
	}

	%end

%end

%ctor
{
	@autoreleasepool
	{
		pref = [[HBPreferences alloc] initWithIdentifier: @"com.johnzaro.dateundertime13prefs"];
		[pref registerDefaults:
		@{
			@"enabled": @NO,
			@"format1": @"HH:mm",
			@"fontSize1": @14,
			@"bold1": @NO,
			@"format2": @"E dd/MM",
			@"fontSize2": @10,
			@"bold2": @NO,
			@"locale": @"en_US",
			@"alignment": @1,
			@"hideLocationIndicator": @NO
    	}];

		enabled = [pref boolForKey: @"enabled"];

		if(enabled)
		{
			format1 = [pref objectForKey: @"format1"];
			fontSize1 = [pref integerForKey: @"fontSize1"];
			bold1 = [pref boolForKey: @"bold1"];

			format2 = [pref objectForKey: @"format2"];
			fontSize2 = [pref integerForKey: @"fontSize2"];
			bold2 = [pref boolForKey: @"bold2"];

			locale = [pref objectForKey: @"locale"];

			alignment = [pref integerForKey: @"alignment"];

			hideLocationIndicator = [pref boolForKey: @"hideLocationIndicator"];

			formatter1 = [[NSDateFormatter alloc] init];
			formatter1.locale = [[NSLocale alloc] initWithLocaleIdentifier: locale];
			formatter1.timeStyle = NSDateFormatterNoStyle;
			formatter1.dateFormat = [NSString stringWithFormat:@"%@\n", format1];

			if(bold1) font1 = [UIFont boldSystemFontOfSize: fontSize1];
			else font1 = [UIFont systemFontOfSize: fontSize1];

			formatter2 = [[NSDateFormatter alloc] init];
			formatter2.locale = [[NSLocale alloc] initWithLocaleIdentifier: locale];
			formatter2.timeStyle = NSDateFormatterNoStyle;
			formatter2.dateFormat = format2;

			if(bold2) font2 = [UIFont boldSystemFontOfSize: fontSize2];
			else font2 = [UIFont systemFontOfSize: fontSize2];

			finalString = [[NSMutableAttributedString alloc] init];

			%init;

			if(hideLocationIndicator) %init(hideLocationIndicatorGroup);
		}
	}
}