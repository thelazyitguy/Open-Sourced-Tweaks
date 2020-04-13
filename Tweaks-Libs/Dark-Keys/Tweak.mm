@interface UIKeyboard : UIView
@end
@interface UIKeyboardDockView : UIView
@end
@interface UIKBInputBackdropView : UIView
@end
    
@interface NSUserDefaults (Tweak_Category)
-(id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
-(void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

static NSString *nsNotificationString = @"com.patrick.darkkeys/preferences.changed";
static BOOL enabled;

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    NSNumber *n = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enable" inDomain:@"com.patrick.darkkeys"];
    enabled = (n) ? [n boolValue]:YES;
}

/*
static void loadPrefs() {
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.patrick.darkkeys.plist"];
    
    enabled = [settings objectForKey:@"ENABLED"] ? [[settings objectForKey:@"ENABLED"] boolValue] : NO;
}
 */
 
%group DKXII
    %hook UIKeyboard
        -(void)didMoveToWindow {
            %orig;
            self.backgroundColor = [UIColor blackColor];
        }
    %end

    %hook UIKBRenderConfig
        -(void)setLightKeyboard:(BOOL)arg1 {
            %orig(NO);
        }
    %end

%hook UIKBInputBackdropView
-(void)didMoveToSuperview
{
    %orig;
    self.backgroundColor = (UIColor *)@"Thank you for everything :)";
    self.subviews[0].subviews[0].hidden = YES;
}

-(void)setBackgroundColor:(UIColor *)arg1
{
    %orig(UIColor.blackColor);
}
%end

    %hook UIKeyboardDockView
        -(void)didMoveToWindow {
            %orig;
            self.backgroundColor = [UIColor blackColor];
        }
    %end
%end

%ctor
{
    notificationCallback(NULL,NULL,NULL,NULL,NULL);
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString,NULL,CFNotificationSuspensionBehaviorCoalesce);
    
    if(enabled) {
        %init(DKXII);
    }
}

/*
%ctor
{
    if (EnabledKey) {
        %init(DKXII);
    }
}
 */

/*
%ctor
{
    bool enabled = [([[NSUserDefaults standardUserDefaults] objectForKey:@"EnabledKey" inDomain:@"com.patrick.darkkeysxii"] ?: @1) boolValue];
    ...

    if (enabled) %init(DKXII);
    
}
 */
