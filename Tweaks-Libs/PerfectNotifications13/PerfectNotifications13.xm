#include "PerfectNotifications13.h"

#import <Cephei/HBPreferences.h>
#import "SparkColourPickerUtils.h"

static HBPreferences *pref;
static BOOL pullToDismissNotifications;
static BOOL oneListNotifications;
static BOOL easyNotificationSwiping;
static BOOL hideNoOlderNotifications;
static BOOL showExactTimePassed;
static BOOL colorizeBackground;
static BOOL customBackgroundColorEnabled;
static UIColor *customBackgroundColor;
static BOOL colorizeBorder;
static BOOL customBorderColorEnabled;
static UIColor *customBorderColor;
static BOOL colorizeText;
static BOOL customTextColorEnabled;
static UIColor *customTextColor;
static NSInteger notificationCorner;
static NSInteger borderWidth;

// --------------------------------------------------------------------------
// --------------------- METHODS FOR CHOOSING COLORS ------------------------
// --------------------------------------------------------------------------

static UIColor *getReadableTextColorBasedOnBackgroundColor(UIColor *backgroundColor)
{
    int d = 0;
	const CGFloat *rgb = CGColorGetComponents(backgroundColor.CGColor);
    double luminance = ( 0.299 * rgb[0] + 0.587 * rgb[1] + 0.114 * rgb[2]) / 255;

    if (luminance > 0.5) d = 0;
    else d = 1;

    return  [UIColor colorWithRed: d green: d blue: d alpha: 1];
}

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

    if (luminance <= 0.5) return lighterColorForColor(backgroundColor);
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

// ------------------------------ PULL DOWN TO DISMISS NOTIFICATIONS ------------------------------

%group pullToDismissNotificationsGroup

	%hook CSCombinedListViewController

	- (void)scrollViewWillEndDragging: (id)arg1 withVelocity: (CGPoint)arg2 targetContentOffset: (CGPoint*)arg3
	{
		%orig;

		if(arg2.y < -2.0)
		{
			NCNotificationStructuredListViewController *structuredListViewController = MSHookIvar<NCNotificationStructuredListViewController*>(self, "_structuredListViewController");
			NCNotificationMasterList *masterList = [structuredListViewController masterList];
			NCNotificationStructuredSectionList *incomingSectionList = [masterList incomingSectionList];
			[incomingSectionList clearAllNotificationRequests];
		}
	}

	%end

%end

// ------------------------------ ONE LIST OF NOTIFICATIONS ------------------------------

%group oneListNotificationsGroup

	%hook NCNotificationListSectionRevealHintView

	- (void)layoutSubviews
	{

	}

	%end

	%hook NCNotificationMasterList

	- (void)setNotificationListStalenessEventTracker: (NCNotificationListStalenessEventTracker*)arg1
	{

	}

	- (NCNotificationListStalenessEventTracker*)notificationListStalenessEventTracker
	{
		return nil;
	}

	- (BOOL)_isNotificationRequestForIncomingSection: (id)arg1
	{
		return YES;
	}

	- (BOOL)_isNotificationRequestForHistorySection: (id)arg1
	{
		return NO;
	}

	- (void)_migrateNotificationsFromList: (id)arg1 toList: (id)arg2 passingTest: (id)arg3 hideToList: (BOOL)arg4 clearRequests: (BOOL)arg5
	{

	}

	- (void)migrateNotifications
	{

	}

	%end

%end

// ------------------------------ EASY NOTOFICATION SWIPING ------------------------------

%group easyNotificationSwipingGroup

	%hook NCNotificationListCell

	- (double)_actionButtonTriggerDistanceForView: (id)arg
	{
		return 0;
	}

	%end

%end

// ------------------------------ HIDE "NO OLDER NOTIFICATIONS" TEXT ------------------------------

%group hideNoOlderNotificationsGroup

	%hook NCNotificationListSectionRevealHintView

	-(void)setFrame:(CGRect)arg1
	{
		self.hidden = YES;
	}

	%end

%end

// ------------------------------ SHOW EXACT TIME PASSED IN NOTIFICATIONS ------------------------------

