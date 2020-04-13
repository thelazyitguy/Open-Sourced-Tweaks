#import "Tweak.h"

static LockWidgetsConfig *tweakConfig = nil;
static LockWidgetsIPCServer *ipcServer = nil;

%group reachability
%hook SBReachabilityWindow
%property (nonatomic, retain) LockWidgetsView *lwReachabilityView;

-(instancetype)initWithWallpaperVariant:(long long)arg1  {
	if((self = %orig)) {
		self.lwReachabilityView = [[LockWidgetsView alloc] initWithFrame:CGRectMake(self.frame.origin.x + 5, self.frame.origin.y - (self.frame.size.height / 3.5), self.frame.size.width - 10, 150)];
	}
	return self;
}

-(void)layoutSubviews {
    %orig;
	if(self.lwReachabilityView && tweakConfig.reachabilityEnabled) {
		self.userInteractionEnabled = NO;
		self.layer.masksToBounds = NO;
		self.clipsToBounds = NO;

		if (self.lwReachabilityView.superview == NULL) {
			[self addSubview:self.lwReachabilityView];
			[self bringSubviewToFront:self.lwReachabilityView];
		}
	} else {
		[self.lwReachabilityView removeFromSuperview];
	}
}

%end
%end

/*
IPC SERVER
*/
@implementation LockWidgetsIPCServer {
	MRYIPCCenter* _center;
}

+(void)load {
	[self sharedInstance];
}

