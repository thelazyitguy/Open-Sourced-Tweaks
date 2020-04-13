#import <UIKit/UIKit.h>
#import "LockWidgetsConfig.h"
#import "LockWidgetsUtils.h"
#import "substrate.h"

@interface LockWidgetsView : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *collectionViewLayout;
@property (strong, nonatomic) NSMutableArray *widgetIdentifiers;

- (void)refresh;
void locked();
void unlocked();
@end

@interface MTMaterialView : UIView
@end

@interface WGWidgetInfo : NSObject {
	NSPointerArray *_registeredWidgetHosts;
	struct {
		unsigned didInitializeWantsVisibleFrame : 1;
	} _widgetInfoFlags;
	BOOL _wantsVisibleFrame;
	NSString *_sdkVersion;
	NSExtension *_extension;
	long long _initialDisplayMode;
	long long _largestAllowedDisplayMode;
	UIImage *_icon;
	UIImage *_outlineIcon;
	NSString *_displayName;
	CGSize _preferredContentSize;
}
@property (setter=_setIcon:, getter=_icon, nonatomic, retain) UIImage *icon; //@synthesize icon=_icon - In the implementation block
@property (setter=_setOutlineIcon:, getter=_outlineIcon, nonatomic, retain) UIImage *outlineIcon; //@synthesize outlineIcon=_outlineIcon - In the implementation block
@property (assign, nonatomic) CGSize preferredContentSize; //@synthesize preferredContentSize=_preferredContentSize - In the implementation block
@property (setter=_setDisplayName:, nonatomic, copy) NSString *displayName; //@synthesize displayName=_displayName - In the implementation block
@property (getter=_sdkVersion, nonatomic, copy, readonly) NSString *sdkVersion; //@synthesize sdkVersion=_sdkVersion - In the implementation block
@property (assign, setter=_setLargestAllowedDisplayMode:, nonatomic) long long largestAllowedDisplayMode; //@synthesize largestAllowedDisplayMode=_largestAllowedDisplayMode - In the implementation block
@property (assign, setter=_setWantsVisibleFrame:, nonatomic) BOOL wantsVisibleFrame; //@synthesize wantsVisibleFrame=_wantsVisibleFrame - In the implementation block
@property (nonatomic, readonly) NSExtension *extension; //@synthesize extension=_extension - In the implementation block
@property (nonatomic, copy, readonly) NSString *widgetIdentifier;
@property (nonatomic, readonly) double initialHeight;
@property (nonatomic, readonly) long long initialDisplayMode; //@synthesize initialDisplayMode=_initialDisplayMode - In the implementation block
+ (id)_productVersion;
+ (double)maximumContentHeightForCompactDisplayMode;
+ (id)widgetInfoWithExtension:(id)arg1;
+ (void)_updateRowHeightForContentSizeCategory;
- (id)_icon;
- (NSString *)displayName;
- (id)_sdkVersion;
- (CGSize)preferredContentSize;
- (void)setPreferredContentSize:(CGSize)arg1;
- (NSExtension *)extension;
- (id)initWithExtension:(id)arg1;
- (void)_setDisplayName:(NSString *)arg1;
- (NSString *)widgetIdentifier;
- (id)_queue_iconWithSize:(CGSize)arg1 scale:(double)arg2 forWidgetWithIdentifier:(id)arg3 extension:(id)arg4;
- (id)_queue_iconWithOutlineForWidgetWithIdentifier:(id)arg1 extension:(id)arg2;
- (void)_resetIconsImpl;
- (void)_resetIcons;
- (id)widgetInfoWithExtension:(id)arg1;
- (void)_setLargestAllowedDisplayMode:(long long)arg1;
- (BOOL)isLinkedOnOrAfterSystemVersion:(id)arg1;
- (void)requestSettingsIconWithHandler:(/*^block*/ id)arg1;
- (id)_queue_iconFromWidgetBundleForWidgetWithIdentifier:(id)arg1 extension:(id)arg2;
- (void)_setIcon:(UIImage *)arg1;
- (void)_requestIcon:(BOOL)arg1 withHandler:(/*^block*/ id)arg2;
- (id)_outlineIcon;
- (void)_setOutlineIcon:(UIImage *)arg1;
- (void)requestIconWithHandler:(/*^block*/ id)arg1;
- (double)initialHeight;
- (BOOL)wantsVisibleFrame;
- (void)_setWantsVisibleFrame:(BOOL)arg1;
- (void)registerWidgetHost:(id)arg1;
- (void)updatePreferredContentSize:(CGSize)arg1 forWidgetHost:(id)arg2;
- (long long)initialDisplayMode;
- (long long)largestAllowedDisplayMode;
@end

