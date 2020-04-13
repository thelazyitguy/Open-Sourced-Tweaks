// WallpaperLoader - Custom wallpaper bundles
// By Skitty
#include "Tweak.h"

static NSMutableArray *stillList;
static NSMutableArray *liveList;

// Load custom bundles
%hook WKWallpaperBundleCollection
- (long long)numberOfItems {
  if (self.wallpaperType == 0) {
    return %orig + [stillList count];
  } else if (self.wallpaperType == 1) {
    return %orig + [liveList count];
  }
  return %orig;
}

- (id)wallpaperBundleAtIndex:(unsigned long long)index {
  if (self.wallpaperType == 0) {
    for (int i = 1; i <= [stillList count]; i++) {
      if (index == [self numberOfItems] - [stillList count] + i - 1) {
        WKWallpaperBundle *bundle = [[%c(WKWallpaperBundle) alloc] init];
        bundle.wallpaperType = @(self.wallpaperType);
        bundle.loadTag = @(i);
        return bundle;
      }
    }
  } else if (self.wallpaperType == 1) {
    for (int i = 1; i <= [liveList count]; i++) {
      if (index == [self numberOfItems] - [liveList count] + i - 1) {
        WKWallpaperBundle *bundle = [[%c(WKWallpaperBundle) alloc] init];
        bundle.wallpaperType = @(self.wallpaperType);
        bundle.loadTag = @(i);
        return bundle;
      }
    }
  }
  return %orig;
}
%end

// Make sure bundles return the correct values
%hook WKWallpaperBundle
%property (nonatomic, retain) NSNumber *wallpaperType;
%property (nonatomic, retain) NSNumber *loadTag;
- (NSString *)name {
  if ([self.loadTag intValue] > 0 && [self.wallpaperType isEqual:@0]) {
    return stillList[[self.loadTag intValue] - 1][@"name"];
  } else if ([self.loadTag intValue] > 0 && [self.wallpaperType isEqual:@1]) {
    return liveList[[self.loadTag intValue] - 1][@"name"];
  }
  return %orig;
}

- (NSString *)family {
  if ([self.loadTag intValue] > 0) {
    return @"WallpaperLoader";
  }
  return %orig;
}

- (unsigned long long)version {
  if ([self.loadTag intValue] > 0) {
    return 1;
  }
  return %orig;
}

- (unsigned long long)identifier {
  if ([self.loadTag intValue] > 0) {
    return 1;
  }
  return %orig;
}

- (BOOL)hasDistintWallpapersForLocations {
  if ([self.loadTag intValue] > 0) {
    return NO;
  }
  return %orig;
}

- (BOOL)isDynamicWallpaperBundle {
  if ([self.loadTag intValue] > 0) {
    return NO;
  }
  return %orig;
}

- (BOOL)isAppearanceAware {
  if ([self.loadTag intValue] > 0 && [self.wallpaperType isEqual:@0]) {
    return stillList[[self.loadTag intValue] - 1][@"appearanceAware"];
  } else if ([self.loadTag intValue] > 0 && [self.wallpaperType isEqual:@1]) {
    return liveList[[self.loadTag intValue] - 1][@"appearanceAware"];
  }
  return %orig;
}

- (NSURL *)thumbnailImageURL {
  if ([self.loadTag intValue] > 0 && [self.wallpaperType isEqual:@0]) {
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"/Library/WallpaperLoader/%@/%@", stillList[[self.loadTag intValue] - 1][@"name"], stillList[[self.loadTag intValue] - 1][@"thumbnailImage"]]];
  } else if ([self.loadTag intValue] > 0 && [self.wallpaperType isEqual:@1]) {
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"/Library/WallpaperLoader/%@/%@", liveList[[self.loadTag intValue] - 1][@"name"], liveList[[self.loadTag intValue] - 1][@"thumbnailImage"]]];
  }
  return %orig;
}

- (NSMutableDictionary *)_defaultAppearanceWallpapers {
  if ([self.loadTag intValue] > 0 && [self.wallpaperType isEqual:@0]) {
    NSString *name = stillList[[self.loadTag intValue] - 1][@"name"];
    NSString *path = [NSString stringWithFormat:@"/Library/WallpaperLoader/%@", name];

    WKStillWallpaper *wp = [[NSClassFromString(@"WKStillWallpaper") alloc] initWithIdentifier:1234 name:name thumbnailImageURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", path, stillList[[self.loadTag intValue] - 1][@"thumbnailImage"]]] fullsizeImageURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", path, stillList[[self.loadTag intValue] - 1][@"defaultImage"]]]];

    return [@{@"WKWallpaperLocationCoverSheet": wp} mutableCopy];
  } else if ([self.loadTag intValue] > 0 && [self.wallpaperType isEqual:@1]) {
    NSString *name = liveList[[self.loadTag intValue] - 1][@"name"];
    NSString *path = [NSString stringWithFormat:@"/Library/WallpaperLoader/%@", name];

    WKLiveWallpaper *wp = [[NSClassFromString(@"WKLiveWallpaper") alloc] initWithIdentifier:1234 name:name thumbnailImageURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", path, liveList[[self.loadTag intValue] - 1][@"thumbnailImage"]]] fullsizeImageURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", path, liveList[[self.loadTag intValue] - 1][@"defaultImage"]]] videoAssetURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", path, liveList[[self.loadTag intValue] - 1][@"defaultVideo"]]] stillTimeInVideo:0];

    return [@{@"WKWallpaperLocationCoverSheet": wp} mutableCopy];
  }
  return %orig;
}

