#import "AXNManager.h"
#import "AXNRequestWrapper.h"
#import "Tweak.h"
@implementation Colour

- (instancetype)init
{
    self = [super init];

    if (self) {

    }

    return self;
}

@end
@implementation AXNManager

+(instancetype)sharedInstance {
    static AXNManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [AXNManager alloc];
        sharedInstance.names = [NSMutableDictionary new];
        sharedInstance.timestamps = [NSMutableDictionary new];
        sharedInstance.notificationRequests = [NSMutableDictionary new];
        sharedInstance.iconStore = [NSMutableDictionary new];
        sharedInstance.backgroundColorCache = [NSMutableDictionary new];
        sharedInstance.textColorCache = [NSMutableDictionary new];
        sharedInstance.countCache = [NSMutableDictionary new];
        sharedInstance.fallbackColor = [UIColor whiteColor];
        sharedInstance.wallpaperColorCache = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIColor whiteColor], @"primary", [UIColor whiteColor], @"secondary", [UIColor whiteColor], @"background", nil];
    });
    return sharedInstance;
}

-(id)init {
    return [AXNManager sharedInstance];
}

-(void)getRidOfWaste {
    for (NSString *bundleIdentifier in [self.notificationRequests allKeys]) {
        __weak NSMutableArray *requests = self.notificationRequests[bundleIdentifier];
        for (int i = [requests count] - 1; i >= 0; i--) {
            __weak AXNRequestWrapper *wrapped = requests[i];
            if (!wrapped || ![wrapped request]) [requests removeObjectAtIndex:i];
        }
    }
}

-(void)invalidateCountCache {
    [self.countCache removeAllObjects];
}

-(void)updateCountForBundleIdentifier:(NSString *)bundleIdentifier {
    NSArray *requests = [self requestsForBundleIdentifier:bundleIdentifier];
    NSInteger count = [requests count];
    if (count == 0) {
        self.countCache[bundleIdentifier] = @(0);
        return;
    }

    if ([self.dispatcher.notificationStore respondsToSelector:@selector(coalescedNotificationForRequest:)]) {
        count = 0;
        NSMutableArray *coalescedNotifications = [NSMutableArray new];
        for (NCNotificationRequest *req in requests) {
            NCCoalescedNotification *coalesced = [self coalescedNotificationForRequest:req];
            if (!coalesced) {
                count++;
                continue;
            }

            if (![coalescedNotifications containsObject:coalesced]) {
                count += [coalesced.notificationRequests count];
                [coalescedNotifications addObject:coalesced];
            }
        }
    }

    self.countCache[bundleIdentifier] = @(count);
}

-(NSInteger)countForBundleIdentifier:(NSString *)bundleIdentifier {
    if (self.countCache[bundleIdentifier]) return [self.countCache[bundleIdentifier] intValue];

    [self updateCountForBundleIdentifier:bundleIdentifier];

    if (self.countCache[bundleIdentifier]) return [self.countCache[bundleIdentifier] intValue];
    else return 0;
}

- (UIImage *)getRoundedRectImageFromImage:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(CGRectMake(0,0,60,60).size, NO, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0,60,60)
                                cornerRadius:30] addClip];
    [image drawInRect:CGRectMake(0,0,60,60)];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return finalImage;
}

-(UIImage *)getIcon:(NSString *)bundleIdentifier withStyle:(NSInteger)style {
    if (self.iconStore[bundleIdentifier]) return self.iconStore[bundleIdentifier];
    UIImage *image;
    SBIconModel *model;

    SBIconController *iconController = [NSClassFromString(@"SBIconController") sharedInstance];

    if([iconController respondsToSelector:@selector(homescreenIconViewMap)]) model = [[iconController homescreenIconViewMap] iconModel];
    else if([iconController respondsToSelector:@selector(model)]) model = [iconController model];
    SBIcon *icon = [model applicationIconForBundleIdentifier:bundleIdentifier];
    if([icon respondsToSelector:@selector(getIconImage:)]) image = [icon getIconImage:2];
    else if([icon respondsToSelector:@selector(iconImageWithInfo:)]) image = [icon iconImageWithInfo:(struct SBIconImageInfo){60,60,2,0}];

    if (!image) {
      NSLog(@"[Axon] Image Not Founded!");
        NSArray *requests = [self requestsForBundleIdentifier:bundleIdentifier];
        for (int i = 0; i < [requests count]; i++) {
            NCNotificationRequest *request = requests[i];
            if ([request.sectionIdentifier isEqualToString:bundleIdentifier] && request.content && request.content.icon) {
                image = request.content.icon;
                break;
            }
        }
    }

    if (!image && model) {
        icon = [model applicationIconForBundleIdentifier:@"com.apple.Preferences"];
        if([icon respondsToSelector:@selector(getIconImage:)]) image = [icon getIconImage:2];
        else if([icon respondsToSelector:@selector(iconImageWithInfo:)]) image = [icon iconImageWithInfo:(struct SBIconImageInfo){60,60,2,0}];
    }

    if (!image) {
        image = [UIImage _applicationIconImageForBundleIdentifier:bundleIdentifier format:0 scale:[UIScreen mainScreen].scale];
    }


    if (self.style == 5) image = [self getRoundedRectImageFromImage:image];

    if (image) {
        self.iconStore[bundleIdentifier] = [image copy];
    }


    return image ?: [UIImage new];
}