@interface WGCalendarWidgetInfo : WGWidgetInfo {
	NSDate *_date;
}
@property (setter=_setDate:, nonatomic, retain) NSDate *date; //@synthesize date=_date - In the implementation block
+ (BOOL)isCalendarExtension:(id)arg1;
- (NSDate *)date;
- (id)initWithExtension:(id)arg1;
- (void)_setDate:(NSDate *)arg1;
- (void)_handleSignificantTimeChange:(id)arg1;
- (id)_queue_iconWithSize:(CGSize)arg1 scale:(double)arg2 forWidgetWithIdentifier:(id)arg3 extension:(id)arg4;
- (id)_queue_iconWithOutlineForWidgetWithIdentifier:(id)arg1 extension:(id)arg2;
- (void)_resetIconsImpl;
@end

@protocol WGWidgetHostingViewControllerDelegate <NSObject>

@optional
- (void)remoteViewControllerDidConnectForWidget:(id)arg1;
- (void)remoteViewControllerDidDisconnectForWidget:(id)arg1;
- (void)remoteViewControllerViewDidAppearForWidget:(id)arg1;
- (void)remoteViewControllerViewDidHideForWidget:(id)arg1;
- (void)brokenViewDidAppearForWidget:(id)arg1;
- (/*^block*/ id)widget:(id)arg1 didUpdatePreferredHeight:(double)arg2 completion:(/*^block*/ id)arg3;
- (void)contentAvailabilityDidChangeForWidget:(id)arg1;
- (void)widget:(id)arg1 didChangeLargestSupportedDisplayMode:(long long)arg2;
- (BOOL)shouldRequestWidgetRemoteViewControllers;
- (long long)activeLayoutModeForWidget:(id)arg1;
- (UIEdgeInsets *)marginInsetsForWidget:(id)arg1;
- (UIEdgeInsets *)layoutMarginForWidget:(id)arg1;
- (BOOL)managingContainerIsVisibleForWidget:(id)arg1;
- (CGRect *)visibleFrameForWidget:(id)arg1;
@required
- (CGSize *)maxSizeForWidget:(id)arg1 forDisplayMode:(long long)arg2;
- (void)registerWidgetForRefreshEvents:(id)arg1;
- (void)unregisterWidgetForRefreshEvents:(id)arg1;
@end

@protocol WGWidgetHostingViewControllerHost <NSObject>

@optional
- (long long)userSpecifiedDisplayModeForWidget:(id)arg1;
- (void)widget:(id)arg1 didChangeUserSpecifiedDisplayMode:(long long)arg2;
- (long long)largestAvailableDisplayModeForWidget:(id)arg1;
- (void)widget:(id)arg1 didChangeLargestAvailableDisplayMode:(long long)arg2;
- (void)widget:(id)arg1 didEncounterProblematicSnapshotAtURL:(id)arg2;
- (void)widget:(id)arg1 didRemoveSnapshotAtURL:(id)arg2;
- (BOOL)shouldPurgeArchivedSnapshotsForWidget:(id)arg1;
- (BOOL)shouldPurgeNonCAMLSnapshotsForWidget:(id)arg1;
- (BOOL)shouldPurgeNonASTCSnapshotsForWidget:(id)arg1;
- (BOOL)shouldRemoveSnapshotWhenNotVisibleForWidget:(id)arg1;
@end

@interface WGWidgetLifeCycleSequence : NSObject {
	long long _currentState;
	NSString *_sequenceIdentifier;
	WGWidgetLifeCycleSequence *_previousSequence;
}
@property (assign, setter=_setCurrentState:, nonatomic) long long currentState; //@synthesize currentState=_currentState - In the implementation block
@property (setter=_setPreviousSequence:, getter=_previousSequence, nonatomic, retain) WGWidgetLifeCycleSequence *previousSequence; //@synthesize previousSequence=_previousSequence - In the implementation block
@property (nonatomic, copy, readonly) NSString *sequenceIdentifier; //@synthesize sequenceIdentifier=_sequenceIdentifier - In the implementation block
- (id)description;
- (long long)currentState;
- (id)transitionToState:(long long)arg1;
- (BOOL)isCurrentStateAtLeast:(long long)arg1;
- (id)initWithSequenceIdentifier:(id)arg1;
- (void)_setPreviousSequence:(WGWidgetLifeCycleSequence *)arg1;
- (NSString *)sequenceIdentifier;
- (void)_setCurrentState:(long long)arg1;
- (BOOL)isCurrentState:(long long)arg1;
- (BOOL)_isValidTransitionToState:(long long)arg1;
- (/*^block*/ id)beginTransitionToState:(long long)arg1 error:(id *)arg2;
- (id)sequenceWithIdentifier:(id)arg1;
- (BOOL)isCurrentStateNotYet:(long long)arg1;
- (BOOL)isCurrentStateAtMost:(long long)arg1;
- (id)_previousSequence;
@end

@class WGWidgetHostingViewController;