- (id)fileBasedWallpaperForLocation:(id)location andAppearance:(id)appearance {
  if ([self.loadTag intValue] > 0 && [self.wallpaperType isEqual:@0]) {
    NSString *name = stillList[[self.loadTag intValue] - 1][@"name"];
    NSString *path = [NSString stringWithFormat:@"/Library/WallpaperLoader/%@", name];
    if ([appearance isEqualToString:@"default"]) {
      WKStillWallpaper *wp = [[NSClassFromString(@"WKStillWallpaper") alloc] initWithIdentifier:1233 name:name thumbnailImageURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", path, stillList[[self.loadTag intValue] - 1][@"thumbnailImage"]]] fullsizeImageURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", path, stillList[[self.loadTag intValue] - 1][@"defaultImage"]]]];
      return wp;
    } else if ([appearance isEqualToString:@"dark"]) {
      WKStillWallpaper *wp = [[NSClassFromString(@"WKStillWallpaper") alloc] initWithIdentifier:1234 name:name thumbnailImageURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", path, stillList[[self.loadTag intValue] - 1][@"thumbnailImage"]]] fullsizeImageURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", path, stillList[[self.loadTag intValue] - 1][@"darkImage"]]]];
      return wp;
    }
  } else if ([self.loadTag intValue] > 0 && [self.wallpaperType isEqual:@1]) {
    NSString *name = liveList[[self.loadTag intValue] - 1][@"name"];
    NSString *path = [NSString stringWithFormat:@"/Library/WallpaperLoader/%@", name];
    if ([appearance isEqualToString:@"default"]) {
      WKLiveWallpaper *wp = [[NSClassFromString(@"WKLiveWallpaper") alloc] initWithIdentifier:1234 name:name thumbnailImageURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", path, liveList[[self.loadTag intValue] - 1][@"thumbnailImage"]]] fullsizeImageURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", path, liveList[[self.loadTag intValue] - 1][@"defaultImage"]]] videoAssetURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", path, liveList[[self.loadTag intValue] - 1][@"defaultVideo"]]] stillTimeInVideo:0];
      return wp;
    } else if ([appearance isEqualToString:@"dark"]) {
      WKLiveWallpaper *wp = [[NSClassFromString(@"WKLiveWallpaper") alloc] initWithIdentifier:1234 name:name thumbnailImageURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", path, liveList[[self.loadTag intValue] - 1][@"thumbnailImage"]]] fullsizeImageURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", path, liveList[[self.loadTag intValue] - 1][@"darkImage"]]] videoAssetURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", path, liveList[[self.loadTag intValue] - 1][@"darkVideo"]]] stillTimeInVideo:0];
      return wp;
    }
  }
  return %orig;
}

- (id)valueBasedWallpaperForLocation:(id)location {
  if ([self.loadTag intValue] > 0) {
    return [self valueBasedWallpaperForLocation:location andAppearance:@"default"];
  }
  return %orig;
}

- (id)fileBasedWallpaperForLocation:(id)location {
  if ([self.loadTag intValue] > 0) {
    return [self fileBasedWallpaperForLocation:location andAppearance:@"default"];
  }
  return %orig;
}

- (id)valueBasedWallpaperForLocation:(id)location andAppearance:(id)appearance {
  if ([self.loadTag intValue] > 0)
    return [self fileBasedWallpaperForLocation:location andAppearance:appearance];
  return %orig;
}
%end

// Fixes stupid crashes
%hook WKStillWallpaper
%new
- (id)thumbnailImage {
  return [[UIImage alloc] init];
}
%new
- (id)wallpaperValue {
  return nil;
}
%end

%hook WKLiveWallpaper
%new
- (id)thumbnailImage {
  return [[UIImage alloc] init];
}
%new
- (id)wallpaperValue {
  return nil;
}
%end

%ctor {
  NSArray *subpaths = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:@"/Library/WallpaperLoader" error:NULL];
  for (NSString *item in subpaths) {
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/Library/WallpaperLoader/%@/Wallpaper.plist", item]]) {
      NSMutableDictionary *plist = [[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/Library/WallpaperLoader/%@/Wallpaper.plist", item]] mutableCopy];

      // Check if proper format
      if (!plist[@"defaultImage"] || (plist[@"appearanceAware"] && !plist[@"darkImage"])) {
        NSLog(@"[WallpaperLoader] nope :( %@", plist[@"wallpaperType"]);
      } else {
        plist[@"name"] = item;
        if (!plist[@"thumbnailImage"]) plist[@"thumbnailImage"] = plist[@"defaultImage"];
        if ([plist[@"wallpaperType"] isEqual:@0]) {
          if (!stillList) stillList = [[NSMutableArray alloc] init];
          [stillList addObject:[plist copy]];
        } else if ([plist[@"wallpaperType"] isEqual:@1]) {
          if (!liveList) liveList = [[NSMutableArray alloc] init];
          [liveList addObject:[plist copy]];
        }
      }
    }
  }

  %init;
}
