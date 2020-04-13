//
//  FUXCommon.xm
//  FastUnlockX
//
//  Created by Juan Carlos Perez on 12/03/2019.
//  Copyright © 2019 CP Digital Darkroom. All rights reserved.
//

#import "FastUnlockX.h"

BOOL settingsValueFor(NSString *prefKey) {
    return [(id)CFPreferencesCopyAppValue((CFStringRef)prefKey, CFSTR("com.cpdigitaldarkroom.fastunlockx")) boolValue];
}

%hook SBDashBoardPearlUnlockBehavior

-(void)_handlePearlFailure {

    %orig;

    if(settingsValueFor(@"FUXEnabled")) {
        if(settingsValueFor(@"RequestsAutoPearlRetry")) {

            /*
             * If user requests retrying for pearl failure, call noteScreenDidTurnOff on SBUIBiometricResource
             * and then noteScreenWillTurnOn after a short delay to trick it to rescan
             *
             * Thanks to gilshahar7 for sending me this part of code, he also mentioned to credit ipad_kid for his help
             */
            [[NSClassFromString(@"SBUIBiometricResource") sharedInstance] noteScreenDidTurnOff];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSClassFromString(@"SBUIBiometricResource") sharedInstance] noteScreenWillTurnOn];
            });
        }
    }
}
%end

static void setupDefaults () {

    /*
     * If no value exists for the FUXEnabled setting set it as not enabled
     */
    if(!CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("FUXEnabled"), CFSTR("com.cpdigitaldarkroom.fastunlockx")))) {
        CFPreferencesSetAppValue((CFStringRef)@"FUXEnabled", (CFPropertyListRef)@0, CFSTR("com.cpdigitaldarkroom.fastunlockx"));
    }

    /*
     * Do the same as above just for the other settings. Only change is here I am setting them as enabled by default.
     */

    if(!CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("RequestsAutoPearlRetry"), CFSTR("com.cpdigitaldarkroom.fastunlockx")))) {
        CFPreferencesSetAppValue((CFStringRef)@"RequestsAutoPearlRetry", (CFPropertyListRef)@1, CFSTR("com.cpdigitaldarkroom.fastunlockx"));
    }

    if(!CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("RequestsFlastlightExcemption"), CFSTR("com.cpdigitaldarkroom.fastunlockx")))) {
        CFPreferencesSetAppValue((CFStringRef)@"RequestsFlastlightExcemption", (CFPropertyListRef)@1, CFSTR("com.cpdigitaldarkroom.fastunlockx"));
    }

    if(!CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("RequestsMediaExcemption"), CFSTR("com.cpdigitaldarkroom.fastunlockx")))) {
        CFPreferencesSetAppValue((CFStringRef)@"RequestsMediaExcemption", (CFPropertyListRef)@1, CFSTR("com.cpdigitaldarkroom.fastunlockx"));
    }

    if(!CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("RequestsContentExcemption"), CFSTR("com.cpdigitaldarkroom.fastunlockx")))) {
        CFPreferencesSetAppValue((CFStringRef)@"RequestsContentExcemption", (CFPropertyListRef)@1, CFSTR("com.cpdigitaldarkroom.fastunlockx"));
    }

}

%ctor {
    setupDefaults();
}