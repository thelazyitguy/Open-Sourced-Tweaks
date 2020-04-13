#import <UIKit/UIKit.h>
#include <dlfcn.h>

@interface _UIStatusBarForegroundView : UIView
@end

%group UIDebug

/* %hook UIResponder

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        UIAlertView *alertView = [[UIAlertView alloc] init];
        alertView.delegate = self;
        alertView.tag = 0;
        alertView.title = @"Lookin UIDebug";
        [alertView addButtonWithTitle:@"2D Inspection"];
        [alertView addButtonWithTitle:@"3D Inspection"];
        [alertView addButtonWithTitle:@"Export"];
        [alertView addButtonWithTitle:@"Cancel"];
        [alertView show];
    }
}

%new

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        
        if (buttonIndex == 0) {//审查元素2D
			[[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_2D" object:nil];
        } else if (buttonIndex == 1) {//3D视图
			[[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_3D" object:nil];
        }else if (buttonIndex == 2) {//导出当前UI结构
        	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				
				[[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_Export" object:nil];
			});
        }
    }
}

%end */

%hook _UIStatusBarForegroundView

- (id)initWithFrame:(CGRect)arg1 {

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlert:)];
    
    tapGesture.numberOfTapsRequired = 2;

    [self addGestureRecognizer:tapGesture];

    return %orig;

}

%new 

- (void)showAlert:(UITapGestureRecognizer *)sender {

    if (sender.state == UIGestureRecognizerStateEnded) {

        UIAlertView *alertView = [[UIAlertView alloc] init];
        alertView.delegate = self;
        alertView.tag = 0;
        alertView.title = @"Lookin UIDebug";
        [alertView addButtonWithTitle:@"2D Inspection"];
        [alertView addButtonWithTitle:@"3D Inspection"];
        [alertView addButtonWithTitle:@"Export"];
        [alertView addButtonWithTitle:@"Cancel"];
        [alertView show];

    }

}

%new

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 0) {
        
        if (buttonIndex == 0) {

			[[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_2D" object:nil];
       
        } else if (buttonIndex == 1) {
			
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_3D" object:nil];
        
        } else if (buttonIndex == 2) {

        	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			
				[[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_Export" object:nil];
			
            });

        }

    }

}

%end

%end

%ctor {
	
	NSFileManager* fileManager = [NSFileManager defaultManager];

	NSString* libPath = @"/usr/lib/Lookin/LookinServer.framework/LookinServer";

	if ([fileManager fileExistsAtPath:libPath]) {

		void *lib = dlopen([libPath UTF8String], RTLD_NOW);
		
		if (lib) {

			%init(UIDebug)

			NSLog(@"[+] LookinLoader loaded!");

		} else {
			
			char* err = dlerror();
			
			NSLog(@"[+] LookinLoader load failed:%s", err);
		}
	
	}

}
