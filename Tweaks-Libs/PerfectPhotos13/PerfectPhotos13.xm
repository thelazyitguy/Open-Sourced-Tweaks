#import "PerfectPhotos13.h"

#import <Cephei/HBPreferences.h>

static HBPreferences *pref;
static BOOL allowSelectAll;
static BOOL unlimitedZoom;
static BOOL skipDeleteConfirm;
static BOOL photoInfo;

// ------------------------- ALLOW SELECT ALL IN ALBUMS -------------------------

%group allowSelectAllGroup

    %hook PUPhotosAlbumViewController

    - (BOOL)allowSelectAllButton
    {
        return YES;
    }

    %end

%end

// ------------------------- ALLOW UNLIMITED ZOOM IN PHOTOS -------------------------

%group unlimitedZoomGroup

    %hook PUUserTransformView

    - (void)_setPreferredMaximumZoomScale: (double)arg
    {
        %orig(9999);
    }

    %end

%end

// ------------------------- SKIP DELETE CONFIRMATION -------------------------

%group skipDeleteConfirmGroup

    %hook PUDeletePhotosActionController

    - (BOOL)shouldSkipDeleteConfirmation
    {
        return YES;
    }

    %end

%end

// ------------------------- DETAILED PHOTO INFO IN NAVIGATION BAR -------------------------

// original tweak by @shepgoba: https://github.com/shepgoba/PhotoInfo

%group photoInfoGroup

    %hook PUPhotoBrowserTitleViewController

    - (void)_setTimeDescription: (id)arg1
    {
        PHAsset *asset = [(PUOneUpViewController*)[(PUNavigationController*)[[self view] performSelector: @selector(_viewControllerForAncestor)] _currentToolbarViewController] pu_debugCurrentAsset];
        if (asset)
        {
            CGSize imageSize = [asset imageSize];
            NSString *correctURL = [[[asset mainFileURL] absoluteString] stringByReplacingOccurrencesOfString: @"file://" withString: @""];
            NSDictionary *fileAttributes;
            NSNumber *fileSizeNumber;
            long long fileSize;
            float fileSizeMB;
            BOOL isDirectory;

            if([[NSFileManager defaultManager] fileExistsAtPath: correctURL isDirectory: &isDirectory])
            {
                fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath: correctURL error: nil];
                fileSizeNumber = [fileAttributes objectForKey: NSFileSize];
                fileSize = [fileSizeNumber longLongValue];
                fileSizeMB = (float)fileSize / (1024 * 1024);
            }
            else fileSizeMB = 0;

            NSString *newTitle = [NSString stringWithFormat: @"%@ (%ix%i, %.02fMB)", arg1, (int)imageSize.width, (int)imageSize.height, fileSizeMB];
            
            %orig(newTitle);
        }
        else %orig;
    }

    %end

%end

%ctor
{
    @autoreleasepool
	{
		pref = [[HBPreferences alloc] initWithIdentifier: @"com.johnzaro.perfectphotos13prefs"];

		[pref registerBool: &allowSelectAll default: YES forKey: @"allowSelectAll"];
		[pref registerBool: &unlimitedZoom default: YES forKey: @"unlimitedZoom"];
		[pref registerBool: &skipDeleteConfirm default: YES forKey: @"skipDeleteConfirm"];
		[pref registerBool: &photoInfo default: YES forKey: @"photoInfo"];

        if(allowSelectAll) %init(allowSelectAllGroup);
        if(unlimitedZoom) %init(unlimitedZoomGroup);
        if(skipDeleteConfirm) %init(skipDeleteConfirmGroup);
        if(photoInfo) %init(photoInfoGroup);
    }
}