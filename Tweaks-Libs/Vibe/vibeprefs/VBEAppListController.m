#import "VBEAppListController.h"
#import <AppList/ALApplicationList.h>
#import "TKVibrationPickerViewController.h"
#import "VBEVibrationManager.h"

@implementation VBEAppListController

//Credit to Nepeta - their Relocate source code showed me how to do most of this

- (id)initForContentSize:(CGSize)size {
    self = [super init];
    
    if(self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) style:UITableViewStylePlain];

        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setEditing:NO];
        [_tableView setAllowsSelection:YES];
        [_tableView setAllowsMultipleSelection:NO];

        _appList = [ALApplicationList sharedApplicationList];
        _bundles = [_appList applicationsFilteredUsingPredicate:[NSPredicate predicateWithFormat:@"isSystemApplication = NO"] onlyVisible:YES titleSortedIdentifiers:nil];
        _sortedBundles = [[_bundles allKeys] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = [_bundles objectForKey:a];
            NSString *second = [_bundles objectForKey:b];
            return [first caseInsensitiveCompare:second];
        }];
        _vibrationManager = [[VBEVibrationManager alloc] init];

        if([self respondsToSelector:@selector(setView:)])
            [self performSelectorOnMainThread:@selector(setView:) withObject:_tableView waitUntilDone:YES];

        [self setTitle:@"Choose application"];
        [[self navigationItem] setTitle:@"Choose application"];
    
    }

    return self;
}

- (id)view {
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return [[_bundles allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    NSString *bundleIdentifier = _sortedBundles[indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = _bundles[bundleIdentifier];
    cell.indentationWidth = 10.0f;
    cell.indentationLevel = 0;

    cell.imageView.image = [_appList iconOfSize:ALApplicationIconSizeSmall forDisplayIdentifier:bundleIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *bundleIdentifier = _sortedBundles[indexPath.row];
    if(!bundleIdentifier)
        return;

    TKVibrationPickerViewController *controller = (TKVibrationPickerViewController *)[[NSClassFromString(@"TKVibrationPickerViewController") alloc] init];
    [controller setDelegate:_vibrationManager];
    [_vibrationManager setCurrentBundle:bundleIdentifier];
    [controller setDefaultVibrationIdentifier:@"Quick"];
    [controller setSelectedVibrationIdentifier:[_vibrationManager vibrationIdentifierForBundle:bundleIdentifier]];
    [controller setTitle:[NSString stringWithFormat:@"Vibration (%@)", _bundles[bundleIdentifier]]];

    [[self navigationController] pushViewController:controller animated:YES];
}

@end
