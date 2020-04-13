//
// HPEditorViewController.m
// HomePlus
// 
// View controller for the Editor and Home base for anything UI.
// 
// Created Oct 2019 
// Authors: Kritanta
//

#include "HPEditorViewController.h"
#import "ExtensionManager.h"
#include "EditorManager.h"
#include "HPOffsetControllerView.h"
#include "HPDataManager.h"
#include "HPSpacingControllerView.h"
#include "HPIconCountControllerView.h"
#include "HPScaleControllerView.h"
#include "HPUtility.h"
#include "HPManager.h"
#include "HPResources.h"
#include <AudioToolbox/AudioToolbox.h>
#import <objc/runtime.h>  


@implementation HPEditorViewNavigationTabBar
@end

@interface HPEditorViewController () 

@property (nonatomic, readwrite, strong) HPControllerView *offsetControlView;
@property (nonatomic, readwrite, strong) HPControllerView *spacingControlView;
@property (nonatomic, readwrite, strong) HPControllerView *iconCountControlView;
@property (nonatomic, readwrite, strong) HPControllerView *scaleControlView;
@property (nonatomic, readwrite, strong) HPControllerView *settingsView;

@property (nonatomic, readwrite, strong) HPEditorViewNavigationTabBar *loadoutTabBar;
@property (nonatomic, readwrite, strong) HPEditorViewNavigationTabBar *tabBar;

@property (nonatomic, readwrite, strong) HPSettingsTableViewController *tableViewController;

@property (nonatomic, retain) HPControllerView *activeView;
@property (nonatomic, retain) UIButton *activeButton;

@property (nonatomic, retain) UIButton *rootButton;
@property (nonatomic, retain) UIButton *dockButton;

@property (nonatomic, retain) UIButton *settingsDoneButton;

@property (nonatomic, retain) UILabel *leftOffsetLabel;

@property (nonatomic, assign) BOOL viewKickedUp;

@end

#pragma mark Constants

/* 
 * So, to get the UI to translate well to other devices, I got the
 *      exact measurements on my X, and then whipped out a calculator. These
 *      are the values it gave me. Assume any of them are * by device screen w/h
 *
 * In hindsight, this is inefficient and, the smaller the screen gets, the less
 *       reliable it is. Fortunately, it all still works on the smallest screen that
 *       this tweak can run on (SE)
 * 
*/

const CGFloat MENU_BUTTON_TOP_ANCHOR = 0.197; 
const CGFloat MENU_BUTTON_SIZE = 40.0;

const CGFloat RESET_BUTTON_SIZE = 25.0;

const CGFloat LEFT_SCREEN_BUFFER = 0.146;

const CGFloat TOP_CONTAINER_TOP_ANCHOR = 0.036;
const CGFloat CONTAINER_HEIGHT = 0.123;

const CGFloat TABLE_HEADER_HEIGHT = 0.458;