// ORIGINAL TWEAK @gilshahar7: https://github.com/gilshahar7/ExactTime

%group showExactTimePassedGroup

	%hook PLPlatterHeaderContentView

	-(void)_updateTextAttributesForDateLabel
	{
		%orig;
		
		NSDate *date = MSHookIvar<NSDate*>(self, "_date");
		NSInteger format = MSHookIvar<NSInteger>(self, "_dateFormatStyle");

		if(date && format == 1)
		{
			BSUIRelativeDateLabel *dateLabel = MSHookIvar<BSUIRelativeDateLabel*> (self, "_dateLabel");
			int timeSinceNow = (int)[date timeIntervalSinceNow];

			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat: @"HH:mm"];
			
			bool isFuture = false;
			if (timeSinceNow > 0) isFuture = true;
			else timeSinceNow = timeSinceNow * -1;
			
			int minutes = (timeSinceNow % 3600) / 60;
			int hours = timeSinceNow / 3600;

			if(hours != 0 || minutes != 0)
			{
				dateLabel.text = @"";
				if(isFuture) dateLabel.text = [dateLabel.text stringByAppendingString: [NSString stringWithFormat: @"in"]];
				if(hours != 0) dateLabel.text = [dateLabel.text stringByAppendingString: [NSString stringWithFormat: @" %ih", hours]];
				if(minutes != 0) dateLabel.text = [dateLabel.text stringByAppendingString: [NSString stringWithFormat: @" %im", minutes]];
				if(!isFuture) dateLabel.text = [dateLabel.text stringByAppendingString: [NSString stringWithFormat: @" ago"]];
			}
			dateLabel.text = [[dateLabel.text stringByAppendingString: @" • "] stringByAppendingString: [dateFormatter stringFromDate: date]];
			
			[dateLabel sizeToFit];
		}
	}
		
	-(void)dateLabelDidChange:(id)arg1
	{
		%orig(arg1);
		[self _updateTextAttributesForDateLabel];
	}

	%end

%end

// --------------------------------------------------------------------------
// ------------------ COLORIZE NOTIFICATIONS & BANNERS ----------------------
// --------------------------------------------------------------------------

