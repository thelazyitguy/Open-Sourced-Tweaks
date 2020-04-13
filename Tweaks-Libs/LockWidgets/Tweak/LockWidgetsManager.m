#import "LockWidgetsManager.h"

@implementation LockWidgetsManager

+ (instancetype)sharedInstance {
	static LockWidgetsManager *sharedInstance = nil;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	  sharedInstance = [LockWidgetsManager alloc];
	});

	return sharedInstance;
}

- (id)init {
	return [LockWidgetsManager sharedInstance];
}

- (NSArray *)getAllWidgetIdentifiers {
	WGWidgetDiscoveryController *wdc = [[NSClassFromString(@"WGWidgetDiscoveryController") alloc] init];
	[wdc beginDiscovery];

	return [[wdc disabledWidgetIdentifiers] arrayByAddingObjectsFromArray:[wdc enabledWidgetIdentifiersForAllGroups]];
}
@end

@implementation UIView (RemoveConstraints)

- (void)removeAllConstraints {
	UIView *superview = self.superview;
	while (superview != nil) {
		for (NSLayoutConstraint *c in superview.constraints) {
			if (c.firstItem == self || c.secondItem == self) {
				[superview removeConstraint:c];
			}
		}
		superview = superview.superview;
	}

	[self removeConstraints:self.constraints];
	self.translatesAutoresizingMaskIntoConstraints = YES;
}

@end