@implementation HPEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    if ([[[EditorManager sharedManager] editingLocation] isEqualToString:@"SBIconLocationRoot"] && UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        [[EditorManager sharedManager] setEditingLocation:@"SBIconLocationRootLandscape"];
    }
    else if ([[[EditorManager sharedManager] editingLocation] isEqualToString:@"SBIconLocationRootLandscape"] && UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        [[EditorManager sharedManager] setEditingLocation:@"SBIconLocationRoot"];
    }

    SBRootFolderController *controller = [[objc_getClass("SBIconController") sharedInstance] _rootFolderController];
    if ([controller isSidebarPinned] && [controller isSidebarVisible])
    {
        if ([[[EditorManager sharedManager] editingLocation] isEqualToString:@"SBIconLocationRoot"] && UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            [[EditorManager sharedManager] setEditingLocation:@"SBIconLocationRootWithSidebarLandscape"];
        }
        if ([[[EditorManager sharedManager] editingLocation] isEqualToString:@"SBIconLocationRootLandscape"] && UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            [[EditorManager sharedManager] setEditingLocation:@"SBIconLocationRootWithSidebarLandscape"];
        }
        if ([[[EditorManager sharedManager] editingLocation] isEqualToString:@"SBIconLocationRootLandscape"] && UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
        {
            [[EditorManager sharedManager] setEditingLocation:@"SBIconLocationRootWithSidebar"];
        }
        else if ([[[EditorManager sharedManager] editingLocation] isEqualToString:@"SBIconLocationRoot"] && UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
        {
            [[EditorManager sharedManager] setEditingLocation:@"SBIconLocationRootWithSidebar"];
        }
    }*/


    //BOOL _tcDockyInstalled = [[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/me.nepeta.docky.list"];
    //BOOL excludeForDocky = (_tcDockyInstalled && [[[EditorManager sharedManager] editingLocation] isEqualToString:@"SBIconLocationDock"]);

    self.homeTabControllerViews = [[NSMutableArray alloc] initWithObjects:[self offsetControlView], [self spacingControlView], 
                                                                        [self iconCountControlView], [self scaleControlView], 
                                                                        [self settingsView], nil];

    self.loadoutTabBar = [self loadoutBar];

    // Add subviews to self. Any time viewDidLoad is called manually, unload these view beforehand
    if (self.activeExtension == nil)
    {
        [self.view addSubview:[self offsetControlView]];
        [self.view addSubview:[self spacingControlView]];
        [self.view addSubview:[self iconCountControlView]];

        [self.view addSubview:[self scaleControlView]];
        [self.view addSubview:[self settingsView]];

        // Load the view
        [self loadControllerView:[self offsetControlView]];


        self.tabBar = [self defaultTabBar];
        
        [self handleDefaultBarTabButtonPress:[self.tabBar subviews][0]];
    }
    else 
    {
        self.tabBar = [self customExtensionTabBar];
        @try 
        {
            [self handleExtensionTabBarButtonPress:[self.tabBar subviews][0]];
        }
        @catch (NSException *ex)
        {
            self.activeExtension = nil;
            [self reload];
            return;
        }
    }

    self.extensionBar = [self anExtensionBar];

    // Set the alpha of the rest to 0

    [self.view addSubview:self.tabBar];
    [self.view addSubview:self.extensionBar];
    [self.view addSubview:self.loadoutTabBar];
}

- (HPEditorViewNavigationTabBar *)loadoutBar
{
    HPEditorViewNavigationTabBar *loadoutBar = [[HPEditorViewNavigationTabBar alloc] initWithFrame:CGRectMake(
                                        7.5,
                                        ([[UIScreen mainScreen] bounds].size.height * .85) - MENU_BUTTON_SIZE*3,
                                        MENU_BUTTON_SIZE, MENU_BUTTON_SIZE*3)];

    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *saveImage = [HPUtility imageWithImage:[HPResources save] scaledToWidth:30];;
    [saveButton setImage:saveImage forState:UIControlStateNormal];
    saveButton.frame = CGRectMake(0,0, MENU_BUTTON_SIZE, MENU_BUTTON_SIZE);
    [saveButton addTarget:self 
        action:@selector(handleSaveButtonPress:)
        forControlEvents:UIControlEventTouchUpInside];
    
    [loadoutBar addSubview:saveButton];

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *cancelImage = [HPUtility imageWithImage:[HPResources cancel] scaledToWidth:30];;
    [cancelButton setImage:cancelImage forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(0,MENU_BUTTON_SIZE, MENU_BUTTON_SIZE, MENU_BUTTON_SIZE);
    [cancelButton addTarget:self 
        action:@selector(handleCancelButtonPress:)
        forControlEvents:UIControlEventTouchUpInside];
    
    [loadoutBar addSubview:cancelButton];

    UIButton *loadoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *loadoutImage = [HPUtility imageWithImage:[HPResources loadouts] scaledToWidth:30];;
    [loadoutButton setImage:loadoutImage forState:UIControlStateNormal];
    loadoutButton.frame = CGRectMake(0,MENU_BUTTON_SIZE*2, MENU_BUTTON_SIZE, MENU_BUTTON_SIZE);
    [saveButton addTarget:self 
        action:@selector(handleLoadoutButtonPress:)
        forControlEvents:UIControlEventTouchUpInside];
    
    [loadoutBar addSubview:loadoutButton];

        for (UIButton *button in [loadoutBar subviews])
    {
        [button addTarget:self
            action:@selector(buttonPressDown:)
            forControlEvents:UIControlEventTouchDown];
    }
    return loadoutBar;
}


- (HPEditorViewNavigationTabBar *)anExtensionBar
{
    HPEditorViewNavigationTabBar *extensionBar = [[HPEditorViewNavigationTabBar alloc] initWithFrame:CGRectMake(
                                        7.5,
                                        MENU_BUTTON_TOP_ANCHOR * [[UIScreen mainScreen] bounds].size.height,
                                        MENU_BUTTON_SIZE, MENU_BUTTON_SIZE*9)];
    
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *homeImage = [HPUtility imageWithImage:[HPResources extensionHome] scaledToWidth:30];
    [homeButton setImage:homeImage forState:UIControlStateNormal];
    homeButton.frame = CGRectMake(0,0, MENU_BUTTON_SIZE, MENU_BUTTON_SIZE);

    [extensionBar addSubview:homeButton];

    NSUInteger index = 1;

    for (HPExtension *extension in [[ExtensionManager sharedManager] extensions])
    {
        UIButton *extensionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *extensionImage = extension.extensionIcon;
        [extensionButton setImage:extensionImage forState:UIControlStateNormal];
        extensionButton.frame = CGRectMake(0, MENU_BUTTON_SIZE * index, MENU_BUTTON_SIZE, MENU_BUTTON_SIZE);
        [extensionBar addSubview:extensionButton];
        index++;
    }

    for (UIButton *button in [extensionBar subviews])
    {
        [button addTarget:self 
            action:@selector(handleExtensionBarButtonPress:)
            forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self
            action:@selector(buttonPressDown:)
            forControlEvents:UIControlEventTouchDown];
    }

    return extensionBar;
}
- (void)buttonPressDown:(id)arg 
{
    AudioServicesPlaySystemSound(1519);
}
- (void)unloadExtensionPanes
{
    if (self.activeExtension != nil)
    {
        [self loadExtension:nil];
    }
}
- (HPEditorViewNavigationTabBar *)customExtensionTabBar
{
    HPEditorViewNavigationTabBar *extensionTabBar = [[HPEditorViewNavigationTabBar alloc] initWithFrame:CGRectMake(
                                        [[UIScreen mainScreen] bounds].size.width - 47.5,
                                         MENU_BUTTON_TOP_ANCHOR * [[UIScreen mainScreen] bounds].size.height,
                                         MENU_BUTTON_SIZE, MENU_BUTTON_SIZE*9)];
    
    NSUInteger index = 0;

    for (HPExtensionControllerView *pane in self.activeExtension.extensionControllerViews)
    {
        UIButton *paneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *paneImage = pane.paneIcon;
        [paneButton setImage:paneImage forState:UIControlStateNormal];
        paneButton.frame = CGRectMake(0, MENU_BUTTON_SIZE * index, MENU_BUTTON_SIZE, MENU_BUTTON_SIZE);
        [extensionTabBar addSubview:paneButton];
        index++;
    }

    for (UIButton *button in [extensionTabBar subviews])
    {
        [button addTarget:self 
            action:@selector(handleExtensionTabBarButtonPress:)
            forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self
            action:@selector(buttonPressDown:)
            forControlEvents:UIControlEventTouchDown];
    }

    return extensionTabBar;

}
- (HPEditorViewNavigationTabBar *)defaultTabBar
{
    HPEditorViewNavigationTabBar *tabBar = [[HPEditorViewNavigationTabBar alloc] initWithFrame:CGRectMake(
                                        [[UIScreen mainScreen] bounds].size.width - 47.5,
                                         MENU_BUTTON_TOP_ANCHOR * [[UIScreen mainScreen] bounds].size.height,
                                         MENU_BUTTON_SIZE, MENU_BUTTON_SIZE*9)];

    UIButton *offsetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *offsetImage = [HPResources offsetImage];
    [offsetButton setImage:offsetImage forState:UIControlStateNormal];
    offsetButton.frame = CGRectMake(0,0, MENU_BUTTON_SIZE, MENU_BUTTON_SIZE);
    
    [tabBar addSubview:offsetButton];
    // Since the offset view will be the first loaded, we dont need to lower alpha
    //      on the button. 

    UIButton *spacerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *spacerImage = [HPResources spacerImage];
    [spacerButton setImage:spacerImage forState:UIControlStateNormal];

    spacerButton.frame = CGRectMake(0, 0 + MENU_BUTTON_SIZE, MENU_BUTTON_SIZE, MENU_BUTTON_SIZE);

    spacerButton.alpha = 0.5;
    
    [tabBar addSubview:spacerButton];

    UIButton *iconCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *iCImage = [HPResources iconCountImage];
    [iconCountButton setImage:iCImage forState:UIControlStateNormal];
    iconCountButton.frame = CGRectMake(0, 0 + MENU_BUTTON_SIZE * 2,  MENU_BUTTON_SIZE, MENU_BUTTON_SIZE);
    iconCountButton.alpha = 0.5;
    
    [tabBar addSubview:iconCountButton];

    UIButton *scaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *sImage = [HPResources scaleImage];
    [scaleButton setImage:sImage forState:UIControlStateNormal];
    scaleButton.frame = CGRectMake(0, 0 + MENU_BUTTON_SIZE * 3,  MENU_BUTTON_SIZE, MENU_BUTTON_SIZE);
    scaleButton.alpha = (0.5);

    [tabBar addSubview:scaleButton];
    
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *settingsImage = [HPResources settingsImage];
    [settingsButton setImage:settingsImage forState:UIControlStateNormal];
    settingsButton.frame = CGRectMake(0, 0 + MENU_BUTTON_SIZE * (4), MENU_BUTTON_SIZE, MENU_BUTTON_SIZE);
    settingsButton.alpha = 0.5;
    
    [tabBar addSubview:settingsButton];
    if (![[[EditorManager sharedManager] editingLocation] isEqualToString:@"SBIconLocationFolder"])
    {

        UIButton *rootButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *rootImage = [HPResources rootImage];
        [rootButton setImage:rootImage forState:UIControlStateNormal];
        rootButton.frame = CGRectMake(0, 0 + MENU_BUTTON_SIZE * 7, MENU_BUTTON_SIZE, MENU_BUTTON_SIZE);
        rootButton.alpha = 1;

        [tabBar addSubview:rootButton];

        UIButton *dockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *dockImage = [HPResources dockImage];
        [dockButton setImage:dockImage forState:UIControlStateNormal];
        dockButton.frame = CGRectMake(0, 0 + MENU_BUTTON_SIZE * 8,  MENU_BUTTON_SIZE, MENU_BUTTON_SIZE);
        dockButton.alpha = 0.5;

        [tabBar addSubview:dockButton];
    }
    else 
    {
        iconCountButton.enabled = NO;
    }
    for (UIButton *button in [tabBar subviews])
    {
        [button addTarget:self 
            action:@selector(handleDefaultBarTabButtonPress:)
            forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self
            action:@selector(buttonPressDown:)
            forControlEvents:UIControlEventTouchDown];
    }
    
    self.activeButton = offsetButton;

    return tabBar;
}
- (void)handleExtensionBarButtonPress:(UIButton *)button 
{
    NSUInteger index = [self.extensionBar.subviews indexOfObject:button];

    if (index <= 0 || [[[ExtensionManager sharedManager] extensions] count] == 0)
    {
        [self loadExtension:nil];
    }
    else 
    {
        [self loadExtension:[[ExtensionManager sharedManager] extensions][index-1]];
    }
}

- (void)loadExtension:(HPExtension *)extension 
{
    self.activeExtension = extension;
    [self reload];
    [self transitionViewsToActivationPercentage:1];
    int _ = 1;
    for (HPExtensionControllerView *controller in extension.extensionControllerViews)
    {
        controller.alpha = 0;
        if (_==1){controller.alpha=1.0;_=0;} // set the first controller to have a 1 alpha
        [self.view addSubview:controller];
    }

    [self.view bringSubviewToFront:self.tabBar];
    [self.view bringSubviewToFront:self.extensionBar];
}
- (void)handleExtensionTabBarButtonPress:(UIButton *)button 
{
    NSUInteger index = [self.tabBar.subviews indexOfObject:button];

    [self loadControllerView:self.activeExtension.extensionControllerViews[index]];

    self.activeButton.userInteractionEnabled = YES; 

    [UIView animateWithDuration:.2 
        animations:
        ^{
            button.alpha = 1;
        }
    ];

    self.activeButton = button;
    button.userInteractionEnabled = NO; 
}

- (void)handleDefaultBarTabButtonPress:(UIButton *)button
{
    NSUInteger index = [self.tabBar.subviews indexOfObject:button];

    if (index < 4)
    {
        [self loadControllerView:[self.homeTabControllerViews objectAtIndex:index]];
        self.activeButton.userInteractionEnabled = YES; 

        [UIView animateWithDuration:.2 
            animations:
            ^{
                self.activeButton.alpha = 0.5;
                button.alpha = 1;
            }
        ];

        self.activeButton = button;
        button.userInteractionEnabled = NO; 
    }
    else if (index == 4)
    {
        [self handleSettingsButtonPress:button];
    }
    else if (index == 5)
    {
        [self handleRootButtonPress:button];
    }
    else 
    {
        [self handleDockButtonPress:button];
    }
}

- (void)transitionViewsToActivationPercentage:(CGFloat)amount 
{
    CGFloat fullAmt = (([[UIScreen mainScreen] bounds].size.height) * 0.15);
    CGFloat topTranslation = 0-fullAmt + (amount * fullAmt);
    CGFloat bottomTranslation = fullAmt - (amount * fullAmt);
    self.activeView.topView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, topTranslation);
    self.activeView.bottomView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, bottomTranslation);
    self.tabBar.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, (50 - (50 * amount)), 0);
    self.extensionBar.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, (-50 + (50 * amount)), 0);
}

