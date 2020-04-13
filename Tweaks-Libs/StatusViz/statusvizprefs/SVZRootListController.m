#include "SVZRootListController.h"

@implementation SVZRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)viewWillAppear:(BOOL)animated {
	[UISegmentedControl appearanceWhenContainedInInstancesOfClasses:@[self.class]].tintColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.38 alpha:1.0];
    [[UISwitch appearanceWhenContainedInInstancesOfClasses:@[self.class]] setOnTintColor:[UIColor colorWithRed:0.25 green:0.25 blue:0.38 alpha:1.0]];
    [[UISlider appearanceWhenContainedInInstancesOfClasses:@[self.class]] setTintColor:[UIColor colorWithRed:0.25 green:0.25 blue:0.38 alpha:1.0]];
    
    [super viewWillAppear:animated];


	self.navigationController.navigationController.navigationBar.translucent = NO;
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.38 alpha:1.0];

	//[self scrollViewDidScroll:self.scrollView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

	self.navigationController.navigationController.navigationBar.translucent = YES;
	//self.navigationController.navigationBar.tintColor = [UIColor systemBlueColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.navigationController.navigationController.navigationBar.translucent = NO;
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.38 alpha:1.0];
}
- (void)viewDidLoad
{
	[super viewDidLoad];
	// [UIColor colorWithRed:0.00 green:0.27 blue:0.35 alpha:1.0];

	self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,280,[[UIScreen mainScreen] bounds].size.width, 200)];
	self.headerView.backgroundColor = [UIColor colorWithRed:0.00 green:0.31 blue:0.39 alpha:0.0];
	UILabel *statvizLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, 300, 50)];
	statvizLabel.font=[UIFont boldSystemFontOfSize:38];
	statvizLabel.textColor = [UIColor whiteColor];
	statvizLabel.text = @"StatusViz";
	[self.headerView addSubview:statvizLabel];
	UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 120, 300, 50)];
	versionLabel.font=[UIFont systemFontOfSize:15 weight:UIFontWeightThin];
	versionLabel.textColor = [UIColor whiteColor];
	versionLabel.text = @"A Status Bar Visualizer";
	[self.headerView addSubview:versionLabel];
	//[self.view addSubview:self.headerView];
	//[self.view sendSubviewToBack:self.headerView];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width, 170)];
	if (!self.overflowView)
	{
		self.overflowView = [[UIView alloc] initWithFrame:CGRectMake(0,-310,[[UIScreen mainScreen] bounds].size.width,480)];
		self.overflowView.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.38 alpha:1.0];;
		CAGradientLayer *gradient = [CAGradientLayer layer];

		gradient.frame = self.overflowView.bounds;
		gradient.colors = @[(id)[UIColor colorWithRed:0.09 green:0.06 blue:0.38 alpha:1.0].CGColor, (id)[UIColor colorWithRed:0.01 green:0.00 blue:0.08 alpha:1.0].CGColor];

		[self.overflowView.layer insertSublayer:gradient atIndex:0];
		[self.overflowView addSubview:self.headerView];
		[tableView addSubview:self.overflowView];
	}

	//[tableView setContentInset:UIEdgeInsetsMake(150+tableView.contentInset.top, 0, 0, 0)];
	//self.automaticallyAdjustsScrollViewInsets = false;
	if (!self.startContentOffset) self.startContentOffset = tableView.contentOffset.y;
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
	if (!self.kick) 
		{
			self.kick = YES;
			offsetY = self.startContentOffset;
		}
	if (offsetY > self.startContentOffset) return;
	CGFloat height = 250 + (offsetY - self.startContentOffset);
	CGFloat desiredY = 0.35 * height;
	self.headerView.subviews[0].frame = CGRectMake(15, desiredY, 300, 50);
	CGFloat aheight = 230 + ((offsetY - self.startContentOffset)/4);
	CGFloat adesiredY = 0.60 * aheight;
	self.headerView.subviews[1].frame = CGRectMake(15, adesiredY, 300, 50);
}

 
@end