-(void)clearAll:(NSString *)bundleIdentifier {
    if (self.notificationRequests[bundleIdentifier]) {
        [self.dispatcher destination:nil requestsClearingNotificationRequests:[self allRequestsForBundleIdentifier:bundleIdentifier]];
    }
}

-(void)insertNotificationRequest:(NCNotificationRequest *)req {
    if (!req || ![req notificationIdentifier] || !req.bulletin || !req.bulletin.sectionID) return;
    NSString *bundleIdentifier = req.bulletin.sectionID;

    if (req.content && req.content.header) {
        self.names[bundleIdentifier] = [req.content.header copy];
    }

    if (req.timestamp) {
        if (!self.timestamps[bundleIdentifier] || [req.timestamp compare:self.timestamps[bundleIdentifier]] == NSOrderedDescending) {
            self.timestamps[bundleIdentifier] = [req.timestamp copy];
        }

        if (!self.latestRequest || [req.timestamp compare:self.latestRequest.timestamp] == NSOrderedDescending) {
            self.latestRequest = req;
        }
    }

    [self getRidOfWaste];
    if (self.notificationRequests[bundleIdentifier]) {
        BOOL found = NO;
        for (int i = 0; i < [self.notificationRequests[bundleIdentifier] count]; i++) {
            __weak AXNRequestWrapper *wrapped = self.notificationRequests[bundleIdentifier][i];
            if (wrapped && [[req notificationIdentifier] isEqualToString:[wrapped notificationIdentifier]]) {
                found = YES;
                break;
            }
        }

        if (!found) [self.notificationRequests[bundleIdentifier] addObject:[AXNRequestWrapper wrapRequest:req]];
    } else {
        self.notificationRequests[bundleIdentifier] = [NSMutableArray new];
        [self.notificationRequests[bundleIdentifier] addObject:[AXNRequestWrapper wrapRequest:req]];
    }

    [self updateCountForBundleIdentifier:bundleIdentifier];
}

-(void)removeNotificationRequest:(NCNotificationRequest *)req {
    if (!req || ![req notificationIdentifier] || !req.bulletin || !req.bulletin.sectionID) return;
    NSString *bundleIdentifier = req.bulletin.sectionID;

    if (self.latestRequest && [[self.latestRequest notificationIdentifier] isEqualToString:[req notificationIdentifier]]) {
        self.latestRequest = nil;
    }

    [self getRidOfWaste];
    if (self.notificationRequests[bundleIdentifier]) {
        __weak NSMutableArray *requests = self.notificationRequests[bundleIdentifier];
        for (int i = [requests count] - 1; i >= 0; i--) {
            __weak AXNRequestWrapper *wrapped = requests[i];
            if (wrapped && [[req notificationIdentifier] isEqualToString:[wrapped notificationIdentifier]]) {
                [requests removeObjectAtIndex:i];
            }
        }
    }

    [self updateCountForBundleIdentifier:bundleIdentifier];
}

-(void)modifyNotificationRequest:(NCNotificationRequest *)req {
    if (!req || ![req notificationIdentifier] || !req.bulletin || !req.bulletin.sectionID) return;
    NSString *bundleIdentifier = req.bulletin.sectionID;

    if (self.latestRequest && [[self.latestRequest notificationIdentifier] isEqualToString:[req notificationIdentifier]]) {
        self.latestRequest = req;
    }

    [self getRidOfWaste];
    if (self.notificationRequests[bundleIdentifier]) {
        __weak NSMutableArray *requests = self.notificationRequests[bundleIdentifier];
        for (int i = [requests count] - 1; i >= 0; i--) {
            __weak AXNRequestWrapper *wrapped = requests[i];
            if (wrapped && [wrapped notificationIdentifier] && [[req notificationIdentifier] isEqualToString:[wrapped notificationIdentifier]]) {
                [requests removeObjectAtIndex:i];
                [requests insertObject:[AXNRequestWrapper wrapRequest:req] atIndex:i];
                return;
            }
        }
    }
}

