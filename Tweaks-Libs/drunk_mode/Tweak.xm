#import "PSSpecifier.h"
#import "WAHeaders.h"

#define PreferencesPlist @"/var/mobile/Library/Preferences/me.qusic.drunkmode.plist"
#define DrunkModeKey @"DrunkMode"

static BOOL getDrunkMode()
{
    NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:PreferencesPlist];
    return [[preferences objectForKey:DrunkModeKey]boolValue];
}

static void setDrunkMode(BOOL value)
{
    NSMutableDictionary *preferences = [NSMutableDictionary dictionary];
    [preferences addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:PreferencesPlist]];
    [preferences setObject:[NSNumber numberWithBool:value] forKey:DrunkModeKey];
    [preferences writeToFile:PreferencesPlist atomically:YES];
}

%hook CKChatController
-(void)messageEntryViewSendButtonHit:(id)messageEntryView {
    if (getDrunkMode()) {
    	// TODO: This really needs to be refactored into a function createAlert
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Drunk Mode"
                                                                message:@"Go Home"
                                                                preferredStyle:UIAlertControllerStyleAlert];

        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Whaat???"
                                                 style:UIAlertActionStyleDefault
                                                 handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        %orig();
    }
}


%end

// WA

%hook WAChatBar

UIWindow *window = [[[UIApplication sharedApplication] delegate] window];

-(void)sendButtonTapped:(id)arg1 {
    if (getDrunkMode()) {
      // TODO: This really needs to be refactored into a function createAlert
       UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Drunk Mode"
                                                               message:@"Go Home"
                                                               preferredStyle:UIAlertControllerStyleAlert];

       //We add buttons to the alert controller by creating UIAlertActions:
       UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Whaat???"
                                                style:UIAlertActionStyleDefault
                                                handler:nil];
      [alertController addAction:actionOk];
      [self.window makeKeyAndVisible];
      //TODO: open keyboard once we close the alert
      [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];

   } else {
        %orig();
    }
}

%end

%hook PSUIPrefsListController
-(NSMutableArray *) specifiers {

    NSMutableArray *specifiers = %orig;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Drunk Mode"
                                                                                      target:self
                                                                                         set:@selector(setDrunkMode:specifier:)
                                                                                         get:@selector(getDrunkMode:)
                                                                                      detail:Nil
                                                                                        cell:PSSwitchCell
                                                                                        edit:Nil];
        [specifier setIdentifier:DrunkModeKey];
        [specifier setProperty:[NSNumber numberWithBool:YES] forKey:@"enabled"];
        [specifier setProperty:[NSNumber numberWithBool:YES] forKey:@"alternateColors"];
        [specifier setProperty:[UIImage imageWithContentsOfFile:@"/Library/Application Support/DrunkMode/DrunkMode.png"] forKey:@"iconImage"];
        [specifier setProperty:@"Settings-DrunkMode" forKey:@"iconCache"];
        
        [specifiers insertObject:specifier atIndex:2];
    });
    
    return specifiers;
}

%new -(id)getDrunkMode:(PSSpecifier*)specifier {
    return [NSNumber numberWithBool:getDrunkMode()];
}

%new -(void)setDrunkMode:(id)value specifier:(PSSpecifier *) specifier {
    setDrunkMode([value boolValue]);
}

%end
