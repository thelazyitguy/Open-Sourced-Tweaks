//
//  FastUnlockX.xm
//  FastUnlockX
//
//  Created by Juan Carlos Perez on 01/19/2018.
//  Copyright © 2019 CP Digital Darkroom. All rights reserved.
//

#import "FastUnlockX.h"
#import <version.h>

extern BOOL settingsValueFor(NSString *prefKey);

%group FUX_12

%hook SBDashBoardViewController

%property (assign, nonatomic) BOOL fux_alreadyAuthenticated;

- (void)viewWillAppear:(BOOL)animated {

    %orig;

    /*
    * There are two ways the lockscreen is shown. When waking the device and also when
    * pulling the notification center  down. When viewWillAppear: is called we can determine
    * if the presentation was manual since the controller will already be authenticated.
    */
    self.fux_alreadyAuthenticated = self.authenticated;
}

/*
 * Use this to catch when FaceID successfully matches
 */
- (void)setAuthenticated:(BOOL)authenticated {

    %orig;

    if(authenticated) {

        /*
         * If FUX is enabled
         */
        if(settingsValueFor(@"FUXEnabled")) {

            /*
             * Only continue with FUX if not already authenticated
             * If already authenticated we manually invoked the cover sheet and want to be there.
             */
            if(!self.fux_alreadyAuthenticated) {

                /*
                 * If a modal view is currently presented, this includes the passcode view, alarms, last mode
                 * and probably more
                 */
                if(self.modalPresentationController) {
                    for(id object in self.modalPresentationController.presentedViewControllers) {
                        /*
                         * If presenting a fullscreen notification, return since it's probably important
                         */
                        if([object isKindOfClass:NSClassFromString(@"SBDashBoardFullscreenNotificationViewController")]) {
                            return;
                        }
                    }
                }

                /*
                 * Flashlight Levels
                 * 0 = Off
                 * 1-4 are equal to the amount of flashlight level steps enabled from the control center module
                 */
                if(([[NSClassFromString(@"SBUIFlashlightController") sharedInstance] level] > 0)) {
                    if(settingsValueFor(@"RequestsFlastlightExcemption")) return;
                }

                /*
                 * If there is any content we likely want to check it out.
                 */
                if(self.mainPageContentViewController.combinedListViewController.hasContent) {
                    /*
                     * Access the notification list view controller
                     */
                    NCNotificationListViewController *listController = [self.mainPageContentViewController.combinedListViewController valueForKey:@"_listViewController"];

                    if([listController hasVisibleContent]) {
                        /*
                        * If notifications are showing and user requests disabling for them, stop here
                        */
                        if(settingsValueFor(@"RequestsContentExcemption")) return;
                    }

                    if(self.isShowingMediaControls) {
                        /*
                        * If media controls are showing and user requests disabling for them, stop here
                        */
                        if(settingsValueFor(@"RequestsMediaExcemption")) return;
                    }

                }
                /*
                 * We're authenticated and have no reason to disable unlocking, send unlock request
                 */
                [[NSClassFromString(@"SBLockScreenManager") sharedInstance] lockScreenViewControllerRequestsUnlock];
            }
        }
    }
}

- (void)setInScreenOffMode:(BOOL)screenOff {

    %orig;

    /*
     * Reset fux_alreadyAuthenticated. If screen goes off we are not authenticated anymore.
     */
     self.fux_alreadyAuthenticated = !screenOff;
}

%end // SBDashBoardViewController

%end // FUX_12

%ctor {
    if(IS_IOS_OR_NEWER(iOS_13_0)) {} else {
        %init(FUX_12);
    }
}
