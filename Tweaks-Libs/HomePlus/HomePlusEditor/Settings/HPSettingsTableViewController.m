//
// HPSettingsTableViewController.m
// HomePlus
//
// Settings (UITable)View Controller. Load stuff and call changes here. 
//
// Created Oct 2019
// Author: Kritanta
//


#include "HPSettingsTableViewController.h"
#include <UIKit/UIKit.h>
#include "EditorManager.h"
#include "HPResources.h"
#include "HPUtility.h"
#include "HPManager.h"
#include "HPTableCell.h"
#include "HPDataManager.h"
#include "spawn.h"

const int RESET_VALUES = 1;

#pragma mark UIViewController

@implementation HPSettingsTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        self.title = @"HomePlus Settings";
    }
    return self;
}

- (void)opened
{
    [self.tableView reloadData];
    //[[tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].accessoryView ]
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    CGFloat topPadding = statusBarSize.height;

    //CGFloat bottomPadding = window.safeAreaInsets.bottom;
    
    //self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y+topPadding, self.tableView.frame.size.width, self.tableView.frame.size.height-topPadding);

    //self.tableView.bounds = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y+topPadding, self.tableView.frame.size.width, self.tableView.frame.size.height-topPadding);
    UIView *bg = [[UIView alloc] init];
    if (!UIAccessibilityIsReduceTransparencyEnabled()) 
    {
        bg.backgroundColor = [UIColor clearColor];

        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //always fill the view
        blurEffectView.frame = self.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        [bg addSubview:blurEffectView]; //if you have more UIViews, use an insertSubview API to place it where needed
    } 
    else 
    {
        bg.backgroundColor = [UIColor blackColor];
    }

    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,(([[UIScreen mainScreen] bounds].size.width)/750)*300-topPadding-20)];
    self.tableView.tableHeaderView = tableHeaderView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = bg;


    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    NSDictionary *attributes = @{
                                 NSUnderlineStyleAttributeName: @0,
                                 NSForegroundColorAttributeName : [UIColor whiteColor],
                                 NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:17]
                                 };
    [self.navigationController.navigationBar setTitleTextAttributes: attributes];


    [self.tableView setTableFooterView:[self customTableFooterView]];
    [self.tableView registerClass:[HPTableCell class] forCellReuseIdentifier:@"Cell"];
}

-(UIView *)customTableFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,10+(([[UIScreen mainScreen] bounds].size.width)/750)*300)];

    UILabel *dInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,0,[[UIScreen mainScreen] bounds].size.width, 10)];
    NSString *DN = [HPUtility deviceName];
    NSString *CF = [NSString stringWithFormat:@"%0.3f", kCFCoreFoundationVersionNumber];
    NSString *FV = [NSString stringWithFormat:@"%@ %@", [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
    dInfoLabel.text = [NSString stringWithFormat:@"Device: %@ | Firmware: %@ | CFVersion: %@", DN, FV, CF];
    [dInfoLabel setFont:[UIFont systemFontOfSize:10.0]];
    [footerView addSubview:dInfoLabel];

    UIImage *myImage = [HPResources inAppFooter];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
    imageView.frame = CGRectMake(0,10,[[UIScreen mainScreen] bounds].size.width,(([[UIScreen mainScreen] bounds].size.width)/750)*300);
    [footerView addSubview:imageView];
    
    //consts
    CGFloat firstButtonLeftOffset = (([[UIScreen mainScreen] bounds].size.width/375) * 120);
    CGFloat buttonWidth = (([[UIScreen mainScreen] bounds].size.width/375) * 60);

    UIButton *patreonButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [patreonButton addTarget:self 
                action:@selector(handlePatreonButtonPress:)
        forControlEvents:UIControlEventTouchUpInside];
        [patreonButton setTitle:@"" forState:UIControlStateNormal];
        patreonButton.frame = CGRectMake(firstButtonLeftOffset, 36, buttonWidth, 80);
        [footerView addSubview:patreonButton];

    UIButton *discordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [discordButton addTarget:self 
                action:@selector(handleDiscordButtonPress:)
        forControlEvents:UIControlEventTouchUpInside];
        [discordButton setTitle:@"" forState:UIControlStateNormal];
        discordButton.frame = CGRectMake(firstButtonLeftOffset+(buttonWidth), 36, buttonWidth, 80);
        [footerView addSubview:discordButton];

    UIButton *twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [twitterButton addTarget:self 
                action:@selector(handleTwitterButtonPress:)
        forControlEvents:UIControlEventTouchUpInside];
        [twitterButton setTitle:@"" forState:UIControlStateNormal];
        twitterButton.frame = CGRectMake(firstButtonLeftOffset+(buttonWidth*2), 36, buttonWidth, 80);
        [footerView addSubview:twitterButton];

    UIButton *sourceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sourceButton addTarget:self 
                action:@selector(handleSourceButtonPress:)
        forControlEvents:UIControlEventTouchUpInside];
        [sourceButton setTitle:@"" forState:UIControlStateNormal];
        sourceButton.frame = CGRectMake(firstButtonLeftOffset+(buttonWidth*3), 36, buttonWidth, 80);
        [footerView addSubview:sourceButton];

    return footerView;
}