%group colorizeNotificationsGroup

	// Notifications on LockScreen and on Notifation Center
	%hook NCNotificationShortLookView

	- (void)layoutSubviews
	{
		%orig;

		if(self.iconButtons)
		{
			UIColor *backgroundColor;
			UIColor *borderColor;
			UIColor *textColor;

			if(colorizeBackground || colorizeBorder && !customBorderColorEnabled || colorizeText && !customTextColorEnabled || !colorizeText)
			{
				if(customBackgroundColorEnabled) backgroundColor = customBackgroundColor;
				else backgroundColor = [((UIButton*)self.iconButtons[0]).currentImage mergedColor];
			}

			if(backgroundColor)
			{
				if(colorizeText)
				{
					if(customTextColorEnabled) textColor = customTextColor;
					else textColor = getContrastColorBasedOnBackgroundColor(backgroundColor);
				}
				else textColor = getReadableTextColorBasedOnBackgroundColor(backgroundColor);
				
				// Colorize header Title & Date
				PLPlatterHeaderContentView *headerContentView = MSHookIvar<PLPlatterHeaderContentView*>(self, "_headerContentView");
				[headerContentView.titleLabel mt_removeAllVisualStyling];
				headerContentView.titleLabel.textColor = textColor;
				[headerContentView.dateLabel mt_removeAllVisualStyling];
				headerContentView.dateLabel.textColor = textColor;
				headerContentView.dateColor = textColor;

				// Colorize content
				NCNotificationContentView *notificationContentView = MSHookIvar<NCNotificationContentView*>(self, "_notificationContentView");
				notificationContentView.primaryLabel.textColor = textColor;
				notificationContentView.primarySubtitleLabel.textColor = textColor;
				notificationContentView.secondaryLabel.textColor = textColor;
				notificationContentView.summaryLabel.contentLabel.textColor = textColor;
				[notificationContentView.summaryLabel.contentLabel mt_removeAllVisualStyling];

				if(colorizeBorder)
				{
					if(customBorderColorEnabled) borderColor = customBorderColor;
					else borderColor = getContrastColorBasedOnBackgroundColor(backgroundColor);
				}

				for (UIView *sbview in [self subviews])
				{
					if([sbview isKindOfClass: %c(MTMaterialView)])
					{
						MTMaterialView *subview = (MTMaterialView*)sbview;

						subview.clipsToBounds = YES;
						subview.layer.cornerRadius = notificationCorner;
						
						if(colorizeBackground) subview.backgroundColor = backgroundColor;
						if(colorizeBorder)
						{
							subview.layer.borderColor = borderColor.CGColor;
							subview.layer.borderWidth = borderWidth;
						}

						break;
					}
				}
			}
		}
	}

	%end

	// When you 3D touch a notification
	%hook NCNotificationLongLookView

	- (void)drawRect: (CGRect)rect
	{
		%orig;

		UIColor *backgroundColor;
		UIColor *textColor;

		if(self.iconButtons)
		{
			PLPlatterHeaderContentView *headerContentView = MSHookIvar<PLPlatterHeaderContentView*>(self, "_headerContentView");
			NCNotificationContentView *notificationContentView = MSHookIvar<NCNotificationContentView*>(self, "_notificationContentView");

			if(colorizeBackground || colorizeText && !customTextColorEnabled || !colorizeText)
			{
				if(customBackgroundColorEnabled) backgroundColor = customBackgroundColor;
				else backgroundColor = [((UIButton*)self.iconButtons[0]).currentImage mergedColor];
			}

			if(colorizeBackground)
			{
				headerContentView.clipsToBounds = YES;
				notificationContentView.clipsToBounds = YES;
				
				headerContentView.layer.cornerRadius = 12;
				notificationContentView.layer.cornerRadius = 12;

				headerContentView.backgroundColor = backgroundColor;
				notificationContentView.backgroundColor = backgroundColor;
			}

			if(colorizeText)
			{
				if(customTextColorEnabled) textColor = customTextColor;
				else textColor = getContrastColorBasedOnBackgroundColor(backgroundColor);
			}
			else textColor = getReadableTextColorBasedOnBackgroundColor(backgroundColor);

			headerContentView.titleLabel.textColor = textColor;
			notificationContentView.primaryLabel.textColor = textColor;
			notificationContentView.primarySubtitleLabel.textColor = textColor;
			notificationContentView.secondaryLabel.textColor = textColor;
		}
	}

	%end

	// Colorize the buttons left and right when you swipe a notification
	%hook NCNotificationListCellActionButtonsView

	- (void)layoutSubviews
	{
		%orig;
		if (!self) return;

		NCNotificationListCell *notificationListCell = (NCNotificationListCell*)self.superview.superview.superview;
		NCNotificationShortLookView *notificationShortlookView = ((NCNotificationShortLookView*)((NCNotificationViewControllerView*)notificationListCell.contentViewController.view).contentView);

		if(notificationShortlookView.iconButtons)
		{
			UIColor *backgroundColor;
			UIColor *borderColor;
			UIColor *textColor;
			
			if(colorizeBackground || colorizeBorder && !customBorderColorEnabled || colorizeText && !customTextColorEnabled || !colorizeText)
			{
				if(customBackgroundColorEnabled) backgroundColor = customBackgroundColor;
				else backgroundColor = [((UIButton*)notificationShortlookView.iconButtons[0]).currentImage mergedColor];
			}
			
			if(colorizeText)
			{
				if(customTextColorEnabled) textColor = customTextColor;
				else textColor = getContrastColorBasedOnBackgroundColor(backgroundColor);
			}
			else textColor = getReadableTextColorBasedOnBackgroundColor(backgroundColor);

			if(colorizeBorder)
			{
				if(customBorderColorEnabled) borderColor = customBorderColor;
				else borderColor = getContrastColorBasedOnBackgroundColor(backgroundColor);
			}

			for(NCNotificationListCellActionButton *button in self.buttonsStackView.arrangedSubviews)
			{
				MTMaterialView *backgroundView = (MTMaterialView*)button.backgroundView;
				if(!backgroundView) return;

				[button.titleLabel mt_removeAllVisualStyling];
				button.titleLabel.textColor = textColor;

				backgroundView.clipsToBounds = YES;
				backgroundView.layer.cornerRadius = notificationCorner;
				
				if(colorizeBackground) backgroundView.backgroundColor = backgroundColor;
				if(colorizeBorder)
				{
					backgroundView.layer.borderColor = borderColor.CGColor;
					backgroundView.layer.borderWidth = borderWidth;
				}
			}
		}
	}

	%end

	// Small fix for date Label losing it's text color
	%hook PLPlatterHeaderContentView

	%property(nonatomic, retain) UIColor *dateColor;

	- (void)layoutSubviews
	{
		%orig;

		if(colorizeText)
		{
			[self.dateLabel mt_removeAllVisualStyling];
			if(self.dateColor) self.dateLabel.textColor = self.dateColor;
		}
	}

	%end