-(void)setLatestRequest:(NCNotificationRequest *)request {
    _latestRequest = request;

    if (self.view.showingLatestRequest) {
        [self.view reset];
    }
}

-(NSArray *)requestsForBundleIdentifier:(NSString *)bundleIdentifier {
    NSMutableArray *array = [NSMutableArray new];
    if (!self.notificationRequests[bundleIdentifier]) return array;

    [self getRidOfWaste];

    for (int i = 0; i < [self.notificationRequests[bundleIdentifier] count]; i++) {
        __weak AXNRequestWrapper *wrapped = self.notificationRequests[bundleIdentifier][i];
        if (wrapped && [wrapped request]) [array addObject:[wrapped request]];
    }

    return array;
}

-(NSArray *)allRequestsForBundleIdentifier:(NSString *)bundleIdentifier {
    NSArray *requests = [self requestsForBundleIdentifier:bundleIdentifier];

    if ([self.dispatcher.notificationStore respondsToSelector:@selector(coalescedNotificationForRequest:)]) {
        NSMutableArray *allRequests = [NSMutableArray new];
        NSMutableArray *coalescedNotifications = [NSMutableArray new];

        for (NCNotificationRequest *req in requests) {
            NCCoalescedNotification *coalesced = [self coalescedNotificationForRequest:req];
            if (!coalesced) {
                BOOL found = NO;
                for (int i = 0; i < [allRequests count]; i++) {
                    if ([[req notificationIdentifier] isEqualToString:[allRequests[i] notificationIdentifier]]) {
                        found = YES;
                        break;
                    }
                }

                if (!found) {
                    [allRequests addObject:req];
                }
                continue;
            }

            if (![coalescedNotifications containsObject:coalesced]) {
                for (NCNotificationRequest *request in coalesced.notificationRequests) {
                    BOOL found = NO;
                    for (int i = 0; i < [allRequests count]; i++) {
                        if ([[request notificationIdentifier] isEqualToString:[allRequests[i] notificationIdentifier]]) {
                            found = YES;
                            break;
                        }
                    }

                    if (!found) {
                        [allRequests addObject:request];
                    }
                }
                [coalescedNotifications addObject:coalesced];
            }
        }

        return allRequests;
    } else {
        return requests;
    }
}

-(id)coalescedNotificationForRequest:(id)req {
    NCCoalescedNotification *coalesced = nil;
    if ([self.dispatcher.notificationStore respondsToSelector:@selector(coalescedNotificationForRequest:)]) {
        coalesced = [self.dispatcher.notificationStore coalescedNotificationForRequest:req];
    }
    return coalesced;
}

-(void)showNotificationRequest:(NCNotificationRequest *)req {
    if (!req) return;
    self.clvc.axnAllowChanges = YES;
    if ([self.clvc respondsToSelector:@selector(insertNotificationRequest:forCoalescedNotification:)]) [self.clvc insertNotificationRequest:req forCoalescedNotification:[self coalescedNotificationForRequest:req]];
    else [self.clvc insertNotificationRequest:req];
    self.clvc.axnAllowChanges = NO;
}

-(void)hideNotificationRequest:(NCNotificationRequest *)req {
    if (!req) return;
    self.clvc.axnAllowChanges = YES;
    [self insertNotificationRequest:req];
    if ([self.clvc respondsToSelector:@selector(removeNotificationRequest:forCoalescedNotification:)]) [self.clvc removeNotificationRequest:req forCoalescedNotification:[self coalescedNotificationForRequest:req]];
    else [self.clvc removeNotificationRequest:req];
    self.clvc.axnAllowChanges = NO;

}

-(void)showNotificationRequests:(id)reqs {
    if (!reqs) return;
    for (id req in reqs) {
        [self showNotificationRequest:req];
    }
}

-(void)hideNotificationRequests:(id)reqs {
    if (!reqs) return;
    for (id req in reqs) {
        [self hideNotificationRequest:req];
    }
}

-(void)showNotificationRequestsForBundleIdentifier:(NSString *)bundleIdentifier {
    [self showNotificationRequests:[self requestsForBundleIdentifier:bundleIdentifier]];
}

-(void)hideAllNotificationRequests {
    [self hideNotificationRequests:[self.clvc allNotificationRequests]];
}

-(void)hideAllNotificationRequestsExcept:(id)notification {
  NSMutableSet *set = [[self.clvc allNotificationRequests] mutableCopy];
  [set removeObject:notification];
  [self hideNotificationRequests:set];
}

-(void)revealNotificationHistory:(BOOL)revealed {
    [self.clvc revealNotificationHistory:revealed];
}

