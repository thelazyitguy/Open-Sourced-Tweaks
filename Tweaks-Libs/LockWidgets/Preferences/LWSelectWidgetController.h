#import <UIKit/UIKit.h>
#import <liblockwidgets/LockWidgetsConfig.h>
#import <liblockwidgets/MRYIPCCenter.h>

@interface LWSelectWidgetController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *availableWidgets;
@property (strong, nonatomic) NSMutableArray *selectedWidgets;
@property (strong, nonatomic) NSArray *allWidgets;
@property (strong, nonatomic) NSMutableDictionary *displayNames;

@end