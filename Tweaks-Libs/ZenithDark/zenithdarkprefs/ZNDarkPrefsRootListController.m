#import "ZNDarkPrefsRootListController.h"

@implementation ZNDarkPrefsRootListController

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	// share button for our tweak :P
	 self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(shareTapped)];


}


//share button action 
- (void)shareTapped {
   
    	 NSString *shareText = @"Turn off the lights! It's too bright! Get dark tabs for #Zenith (@Muirey03) by using #ZenithDark from @mac_user669 and @iKilledAppl3! https://mac-user669.github.io/repo/";
    	 UIImage *image = [UIImage imageWithContentsOfFile:kImagePath];
	     NSArray * itemsToShare = @[shareText, image];
	 
    	UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:itemsToShare applicationActivities:nil];
    
    // and present it
    [self presentActivityController:controller];
}

- (void)presentActivityController:(UIActivityViewController *)controller {
    
    // for iPad: make the presentation a Popover
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = self.navigationItem.rightBarButtonItem;
 
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}


-(void)followMe {	
	NSURL *twitter = [NSURL URLWithString:@"https://twitter.com/mac_user669"];	
	[[UIApplication sharedApplication] openURL:twitter options:@{} completionHandler:nil];	
}

-(void)followiKA {	
	NSURL *twitter = [NSURL URLWithString:@"https://twitter.com/iKilledAppl3"];	
	[[UIApplication sharedApplication] openURL:twitter options:@{} completionHandler:nil];	
}

-(void)followSkitty {	
	NSURL *twitter = [NSURL URLWithString:@"https://twitter.com/SkittyBlock"];	
	[[UIApplication sharedApplication] openURL:twitter options:@{} completionHandler:nil];	
}


-(void)respring {
    NSTask *task = [[[NSTask alloc] init] autorelease];
    [task setLaunchPath:@"/usr/bin/killall"];
    [task setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
    [task launch];	  
    
}

-(void)doAFancyRespring {

	UIAlertController *confirmRespringAlert = [UIAlertController alertControllerWithTitle:@"Apply Settings?" message:@"This will respring your device." preferredStyle:UIAlertControllerStyleActionSheet];	
	UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {	

	// blur then respring our device!	
	self.mainAppRootWindow = [UIApplication sharedApplication].keyWindow;
    self.respringBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.respringEffectView = [[UIVisualEffectView alloc] initWithEffect:self.respringBlur];
    self.respringEffectView.frame = [[UIScreen mainScreen] bounds];
    [self.mainAppRootWindow addSubview:self.respringEffectView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:5.0];
    [self.respringEffectView setAlpha:0];
    [UIView commitAnimations];

    [self performSelector:@selector(respring) withObject:nil afterDelay:3.0];

    }];	

	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];	

    [confirmRespringAlert addAction:cancel];	
	[confirmRespringAlert addAction:confirm];	

	[self presentViewController:confirmRespringAlert animated:YES completion:nil];	
}

@end