%end

%ctor
{
	@autoreleasepool
	{
		pref = [[HBPreferences alloc] initWithIdentifier: @"com.johnzaro.perfectnotifications13prefs"];
		[pref registerDefaults:
		@{
			@"pullToDismissNotifications": @NO,
			@"oneListNotifications": @NO,
			@"easyNotificationSwiping": @NO,
			@"hideNoOlderNotifications": @NO,
			@"showExactTimePassed": @NO,
			@"colorizeBackground": @NO,
			@"customBackgroundColorEnabled": @NO,
			@"colorizeText": @NO,
			@"customTextColorEnabled": @NO,
			@"colorizeBorder": @NO,
			@"customBorderColorEnabled": @NO,
			@"borderWidth": @3,
			@"notificationCorner": @12
    	}];

		pullToDismissNotifications = [pref boolForKey: @"pullToDismissNotifications"];
		oneListNotifications = [pref boolForKey: @"oneListNotifications"];
		easyNotificationSwiping = [pref boolForKey: @"easyNotificationSwiping"];
		hideNoOlderNotifications = [pref boolForKey: @"hideNoOlderNotifications"];
		showExactTimePassed = [pref boolForKey: @"showExactTimePassed"];
		colorizeBackground = [pref boolForKey: @"colorizeBackground"];
		customBackgroundColorEnabled = [pref boolForKey: @"customBackgroundColorEnabled"];
		colorizeText = [pref boolForKey: @"colorizeText"];
		customTextColorEnabled = [pref boolForKey: @"customTextColorEnabled"];
		colorizeBorder = [pref boolForKey: @"colorizeBorder"];
		customBorderColorEnabled = [pref boolForKey: @"customBorderColorEnabled"];
		borderWidth = [pref integerForKey: @"borderWidth"];
		notificationCorner = [pref integerForKey: @"notificationCorner"];

		if(customBackgroundColorEnabled || customBorderColorEnabled || customTextColorEnabled)
		{
			NSDictionary *preferencesDictionary = [NSDictionary dictionaryWithContentsOfFile: @"/var/mobile/Library/Preferences/com.johnzaro.perfectnotifications13prefs.colors.plist"];

			if(customBackgroundColorEnabled)
				customBackgroundColor = [SparkColourPickerUtils colourWithString: [preferencesDictionary objectForKey: @"customBackgroundColor"] withFallback: @"#FF9400"];
			if(customTextColorEnabled)
				customTextColor = [SparkColourPickerUtils colourWithString: [preferencesDictionary objectForKey: @"customTextColor"] withFallback: @"#A36827"];
			if(customBorderColorEnabled)
				customBorderColor = [SparkColourPickerUtils colourWithString: [preferencesDictionary objectForKey: @"customBorderColor"] withFallback: @"#A36827"];

		}

		if(pullToDismissNotifications) %init(pullToDismissNotificationsGroup);
		if(oneListNotifications) %init(oneListNotificationsGroup);
		if(easyNotificationSwiping) %init(easyNotificationSwipingGroup);
		if(hideNoOlderNotifications) %init(hideNoOlderNotificationsGroup);
		if(showExactTimePassed) %init(showExactTimePassedGroup);
		%init(colorizeNotificationsGroup);
	}
}
