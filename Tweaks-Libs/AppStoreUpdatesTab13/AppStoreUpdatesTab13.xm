#import "AppStoreUpdatesTab13.h"

%hook UITabBar

- (void)layoutSubviews
{
	%orig;

	for(UIView *subview in [self subviews])
	{
		if([subview isKindOfClass: %c(UITabBarButton)])
		{
			UITabBarButton *button = (UITabBarButton*)subview;
			UITabBarButtonLabel *_label = MSHookIvar<UITabBarButtonLabel*> (button, "_label");
			
			if([[_label text] isEqualToString: @"Arcade"])
			{
				[_label setText: @"Updates"];

				UITabBarSwappableImageView *_imageView = MSHookIvar<UITabBarSwappableImageView*> (button, "_imageView");
				_imageView.image = [UIImage imageNamed: @"UpdatesTabIcon-38-56-" inBundle: bundle compatibleWithTraitCollection: nil];
				
				UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(openUpdates)];
				[button addGestureRecognizer: gr];
			}
		}
	}
}

%new
- (void)openUpdates
{
	UIApplication *application = [%c(UIApplication) sharedApplication];

	[application openURL: [NSURL URLWithString: @"itms-apps://apps.apple.com/updates"]];
}

%end

%ctor
{
	bundle = [[NSBundle alloc] initWithPath: kBundlePath];
	
	%init;
}
