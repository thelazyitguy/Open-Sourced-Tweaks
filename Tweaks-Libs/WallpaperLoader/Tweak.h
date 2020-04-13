// WallpaperLoader Headers

@interface WKWallpaperBundleCollection : NSObject
@property (nonatomic, assign) unsigned long long wallpaperType;
- (NSString *)displayName;
- (long long)numberOfItems;
- (id)wallpaperBundleAtIndex:(unsigned long long)index;
@end

@interface WKWallpaperBundle : NSObject
@property (nonatomic, retain) NSNumber *wallpaperType;
@property (nonatomic, retain) NSNumber *loadTag;
- (id)initWithDynamicDictionary:(id)arg1 identifier:(unsigned long long)arg2;
- (id)fileBasedWallpaperForLocation:(id)arg1 andAppearance:(id)appearance;
- (id)valueBasedWallpaperForLocation:(id)arg1 andAppearance:(id)appearance;
- (void)set_defaultAppearanceWallpapers:(NSMutableDictionary *)dict;
- (void)test;
@end

@interface WKStillWallpaper : NSObject
- (id)initWithIdentifier:(unsigned long long)arg1 name:(id)arg2 thumbnailImageURL:(id)arg3 fullsizeImageURL:(id)arg4;
@end

@interface WKLiveWallpaper : NSObject
- (id)initWithIdentifier:(unsigned long long)arg1 name:(id)arg2 thumbnailImageURL:(id)arg3 fullsizeImageURL:(id)arg4 videoAssetURL:(id)arg5 stillTimeInVideo:(double)arg6;
@end
