#import <dlfcn.h>
#import <objc/runtime.h>
#import <substrate.h>

@interface PSSpecifier : NSObject
+ (instancetype)deleteButtonSpecifierWithName:(NSString *)name target:(id)target action:(SEL)action;
- (void)setProperty:(id)value forKey:(NSString *)key;
- (id)propertyForKey:(NSString *)key;
- (void)setConfirmationAction:(SEL)action;
@property (nonatomic, readonly) NSString *identifier;
+ (id)emptyGroupSpecifier;
@end

@interface PSViewController : UIViewController {
@public
	PSSpecifier *_specifier;
}
@end

@interface PSListController : PSViewController {
@public
	NSMutableArray *_specifiers;
}
- (NSArray *)specifiers;
- (void)showConfirmationViewForSpecifier:(PSSpecifier *)specifier;
@end

@interface UsageDetailController : PSListController
- (BOOL)isAppController;
@end

@interface LSBundleProxy : NSObject
@property (nonatomic, readonly) NSURL *dataContainerURL;
@end

@interface LSApplicationProxy : LSBundleProxy
+ (instancetype)applicationProxyForIdentifier:(NSString *)identifier;
@property (nonatomic, readonly) NSString *localizedShortName;
@property (nonatomic, readonly) NSString *itemName;
@property (nonatomic, readonly) NSNumber *dynamicDiskUsage;
@end

typedef const struct __SBSApplicationTerminationAssertion *SBSApplicationTerminationAssertionRef;

extern "C" SBSApplicationTerminationAssertionRef SBSApplicationTerminationAssertionCreateWithError(void *unknown, NSString *bundleIdentifier, int reason, int *outError);
extern "C" void SBSApplicationTerminationAssertionInvalidate(SBSApplicationTerminationAssertionRef assertion);
extern "C" NSString *SBSApplicationTerminationAssertionErrorString(int error);

#define NSLog(...)


@interface PSStorageApp : NSObject
@property (nonatomic,readonly) NSString * appIdentifier;
@property (nonatomic,readonly) LSApplicationProxy * appProxy;
@end

@interface STStorageAppDetailController : PSListController
{
	PSStorageApp* _storageApp;
}
@end

%hook STStorageAppDetailController
- (NSArray*)specifiers
{
	NSArray* ret = %orig;
	NSMutableArray* _specifiers = [ret mutableCopy];
		PSSpecifier* specifier;
		specifier = [PSSpecifier emptyGroupSpecifier];
        [_specifiers addObject:specifier];
		
		specifier = [PSSpecifier deleteButtonSpecifierWithName:@"Reset App" target:self action:@selector(resetDiskContent)];
		[specifier setConfirmationAction:@selector(clearCaches)];
		[_specifiers addObject:specifier];
		specifier = [PSSpecifier deleteButtonSpecifierWithName:@"Clear App's Cache" target:self action:@selector(clearCaches)];
		[specifier setConfirmationAction:@selector(clearCaches)];
		[_specifiers addObject:specifier];
		
		ret = [_specifiers copy];
		MSHookIvar<NSArray*>(self, "_specifiers") = ret;
	return ret;
}


static void ClearDirectoryURLContents(NSURL *url)
{
	NSFileManager *fm = [NSFileManager defaultManager];
	NSDirectoryEnumerator *enumerator = [fm enumeratorAtURL:url includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants errorHandler:nil];
	NSURL *child;
	while ((child = [enumerator nextObject])) {
		[fm removeItemAtURL:child error:NULL];
	}
}

static void ShowMessage(NSString *message)
{
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"CacheClearer" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[av show];
	[av release];
}