+(instancetype)sharedInstance {
	static dispatch_once_t onceToken = 0;
	__strong static LockWidgetsIPCServer* sharedInstance = nil;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

-(instancetype)init {
	if ((self = [super init]))
	{
		_center = [MRYIPCCenter centerNamed:@"me.conorthedev.lockwidgetsipcserver"];
		[_center addTarget:self action:@selector(getAllIdentifiers:)];
		[_center addTarget:self action:@selector(getWidgetNamesForIdentifiers:)];

		LogDebug(@"running server in %@", [NSProcessInfo processInfo].processName);
	}
	return self;
}

-(NSArray*)getAllIdentifiers:(NSDictionary*)args {
	return [[LockWidgetsManager sharedInstance] getAllWidgetIdentifiers];
}

-(NSMutableDictionary*)getWidgetNamesForIdentifiers:(NSDictionary*)args {	
	NSMutableDictionary *allIdentifiers = [NSMutableDictionary new];

	for(NSString *identifier in args[@"identifiers"]) {
		NSError *error;
		NSExtension *extension = [NSExtension extensionWithIdentifier:identifier error:&error];
		WGWidgetInfo *widgetInfo = [[NSClassFromString(@"WGWidgetInfo") alloc] initWithExtension:extension];
		WGWidgetHostingViewController *host	= [[%c(WGWidgetHostingViewController) alloc] initWithWidgetInfo:widgetInfo delegate:nil host:nil];

		if(!host.appBundleID) {
			[allIdentifiers setValue:@{@"name":[widgetInfo displayName]} forKey:identifier];
		} else {
			UIImage *image = [UIImage _applicationIconImageForBundleIdentifier:host.appBundleID format:2 scale:1];
			if(image) {
				[allIdentifiers setValue:@{@"name":[widgetInfo displayName], @"image": UIImagePNGRepresentation(image)} forKey:identifier];
			} else {
				[allIdentifiers setValue:@{@"name":[widgetInfo displayName]} forKey:identifier];
			}
		}
	}

	return allIdentifiers;
}
@end

%group group
%hook SheetViewController
- (void)setAuthenticated:(BOOL)authenticated {
	%orig;
	if(authenticated) {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.conorthedev.lockwidgets/Authenticated"), NULL, NULL, YES);
	} else {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.conorthedev.lockwidgets/NotAuthenticated"), NULL, NULL, YES);
	}
}

- (void)setInScreenOffMode:(BOOL)screenOff {
    %orig;
    if(screenOff) {
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.conorthedev.lockwidgets/NotAuthenticated"), NULL, NULL, YES);
    }
}
%end
%end

%group ios12
%hook SBDashBoardNotificationAdjunctListViewController
%property (nonatomic, retain) LockWidgetsView *lockWidgetsView;
-(void)viewDidLoad {
	%orig;
	[self addLockWidgetsView];
}

-(void)_insertItem:(id)arg1 animated:(BOOL)arg2 {
	%orig;
	[self refreshView];
}

-(void)viewDidAppear:(BOOL)animated {
	%orig;
	[self refreshView];
}

-(void)_updatePresentingContent {
    %orig;
	[self refreshView];
}

%new
-(void)addLockWidgetsView {
	if(!self.lockWidgetsView) {
		self.lockWidgetsView = [[LockWidgetsView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
	}

	UIStackView *stackView = [self valueForKey:@"_stackView"];
	[stackView addArrangedSubview:self.lockWidgetsView];
	
	self.lockWidgetsView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.lockWidgetsView.centerXAnchor constraintEqualToAnchor:stackView.centerXAnchor].active = true;
	[self.lockWidgetsView.leadingAnchor constraintEqualToAnchor:stackView.leadingAnchor constant:5].active = true;
	[self.lockWidgetsView.trailingAnchor constraintEqualToAnchor:stackView.trailingAnchor constant:-5].active = true;
	[self.lockWidgetsView.heightAnchor constraintEqualToConstant:160].active = true;

	[LockWidgetsManager sharedInstance].view = self.lockWidgetsView;

}

%new 
-(void)refreshView {
	if(self.lockWidgetsView) {
		[self.lockWidgetsView refresh];
	}
}
%end
%end

%group ios13
%hook CSNotificationAdjunctListViewController
%property (nonatomic, retain) LockWidgetsView *lockWidgetsView;
-(void)viewDidLoad {
	%orig;
	[self addLockWidgetsView];
}

-(void)_insertItem:(id)arg1 animated:(BOOL)arg2 {
	%orig;
	[self refreshView];
}

-(void)viewDidAppear:(BOOL)animated {
	%orig;
	[self refreshView];
}

-(void)_updatePresentingContent {
    %orig;
	[self refreshView];
}

%new
-(void)addLockWidgetsView {
	if(!self.lockWidgetsView) {
		self.lockWidgetsView = [[LockWidgetsView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
	}

	UIStackView *stackView = [self valueForKey:@"_stackView"];
	[stackView addArrangedSubview:self.lockWidgetsView];
	
	self.lockWidgetsView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.lockWidgetsView.centerXAnchor constraintEqualToAnchor:stackView.centerXAnchor].active = true;
	[self.lockWidgetsView.leadingAnchor constraintEqualToAnchor:stackView.leadingAnchor constant:5].active = true;
	[self.lockWidgetsView.trailingAnchor constraintEqualToAnchor:stackView.trailingAnchor constant:-5].active = true;
	[self.lockWidgetsView.heightAnchor constraintEqualToConstant:160].active = true;

	[LockWidgetsManager sharedInstance].view = self.lockWidgetsView;

}

%new 
-(void)refreshView {
	if(self.lockWidgetsView) {
		[self.lockWidgetsView refresh];
	}
}
%end
%end

// Used to reload preferences from Cephei
void reloadPreferences() {
	// Log that the preferences are being loaded
	LogInfo("Reloading preferences...");

	// Tell our config class to reload
	tweakConfig = [LockWidgetsConfig sharedInstance];
	[tweakConfig reloadPreferences];

	// Tell our LockWidgetsView to reload
	[[LockWidgetsManager sharedInstance].view refresh];
	// Log in the console if LockWidgets is enabled or disabled
	LogInfo("%s", tweakConfig.enabled ? "LockWidgets is enabled!" : "LockWidgets is disabled.");
	LogInfo("%s", tweakConfig.reachabilityEnabled ? "Reachability is enabled!" : "Reachability is disabled.");
}

// Called when the tweak is injected into a new process
%ctor {	
	// Call reloadPreferences and register notification 'me.conorthedev.lockwidgets/ReloadPreferences' to tell the tweak when it should reload it's preferences
	reloadPreferences();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPreferences, CFSTR("me.conorthedev.lockwidgets/ReloadPreferences"), NULL, kNilOptions);

	// If the tweak is enabled, run all code, otherwise ignore everything else
	if(tweakConfig.enabled) {
		// Start the IPC Server
		ipcServer = [[LockWidgetsIPCServer alloc] init];

		%init(reachability);

		// Easier than having multiple groups, reduces the file length by half basically
        NSString *sheetControllerClass = @"SBDashBoardViewController";
        if(@available(iOS 13.0, *)) {
            sheetControllerClass = @"CSCoverSheetViewController";
            LogDebug(@"Current version is iOS 13 or higher, using %@", sheetControllerClass);
			%init(ios13);
        } else {
            LogDebug(@"Current version is iOS 12 or lower, using %@", sheetControllerClass);
			%init(ios12);
        }

		// Start hooking into reachability classes
		// Start hooking into the classes we need to hook
		%init(group, SheetViewController = NSClassFromString(sheetControllerClass));
	}
}