- (void)handlePatreonButtonPress:(UIButton*)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.patreon.com/kritantadev"] options:@{} completionHandler:nil];
}

- (void)handleDiscordButtonPress:(UIButton*)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://discord.gg/E9YWU3m"] options:@{} completionHandler:nil];
}

- (void)handleTwitterButtonPress:(UIButton*)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://twitter.com/_kritanta"] options:@{} completionHandler:nil];
}

- (void)handleSourceButtonPress:(UIButton*)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/KritantaDev/HomePlus"] options:@{} completionHandler:nil];
}

#pragma mark - 


- (void)donePressed:(id)sender
{
    //[self.delegate globalsViewControllerDidFinish:self];
}

#pragma mark Table Data Helpers

- (NSString *)titleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = @"";
    switch ( indexPath.section )
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    title = [HPUtility localizedItem:@"FORCE_ROTATION"];
                    break;
                }
            }
            break;
        }
        case 1:
        {
            switch ( indexPath.row )
            {
                case 0:
                {
                    title = [HPUtility localizedItem:@"HIDE_ICON_LABELS"];
                    break;
                }
                case 1:
                {
                    title = [HPUtility localizedItem:@"HIDE_BADGES"];
                    break;
                }
                case 2:
                {
                    title = [HPUtility localizedItem:@"HIDE_LABELS_FOLDERS"];
                    break;
                }
            }
            break;
        }
        case 2:
        {
            switch ( indexPath.row )
            {
                case 0:
                {
                    title = [HPUtility localizedItem:@"DOCK_CONFIG_ENABLED"];
                    break;
                }
                case 1:
                {
                    title = [HPUtility localizedItem:@"HIDE_DOCK_BG"];
                    break;
                }
                case 2:
                {
                    title = [HPUtility localizedItem:@"FORCE_IPX_DOCK"];
                    break;
                }
            }
            break;
        }
        case 3:
        {
            switch ( indexPath.row )
            {
                case 0:
                {
                    title = [HPUtility localizedItem:@"RESET_VALUES"];
                    break;
                }
                case 1:
                {
                    title = [HPUtility localizedItem:@"APP_SWITCHER_DISABLES_EDITOR"];
                    break;
                }
                case 2:
                {
                    title = [HPUtility localizedItem:@"RESPRING"];
                    break;
                }
            }
            break;
        }
    }

    return title;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    switch ( section ) 
    {
        case 0:
        {
            rows = 1;
            break;
        }
        case 1: // Icons
        {
            rows = 3;
            break;
        }
        case 2: // Dock
        {
            rows = 3;
            break;
        }
        case 3: // Settings
        {
            rows = 3;
            break;
        }
    }
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{

    NSString *sectionName;
    switch (section) 
    {
        case 0:
            sectionName = [HPUtility localizedItem:@"HOMESCREEN"];
            break;
        case 1:
            sectionName = [HPUtility localizedItem:@"ICONS"];
            break;
        case 2:
            sectionName = [HPUtility localizedItem:@"DOCK"];
            break;
        case 3:
            sectionName = [HPUtility localizedItem:@"SETTINGS"];
            break;
        default:
            sectionName = @"";
            break;
    }    
    return sectionName;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.tableView) {
            CGFloat cornerRadius = 15.f;
            cell.backgroundColor = [UIColor clearColor];
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 0, 0);
            BOOL addLine = NO;
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            } else if (indexPath.row == 0) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            } else {
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            layer.path = pathRef;
            CFRelease(pathRef);
            layer.fillColor = [UIColor colorWithRed:10.0/255.0 green:10.0/255.0 blue:10.0/255.0 alpha:0.4].CGColor;

            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                [layer addSublayer:lineLayer];
            }
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
        }
    }
}
- (BOOL)storedStateForSwitchAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = @"";

    switch ( indexPath.section )
    {
        case 0:
        {
            switch ( indexPath.row )
            {
                case 0:
                {
                    key = @"HPThemeDefaultForceRotation";
                    break;
                }
            }
            break;
        }
        case 1:
        {
            switch ( indexPath.row )
            {
                case 0:
                {
                    key = @"HPThemeDefaultIconLabels";
                    break;
                }
                case 1:
                {
                    key = @"HPThemeDefaultIconBadges";
                    break;
                }
                case 2:
                {
                    key = @"HPThemeDefaultIconLabelsF";
                    break;
                }
            }
            break;
        }
        case 2:
        {
            switch ( indexPath.row )
            {
                case 0:
                {
                    key = @"HPdockConfigEnabled";
                    break;
                }
                case 1:
                {
                    key = @"HPThemeDefaultHideDock";
                    break;
                }
                case 2:
                {
                    key = @"HPThemeDefaultModernDock";
                    break;
                }
            }
            break;
        }
        case 3:
        {
            switch ( indexPath.row )
            {
                case 0:
                {
                    key = @"";
                    break;
                }
                case 1:
                {
                    return [[HPManager sharedManager] switcherDisables];
                    break;
                }
                case 2:
                {
                    key = @"";
                    break;
                }
            }
            break;
        }
    }

    return [[[HPDataManager sharedManager] currentConfiguration] objectForKey:key] 
                ? [[[HPDataManager sharedManager] currentConfiguration] boolForKey:key]
                : NO;
}



