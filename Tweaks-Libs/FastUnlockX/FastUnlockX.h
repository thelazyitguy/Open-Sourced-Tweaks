//
//  FastUnlockX.h
//  FastUnlockX
//
//  Created by Juan Carlos Perez on 01/19/2018.
//  Copyright © 2017 CP Digital Darkroom. All rights reserved.
//

@interface NCNotificationListViewController : UICollectionViewController
-(BOOL)hasVisibleContent;
@end

@interface NCNotificationCombinedListViewController : NCNotificationListViewController
@end

@interface SBUIBiometricResource : NSObject
+ (id)sharedInstance;
- (void)noteScreenDidTurnOff;
- (void)noteScreenWillTurnOn;
@end

@interface SBDashBoardViewControllerBase : UIViewController
@end

@interface SBDashBoardPresentationViewController : SBDashBoardViewControllerBase
@property (nonatomic,copy,readonly) NSArray * presentedViewControllers;
@end

@interface SBDashBoardPageViewController : SBDashBoardPresentationViewController
@end

@interface SBDashBoardCombinedListViewController : SBDashBoardViewControllerBase {
	NCNotificationCombinedListViewController *_listViewController;
}
@property (nonatomic,retain) NSMutableOrderedSet * filteredNotificationRequests;
@property(readonly, nonatomic) BOOL hasContent;
@end

@interface SBDashBoardModalViewControllerBase : SBDashBoardViewControllerBase
@end

@interface SBDashBoardFullscreenNotificationViewController : SBDashBoardModalViewControllerBase
@property (nonatomic,copy,readonly) NSString * dashBoardIdentifier;
@end

@interface SBDashBoardMainPageContentViewController : SBDashBoardPageViewController
@property(readonly, nonatomic) SBDashBoardCombinedListViewController *combinedListViewController;
@end

@interface SBDashBoardPearlUnlockBehavior : NSObject
-(void)mesaUnlockTriggerFired:(id)arg1 ;
@end

@interface SBDashBoardModalPresentationViewController : SBDashBoardPresentationViewController
@end

@interface SBLockScreenViewControllerBase : UIViewController
@end

@interface SBDashBoardViewController : SBLockScreenViewControllerBase
@property(assign, nonatomic) BOOL fux_alreadyAuthenticated;
@property(nonatomic, getter=isAuthenticated) BOOL authenticated;
@property(retain, nonatomic) SBDashBoardMainPageContentViewController *mainPageContentViewController;
@property (nonatomic,retain) SBDashBoardModalPresentationViewController * modalPresentationController;
- (BOOL)isShowingMediaControls;
- (BOOL)isInScreenOffMode;
- (BOOL)biometricUnlockBehavior:(id)arg1 requestsUnlock:(id)arg2 withFeedback:(id)arg3 ;
@end

@interface SBLockScreenManager : NSObject
+ (id)sharedInstance;
- (void)tapToWakeControllerDidRecognizeWakeGesture:(id)arg1;
- (void)lockScreenViewControllerRequestsUnlock;
@end

@interface SBUIFlashlightController : NSObject

+(id)sharedInstance;

-(NSInteger)level;

@end

@interface CSCoverSheetViewControllerBase: UIViewController
@end

@interface CSPresentationViewController : CSCoverSheetViewControllerBase
@property (nonatomic,copy,readonly) NSArray * presentedViewControllers; 
@end

@interface CSCombinedListViewController : CSCoverSheetViewControllerBase
@property(readonly, nonatomic) BOOL hasContent;
@end

@interface CSModalPresentationViewController : CSPresentationViewController
@end

@interface CSPageViewController : CSPresentationViewController
@end

@interface CSMainPageContentViewController : CSPageViewController
@property(readonly, nonatomic) CSCombinedListViewController *combinedListViewController;
@end


@interface CSCoverSheetViewController : UIViewController
@property(assign, nonatomic) BOOL fux_alreadyAuthenticated;
@property(nonatomic, getter=isAuthenticated) BOOL authenticated;
@property(retain, nonatomic) CSMainPageContentViewController *mainPageContentViewController;
@property (nonatomic,retain) CSModalPresentationViewController * modalPresentationController;
- (BOOL)isShowingMediaControls;
- (BOOL)isInScreenOffMode;
- (BOOL)biometricUnlockBehavior:(id)arg1 requestsUnlock:(id)arg2 withFeedback:(id)arg3 ;
@end