@interface _WGWidgetRemoteViewController : UIViewController {
	BOOL _valid;
	WGWidgetHostingViewController *_managingHost;
}
@property (assign, setter=_setValid:, getter=_isValid, nonatomic) BOOL valid; //@synthesize valid=_valid - In the implementation block
@property (assign, nonatomic) WGWidgetHostingViewController *managingHost; //@synthesize managingHost=_managingHost - In the implementation block
+ (id)exportedInterface;
+ (id)serviceViewControllerInterface;
- (void)dealloc;
- (id)disconnect;
- (id)initWithNibName:(id)arg1 bundle:(id)arg2;
- (BOOL)_isValid;
- (BOOL)_canShowWhileLocked;
- (void)viewServiceDidTerminateWithError:(id)arg1;
- (BOOL)__shouldRemoteViewControllerFenceOperations;
- (BOOL)_serviceHasScrollToTopView;
- (void)__viewServiceDidRegisterScrollToTopView;
- (void)__viewServiceDidUnregisterScrollToTopView;
- (void)_setValid:(BOOL)arg1;
- (void)__requestPreferredViewHeight:(double)arg1;
- (void)__closeTransactionForAppearanceCallWithState:(int)arg1 withIdentifier:(id)arg2;
- (void)__setLargestAvailableDisplayMode:(long long)arg1;
- (void)_setActiveDisplayMode:(long long)arg1;
- (void)_setMaximumSize:(CGSize)arg1 forDisplayMode:(long long)arg2;
- (void)_openTransactionForAppearanceCallWithState:(int)arg1 withIdentifier:(id)arg2;
- (void)setManagingHost:(WGWidgetHostingViewController *)arg1;
- (void)_performUpdateWithReplyHandler:(/*^block*/ id)arg1;
- (void)_requestEncodedLayerTreeAtURL:(id)arg1 withReplyHandler:(/*^block*/ id)arg2;
- (void)_updateVisibilityState:(long long)arg1;
- (void)_updateLayoutMargins:(UIEdgeInsets)arg1;
- (void)_updateVisibleFrame:(CGRect)arg1 withReplyHandler:(/*^block*/ id)arg2;
- (WGWidgetHostingViewController *)managingHost;
@end

