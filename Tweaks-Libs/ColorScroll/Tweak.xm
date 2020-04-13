#import <libcolorpicker.h>

static UIColor *customColor;
static BOOL enabled, retainAlpha;

static void setupPrefs() {
	NSDictionary *settings;

	CFArrayRef keyList = CFPreferencesCopyKeyList(CFSTR("com.shepgoba.colorscrollprefs"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
	if (keyList) {
		settings = (NSMutableDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, CFSTR("com.shepgoba.colorscrollprefs"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
		CFRelease(keyList);
	} else {
		settings = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.shepgoba.colorscrollprefs.plist"];
	}

	enabled = [([settings objectForKey:@"enabled"] ? [settings objectForKey:@"enabled"] : @(YES)) boolValue];
	retainAlpha = [([settings objectForKey:@"retainAlpha"] ? [settings objectForKey:@"retainAlpha"] : @(YES)) boolValue];

	NSDictionary *colors = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.shepgoba.colorscrollprefs.color.plist"];
	customColor = LCPParseColorString([colors objectForKey:@"scrollIndicatorColor"], @"#FFFFFF");
}

@interface UIScrollView (stuff)
@property (getter=_verticalScrollIndicator,nonatomic,readonly) UIView * verticalScrollIndicator; 
@property (getter=_horizontalScrollIndicator,nonatomic,readonly) UIView * horizontalScrollIndicator; 
@end

%group Tweak13
%hook _UIScrollViewScrollIndicator 
-(id)_colorForStyle:(long long)arg1 {

	CGFloat red, green, blue, alpha;
	[customColor getRed:&red green:&green blue:&blue alpha:&alpha];

	if (retainAlpha) {
		UIColor *orig = %orig;

		CGFloat origAlpha;
		[orig getRed:NULL green:NULL blue:NULL alpha:&origAlpha];
		alpha = origAlpha;
	}

	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
%end
%end

%group Tweak12
%hook UIScrollView
-(void)addSubview:(UIView *)view {
	%orig;
	if ([view isMemberOfClass:[UIImageView class]] && CGSizeEqualToSize(view.frame.size, CGSizeMake(2.5, 2.5))) {
		UIImageView *imgView = (UIImageView *)view;
		if (retainAlpha) {
			imgView.image = [imgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			[imgView setTintColor:customColor];
		} else {
			imgView.backgroundColor = customColor;
			imgView.layer.cornerRadius = 1.5;
			imgView.image = nil;
		}
	}
}
%end
%end

%ctor {
	setupPrefs();
	if (enabled) {
		if (@available(iOS 13, *)) {
			%init(Tweak13);
		} else {
			%init(Tweak12);
		}
	}
}