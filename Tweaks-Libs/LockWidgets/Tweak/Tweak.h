#import <UIKit/UIKit.h>
#import <liblockwidgets/LockWidgetsConfig.h>
#import <liblockwidgets/LockWidgetsUtils.h>
#import <liblockwidgets/MRYIPCCenter.h>
#import "LockWidgetsManager.h"
#import "Reachability.h"

@interface LockWidgetsIPCServer : NSObject
@end

@interface CSNotificationAdjunctListViewController : UIViewController {
	UIStackView *_stackView;
}

@property (retain, nonatomic) UIStackView *stackView;

- (void)_didUpdateDisplay;
- (void)_removeItem:(id)arg1 animated:(_Bool)arg2;
- (void)_insertItem:(id)arg1 animated:(_Bool)arg2;
- (void)adjunctListModel:(id)arg1 didRemoveItem:(id)arg2;
- (void)adjunctListModel:(id)arg1 didAddItem:(id)arg2;
- (void)viewWillTransitionToSize:(struct CGSize)arg1
	   withTransitionCoordinator:(id)arg2;
- (void)viewDidLayoutSubviews;
- (void)viewWillAppear:(_Bool)arg1;
- (void)viewDidLoad;

@end

@interface SBDashBoardNotificationAdjunctListViewController : UIViewController {
	UIStackView *_stackView;
}

@property (retain, nonatomic) UIStackView *stackView;

- (void)_didUpdateDisplay;
- (void)_removeItem:(id)arg1 animated:(_Bool)arg2;
- (void)_insertItem:(id)arg1 animated:(_Bool)arg2;
- (void)adjunctListModel:(id)arg1 didRemoveItem:(id)arg2;
- (void)adjunctListModel:(id)arg1 didAddItem:(id)arg2;
- (void)viewWillTransitionToSize:(struct CGSize)arg1
	   withTransitionCoordinator:(id)arg2;
- (void)viewDidLayoutSubviews;
- (void)viewWillAppear:(_Bool)arg1;
- (void)viewDidLoad;

@end

@interface CSNotificationAdjunctListViewController (LockWidgets)
@property (retain, nonatomic) LockWidgetsView *lockWidgetsView;
- (void)refreshView;
- (void)addLockWidgetsView;
@end

@interface SBDashBoardNotificationAdjunctListViewController (LockWidgets)
@property (retain, nonatomic) LockWidgetsView *lockWidgetsView;
- (void)refreshView;
- (void)addLockWidgetsView;
@end