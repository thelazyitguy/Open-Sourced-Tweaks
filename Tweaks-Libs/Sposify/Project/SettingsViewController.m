#import "SettingsViewController.h"
#import "SettingsUsecase.h"
#import "ColorForHex.h"
#import "UIViewController+SendMail.h" 
#import <AudioToolbox/AudioToolbox.h>
#import "ViewController.h"

enum{ 
    kHomeSection = 0,
    kLibrarySection,
    kNowPlayingAdditionsSection,
    kNowPlayingViewAnnoyancesSection, 
    kSupportSection,
    kSectionsCount,
};

//rows

//Home Section
enum {
    kHomeFeature1 = 0,
    kHomeFeature2,
    kHomeFeature3,
    kHomeFeature4,
    kHomeFeature5,
    kHomeRowsCount,
};

//Your Library Section
enum{
    kLibraryFeature1 = 0,
    kLibraryFeature2,
    kLibraryFeature3,
    kLibraryFeature4,
    kLibraryFeature5,
    kLibraryFeature6,
    kLibraryFeature7,
    kLibraryFeature8, 
    kLibraryRowsCount,
};

//Now Playing View Section
enum {
    kNowPlayingAdditionsFeature1 = 0,
    kNowPlayingAdditionsFeature2,
    kNowPlayingAdditionsFeature3,
    kNowPlayingAdditionsFeature4,
    kNowPlayingAdditionsFeature5,
    kNowPlayingAdditionsFeature6,
    kNowPlayingAdditionsFeature7,
    kNowPlayingAdditionsFeature8,
    kNowPlayingAdditionsFeature9, 
    kNowPlayingAdditionsRowsCount,
};

//Now Playing View Anooyances Section
enum {
    kNowPlayingViewAnnoyancesFeature1 = 0,
    kNowPlayingViewAnnoyancesFeature2,
    kNowPlayingViewAnnoyancesFeature3,
    kNowPlayingViewAnnoyancesFeature4,
    kNowPlayingViewAnnoyancesFeature5,
    kNowPlayingViewAnnoyancesRowsCount,
}; 

//Support Section
enum {
    kSupportHelpFAQ = 0,
    kSupportReportaBug, 
    kSupportRowsCount,
};


@interface SettingsViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *FeaturesTableView;
@property (nonatomic, strong) UIImageView *expandImageView;
@end

