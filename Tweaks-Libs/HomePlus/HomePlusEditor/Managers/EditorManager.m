//
// EditorManager.h
// HomePlus
//
// Global manager for the Editor (and tutorial) views. 
//
// Maybe at some point this should be refactored to HPEditorManager :)
//
// Authors: Kritanta
// Created  Oct 2019
//

#include "EditorManager.h"
#include "HPEditorWindow.h"
#include "HPUtility.h"
#include "HPResources.h"
#include "HPEditorViewController.h"
#include "spawn.h"

@interface HPEditorViewController () 

@property (nonatomic, readwrite, strong) HPControllerView *offsetControlView;
@property (nonatomic, readwrite, strong) HPControllerView *spacingControlView;
@property (nonatomic, readwrite, strong) HPControllerView *iconCountControlView;
@property (nonatomic, readwrite, strong) HPControllerView *settingsView;
@property (nonatomic, readwrite, strong) HPEditorViewNavigationTabBar *tabBar;

@property (nonatomic, readwrite, strong) HPSettingsTableViewController *tableViewController;

@property (nonatomic, readwrite, strong) UIView *tapBackView;

@property (nonatomic, retain) HPControllerView *activeView;
@property (nonatomic, retain) UIButton *activeButton;

@property (nonatomic, retain) UIButton *offsetButton;
@property (nonatomic, retain) UIButton *spacerButton;
@property (nonatomic, retain) UIButton *iconCountButton;
@property (nonatomic, retain) UIButton *settingsButton;
@property (nonatomic, retain) UIButton *settingsDoneButton;

@end


@interface EditorManager () <HPEditorViewControllerDelegate>

@property (nonatomic, readwrite, strong) HPEditorViewController *editorViewController;
@property (nonatomic, readwrite, strong) HPEditorWindow *editorView;


@property (nonatomic, readwrite, strong) HPTutorialViewController *tutorialViewController;
@property (nonatomic, readwrite, strong) HPEditorWindow *tutorialView;

@end

@implementation EditorManager 

+ (instancetype)sharedManager
{
    static EditorManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];

    if (self) {
        self.editingLocation = @"SBIconLocationRoot";
    }

    return self;
}

- (void)loadUpImagesFromWallpaper:(UIImage *)image 
{
    /*
    @property (nonatomic, retain) UIImage *wallpaper;
    @property (nonatomic, retain) UIImage *dynamicallyGeneratedSettingsHeaderImage;
    @property (nonatomic, retain) UIImage *blurredAndDarkenedWallpaper;
    @property (nonatomic, retain) UIImage *blurredMoreBackgroundImage;
    */
    self.wallpaper = image;
    self.blurredAndDarkenedWallpaper = [self bdBackgroundImage];
    self.blurredMoreBackgroundImage = [self blurredMoreBGImage];

    UIImage *a = [HPUtility isCurrentDeviceNotched]? [HPResources inAppBannerNotched] : [HPResources inAppBanner];
    UIImage *b = [[EditorManager sharedManager] blurredMoreBGImage];

    self.dynamicallyGeneratedSettingsHeaderImage = [HPUtility imageByCombiningImage:b withImage:a];
}
- (UIImage *)bdBackgroundImage
{   
    UIImage *sourceImage = self.wallpaper;

    //  Create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];


    CIFilter* blackGenerator = [CIFilter filterWithName:@"CIConstantColorGenerator"];
    CIColor* black = [CIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:.5];
    [blackGenerator setValue:black forKey:@"inputColor"];
    CIImage* blackImage = [blackGenerator valueForKey:@"outputImage"];

    //Second, apply that black
    CIFilter *compositeFilter = [CIFilter filterWithName:@"CIMultiplyBlendMode"];
    [compositeFilter setValue:blackImage forKey:@"inputImage"];
    [compositeFilter setValue:inputImage forKey:@"inputBackgroundImage"];
    CIImage *darkenedImage = [compositeFilter outputImage];

    //Third, blur the image
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setDefaults];
    [blurFilter setValue:@(15.0) forKey:@"inputRadius"];
    [blurFilter setValue:darkenedImage forKey:kCIInputImageKey];
    CIImage *blurredImage = [blurFilter outputImage];

    CGImageRef cgimg = [context createCGImage:blurredImage fromRect:inputImage.extent];
    UIImage *blurredAndDarkenedImage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);

    return blurredAndDarkenedImage;
}
- (UIImage *)blurredMoreBGImage
{
    UIImage *sourceImage = self.wallpaper;

    //  Create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];


    CIFilter* blackGenerator = [CIFilter filterWithName:@"CIConstantColorGenerator"];
    CIColor* black = [CIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:.8];
    [blackGenerator setValue:black forKey:@"inputColor"];
    CIImage* blackImage = [blackGenerator valueForKey:@"outputImage"];

    //Second, apply that black
    CIFilter *compositeFilter = [CIFilter filterWithName:@"CIMultiplyBlendMode"];
    [compositeFilter setValue:blackImage forKey:@"inputImage"];
    [compositeFilter setValue:inputImage forKey:@"inputBackgroundImage"];
    CIImage *darkenedImage = [compositeFilter outputImage];

    //Third, blur the image
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setDefaults];
    [blurFilter setValue:@(30.0) forKey:@"inputRadius"];
    [blurFilter setValue:darkenedImage forKey:kCIInputImageKey];
    CIImage *blurredImage = [blurFilter outputImage];

    CGImageRef cgimg = [context createCGImage:blurredImage fromRect:inputImage.extent];
    UIImage *blurredAndDarkenedImage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    

    return blurredAndDarkenedImage;
}