@interface WGWidgetHostingViewController : UIViewController {
	BOOL _implementsPerformUpdate;
	BOOL _lockedOut;
	BOOL _disconnectsImmediately;
	BOOL _encodingLayerTree;
	BOOL _didRequestViewInset;
	BOOL _didUpdate;
	BOOL _blacklisted;
	BOOL _ignoringParentAppearState;
	WGWidgetInfo *_widgetInfo;
	id<WGWidgetHostingViewControllerDelegate> _delegate;
	id<WGWidgetHostingViewControllerHost> _host;
	long long _activeDisplayMode;
	double _cornerRadius;
	unsigned long long _maskedCorners;
	NSString *_appBundleID;
	WGWidgetLifeCycleSequence *_activeLifeCycleSequence;
	long long _connectionState;
	_WGWidgetRemoteViewController *_remoteViewController;
	id<NSCopying> _extensionRequest;
	UIView *_contentProvidingView;
	NSTimer *_disconnectionTimer;
	/*^block*/ id _remoteViewControllerConnectionHandler;
	/*^block*/ id _remoteViewControllerDisconnectionHandler;
	NSDate *_lastUnanticipatedDisconnectionDate;
	NSMapTable *_openAppearanceTransactions;
	NSMutableDictionary *_sequenceIDsToOutstandingWidgetUpdateCompletionHandlers;
	CGRect _snapshotViewBounds;
}
@property (nonatomic, copy) NSString *appBundleID; //@synthesize appBundleID=_appBundleID - In the implementation block
@property (getter=_containerIdentifier, nonatomic, copy, readonly) NSString *containerIdentifier;
@property (getter=_activeLifeCycleSequence, nonatomic, readonly) WGWidgetLifeCycleSequence *activeLifeCycleSequence; //@synthesize activeLifeCycleSequence=_activeLifeCycleSequence - In the implementation block
@property (assign, setter=_setConnectionState:, getter=_connectionState, nonatomic) long long connectionState; //@synthesize connectionState=_connectionState - In the implementation block
@property (setter=_setRemoteViewController:, getter=_remoteViewController, nonatomic, retain) _WGWidgetRemoteViewController *remoteViewController; //@synthesize remoteViewController=_remoteViewController - In the implementation block
@property (setter=_setExtensionRequest:, getter=_extensionRequest, nonatomic, copy) id<NSCopying> extensionRequest; //@synthesize extensionRequest=_extensionRequest - In the implementation block
@property (setter=_setContentProvidingView:, getter=_contentProvidingView, nonatomic, retain) UIView *contentProvidingView; //@synthesize contentProvidingView=_contentProvidingView - In the implementation block
@property (assign, setter=_setSnapshotBounds:, getter=_snapshotViewBounds, nonatomic) CGRect snapshotViewBounds; //@synthesize snapshotViewBounds=_snapshotViewBounds - In the implementation block
@property (assign, setter=_setEncodingLayerTree:, getter=_isEncodingLayerTree, nonatomic) BOOL encodingLayerTree; //@synthesize encodingLayerTree=_encodingLayerTree - In the implementation block
@property (assign, setter=_setDidRequestViewInset:, getter=_didRequestViewInset, nonatomic) BOOL didRequestViewInset; //@synthesize didRequestViewInset=_didRequestViewInset - In the implementation block
@property (assign, setter=_setDisconnectionTimer:, getter=_disconnectionTimer, nonatomic) NSTimer *disconnectionTimer; //@synthesize disconnectionTimer=_disconnectionTimer - In the implementation block
@property (setter=_setRemoteViewControllerConnectionHandler:, getter=_remoteViewControllerConnectionHandler, nonatomic, copy) id remoteViewControllerConnectionHandler; //@synthesize remoteViewControllerConnectionHandler=_remoteViewControllerConnectionHandler - In the implementation block
@property (setter=_setRemoteViewControllerDisconnectionHandler:, getter=_remoteViewControllerDisconnectionHandler, nonatomic, copy) id remoteViewControllerDisconnectionHandler; //@synthesize remoteViewControllerDisconnectionHandler=_remoteViewControllerDisconnectionHandler - In the implementation block
@property (setter=_setLastUnanticipatedDisconnectionDate:, getter=_lastUnanticipatedDisconnectionDate, nonatomic, retain) NSDate *lastUnanticipatedDisconnectionDate; //@synthesize lastUnanticipatedDisconnectionDate=_lastUnanticipatedDisconnectionDate - In the implementation block
@property (getter=_openAppearanceTransactions, nonatomic, readonly) NSMapTable *openAppearanceTransactions; //@synthesize openAppearanceTransactions=_openAppearanceTransactions - In the implementation block
@property (assign, setter=_setDidUpdate:, getter=_didUpdate, nonatomic) BOOL didUpdate; //@synthesize didUpdate=_didUpdate - In the implementation block
@property (assign, setter=_setImplementsPerformUpdate:, nonatomic) BOOL implementsPerformUpdate; //@synthesize implementsPerformUpdate=_implementsPerformUpdate - In the implementation block
@property (assign, setter=_setBlacklisted:, getter=_isBlacklisted, nonatomic) BOOL blacklisted; //@synthesize blacklisted=_blacklisted - In the implementation block
@property (setter=_setSequenceIDsToOutstandingWidgetUpdateCompletionHandlers:, getter=_sequenceIDsToOutstandingWidgetUpdateCompletionHandlers, nonatomic, retain) NSMutableDictionary *sequenceIDsToOutstandingWidgetUpdateCompletionHandlers; //@synthesize sequenceIDsToOutstandingWidgetUpdateCompletionHandlers=_sequenceIDsToOutstandingWidgetUpdateCompletionHandlers - In the implementation block
@property (assign, setter=_setIgnoringParentAppearState:, getter=_isIgnoringParentAppearState, nonatomic) BOOL ignoringParentAppearState; //@synthesize ignoringParentAppearState=_ignoringParentAppearState - In the implementation block
@property (nonatomic, readonly) WGWidgetInfo *widgetInfo; //@synthesize widgetInfo=_widgetInfo - In the implementation block
@property (nonatomic, copy, readonly) NSString *widgetIdentifier;
@property (nonatomic, copy, readonly) NSString *displayName;
@property (assign, nonatomic) id<WGWidgetHostingViewControllerDelegate> delegate; //@synthesize delegate=_delegate - In the implementation block
@property (assign, nonatomic) id<WGWidgetHostingViewControllerHost> host; //@synthesize host=_host - In the implementation block
@property (nonatomic, readonly) long long largestAvailableDisplayMode;
@property (nonatomic, readonly) long long activeDisplayMode; //@synthesize activeDisplayMode=_activeDisplayMode - In the implementation block
@property (assign, nonatomic) long long userSpecifiedDisplayMode;
@property (getter=isRemoteViewVisible, nonatomic, readonly) BOOL remoteViewVisible;
@property (getter=isSnapshotLoaded, nonatomic, readonly) BOOL snapshotLoaded;
@property (getter=isBrokenViewVisible, nonatomic, readonly) BOOL brokenViewVisible;
@property (getter=isLockedOut, nonatomic, readonly) BOOL lockedOut; //@synthesize lockedOut=_lockedOut - In the implementation block
@property (assign, nonatomic) double cornerRadius; //@synthesize cornerRadius=_cornerRadius - In the implementation block
@property (assign, nonatomic) unsigned long long maskedCorners; //@synthesize maskedCorners=_maskedCorners - In the implementation block
@property (assign, nonatomic) BOOL disconnectsImmediately; //@synthesize disconnectsImmediately=_disconnectsImmediately - In the implementation block
+ (void)setWidgetSnapshotTimestampsEnabled:(BOOL)arg1;
+ (BOOL)_canWidgetHostConnectRemoteViewControllerByRequestingForSequence:(id)arg1 disconnectionTimer:(id)arg2 connectionState:(long long)arg3;
+ (BOOL)_canWidgetHostConnectRemoteViewControllerByCancellingDisappearanceForSequence:(id)arg1;
+ (BOOL)_canWidgetHostRequestRemoteViewControllerForSequence:(id)arg1;
+ (BOOL)_canWidgetHostCaptureSnapshotForSequence:(id)arg1;
+ (BOOL)_canWidgetHostInsertRemoteViewForSequence:(id)arg1;
+ (BOOL)_canWidgetHostEndSequenceByDisconnectingRemoteViewControllerForSequence:(id)arg1;
+ (BOOL)_canWidgetHostDisconnectRemoteViewControllerForSequence:(id)arg1 disconnectionTimer:(id)arg2 coalesce:(BOOL)arg3;
- (void)dealloc;
- (id)description;
- (id<WGWidgetHostingViewControllerDelegate>)delegate;
- (void)setDelegate:(id<WGWidgetHostingViewControllerDelegate>)arg1;
- (id<WGWidgetHostingViewControllerHost>)host;
- (NSString *)appBundleID;
- (void)setHost:(id<WGWidgetHostingViewControllerHost>)arg1;
- (NSString *)displayName;
- (id)_containerIdentifier;
- (long long)_connectionState;
- (void)setCornerRadius:(double)arg1;
- (void)traitCollectionDidChange:(id)arg1;
- (void)viewWillAppear:(BOOL)arg1;
- (void)viewWillDisappear:(BOOL)arg1;
- (void)setMaskedCorners:(unsigned long long)arg1;
- (void)viewDidLoad;
- (void)setPreferredContentSize:(CGSize)arg1;
- (void)viewDidAppear:(BOOL)arg1;
- (void)viewDidDisappear:(BOOL)arg1;
- (double)cornerRadius;
- (UIEdgeInsets)_layoutMargins;
- (id)_cancelTouches;
- (id)_snapshotView;
- (BOOL)shouldAutomaticallyForwardAppearanceMethods;
- (BOOL)_canShowWhileLocked;
- (id)_remoteViewController;
- (unsigned long long)maskedCorners;
- (void)setAppBundleID:(NSString *)arg1;
- (UIEdgeInsets)_marginInsets;
- (BOOL)isLockedOut;
- (NSString *)widgetIdentifier;
- (void)_setLargestAvailableDisplayMode:(long long)arg1;
- (BOOL)_isBlacklisted;
- (id)_diskWriteQueue;
- (id)initWithWidgetInfo:(id)arg1 delegate:(id)arg2 host:(id)arg3;
- (WGWidgetInfo *)widgetInfo;
- (BOOL)isRemoteViewVisible;
- (BOOL)isSnapshotLoaded;
- (void)setLockedOut:(BOOL)arg1 withExplanation:(id)arg2;
- (void)invalidateCachedSnapshotWithCompletionHandler:(/*^block*/ id)arg1;
- (void)invalidateCachedSnapshotWithURL:(id)arg1 completionHandler:(/*^block*/ id)arg2;
- (void)_updateWidgetWithCompletionHandler:(/*^block*/ id)arg1;
- (BOOL)isLinkedOnOrAfterSystemVersion:(id)arg1;
- (void)requestSettingsIconWithHandler:(/*^block*/ id)arg1;
- (void)requestIconWithHandler:(/*^block*/ id)arg1;
- (void)setUserSpecifiedDisplayMode:(long long)arg1;
- (long long)userSpecifiedDisplayMode;
- (long long)largestAvailableDisplayMode;
- (void)managingContainerWillAppear:(id)arg1;
- (BOOL)isBrokenViewVisible;
- (long long)activeDisplayMode;
- (void)managingContainerDidDisappear:(id)arg1;
- (void)maximumSizeDidChangeForDisplayMode:(long long)arg1;
- (void)_invalidateVisibleFrame;
- (void)setDisconnectsImmediately:(BOOL)arg1;
- (void)_removeItemAsynchronouslyAtURL:(id)arg1;
- (void)_removeAllSnapshotFilesDueToIssue:(BOOL)arg1;
- (void)_updatePreferredContentSizeWithHeight:(double)arg1;
- (void)_purgeLegacySnapshotsIfNecessary;
- (BOOL)_shouldRemoveSnapshotWhenNotVisible;
- (BOOL)_isActiveSequence:(id)arg1;
- (void)_insertSnapshotWithCompletionHandler:(/*^block*/ id)arg1;
- (void)_synchronizeGeometryWithSnapshot;
- (void)_loadSnapshotViewFromDiskIfNecessary:(/*^block*/ id)arg1;
- (CGSize)_maxSizeForDisplayMode:(long long)arg1;
- (void)_rowHeightDidChange:(id)arg1;
- (id)_activeLifeCycleSequence;
- (void)_enqueueRemoteServiceRequest:(/*^block*/ id)arg1 withDescription:(id)arg2;
- (void)setActiveDisplayMode:(long long)arg1;
- (void)_invalidateSnapshotWithForce:(BOOL)arg1 removingSnapshotFilesForActiveDisplayMode:(BOOL)arg2 completionHandler:(/*^block*/ id)arg3;
- (id)_widgetSnapshotURLForSnapshotIdentifier:(id)arg1 ensuringDirectoryExists:(BOOL)arg2;
- (void)_insertLockedOutViewWithExplanation:(id)arg1;
- (void)_endSequence:(id)arg1 withReason:(id)arg2 completion:(/*^block*/ id)arg3;
- (void)_endRemoteViewControllerAppearanceTransitionIfNecessary;
- (id)_lockedOutView;
- (void)_setLockedOutView:(id)arg1;
- (void)_beginSequenceWithReason:(id)arg1 completion:(/*^block*/ id)arg2 updateHandler:(/*^block*/ id)arg3;
- (id)_openAppearanceTransactions;
- (void)_endRemoteViewControllerAppearanceTransitionIfNecessaryWithCompletion:(/*^block*/ id)arg1;
- (void)_validateSnapshotViewForActiveLayoutMode;
- (void)_insertSnapshotViewIfAppropriate;
- (void)_requestVisibilityStateUpdateForPossiblyAppearing:(BOOL)arg1 sequence:(id)arg2;
- (id)_contentProvidingView;
- (void)_insertContentProvidingSubview:(id)arg1 sequence:(id)arg2 completion:(/*^block*/ id)arg3;
- (void)_insertAppropriateContentView;
- (void)_removeAllSnapshotFilesInActiveDisplayModeForContentSizeCategory:(id)arg1;
- (void)_layoutMarginsDidChange;
- (void)_removeAllSnapshotFilesInActiveDisplayModeForAllButActiveUserInterfaceStyle;
- (id)_proxyRequestQueue;
- (void)_enqueueRequest:(/*^block*/ id)arg1 inQueue:(id)arg2 trampolinedToMainQueue:(BOOL)arg3 withDescription:(id)arg4;
- (void)_initiateNewSequenceIfNecessary;
- (void)_noteOutstandingUpdateRequestForSequence:(id)arg1;
- (/*^block*/ id)_updateRequestForSequence:(id)arg1;
- (void)_registerUpdateRequestCompletionHandler:(/*^block*/ id)arg1 forSequence:(id)arg2;
- (void)_performUpdateForSequence:(id)arg1 withCompletionHandler:(/*^block*/ id)arg2;
- (void)_requestInsertionOfRemoteViewAfterViewWillAppearForSequence:(id)arg1 completionHandler:(/*^block*/ id)arg2;
- (void)_abortActiveSequence;
- (void)_connectRemoteViewControllerForReason:(id)arg1 sequence:(id)arg2 completionHandler:(/*^block*/ id)arg3;
- (void)_requestRemoteViewControllerForSequence:(id)arg1 completionHander:(/*^block*/ id)arg2;
- (void)_invalidateDisconnectionTimer;
- (/*^block*/ id)_remoteViewControllerConnectionHandler;
- (void)_setRemoteViewControllerConnectionHandler:(/*^block*/ id)arg1;
- (void)_setConnectionState:(long long)arg1;
- (void)_setExtensionRequest:(id<NSCopying>)arg1;
- (void)_finishDisconnectingRemoteViewControllerForSequence:(id)arg1 error:(id)arg2 completion:(/*^block*/ id)arg3;
- (id)_proxyConnectionQueue;
- (id)_extensionRequest;
- (void)_setRemoteViewController:(_WGWidgetRemoteViewController *)arg1;
- (BOOL)implementsPerformUpdate;
- (BOOL)_didUpdate;
- (void)_setDidUpdate:(BOOL)arg1;
- (void)_setImplementsPerformUpdate:(BOOL)arg1;
- (void)_setIgnoringParentAppearState:(BOOL)arg1;
- (id)_viewWillDisappearSemaphore;
- (void)_setViewWillDisappearSemaphore:(id)arg1;
- (void)_removeAllSnapshotFilesForActiveDisplayMode;
- (void)_setSnapshotView:(id)arg1;
- (void)_packageViewFromURL:(id)arg1 reply:(/*^block*/ id)arg2;
- (void)_captureLayerTree:(/*^block*/ id)arg1;
- (void)_beginRemoteViewControllerAppearanceTransitionIfNecessary:(BOOL)arg1 semaphore:(id)arg2 animated:(BOOL)arg3 completion:(/*^block*/ id)arg4;
- (id)_snapshotIdentifierForLayoutMode:(long long)arg1;
- (void)_removeItemAtURL:(id)arg1;
- (void)_removeAllSnapshotFilesMatchingPredicate:(id)arg1 dueToIssue:(BOOL)arg2;
- (BOOL)_isEncodingLayerTree;
- (void)_setEncodingLayerTree:(BOOL)arg1;
- (id)_widgetSnapshotURLForLayoutMode:(long long)arg1 ensuringDirectoryExists:(BOOL)arg2;
- (void)_packageViewWithBlock:(/*^block*/ id)arg1 reply:(/*^block*/ id)arg2;
- (void)_setContentProvidingView:(UIView *)arg1;
- (void)_setViewWillAppearSemaphore:(id)arg1;
- (id)_viewWillAppearSemaphore;
- (BOOL)_canInsertRemoteView:(id *)arg1;
- (CGRect)_snapshotViewBounds;
- (BOOL)_managingContainerIsVisible;
- (BOOL)disconnectsImmediately;
- (void)_disconnectRemoteViewControllerForReason:(id)arg1 sequence:(id)arg2 coalesce:(BOOL)arg3 completionHandler:(/*^block*/ id)arg4;
- (void)_captureSnapshotAndBeginDisappearanceTransitionForSequence:(id)arg1 completionHandler:(/*^block*/ id)arg2;
- (BOOL)_hasOutstandingUpdateRequestForSequence:(id)arg1;
- (void)_scheduleDisconnectionTimerForSequence:(id)arg1 endTransitionBlock:(/*^block*/ id)arg2 completion:(/*^block*/ id)arg3;
- (void)_enqueueDisconnectionRequestForSequence:(id)arg1 endTransitionBlock:(/*^block*/ id)arg2 completion:(/*^block*/ id)arg3;
- (void)_disconnectRemoteViewControllerForSequence:(id)arg1 completion:(/*^block*/ id)arg2;
- (void)_setRemoteViewControllerDisconnectionHandler:(/*^block*/ id)arg1;
- (void)widget:(id)arg1 didTerminateWithError:(id)arg2;
- (void)_attemptReconnectionAfterUnanticipatedDisconnection;
- (void)_disconnectionTimerDidFire:(id)arg1;
- (void)_setBlacklisted:(BOOL)arg1;
- (void)_insertBrokenView;
- (void)_setLastUnanticipatedDisconnectionDate:(NSDate *)arg1;
- (id)_brokenView;
- (void)_setBrokenView:(id)arg1;
- (void)handleReconnectionRequest:(id)arg1;
- (/*^block*/ id)_remoteViewControllerDisconnectionHandler;
- (void)_setupRequestQueue;
- (id)_widgetSnapshotURLForSnapshotIdentifier:(id)arg1;
- (void)_setSnapshotBounds:(CGRect)arg1;
- (BOOL)_didRequestViewInset;
- (void)_setDidRequestViewInset:(BOOL)arg1;
- (id)_disconnectionTimer;
- (void)_setDisconnectionTimer:(NSTimer *)arg1;
- (id)_lastUnanticipatedDisconnectionDate;
- (id)_sequenceIDsToOutstandingWidgetUpdateCompletionHandlers;
- (void)_setSequenceIDsToOutstandingWidgetUpdateCompletionHandlers:(NSMutableDictionary *)arg1;
- (BOOL)_isIgnoringParentAppearState;
@end

