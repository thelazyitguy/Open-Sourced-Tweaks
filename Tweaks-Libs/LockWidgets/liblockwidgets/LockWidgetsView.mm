#import "LockWidgetsView.h"

bool deviceLocked = YES;
LockWidgetsView *globalSelf;

@implementation LockWidgetsView
@synthesize collectionView;
@synthesize widgetIdentifiers;

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	if (self) {
		globalSelf = self;
		// Setup the widgetIdentifiers with some default values if it's not set
		if (!widgetIdentifiers) {
			widgetIdentifiers = [[LockWidgetsConfig sharedInstance].selectedWidgets mutableCopy];
		}

		self.collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
		self.collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		self.collectionViewLayout.itemSize = CGSizeMake(frame.size.width - 4, 150);
		self.collectionViewLayout.estimatedItemSize = CGSizeMake(frame.size.width - 4, 150);
		self.collectionViewLayout.minimumLineSpacing = 5;

		self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.collectionViewLayout];
		self.collectionView.dataSource = self;
		self.collectionView.delegate = self;

		self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
		self.collectionView.backgroundColor = [UIColor clearColor];
		self.collectionView.layer.cornerRadius = 13;
		self.collectionView.layer.masksToBounds = true;
		self.collectionView.pagingEnabled = YES;
		self.collectionView.contentSize = CGSizeMake(([widgetIdentifiers count] * frame.size.width - 4) + 100, 150);

		[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"WidgetCell"];

		[self addSubview:self.collectionView];

		[NSLayoutConstraint activateConstraints:@[
			[self.collectionView.topAnchor constraintEqualToAnchor:self.topAnchor],
			[self.collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
			[self.collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
			[self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
		]];

		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)unlocked, CFSTR("me.conorthedev.lockwidgets/Authenticated"), NULL, kCFNotificationDeliverImmediately);
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)locked, CFSTR("me.conorthedev.lockwidgets/NotAuthenticated"), NULL, kCFNotificationDeliverImmediately);
	}

	return self;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"WidgetCell" forIndexPath:indexPath];

	if ([widgetIdentifiers count] == 0) {
		for (UIView *view in cell.contentView.subviews) {
			[view removeFromSuperview];
		}

		UILabel *textLabel = [[UILabel alloc]
			initWithFrame:CGRectMake(0, 0, self.frame.size.width - 4, 150)];
		textLabel.textAlignment = NSTextAlignmentCenter;
		textLabel.textColor = [UIColor whiteColor];
		textLabel.numberOfLines = 0;
		[textLabel setText:@"Please select a widget to show"];
		[cell.contentView addSubview:textLabel];

		UIBlurEffect *blurEffect;
		if (@available(iOS 13.0, *)) {
			blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
		} else {
			blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
		}

		UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
		blurEffectView.frame = CGRectMake(0, 0, self.frame.size.width - 4, 150);
		blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		blurEffectView.layer.cornerRadius = 13.0f;
		blurEffectView.clipsToBounds = YES;

		[cell.contentView insertSubview:blurEffectView atIndex:0];

		return cell;
	}

	if ((deviceLocked && [LockWidgetsConfig sharedInstance].hideWhenLocked)) {
		for (UIView *view in cell.contentView.subviews) {
			[view removeFromSuperview];
		}

		UILabel *textLabel = [[UILabel alloc]
			initWithFrame:CGRectMake(0, 0, self.frame.size.width - 4, 150)];
		textLabel.textAlignment = NSTextAlignmentCenter;
		textLabel.textColor = [UIColor whiteColor];
		textLabel.numberOfLines = 0;
		[textLabel setText:@"Unlock device to show widgets view"];
		[cell.contentView addSubview:textLabel];

		UIBlurEffect *blurEffect;
		if (@available(iOS 13.0, *)) {
			blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
		} else {
			blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
		}

		UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
		blurEffectView.frame = CGRectMake(0, 0, self.frame.size.width - 4, 150);
		blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		blurEffectView.layer.cornerRadius = 13.0f;
		blurEffectView.clipsToBounds = YES;

		[cell.contentView insertSubview:blurEffectView atIndex:0];

		return cell;
	}

	if (!NSClassFromString(@"WGWidgetPlatterView")) {
		for (UIView *view in cell.contentView.subviews) {
			[view removeFromSuperview];
		}

		UILabel *textLabel = [[UILabel alloc]
			initWithFrame:CGRectMake(0, 0, self.frame.size.width - 4, 150)];
		textLabel.textAlignment = NSTextAlignmentCenter;
		textLabel.textColor = [UIColor whiteColor];
		textLabel.numberOfLines = 0;
		[textLabel setText:@"Unable to load widgets view"];
		[cell.contentView addSubview:textLabel];

		UIBlurEffect *blurEffect;
		if (@available(iOS 13.0, *)) {
			blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
		} else {
			blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
		}

		UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
		blurEffectView.frame = CGRectMake(0, 0, self.frame.size.width - 4, 150);
		blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		blurEffectView.layer.cornerRadius = 13.0f;
		blurEffectView.clipsToBounds = YES;

		[cell.contentView insertSubview:blurEffectView atIndex:0];

		return cell;
	}

	NSError *error;
	NSString *identifier = [widgetIdentifiers objectAtIndex:indexPath.row];
	NSExtension *extension = [NSExtension extensionWithIdentifier:identifier error:&error];

	WGWidgetInfo *widgetInfo = [[NSClassFromString(@"WGWidgetInfo") alloc] initWithExtension:extension];
	WGWidgetHostingViewController *widgetHost = [[NSClassFromString(@"WGWidgetHostingViewController") alloc] initWithWidgetInfo:widgetInfo delegate:nil host:nil];

	WGWidgetPlatterView *platterView = [[NSClassFromString(@"WGWidgetPlatterView") alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 4, 150)];

	if ([identifier isEqualToString:@"com.apple.UpNextWidget.extension"] || [identifier isEqualToString:@"com.apple.mobilecal.widget"]) {
		WGCalendarWidgetInfo *widgetInfoCal = [[NSClassFromString(@"WGCalendarWidgetInfo") alloc] initWithExtension:extension];
		NSDate *now = [NSDate date];
		[widgetInfoCal setValue:now forKey:@"_date"];
		[platterView setWidgetHost:[[NSClassFromString(@"WGWidgetHostingViewController") alloc] initWithWidgetInfo:widgetInfoCal delegate:nil host:nil]];
	} else {
		[platterView setWidgetHost:widgetHost];
	}

	for (UIView *view in cell.contentView.subviews) {
		[view removeFromSuperview];
	}

	[cell.contentView addSubview:platterView];

	if (@available(iOS 13.0, *)) {
		// Fix on iOS 13 for the dark header being the old style
		MTMaterialView *header = MSHookIvar<MTMaterialView *>(platterView, "_headerBackgroundView");
		[header removeFromSuperview];
	}

	if ([identifier isEqualToString:@"com.apple.UpNextWidget.extension"] || [identifier isEqualToString:@"com.apple.mobilecal.widget"]) {
		WGCalendarWidgetInfo *widgetInfoCal = [[NSClassFromString(@"WGCalendarWidgetInfo") alloc] initWithExtension:extension];
		NSDate *now = [NSDate date];
		[widgetInfoCal setValue:now forKey:@"_date"];
		[platterView setWidgetHost:[[NSClassFromString(@"WGWidgetHostingViewController") alloc] initWithWidgetInfo:widgetInfoCal delegate:nil host:nil]];
	} else {
		[platterView setWidgetHost:[[NSClassFromString(@"WGWidgetHostingViewController") alloc] initWithWidgetInfo:widgetInfo delegate:nil host:nil]];
	}

	return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	if ([widgetIdentifiers count] == 0) {
		return 1;
	}
	return [widgetIdentifiers count];
}