- (HPTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3 && (indexPath.row == 0 || indexPath.row == 2))
    {   // Clickable Cells
        static NSString *CellIdentifier = @"Cell";
        HPTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) 
        {
            cell = [[HPTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        }
        
        cell.textLabel.text = [self titleForRowAtIndexPath:indexPath];
        
        //[cell.layer setCornerRadius:10];

        [cell setBackgroundColor: [UIColor colorWithRed:10.0/255.0 green:10.0/255.0 blue:10.0/255.0 alpha:0.4]];//rgb(38, 37, 42)];
        //Border Color and Width
        [cell.layer setBorderColor:[UIColor blackColor].CGColor];
        [cell.layer setBorderWidth:0];

        //Set Text Col
        cell.textLabel.textColor = [UIColor whiteColor];//[prefs colorForKey:@"textTint"];
        cell.detailTextLabel.textColor = [UIColor whiteColor];//[prefs colorForKey:@"textTint"];

        cell.clipsToBounds = YES;
        cell.hidden = NO;
        return cell;
    }
    else 
    {   // Switch Cells
        HPTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        if( cell == nil ) 
        {
            cell = [[HPTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"SwitchCell"];
            cell.textLabel.text = [self titleForRowAtIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.accessoryView = switchView;
            [switchView setOn:[self storedStateForSwitchAtIndexPath:indexPath] animated:NO];
            [switchView addTarget:self action:[self selectorForIndexPath:indexPath] forControlEvents:UIControlEventValueChanged];

            //[cell.layer setCornerRadius:10];

            [cell setBackgroundColor: [UIColor colorWithRed:10.0/255.0 green:10.0/255.0 blue:10.0/255.0 alpha:0.4]];//rgb(38, 37, 42)];
            //Border Color and Width
            [cell.layer setBorderColor:[UIColor blackColor].CGColor];
            [cell.layer setBorderWidth:0];

            //Set Text Col
            cell.textLabel.textColor = [UIColor whiteColor];//[prefs colorForKey:@"textTint"];
            cell.detailTextLabel.textColor = [UIColor whiteColor];//[prefs colorForKey:@"textTint"];

            cell.clipsToBounds = YES;
        }
        return cell;
    }
    

    return nil;
}
- (SEL)selectorForIndexPath:(NSIndexPath *)indexPath
{
    switch ( indexPath.section )
    {
        case 0:
        {
            switch ( indexPath.row )
            {
                case 0:
                {
                    return @selector(forceRotationSwitchChanged:);
                    break;
                }
            }
            break;
        }
        case 1:
        {
            switch ( indexPath.row )
            {
                case 0:
                {
                    return @selector(iconLabelSwitchChanged:);
                    break;
                }
                case 1:
                {
                    return @selector(iconBadgeSwitchChanged:);
                    break;
                }
                case 2:
                {
                    return @selector(iconLabelFolderSwitchChanged:);
                    break;
                }
            }
            break;
        }
        case 2:
        {
            switch ( indexPath.row )
            {
                case 0:
                {
                    return @selector(dockConfigSwitchChanged:);
                    break;
                }
                case 1:
                {
                    return @selector(dockbGSwitchChanged:);
                    break;
                }
                case 2:
                {
                    return @selector(modernDockSwitchChanged:);
                    break;
                }
            }
            break;
        }
        case 3:
        {
            switch ( indexPath.row )
            {
                case 0:
                {
                    return nil;
                    break;
                }
                case 1:
                {
                    return @selector(switcherSwitchChanged:);
                    break;
                }
                case 2:
                {
                    return nil;
                    break;
                }
            }
            break;
        }
    }
    return nil;
}

#pragma mark - Table View Data Source


- (void)storageControlAction:(UISegmentedControl *)segment 
{
    if (segment.selectedSegmentIndex == 0) {
    }
    else 
    {

    }
}
- (void)forceRotationSwitchChanged:(UISwitch *)sender
{
    [[[HPDataManager sharedManager] currentConfiguration] setBool:sender.on
                    forKey:@"HPThemeDefaultForceRotation"];
}
- (void)dockConfigSwitchChanged:(UISwitch *)sender
{
    [[[HPDataManager sharedManager] currentConfiguration] setBool:sender.on
                    forKey:@"HPdockConfigEnabled"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HPResetIconViews" object:nil];
}
- (void)switcherSwitchChanged:(id)sender 
{
    UISwitch *switchControl = sender;
    [[HPManager sharedManager] setSwitcherDisables:switchControl.on];
}

- (void)vRowSwitchChanged:(id)sender 
{
    UISwitch *switchControl = sender;
    [[HPManager sharedManager] setVRowUpdates:switchControl.on];
}

- (void)dockbGSwitchChanged:(id)sender 
{
    UISwitch *switchControl = sender;
    [[[HPDataManager sharedManager] currentConfiguration] setBool:switchControl.on
                    forKey:[NSString stringWithFormat:@"%@%@", @"HPThemeDefault", @"HideDock"] ];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HPLayoutDockView" object:nil];
}

- (void)modernDockSwitchChanged:(id)sender 
{
    UISwitch *switchControl = sender;
    [[[HPDataManager sharedManager] currentConfiguration] setBool:switchControl.on
                    forKey:[NSString stringWithFormat:@"%@%@", @"HPThemeDefault", @"ModernDock"] ];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HPLayoutDockView" object:nil];
}

- (void)iconLabelSwitchChanged:(id)sender 
{
    UISwitch *switchControl = sender;
    [[[HPDataManager sharedManager] currentConfiguration] setBool:switchControl.on
                    forKey:[NSString stringWithFormat:@"%@%@", @"HPThemeDefault", @"IconLabels"] ];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HPResetIconViews" object:nil];
}

- (void)iconBadgeSwitchChanged:(id)sender 
{
    UISwitch *switchControl = sender;
    [[[HPDataManager sharedManager] currentConfiguration] setBool:switchControl.on
                    forKey:[NSString stringWithFormat:@"%@%@", @"HPThemeDefault", @"IconBadges"] ];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HPResetIconViews" object:nil];
}

- (void)iconLabelFolderSwitchChanged:(id)sender 
{
    UISwitch *switchControl = sender;
    [[[HPDataManager sharedManager] currentConfiguration] setBool:switchControl.on
                    forKey:[NSString stringWithFormat:@"%@%@", @"HPThemeDefault", @"IconLabelsF"] ];}

#pragma mark - Table View Delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) 
    {
        case 3: 
        {
            switch (indexPath.row) 
            {
                case 0: 
                {
                    UIAlertController * alert = [UIAlertController
                                    alertControllerWithTitle:[HPUtility localizedItem:@"THIS_WILL_RESET"]
                                                    message:[HPUtility localizedItem:@"ARE_YOU_SURE_RESET"]
                                            preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Yes"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                                                    [[[HPDataManager sharedManager] currentConfiguration] setInteger:0 forKey:@"HPTutorialGiven"];
                                                    [[[HPDataManager sharedManager] currentConfiguration] saveConfigurationToFile];
                                                    pid_t pid;
                                                    const char* args[] = {"killall", "backboardd", NULL};
                                                    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
                                                }];

                    UIAlertAction* noButton = [UIAlertAction
                                            actionWithTitle:@"No"
                                                    style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                    //Handle no, thanks button                
                                                    }];

                    [alert addAction:yesButton];
                    [alert addAction:noButton];

                    [self presentViewController:alert animated:YES completion:nil];
                    break;
                }
                case 2: 
                {
                    [[HPManager sharedManager] saveCurrentLoadoutName];
                    [[HPManager sharedManager] saveCurrentLoadout];
                    [[[HPDataManager sharedManager] currentConfiguration] saveConfigurationToFile];
                    pid_t pid;
                    int status;
                    const char *args[] = {"sbreload", NULL, NULL, NULL};
                    posix_spawn(&pid, "usr/bin/sbreload", NULL, NULL, (char *const *)args, NULL);
                    waitpid(pid, &status, WEXITED);
                    break;
                }
            }
            break;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor clearColor];

    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];

    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}

@end
