#include "SBFAuthenticationRequest.h"

#define settingsPath [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.soup.uzitimepref.plist"]

%hook SBFUserAuthenticationController
-(void)processAuthenticationRequest:(id)arg1 {

	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

	bool enabled = [[prefs objectForKey:@"enabled"] boolValue];
	bool trippie = [[prefs objectForKey:@"trippie"] boolValue];
	bool popups = [[prefs objectForKey:@"popups"] boolValue];
	NSString *password = [prefs objectForKey:@"password"];

	if (enabled) {

		SBFAuthenticationRequest *req = arg1;
		NSString *pass = req.passcode; // Gets entered Passcode

		//NSString *text = [[NSArray arrayWithObjects:userPass, pass, nil] componentsJoinedByString:@"\n"];

		if ([pass isEqualToString:@"1600"]) {
			if (popups) {
				UIAlertView *testAlert = [[UIAlertView alloc]initWithTitle:@"Oozifer" message:@"Uzi Time!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
				[testAlert show];
			}

			SBFAuthenticationRequest *newReq = [[%c(SBFAuthenticationRequest) alloc] initForPasscode:password source: req.source handler: req.handler];
			return %orig(newReq);
		}

		if ([pass isEqualToString:@"1400"]) {
			if (trippie) {
				if (popups) {
					UIAlertView *testAlert = [[UIAlertView alloc]initWithTitle:@"Trippie Time!" message:@"1400" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
					[testAlert show];
				}

				SBFAuthenticationRequest *newReq = [[%c(SBFAuthenticationRequest) alloc] initForPasscode:password source: req.source handler: req.handler];
				return %orig(newReq);
			}
		}
	}

	%orig;
}
%end