- (BOOL)_canShowWhileLocked {
	return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
	shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
								 layout:(UICollectionViewLayout *)collectionViewLayout
	minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsMake(0, 2, 0, 2);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake(self.frame.size.width - 4, self.frame.size.height + 5);
}

- (void)refresh {
	if (!NSClassFromString(@"WGWidgetPlatterView")) {
		return;
	}
	LogDebug(@"Refreshing...");
	widgetIdentifiers = [[LockWidgetsConfig sharedInstance].selectedWidgets mutableCopy];

	LogDebug(@"Identififers: %@", widgetIdentifiers);
	[self.collectionView reloadData];

	for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
		UIView *contentView = cell.contentView;
		WGWidgetPlatterView *platterView = (WGWidgetPlatterView *)contentView;

		if (![platterView isKindOfClass:NSClassFromString(@"WGWidgetPlatterView")]) {
			LogError(@"platterView is not WGWidgetPlatterView!! returning before crash...");
			return;
		}

		// Parse the widget information from the identifier
		NSError *error;
		NSString *identifier = widgetIdentifiers[[self.collectionView indexPathForCell:cell].row];
		NSExtension *extension = [NSExtension extensionWithIdentifier:identifier error:&error];

		WGWidgetInfo *widgetInfo = [[NSClassFromString(@"WGWidgetInfo") alloc] initWithExtension:extension];
		WGWidgetHostingViewController *widgetHost = [[NSClassFromString(@"WGWidgetHostingViewController") alloc] initWithWidgetInfo:widgetInfo delegate:nil host:nil];

		if ([identifier isEqualToString:@"com.apple.UpNextWidget.extension"] || [identifier isEqualToString:@"com.apple.mobilecal.widget"]) {
			WGCalendarWidgetInfo *widgetInfoCal = [[NSClassFromString(@"WGCalendarWidgetInfo") alloc] initWithExtension:extension];
			NSDate *now = [NSDate date];
			[widgetInfoCal setValue:now forKey:@"_date"];
			[platterView setWidgetHost:[[NSClassFromString(@"WGWidgetHostingViewController") alloc] initWithWidgetInfo:widgetInfoCal delegate:nil host:nil]];
		} else {
			[platterView setWidgetHost:widgetHost];
		}
	}
}

void locked() {
	deviceLocked = YES;
	[globalSelf refresh];
}

void unlocked() {
	deviceLocked = NO;
	[globalSelf refresh];
}

// FUCK SAFEMODE SHIT YE YE
- (void)setContentHost:(id)arg1 {
}
- (void)setSizeToMimic:(CGSize)arg1 {
}
- (void)_layoutContentHost {
}
- (CGSize)sizeToMimic {
	return self.frame.size;
}
- (id)contentHost {
	return nil;
}
- (void)_updateSizeToMimic {
}
- (unsigned long long)_optionsForMainOverlay {
	return 0;
}

@end