- (void)updateWallpaperColors:(UIImage *)wallpaperImage
{
    self.wallpaperColorCache = [[self coloursForImage:wallpaperImage forEdge:1] mutableCopy];
}

// Code from https://stackoverflow.com/a/41401246
-(NSDictionary *)coloursForImage:(UIImage *)image forEdge:(int)edge {


    //1. set vars
    float dimension = 20;

    //2. resize image and grab raw data
    //this part pulls the raw data from the image
    CGImageRef imageRef = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(dimension * dimension * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * dimension;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, dimension, dimension, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, dimension, dimension), imageRef);
    CGContextRelease(context);

    //3. create colour array
    NSMutableArray * colours = [NSMutableArray new];
    float x = 0, y = 0; //used to set coordinates
    float eR = 0, eB = 0, eG = 0; //used for mean edge colour
    for (int n = 0; n<(dimension*dimension); n++){

        Colour * c = [Colour new]; //create colour
        int i = (bytesPerRow * y) + x * bytesPerPixel; //pull index
        c.r = rawData[i]; //set red
        c.g = rawData[i + 1]; //set green
        c.b = rawData[i + 2]; //set blue
        [colours addObject:c]; //add colour

        //add to edge if true
        if ((edge == 0 && y == 0) || //top
            (edge == 1 && x == 0) || //left
            (edge == 2 && y == dimension-1) || //bottom
            (edge == 3 && x == dimension-1)){ //right
            eR+=c.r; eG+=c.g; eB+=c.b; //add the colours
        }

        //update pixel coordinate
        x = (x == dimension - 1) ? 0 : x+1;
        y = (x == 0) ? y+1 : y;

    }
    free(rawData);

    //4. calculate edge colour
    Colour * e = [Colour new];
    e.r = eR/dimension;
    e.g = eG/dimension;
    e.b = eB/dimension;

    //5. calculate the frequency of colour
    NSMutableArray * accents = [NSMutableArray new]; //holds valid accents

    float minContrast = 3.1; //play with this value
    while (accents.count < 3) { //minimum number of accents
        for (Colour * a in colours){

            //NSLog(@"contrast value is %f", [self contrastValueFor:a andB:e]);

            //5.1 ignore if it does not contrast with edge
            if ([self contrastValueFor:a andB:e] < minContrast){ continue;}

            //5.2 set distance (frequency)
            for (Colour * b in colours){
                a.d += [self colourDistance:a andB:b];
            }

            //5.3 add colour to accents
            [accents addObject:a];
        }

        minContrast-=0.1f;
    }

    //6. sort colours by the most common
    NSArray * sorted = [[NSArray arrayWithArray:accents] sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"d" ascending:true]]];

    //6.1 set primary colour (most common)
    Colour * p = sorted[0];

    //7. get most contrasting colour
    float high = 0.0f; //the high
    int index = 0; //the index
    for (int n = 1; n < sorted.count; n++){

        Colour * c = sorted[n];
        float contrast = [self contrastValueFor:c andB:p];
        //float sat = [self saturationValueFor:c andB:p];

        if (contrast > high){
            high = contrast;
            index = n;
        }
    }
    //7.1 set secondary colour (most contrasting)
    Colour * s = sorted[index];

    NSMutableDictionary * result = [NSMutableDictionary new];
    [result setValue:[UIColor colorWithRed:e.r/255.0f green:e.g/255.0f blue:e.b/255.0f alpha:1.0f] forKey:@"background"];
    [result setValue:[UIColor colorWithRed:p.r/255.0f green:p.g/255.0f blue:p.b/255.0f alpha:1.0f] forKey:@"primary"];
    [result setValue:[UIColor colorWithRed:s.r/205.0f green:s.g/205.0f blue:s.b/205.0f alpha:0.9f] forKey:@"secondary"]; // something was being weird with floating point math so i just did it backwards

    return result;

}
-(float)contrastValueFor:(Colour *)a andB:(Colour *)b {
    float aL = 0.2126 * a.r + 0.7152 * a.g + 0.0722 * a.b;
    float bL = 0.2126 * b.r + 0.7152 * b.g + 0.0722 * b.b;
    return (aL>bL) ? (aL + 0.05) / (bL + 0.05) : (bL + 0.05) / (aL + 0.05);
}
-(float)saturationValueFor:(Colour *)a andB:(Colour *)b {
    float min = MIN(a.r, MIN(a.g, a.b)); //grab min
    float max = MAX(b.r, MAX(b.g, b.b)); //grab max
    return (max - min)/max;
}
-(int)colourDistance:(Colour *)a andB:(Colour *)b {
    return abs(a.r-b.r)+abs(a.g-b.g)+abs(a.b-b.b);
}

@end
