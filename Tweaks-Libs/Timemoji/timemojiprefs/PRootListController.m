#import "PRootListController.h"
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import <spawn.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSHeaderFooterView.h>

@interface HBImageTableCell : PSTableCell <PSHeaderFooterView>
@end


@implementation PRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}
/*
- (void)respring {
	//[NSThread sleepForTimeInterval: 3.2];

	pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}*/
-(void)twitter {
	[[UIApplication sharedApplication]
	openURL:[NSURL URLWithString:@"https://twitter.com/1DI4R"]
	options:@{}
	completionHandler:nil];
		}
-(void)paypal {
			[[UIApplication sharedApplication]
			openURL:[NSURL URLWithString:@"https://paypal.me/dyarib/2"]
			options:@{}
			completionHandler:nil];
				}
-(void)github {
		 	 			[[UIApplication sharedApplication]
		 	 			openURL:[NSURL URLWithString:@"https://github.com/1di4r"]
		 	 			options:@{}
		 	 			completionHandler:nil];
		 	 				}

							//thanks to @teo155 for this :P

- (void)loadSpinner {


	UIAlertController *pending = [UIAlertController alertControllerWithTitle:nil
	                                                               message:@"Saving Changes...\n\n"
	                                                        preferredStyle:UIAlertControllerStyleAlert];
	UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.color = [UIColor blackColor];
	indicator.translatesAutoresizingMaskIntoConstraints=NO;
	indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;

	[pending.view addSubview:indicator];
	NSDictionary * views = @{@"pending" : pending.view, @"indicator" : indicator};

	NSArray * constraintsVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[indicator]-(20)-|" options:0 metrics:nil views:views];
	NSArray * constraintsHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[indicator]|" options:0 metrics:nil views:views];
	NSArray * constraints = [constraintsVertical arrayByAddingObjectsFromArray:constraintsHorizontal];
	[pending.view addConstraints:constraints];
	[indicator setUserInteractionEnabled:NO];
	[indicator startAnimating];
	[self presentViewController:pending animated:YES completion:nil];
	[indicator performSelector:@selector(stopAnimating) withObject:nil afterDelay:2.0];
  [self performSelector:@selector(hideAlertView) withObject:nil afterDelay:2.0];             }

	-(void)hideAlertView{
	// [pending dismissViewControllerAnimated:YES completion:nil];
	  [self dismissViewControllerAnimated:pending completion:nil];
		[pending release];
	}

-(void)doit {
	[self loadSpinner];
	[self.view endEditing:YES];

	double delayInSeconds = 2.3;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
	 {
	               pid_t pid;
		             const char* args[] = {"killall", "backboardd", NULL};
		             posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
							 });

}

@end
