#import "AXNView.h"
#import "RandomHeaders.h"
#import "Protocol.h"
@interface Colour : NSObject
@property int r, g, b, d;
@end
@interface AXNManager : NSObject

@property (nonatomic, assign) NSInteger style;
@property (nonatomic, assign) BOOL fadeEntireCell;
@property (nonatomic, assign) BOOL dynamicBadges;
@property (nonatomic, assign) BOOL dynamicCellBackground;
@property (nonatomic, retain) NSMutableDictionary *notificationRequests;
@property (nonatomic, retain) NSMutableDictionary *names;
@property (nonatomic, retain) NSMutableDictionary *timestamps;
@property (nonatomic, retain) NSMutableDictionary *iconStore;
@property (nonatomic, retain) NSMutableDictionary *backgroundColorCache;
@property (nonatomic, retain) NSMutableDictionary *textColorCache;
@property (nonatomic, retain) NSMutableDictionary *countCache;
@property (nonatomic, retain) NSMutableDictionary *wallpaperColorCache;
@property (nonatomic, retain) NSString *wallpaperImageHash;
@property (nonatomic, retain) UIColor *fallbackColor;
@property (nonatomic, weak) NCNotificationRequest *latestRequest;
@property (nonatomic, weak) AXNView *view;
@property (nonatomic, weak) id<clvc> clvc;
@property (nonatomic, weak) id sbclvc;
@property (nonatomic, weak) NCNotificationDispatcher *dispatcher;

+(instancetype)sharedInstance;
-(id)init;
-(void)getRidOfWaste;
-(void)insertNotificationRequest:(id)req;
-(void)removeNotificationRequest:(id)req;
-(void)modifyNotificationRequest:(id)req;
-(UIImage *)getIcon:(NSString *)bundleIdentifier withStyle:(NSInteger)style;
-(void)clearAll:(NSString *)bundleIdentifier;

- (void)updateWallpaperColors:(UIImage *)wallpaperImage;
-(void)showNotificationRequest:(id)req;
-(void)hideNotificationRequest:(id)req;

-(void)showNotificationRequests:(id)reqs;
-(void)hideNotificationRequests:(id)reqs;

-(id)requestsForBundleIdentifier:(NSString *)bundleIdentifier;
-(NSArray *)allRequestsForBundleIdentifier:(NSString *)bundleIdentifier;
-(void)showNotificationRequestsForBundleIdentifier:(NSString *)bundleIdentifier;
-(void)hideAllNotificationRequests;
-(void)hideAllNotificationRequestsExcept:(id)notification;
-(void)revealNotificationHistory:(BOOL)revealed;

-(void)invalidateCountCache;
-(NSInteger)countForBundleIdentifier:(NSString *)bundleIdentifier;
- (UIImage *)getRoundedRectImageFromImage:(UIImage *)image;

-(NSDictionary *)coloursForImage:(UIImage *)image forEdge:(int)edge;
-(float)contrastValueFor:(Colour *)a andB:(Colour *)b;
-(float)saturationValueFor:(Colour *)a andB:(Colour *)b;
-(int)colourDistance:(Colour *)a andB:(Colour *)b;
@end
