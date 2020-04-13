#include <libcolorpicker.h>
#include <UIKit/UIKit.h>
#include <Foundation/Foundation.h>
NSDictionary *preferences;
BOOL isEnabled;
UIColor *firstGradient;
UIColor *secondGradient;
@interface CKGradientView : UIView {
	NSArray* _colors;
}
- (void)setColors:(NSArray *)arg1;
@end
%hook CKGradientView
- (void)setColors:(NSArray *)arg1 {
	NSDictionary *colorPrefs = [[NSDictionary alloc] initWithContentsOfURL:[NSURL fileURLWithPath:@"/var/mobile/Library/Preferences/com.daydream.messagesprocolorprefs"]];
	firstGradient = LCPParseColorString([colorPrefs objectForKey:@"gradientColor"], @"#ff0000");
	secondGradient = LCPParseColorString([colorPrefs objectForKey:@"gradientColorAlt"], @"#ff7f00");
	if(isEnabled) {
		%orig(@[firstGradient, secondGradient]);
		return;
	}
	%orig((NSArray *)arg1);
}
%end
%ctor {
	preferences = [[NSUserDefaults standardUserDefaults]
	persistentDomainForName:@"com.daydream.messagesproprefs"];
	isEnabled = [[preferences valueForKey:@"isEnabled"] boolValue];
	NSDictionary *colorPrefs = [[NSDictionary alloc] initWithContentsOfURL:[NSURL fileURLWithPath:@"/var/mobile/Library/Preferences/com.daydream.messagesprocolorprefs"]];
	NSLog(@"[MessagesPro] %@", (NSString *)[colorPrefs objectForKey:@"gradientColor"]);
	NSLog(@"[MessagesPro] %@", (NSString *)[colorPrefs objectForKey:@"gradientColorAlt"]);
	firstGradient = LCPParseColorString([colorPrefs objectForKey:@"gradientColor"], @"#ff0000");
	secondGradient = LCPParseColorString([colorPrefs objectForKey:@"gradientColorAlt"], @"#ff7f00");
}
