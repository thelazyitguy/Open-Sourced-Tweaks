#import <Preferences/PSListController.h>
#import <AppList/AppList.h>
#import "VBEVibrationManager.h"

@interface VBEAppListController : PSViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    NSDictionary *_bundles;
    ALApplicationList *_appList;
    VBEVibrationManager *_vibrationManager;
    NSArray *_sortedBundles;
}

@end