%new
- (void)resetDiskContent
{
	PSStorageApp* _storageApp = MSHookIvar<PSStorageApp*>(self, "_storageApp");	
	NSString *identifier = _storageApp.appIdentifier;
	LSApplicationProxy *app = [LSApplicationProxy applicationProxyForIdentifier:identifier];
	NSString *title = app.localizedShortName;
	NSNumber *originalDynamicSize = [[app.dynamicDiskUsage retain] autorelease];
	NSURL *dataContainer = app.dataContainerURL;
	SBSApplicationTerminationAssertionRef assertion = SBSApplicationTerminationAssertionCreateWithError(NULL, identifier, 1, NULL);
	ClearDirectoryURLContents([dataContainer URLByAppendingPathComponent:@"tmp" isDirectory:YES]);
	NSURL *libraryURL = [dataContainer URLByAppendingPathComponent:@"Library" isDirectory:YES];
	ClearDirectoryURLContents(libraryURL);
	[[NSFileManager defaultManager] createDirectoryAtURL:[libraryURL URLByAppendingPathComponent:@"Preferences" isDirectory:YES] withIntermediateDirectories:YES attributes:nil error:NULL];
	ClearDirectoryURLContents([dataContainer URLByAppendingPathComponent:@"Documents" isDirectory:YES]);
	if (assertion) {
		SBSApplicationTerminationAssertionInvalidate(assertion);
	}
	NSNumber *newDynamicSize = [LSApplicationProxy applicationProxyForIdentifier:identifier].dynamicDiskUsage;
	if ([newDynamicSize isEqualToNumber:originalDynamicSize]) {
		ShowMessage([NSString stringWithFormat:@"%@ was already reset, no disk space was reclaimed.", title]);
	} else {
		ShowMessage([NSString stringWithFormat:@"%@ is now restored to a fresh state. Reclaimed %@ bytes!", title, [NSNumber numberWithDouble:[originalDynamicSize doubleValue] - [newDynamicSize doubleValue]]]);
	}
}

%new
- (void)clearCaches
{
	PSStorageApp* _storageApp = MSHookIvar<PSStorageApp*>(self, "_storageApp");	
	NSString *identifier = _storageApp.appIdentifier;
	LSApplicationProxy *app = [LSApplicationProxy applicationProxyForIdentifier:identifier];
	NSString *title = app.localizedShortName;
	NSNumber *originalDynamicSize = [[app.dynamicDiskUsage retain] autorelease];
	NSURL *dataContainer = app.dataContainerURL;
	SBSApplicationTerminationAssertionRef assertion = SBSApplicationTerminationAssertionCreateWithError(NULL, identifier, 1, NULL);
	ClearDirectoryURLContents([dataContainer URLByAppendingPathComponent:@"tmp" isDirectory:YES]);
	ClearDirectoryURLContents([[dataContainer URLByAppendingPathComponent:@"Library" isDirectory:YES] URLByAppendingPathComponent:@"Caches" isDirectory:YES]);
	ClearDirectoryURLContents([[[dataContainer URLByAppendingPathComponent:@"Library" isDirectory:YES] URLByAppendingPathComponent:@"Application Support" isDirectory:YES] URLByAppendingPathComponent:@"Dropbox" isDirectory:YES]);
	if (assertion) {
		SBSApplicationTerminationAssertionInvalidate(assertion);
	}
	NSNumber *newDynamicSize = [LSApplicationProxy applicationProxyForIdentifier:identifier].dynamicDiskUsage;
	if ([newDynamicSize isEqualToNumber:originalDynamicSize]) {
		ShowMessage([NSString stringWithFormat:@"Cache for %@ was already empty, no disk space was reclaimed.", title]);
	} else {
		ShowMessage([NSString stringWithFormat:@"Reclaimed %@ bytes!\n%@ may use more data or run slower on next launch to repopulate the cache.", [NSNumber numberWithDouble:[originalDynamicSize doubleValue] - [newDynamicSize doubleValue]], title]);
	}
}

%end


%ctor
{
	dlopen("/System/Library/PreferenceBundles/StorageSettings.bundle/StorageSettings", RTLD_LAZY);
}