@implementation SettingsViewController
-(BOOL)prefersHomeIndicatorAutoHidden{
   return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Sposify";
    [self setupTableView];

    UIImage *SettingsIcon = [UIImage imageForSPTIcon:48 size:CGSizeMake(20, 20)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:SettingsIcon
                                                                    style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(dismissTable:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    // Stops rotation.
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    

    if (section == kSupportSection) {
      if (row == kSupportReportaBug) {
    SFSafariViewController *safariVC = [[SFSafariViewController alloc]
        initWithURL:[NSURL URLWithString:@"https://github.com/MindfulOutlet/Sposify/issues"]]; 
    if (@available(iOS 13, *)) {
        safariVC.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [self presentViewController:safariVC animated:YES completion:nil];
} 
        else if (row == kSupportHelpFAQ) {
                 [self sendMailWithDelegate:self subject:@"Sposify Support" toRecipients:@[@"aesthyrica@gmail.com"] ccRecipients:@[] bccRecipients:@[] result:^(MFMailComposeResult result) {
         }];

        }
    }
}


- (void)dismissTable:(id)sender
{
    // Create the Button to Dismiss the TableView.
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleLight];
    [generator prepare];
    [generator impactOccurred];
    [self dismissViewControllerAnimated:true completion:nil];
}



#pragma mark - Navigation Bar Target action
-(void)selectRightAction:(id)sender
{

}

- (void)setupTableView {

    self.FeaturesTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.FeaturesTableView.delegate = self;
    self.FeaturesTableView.dataSource = self;
    self.FeaturesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.FeaturesTableView setBackgroundColor:[UIColor colorWithHexString:@"#121212"]];
    [self.view addSubview:self.FeaturesTableView];
    self.FeaturesTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.FeaturesTableView setContentInset:UIEdgeInsetsMake(0, 0, -60, 0)];

    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#121212"]];
    [self.navigationController.navigationBar setTranslucent:false];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]])
    {
        // Create Header for sections.
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        tableViewHeaderFooterView.textLabel.font = [UIFont fontWithName:@"CircularSpUIm40-Bold" size:24];
        tableViewHeaderFooterView.textLabel.text = [tableViewHeaderFooterView.textLabel.text capitalizedString];
        tableViewHeaderFooterView.textLabel.textColor = [UIColor whiteColor];
        CGRect headerFrame = tableViewHeaderFooterView.frame;
        tableViewHeaderFooterView.textLabel.frame = headerFrame;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    if([view isKindOfClass:UITableViewHeaderFooterView.class]) {
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        header.textLabel.textColor = [UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil].textColor;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return kSectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section. 
    if (section == kHomeSection) {
        return kHomeRowsCount;
    } 
    else if (section == kLibrarySection) {
        return kLibraryRowsCount;
    }
    else if (section == kNowPlayingAdditionsSection) {
        return kNowPlayingAdditionsRowsCount;
    }
    else if (section == kNowPlayingViewAnnoyancesSection) {
        return kNowPlayingViewAnnoyancesRowsCount;
    }
    else if (section == kSupportSection) {
        return kSupportRowsCount;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;

    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FeatureCell"];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SubCell"];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:@"CircularSpUI-Book" size:15];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#121212"];

    // Configure the cell... 
    if (section == kHomeSection) {
        if (row == kHomeFeature1) {
            cell.textLabel.text = @"Connect Access Button";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].ConnectAccessButtonEnabled;
            [switchView addTarget:self action:@selector(ConnectAccessButtonSwitchChanged:) forControlEvents:UIControlEventValueChanged];

        }
        else if (row == kHomeFeature2) {
            cell.textLabel.text = @"Import Your Music";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].ImportYourMusicEnabled;
            [switchView addTarget:self action:@selector(ImportYourMusicSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if (row == kHomeFeature3) {
            cell.textLabel.text = @"Voice Search";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].VoiceSearchEnabled;
            [switchView addTarget:self action:@selector(VoiceSearchSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if (row == kHomeFeature4) {
            cell.textLabel.text = @"Verified Profile Badge";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].VerifiedProfileBadgeEnabled;
            [switchView addTarget:self action:@selector(VerifiedProfileBadgeSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if (row == kHomeFeature5) {
            cell.textLabel.text = @"No Burger Menu icon on Lockscreen";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].NoBurgerButtonOnLockscreenEnabled;
            [switchView addTarget:self action:@selector(NoBurgerButtonOnLockscreenSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }    
    } 

        else if (section == kLibrarySection) {
        if (row == kLibraryFeature1) {
            cell.textLabel.text = @"Show Album & Artist Recommendations";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].ShowAlbumArtistRecommendationsEnabled;
            [switchView addTarget:self action:@selector(ShowAlbumArtistRecommendationsSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }    
        else if (row == kLibraryFeature2) {
            cell.textLabel.text = @"Create Playlist New Interface";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].CreatePlaylistNewInterfaceEnabled;
            [switchView addTarget:self action:@selector(CreatePlaylistNewInterfaceSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if (row == kLibraryFeature3) {
            cell.textLabel.text = @"Open Canvas Playlist";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].OpenCanvasPlaylistEnabled;
            [switchView addTarget:self action:@selector(OpenCanvasPlaylistSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if (row == kLibraryFeature4) {
            cell.textLabel.text = @"True Shuffle";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].TrueShuffleEnabled;
            [switchView addTarget:self action:@selector(TrueShuffleSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if (row == kLibraryFeature5) {
            cell.textLabel.text = @"No Shuffle on Big Play Button";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].DisableShufflePlayButtonEnabled;
            [switchView addTarget:self action:@selector(DisableShufflePlayButtonSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if (row == kLibraryFeature6) {
            cell.textLabel.text = @"Hide Create Playlist";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].HideCreatePlaylistEnabled;
            [switchView addTarget:self action:@selector(HideCreatePlaylistSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if (row == kLibraryFeature7) {
            cell.textLabel.text = @"Old Artists & Playlists Interface";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].OldArtistsPlaylistsInterfaceEnabled;
            [switchView addTarget:self action:@selector(OldArtistsPlaylistsInterfaceSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if (row == kLibraryFeature8) {
            cell.textLabel.text = @"View Artists Offline";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].ViewArtistsOfflineEnabled;
            [switchView addTarget:self action:@selector(ViewArtistsOfflineSwitchChanged:) forControlEvents:UIControlEventValueChanged]; 
        }    
    }
    
    else if (section == kNowPlayingAdditionsSection) {
        if (row == kNowPlayingAdditionsFeature1) {
            cell.textLabel.text = @"Align Text to Top";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].AlignTextToTopEnabled;
            [switchView addTarget:self action:@selector(AlignTextToTopSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if (row == kNowPlayingAdditionsFeature2) {
            cell.textLabel.text = @"Auto Hide Duration Labels";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].AutoHideDurationLabelsEnabled;
            [switchView addTarget:self action:@selector(AutoHideDurationLabelsSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }     
        else if (row == kNowPlayingAdditionsFeature3) {
            cell.textLabel.text = @"Blackout Mode";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].BlackoutModeEnabled;
            [switchView addTarget:self action:@selector(BlackoutModeSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }     
        else if (row == kNowPlayingAdditionsFeature4) {
            cell.textLabel.text = @"Canvas Choice Button";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].CanvasChoiceButtonEnabled;
            [switchView addTarget:self action:@selector(CanvasChoiceButtonSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if (row == kNowPlayingAdditionsFeature5) {
            cell.textLabel.text = @"Canvas Tap";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].CanvasTapEnabled;
            [switchView addTarget:self action:@selector(CanvasTapSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if (row == kNowPlayingAdditionsFeature6) {
            cell.textLabel.text = @"Car View";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].CarViewEnabled;
            [switchView addTarget:self action:@selector(CarViewSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if (row == kNowPlayingAdditionsFeature7) {
            cell.textLabel.text = @"Show Statusbar";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].ShowStatusBarEnabled;
            [switchView addTarget:self action:@selector(ShowStatusBarSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if (row == kNowPlayingAdditionsFeature8) {
            cell.textLabel.text = @"Realtime Lyrics Button";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].RealtimeLyricsButtonEnabled;
            [switchView addTarget:self action:@selector(RealtimeLyricsButtonSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if (row == kNowPlayingAdditionsFeature9) {
            cell.textLabel.text = @"Realtime Lyrics Popup";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].RealtimeLyricsPopupEnabled;
            [switchView addTarget:self action:@selector(RealtimeLyricsPopupSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        } 
    }

    else if (section == kNowPlayingViewAnnoyancesSection) {
        if (row == kNowPlayingViewAnnoyancesFeature1) {
            cell.textLabel.text = @"Disable Genius Lyrics";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].DisableGeniusLyricsEnabled;
            [switchView addTarget:self action:@selector(DisableGeniusLyricsSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if (row == kNowPlayingViewAnnoyancesFeature2) {
            cell.textLabel.text = @"Disable Storylines";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].DisableStorylinesEnabled;
            [switchView addTarget:self action:@selector(DisableStorylinesSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }     
        else if (row == kNowPlayingViewAnnoyancesFeature3) {
            cell.textLabel.text = @"Disable Canvas";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].DisableCanvasEnabled;
            [switchView addTarget:self action:@selector(DisableCanvasSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if (row == kNowPlayingViewAnnoyancesFeature4) {
            cell.textLabel.text = @"Disable Queue Screen Controls";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].DisableQueueScreenControlsEnabled;
            [switchView addTarget:self action:@selector(DisableQueueScreenControlsSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if (row == kNowPlayingViewAnnoyancesFeature5) {
            cell.textLabel.text = @"Disable Social Listening Section";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.on = [SettingsUsecase sharedUsecase].DisableSocialListeningSectionEnabled;
            [switchView addTarget:self action:@selector(DisableSocialListeningSectionSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        } 
    } 

    else if (section == kSupportSection) {
        if (row == kSupportHelpFAQ) {
            cell.textLabel.text = @"Help FAQ";
            UIImage *Contact = [UIImage imageForSPTIcon:96 size:CGSizeMake(20, 20)];
            cell.imageView.image = Contact;
        }
        else if (row == kSupportReportaBug) {
            cell.textLabel.text = @"Report a bug";
            UIImage *Contact = [UIImage imageForSPTIcon:17 size:CGSizeMake(20, 20)];
            cell.imageView.image = Contact;
        } 
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == kLibrarySection) {
        return NSLocalizedString(@"Your Library Additions", nil);
    } else if (section == kNowPlayingAdditionsSection) {
        return NSLocalizedString(@"Now Playing View Additions", nil);
    } else if (section == kNowPlayingViewAnnoyancesSection) {
        return NSLocalizedString(@"Now Playing View Annoyances", nil);
    } else if (section == kHomeSection) {
        return NSLocalizedString(@"Home Additions", nil);
    } else if (section == kSupportSection) {
        return NSLocalizedString(@"Support", nil);
    }
    return nil;
}

- (void)ConnectAccessButtonSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].ConnectAccessButtonEnabled = switchView.isOn;
}
- (void)HideCreatePlaylistSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].HideCreatePlaylistEnabled = switchView.isOn;
}
- (void)LyricsButtonSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].ViewArtistsOfflineEnabled = switchView.isOn;
}
- (void)RealtimeLyricsButtonSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].RealtimeLyricsButtonEnabled = switchView.isOn;
} 
- (void)ViewArtistsOfflineSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].ViewArtistsOfflineEnabled = switchView.isOn;
}




#pragma mark - Library Additions
- (void)ShowAlbumArtistRecommendationsSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].ShowAlbumArtistRecommendationsEnabled = switchView.isOn;
}
- (void)OldArtistsPlaylistsInterfaceSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].OldArtistsPlaylistsInterfaceEnabled = switchView.isOn;
} 
- (void)CreatePlaylistNewInterfaceSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].CreatePlaylistNewInterfaceEnabled = switchView.isOn;
}
- (void)TrueShuffleSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].TrueShuffleEnabled = switchView.isOn;
} 
- (void)OpenCanvasPlaylistSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].OpenCanvasPlaylistEnabled = switchView.isOn;
}
- (void)DisableShufflePlayButtonSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].DisableShufflePlayButtonEnabled = switchView.isOn;
}

#pragma mark - Now Playing Additions
- (void)AlignTextToTopSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].AlignTextToTopEnabled = switchView.isOn;
} 
- (void)AutoHideDurationLabelsSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].AutoHideDurationLabelsEnabled = switchView.isOn;
}
- (void)BlackoutModeSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].BlackoutModeEnabled = switchView.isOn;
}
- (void)CanvasChoiceButtonSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].CanvasChoiceButtonEnabled = switchView.isOn;
}
- (void)CanvasTapSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].CanvasTapEnabled = switchView.isOn;
}
- (void)CarViewSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].CarViewEnabled = switchView.isOn;
} 
- (void)ShowStatusBarSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].ShowStatusBarEnabled = switchView.isOn;
} 
- (void)RealtimeLyricsPopupSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].RealtimeLyricsPopupEnabled = switchView.isOn;
}


#pragma mark - Now Playing Annoyances 
- (void)DisableGeniusLyricsSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].DisableGeniusLyricsEnabled = switchView.isOn;
}
- (void)DisableStorylinesSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].DisableStorylinesEnabled = switchView.isOn;
}
- (void)DisableCanvasSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].DisableCanvasEnabled = switchView.isOn;
} 
- (void)DisableQueueScreenControlsSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].DisableQueueScreenControlsEnabled = switchView.isOn;
}
- (void)DisableSocialListeningSectionSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].DisableSocialListeningSectionEnabled = switchView.isOn;
}


#pragma mark - Home Additions
- (void)ImportYourMusicSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].ImportYourMusicEnabled = switchView.isOn;
}
- (void)VoiceSearchSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].VoiceSearchEnabled = switchView.isOn;
} 
- (void)VerifiedProfileBadgeSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].VerifiedProfileBadgeEnabled = switchView.isOn;
} 
- (void)NoBurgerButtonOnLockscreenSwitchChanged:(UISwitch *)switchView {
    [SettingsUsecase sharedUsecase].NoBurgerButtonOnLockscreenEnabled = switchView.isOn;
}
@end