@interface WGWidgetPlatterView : UIView {
	MTMaterialView *_backgroundView;
	MTMaterialView *_headerBackgroundView;
	double _cornerRadius;
	BOOL _adjustsFontForContentSizeCategory;
	BOOL _contentViewHitTestingDisabled;
	BOOL _backgroundHidden;
	BOOL _showingMoreContent;
	NSString *_materialGroupNameBase;
	WGWidgetHostingViewController *_widgetHost;
	UIView *_contentView;
	unsigned long long _clippingEdge;
	double _overrideHeightForLayingOutContentView;
	double _topMarginForLayout;
	long long _buttonMode;
}
@property (setter=_setContentView:, nonatomic, retain) UIView *contentView; //@synthesize contentView=_contentView - In the implementation block
@property (assign, nonatomic) WGWidgetHostingViewController *widgetHost; //@synthesize widgetHost=_widgetHost - In the implementation block
@property (assign, getter=isContentViewHitTestingDisabled, nonatomic) BOOL contentViewHitTestingDisabled; //@synthesize contentViewHitTestingDisabled=_contentViewHitTestingDisabled - In the implementation block
@property (assign, nonatomic) unsigned long long clippingEdge; //@synthesize clippingEdge=_clippingEdge - In the implementation block
@property (assign, getter=isBackgroundHidden, nonatomic) BOOL backgroundHidden; //@synthesize backgroundHidden=_backgroundHidden - In the implementation block
@property (assign, nonatomic) double overrideHeightForLayingOutContentView; //@synthesize overrideHeightForLayingOutContentView=_overrideHeightForLayingOutContentView - In the implementation block
@property (assign, nonatomic) double topMarginForLayout; //@synthesize topMarginForLayout=_topMarginForLayout - In the implementation block
@property (assign, nonatomic) long long buttonMode; //@synthesize buttonMode=_buttonMode - In the implementation block
@property (nonatomic, readonly) UIButton *showMoreButton;
@property (assign, getter=isShowingMoreContent, nonatomic) BOOL showingMoreContent; //@synthesize showingMoreContent=_showingMoreContent - In the implementation block
@property (assign, getter=isShowMoreButtonVisible, nonatomic) BOOL showMoreButtonVisible;
@property (nonatomic, readonly) UIButton *addWidgetButton;
@property (assign, getter=isAddWidgetButtonVisible, nonatomic) BOOL addWidgetButtonVisible;
@property (readonly) unsigned long long hash;
@property (readonly) Class superclass;
@property (copy, readonly) NSString *description;
@property (copy, readonly) NSString *debugDescription;
@property (assign, nonatomic) BOOL adjustsFontForContentSizeCategory; //@synthesize adjustsFontForContentSizeCategory=_adjustsFontForContentSizeCategory - In the implementation block
@property (nonatomic, copy) NSString *preferredContentSizeCategory;
@property (nonatomic, copy) NSString *materialGroupNameBase; //@synthesize materialGroupNameBase=_materialGroupNameBase - In the implementation block
@property (nonatomic, copy, readonly) NSArray *requiredVisualStyleCategories;
+ (double)contentBaselineToBoundsBottomWithWidth:(double)arg1;
- (CGSize)_contentSize;
- (UIView *)contentView;
- (CGSize)intrinsicContentSize;
- (id)initWithFrame:(CGRect)arg1;
- (CGSize)sizeThatFits:(CGSize)arg1;
- (void)layoutSubviews;
- (void)_setContinuousCornerRadius:(double)arg1;
- (double)_continuousCornerRadius;
- (void)willRemoveSubview:(id)arg1;
- (void)setAdjustsFontForContentSizeCategory:(BOOL)arg1;
- (void)_setContentView:(UIView *)arg1;
- (BOOL)adjustsFontForContentSizeCategory;
- (id)visualStylingProviderForCategory:(long long)arg1;
- (long long)buttonMode;
- (void)setButtonMode:(long long)arg1;
- (WGWidgetHostingViewController *)widgetHost;
- (void)setWidgetHost:(WGWidgetHostingViewController *)arg1;
- (void)_layoutContentView;
- (void)setBackgroundHidden:(BOOL)arg1;
- (void)setAddWidgetButtonVisible:(BOOL)arg1;
- (UIButton *)addWidgetButton;
- (NSArray *)requiredVisualStyleCategories;
- (void)setVisualStylingProvider:(id)arg1 forCategory:(long long)arg2;
- (void)setTopMarginForLayout:(double)arg1;
- (double)topMarginForLayout;
- (void)_handleIconButton:(id)arg1;
- (void)_updateUtilityButtonForMode:(long long)arg1;
- (CGSize)sizeThatFitsContentWithSize:(CGSize)arg1;
- (void)_configureHeaderViewsIfNecessary;
- (BOOL)_isUtilityButtonVisible;
- (void)_setUtilityButtonVisible:(BOOL)arg1;
- (void)_updateUtilityButtonForMoreContentState:(BOOL)arg1;
- (void)_configureBackgroundMaterialViewIfNecessary;
- (void)_layoutHeaderViews;
- (UIButton *)showMoreButton;
- (void)_updateShowMoreButtonImage;
- (BOOL)adjustForContentSizeCategoryChange;
- (void)_updateHeaderContentViewVisualStyling;
- (CGRect)_headerFrameForBounds:(CGRect)arg1;
- (void)setShowingMoreContent:(BOOL)arg1;
- (void)_handleAddWidget:(id)arg1;
- (void)_toggleShowMore:(id)arg1;
- (void)setShowMoreButtonVisible:(BOOL)arg1;
- (BOOL)isShowingMoreContent;
- (CGSize)contentSizeForSize:(CGSize)arg1;
- (NSString *)materialGroupNameBase;
- (void)setMaterialGroupNameBase:(NSString *)arg1;
- (CGSize)minimumSizeThatFits:(CGSize)arg1;
- (void)setContentViewHitTestingDisabled:(BOOL)arg1;
- (void)setClippingEdge:(unsigned long long)arg1;
- (BOOL)isShowMoreButtonVisible;
- (BOOL)isAddWidgetButtonVisible;
- (void)setOverrideHeightForLayingOutContentView:(double)arg1;
- (void)iconDidInvalidate:(id)arg1;
- (BOOL)isContentViewHitTestingDisabled;
- (unsigned long long)clippingEdge;
- (BOOL)isBackgroundHidden;
- (double)overrideHeightForLayingOutContentView;
@end