- (void)transitionViewsToActivationPercentage:(CGFloat)amount withDuration:(CGFloat)duration 
{
    [UIView animateWithDuration:duration
        animations:
        ^{  
            CGFloat fullAmt = (([[UIScreen mainScreen] bounds].size.height) * 0.15);
            CGFloat topTranslation = 0-fullAmt + (amount * fullAmt);
            CGFloat bottomTranslation = fullAmt - (amount * fullAmt);
            self.activeView.topView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, topTranslation);
            self.activeView.bottomView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, bottomTranslation);
            self.tabBar.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, (50 - (50 * amount)), 0);
            self.extensionBar.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, (-50 + (50 * amount)), 0);
        }
    ];
}
- (void)reload 
{
    [[HPManager sharedManager] saveCurrentLoadout];

    [[self.view subviews]
        makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _spacingControlView = nil;
    _offsetControlView = nil;
    _settingsView = nil;
    _iconCountControlView = nil;
    _scaleControlView = nil;

    [self viewDidLoad];
}
#pragma mark Editing Location
- (void)handleDockButtonPress:(UIButton*)sender
{
    if (self.tabBar.subviews[6].alpha == 1) return;
    AudioServicesPlaySystemSound(1519);
    [[EditorManager sharedManager] setEditingLocation:@"SBIconLocationDock"];
    [[HPManager sharedManager] saveCurrentLoadout];

    [[self.view subviews]
        makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _spacingControlView = nil;
    _offsetControlView = nil;
    _settingsView = nil;
    _iconCountControlView = nil;
    _scaleControlView = nil;

    // Reload views
    [self viewDidLoad];

    self.tabBar.subviews[5].alpha = 0.5;
    self.tabBar.subviews[6].alpha = 1;

    [[NSNotificationCenter defaultCenter] postNotificationName:kHighlightViewNotificationName object:nil];
}
- (void)handleRootButtonPress:(UIButton*)sender
{
    if (self.tabBar.subviews[5].alpha == 1) return;
    AudioServicesPlaySystemSound(1519);
    [[EditorManager sharedManager] setEditingLocation:@"SBIconLocationRoot"];
    [[HPManager sharedManager] saveCurrentLoadout];
    [[self.view subviews]
        makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _spacingControlView = nil;
    _offsetControlView = nil;
    _settingsView = nil;
    _iconCountControlView = nil;
    _scaleControlView = nil;

    // Reload views
    [self viewDidLoad];

    self.tabBar.subviews[5].alpha = 1;
    self.tabBar.subviews[6].alpha = 0.5;

    [[NSNotificationCenter defaultCenter] postNotificationName:kHighlightViewNotificationName object:nil];
}

- (void)handleSaveButtonPress:(UIButton*)sender
{
    [[[HPDataManager sharedManager] currentConfiguration] saveConfigurationToFile];
}
- (void)handleCancelButtonPress:(UIButton*)sender
{
    [[[HPDataManager sharedManager] currentConfiguration] loadConfigurationFromFile];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HPlayoutIconViews" object:nil];
    [self reload];
}
- (void)handleLoadoutButtonPress:(UIButton*)sender
{
    NSLog(@"and i oop");
}
#pragma mark Settings View

- (HPControllerView *)settingsView 
{
    // settings table controller hacked into the usual hpcontrollerview model we use. 
    // top view is the entire controller, bottom view is the header. 
    if (!_settingsView) 
    {
        _settingsView = [[HPControllerView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIView *settingsContainerView = self.tableViewController.view;
        _settingsView.topView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [_settingsView.topView addSubview:settingsContainerView];
        [_settingsView addSubview:_settingsView.topView];

        UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,(([[UIScreen mainScreen] bounds].size.width)/750)*300)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,(([[UIScreen mainScreen] bounds].size.width)/750)*300)];

        imageView.image = [EditorManager sharedManager].dynamicallyGeneratedSettingsHeaderImage;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [tableHeaderView addSubview:imageView];

        UIView *doneButtonContainerView = [[UIView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-80, ((([[UIScreen mainScreen] bounds].size.width)/750)*300)-40, [[UIScreen mainScreen] bounds].size.width/2, 40)];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self 
                action:@selector(handleDoneSettingsButtonPress:)
        forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Done" forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 80, 40);
        [doneButtonContainerView addSubview:button];
        _settingsView.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,(TABLE_HEADER_HEIGHT*[[UIScreen mainScreen] bounds].size.width))];
        [_settingsView.bottomView addSubview:doneButtonContainerView];
        
        [_settingsView.topView addSubview:tableHeaderView];
        [_settingsView addSubview:_settingsView.bottomView];
    }
    _settingsView.hidden = NO;
    _settingsView.alpha = 0;
    return _settingsView;
}