- (HPEditorWindow *)tutorialView 
{
    [self tutorialViewController];
    if (!_tutorialView) 
    {
        _tutorialView = [[HPEditorWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _tutorialView.rootViewController = self.tutorialViewController;
        [_tutorialView addSubview:[self tutorialViewController].view];
        [_tutorialViewController introView];
        _tutorialView.hidden = YES;
    }
    return _tutorialView;
}

- (HPTutorialViewController *)tutorialViewController 
{
    if (!_tutorialViewController) 
    {
        _tutorialViewController = [[HPTutorialViewController alloc] init];
    }
    return _tutorialViewController;
}

- (HPEditorWindow *)editorView 
{
    if (!_editorView) 
    {
        _editorView = [[HPEditorWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _editorView.rootViewController = self.editorViewController;
    }
    return _editorView;
}

- (HPEditorViewController *)editorViewController 
{
    if (!_editorViewController) 
    {
        _editorViewController = [[HPEditorViewController alloc] init];
        _editorViewController.delegate = self;
    }

    return _editorViewController;
}

- (void)showEditorView 
{
    [self editorViewController];
    [self editorView];
    _editorView.hidden = NO;
    _editorView.alpha = 0;
    [UIView animateWithDuration:.2
        animations:
        ^{
            _editorView.alpha = 1;
        }
    ];
}
- (void)showTutorialView
{
    self.tutorialActive = YES;
    [self tutorialViewController];
    [self tutorialView];
    _tutorialView.alpha = 0;
    _tutorialView.hidden = NO;
    _tutorialViewController.viewOne.alpha = 1;
    [UIView animateWithDuration:.2 
        animations:
        ^{
            _tutorialView.alpha = 1;
        }
    ];
}
- (void)hideTutorialView
{
    self.tutorialActive = NO;
    _tutorialView.hidden = YES;
}
- (void)hideEditorView
{
    [_editorViewController handleDoneSettingsButtonPress:_editorViewController.settingsDoneButton];
    [self hideTutorialView];
    _editorView.hidden = YES;
    [[self editorViewController] unloadExtensionPanes];
    [[self editorViewController] reload];
}

- (void)toggleEditorView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowFloatingDockNotificationName object:nil];
    if (_editorView.hidden) 
    {
        [self showEditorView];
    } 
    else 
    {
        [self hideEditorView];
    }
}

- (void)resetAllValuesToDefaults 
{
    [_editorViewController resetAllValuesToDefaults];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomePlusEditingModeDisabled" object:nil];
    [self hideEditorView];
    _editorView = nil;
    _editorViewController = nil;
    _editorViewController = [[HPEditorViewController alloc] init];
    _editorViewController.delegate = self;
    _editorView = [[HPEditorWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _editorView.rootViewController = self.editorViewController;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"HPResetIconViews" object:nil];
    //if (kCFCoreFoundationVersionNumber < 1600) return;
	pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

- (void)editorViewControllerDidFinish:(HPEditorViewController *)editorViewController 
{

}

@end
