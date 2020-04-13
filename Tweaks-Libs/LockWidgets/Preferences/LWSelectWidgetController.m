#import "LWSelectWidgetController.h"

static MRYIPCCenter *center;

@implementation LWSelectWidgetController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.navigationItem.title = @"Select Widgets";

	// Load IPC Center
	center = [MRYIPCCenter centerNamed:@"me.conorthedev.lockwidgetsipcserver"];

	// Load data
	NSArray *result = [center callExternalMethod:@selector(getAllIdentifiers:) withArguments:@{}];
	NSMutableArray *mutableResult = [result mutableCopy];
	[mutableResult removeObjectsInArray:[LockWidgetsConfig sharedInstance].selectedWidgets];

	// Save data to variables
	self.availableWidgets = mutableResult;
	self.selectedWidgets = [[LockWidgetsConfig sharedInstance].selectedWidgets mutableCopy];
	self.allWidgets = [self.availableWidgets arrayByAddingObjectsFromArray:self.selectedWidgets];
	self.displayNames = [center callExternalMethod:@selector(getWidgetNamesForIdentifiers:) withArguments:@{@"identifiers" : self.allWidgets}];

	// Setup tableview
	self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;

	[self.tableView setEditing:YES animated:NO];
	[self.view addSubview:self.tableView];
}

- (void)save {
	[LockWidgetsConfig sharedInstance].selectedWidgets = self.selectedWidgets;
	[[LockWidgetsConfig sharedInstance] writeValue:self.selectedWidgets forKey:@"selectedWidgets"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return @"Selected Widgets";
	} else {
		return @"Available Widgets";
	}
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return [self.selectedWidgets count];
	} else {
		return [self.availableWidgets count];
	}
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		static NSString *cellIdentifier = @"SelectedWidgetCell";

		UITableViewCell *cell = (UITableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		}

		cell.textLabel.text = self.displayNames[self.selectedWidgets[indexPath.row]][@"name"];
		if (self.displayNames[self.selectedWidgets[indexPath.row]][@"image"]) {
			cell.imageView.image = [self rescaleImage:[UIImage imageWithData:self.displayNames[self.selectedWidgets[indexPath.row]][@"image"]] scaledToSize:CGSizeMake(30, 30)];
			cell.imageView.layer.cornerRadius = 7;
			cell.imageView.clipsToBounds = YES;
		} else {
			cell.imageView.image = [self rescaleImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LockWidgetsPreferences.bundle/icon@3x.png"] scaledToSize:CGSizeMake(30, 30)];
			cell.imageView.layer.cornerRadius = 7;
			cell.imageView.clipsToBounds = YES;
		}

		return cell;
	} else {
		static NSString *cellIdentifier = @"WidgetCell";

		UITableViewCell *cell = (UITableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		}

		cell.textLabel.text = self.displayNames[self.availableWidgets[indexPath.row]][@"name"];
		if (self.displayNames[self.availableWidgets[indexPath.row]][@"image"]) {
			cell.imageView.image = [self rescaleImage:[UIImage imageWithData:self.displayNames[self.availableWidgets[indexPath.row]][@"image"]] scaledToSize:CGSizeMake(30, 30)];
			cell.imageView.layer.cornerRadius = 7;
			cell.imageView.clipsToBounds = YES;
		} else {
			cell.imageView.image = [self rescaleImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LockWidgetsPreferences.bundle/icon@3x.png"] scaledToSize:CGSizeMake(30, 30)];
			cell.imageView.layer.cornerRadius = 7;
			cell.imageView.clipsToBounds = YES;
		}

		return cell;
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
		   toIndexPath:(NSIndexPath *)toIndexPath {
	LogDebug(@"From: %@ | To: %@", fromIndexPath, toIndexPath);
	if (fromIndexPath != toIndexPath) {
		if (toIndexPath.section == 0) {
			if (fromIndexPath.section == toIndexPath.section) {
				NSString *identifier = [self.selectedWidgets objectAtIndex:fromIndexPath.row];
				[self.selectedWidgets removeObject:identifier];
				[self.selectedWidgets insertObject:identifier atIndex:toIndexPath.row];
			} else {
				NSString *identifier = [self.availableWidgets objectAtIndex:fromIndexPath.row];
				[self.availableWidgets removeObject:identifier];
				[self.selectedWidgets insertObject:identifier atIndex:toIndexPath.row];
			}
		} else {
			NSString *identifier = [self.selectedWidgets objectAtIndex:fromIndexPath.row];
			[self.selectedWidgets removeObject:identifier];
			[self.availableWidgets insertObject:identifier atIndex:toIndexPath.row];
		}

		[self save];
		[self.tableView reloadData];
	} else {
		[self.tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
	}
}

- (UIImage *)rescaleImage:(UIImage *)image scaledToSize:(CGSize)newSize {
	UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
	[image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end