- (HPSettingsTableViewController *)tableViewController
{
    if (!_tableViewController) 
    {
        _tableViewController = [[HPSettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    return _tableViewController;
}

#pragma mark - Controller Views

- (HPControllerView *)offsetControlView 
{
    if (!_offsetControlView) 
    {
        _offsetControlView = [[HPOffsetControllerView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _offsetControlView.alpha = 0;
    }
    return _offsetControlView;
}

- (HPControllerView *)spacingControlView
{
    if (!_spacingControlView) 
    {
        _spacingControlView = [[HPSpacingControllerView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _spacingControlView.alpha = 0;
    }
    return _spacingControlView;
}

- (HPControllerView *)iconCountControlView
{
    if (!_iconCountControlView) 
    {
        _iconCountControlView = [[HPIconCountControllerView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _iconCountControlView.alpha = 0;
    }
    return _iconCountControlView;
}

- (HPControllerView *)scaleControlView 
{
    if (!_scaleControlView) 
    {
        _scaleControlView = [[HPScaleControllerView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _scaleControlView.alpha = 0;
    }
    return _scaleControlView;
}

- (void)addRootIconListViewToUpdate:(SBRootIconListView *)view
{
    if (!self.rootIconListViewsToUpdate) 
    {
        self.rootIconListViewsToUpdate = [[NSMutableArray alloc] init];
    }
    [self.rootIconListViewsToUpdate addObject:view];
}

- (void)resetAllValuesToDefaults 
{
    [[HPManager sharedManager] resetCurrentLoadoutToDefaults];
}

#pragma mark Button Handlers

- (void)handleSettingsButtonPress:(UIButton*)sender
{
    if (![[[EditorManager sharedManager] editingLocation] isEqualToString:@"SBIconLocationFolder"])
        [self handleRootButtonPress:self.rootButton];
    [[HPManager sharedManager] saveCurrentLoadoutName];
    [[HPManager sharedManager] saveCurrentLoadout];
    [[HPManager sharedManager] loadCurrentLoadout]; // Will Save + Load

    [self loadControllerView:[self settingsView]];
    self.activeButton.userInteractionEnabled = YES; 

    [[NSNotificationCenter defaultCenter] postNotificationName:kFadeFloatingDockNotificationName object:nil];
    [UIView animateWithDuration:.2 
        animations:
        ^{
            self.tabBar.alpha = 0;
            self.extensionBar.alpha = 0;
        }
    ];
    [[self tableViewController] opened];

    self.activeButton = sender;
}
- (void)handleDoneSettingsButtonPress:(UIButton*)sender
{
    [UIView animateWithDuration:.2 
        animations:
        ^{
            _settingsView.alpha = 0.0;
            self.tabBar.alpha = 1;
            self.extensionBar.alpha = 1;
        }
    ];
    [self handleDefaultBarTabButtonPress:[self tabBar].subviews[0]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowFloatingDockNotificationName object:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"HPResetIconViews" object:nil];
}

- (void)resignAllTextFields
{
    // TODO: THIS
}

- (void)loadControllerView:(HPControllerView *)arg1 
{
    [self resignAllTextFields];
    AudioServicesPlaySystemSound(1519);

    [UIView animateWithDuration:.2 
        animations:
        ^{
            self.activeView.alpha = 0;
            arg1.alpha = 1;
        }
    ];
    

    self.activeView = arg1;
    [self transitionViewsToActivationPercentage:1];
}

#pragma mark Springboard Layout Updates 

- (void)layoutAllSpringboardIcons
{
    for (SBRootIconListView *view in self.rootIconListViewsToUpdate) 
    {
        [view layoutIconsNow];
        for (UIView *icon in [view allSubviews]) 
        {
            [icon layoutSubviews];
        }
    }
}

- (void)viewWillTransitionToSize:(CGSize)size 
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self reload];
}

#pragma mark UIViewController overrides

- (BOOL)shouldAutorotate 
{
    return [HPUtility deviceRotatable];
}


@end
