#import "SettingsUsecase.h"


//8.5.49 Update
#define ConnectAccessButton_KEY @"ConnectAccessButton_Enabled"
#define HideCreatePlaylist_KEY @"HideCreatePlaylist_Enabled" 
#define RealtimeLyricsButton_KEY @"RealtimeLyricsButton_Enabled"
#define RealtimeLyricsPopup_KEY @"RealtimeLyricsPopup_Enabled" 
#define ViewArtistsOffline_KEY @"ViewArtistsOffline_Enabled"

//Lbrary Additions
#define ShowAlbumArtistRecommendations_KEY @"ShowAlbumArtistRecommendations_Enabled"
#define OldArtistsPlaylistsInterface_KEY @"OldArtistsPlaylistsInterface_Enabled" 
#define CreatePlaylistNewInterface_KEY @"CreatePlaylistNewInterface_Enabled"
#define TrueShuffle_KEY @"TrueShuffle_Enabled" 
#define OpenCanvasPlaylist_KEY @"OpenCanvasPlaylist_Enabled"
#define DisableShufflePlayButton_KEY @"DisableShufflePlayButton_Enabled"

//Now Playing Additions
#define AutoHideDurationLabels_KEY @"AutoHideDurationLabels_Enabled" 
#define CarView_KEY @"CarView_Enabled"
#define AlignTextToTop_KEY @"AlignTextToTop_Enabled"
#define CanvasChoiceButton_KEY @"CanvasChoiceButton_Enabled"
#define CanvasTap_KEY @"CanvasTap_Enabled" 
#define BlackoutMode_KEY @"BlackoutMode_Enabled"
#define AutoHideDurationLabels_KEY @"AutoHideDurationLabels_Enabled"
#define RealtimeLyricsPopup_KEY @"RealtimeLyricsPopup_Enabled" 

//Now PLaying Annoyances 
#define DisableGeniusLyrics_KEY @"DisableGeniusLyrics_Enabled"
#define DisableStorylines_KEY @"DisableStorylines_Enabled"
#define DisableCanvas_KEY @"DisableCanvas_Enabled" 
#define DisableQueueScreenControls_KEY @"DisableQueueScreenControls_Enabled"
#define DisableSocialListeningSection_KEY @"DisableSocialListeningSection_Enabled"
//General Annoyances 

//General Additions
#define ImportYourMusic_KEY @"ImportYourMusic_Enabled"
#define VoiceSearch_KEY @"VoiceSearch_Enabled"
#define ShowStatusBar_KEY @"ShowStatusBar_Enabled" 
#define VerifiedProfileBadge_KEY @"VerifiedProfileBadge_Enabled" 
#define NoBurgerButtonOnLockscreen_KEY @"NoBurgerButtonOnLockscreen_Enabled"
//Experimental Additions


@interface SettingsUsecase()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end


@implementation SettingsUsecase

+ (instancetype)sharedUsecase {
    static dispatch_once_t onceToken;
    static SettingsUsecase *usecase;
    dispatch_once(&onceToken, ^{
        usecase = [[SettingsUsecase alloc] init];
    });
    return usecase;
}

- (instancetype)init {
    if (self = [super init]) {
        _userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.sposify.client"];

          //New Features
        _ConnectAccessButtonEnabled = [_userDefaults boolForKey:ConnectAccessButton_KEY];
        _HideCreatePlaylistEnabled = [_userDefaults boolForKey:HideCreatePlaylist_KEY];
        _RealtimeLyricsButtonEnabled = [_userDefaults boolForKey:RealtimeLyricsButton_KEY];
        _RealtimeLyricsPopupEnabled = [_userDefaults boolForKey:RealtimeLyricsPopup_KEY];
        _ViewArtistsOfflineEnabled = [_userDefaults boolForKey:ViewArtistsOffline_KEY];

        //Library Additions
        _ShowAlbumArtistRecommendationsEnabled = [_userDefaults boolForKey:ShowAlbumArtistRecommendations_KEY];
        _OldArtistsPlaylistsInterfaceEnabled = [_userDefaults boolForKey:OldArtistsPlaylistsInterface_KEY]; 
        _CreatePlaylistNewInterfaceEnabled = [_userDefaults boolForKey:CreatePlaylistNewInterface_KEY];
        _TrueShuffleEnabled = [_userDefaults boolForKey:TrueShuffle_KEY]; 

        //Library Annoyances
        _DisableShufflePlayButtonEnabled = [_userDefaults boolForKey:DisableShufflePlayButton_KEY];
        
        //Now Playing Additions
        _AlignTextToTopEnabled = [_userDefaults boolForKey:AlignTextToTop_KEY]; 
        _AutoHideDurationLabelsEnabled = [_userDefaults boolForKey:AutoHideDurationLabels_KEY];
        _BlackoutModeEnabled = [_userDefaults boolForKey:BlackoutMode_KEY];
        _CarViewEnabled = [_userDefaults boolForKey:CarView_KEY];
        _CanvasChoiceButtonEnabled = [_userDefaults boolForKey:CanvasChoiceButton_KEY];
        _CanvasTapEnabled = [_userDefaults boolForKey:CanvasTap_KEY]; 



        //Now Playing Annoyances 
        _DisableGeniusLyricsEnabled = [_userDefaults boolForKey:DisableGeniusLyrics_KEY];
        _DisableStorylinesEnabled = [_userDefaults boolForKey:DisableStorylines_KEY];
        _DisableCanvasEnabled = [_userDefaults boolForKey:DisableCanvas_KEY]; 
        _DisableQueueScreenControlsEnabled = [_userDefaults boolForKey:DisableQueueScreenControls_KEY];
        _DisableSocialListeningSectionEnabled = [_userDefaults boolForKey:DisableSocialListeningSection_KEY];

        //General Additions
        _ImportYourMusicEnabled = [_userDefaults boolForKey:ImportYourMusic_KEY];
        _VoiceSearchEnabled = [_userDefaults boolForKey:VoiceSearch_KEY];
        _ShowStatusBarEnabled = [_userDefaults boolForKey:ShowStatusBar_KEY]; 
        _VerifiedProfileBadgeEnabled = [_userDefaults boolForKey:VerifiedProfileBadge_KEY]; 
        _NoBurgerButtonOnLockscreenEnabled = [_userDefaults boolForKey:NoBurgerButtonOnLockscreen_KEY];
        //Experimental Additions
        _OpenCanvasPlaylistEnabled = [_userDefaults boolForKey:OpenCanvasPlaylist_KEY];


    }
    return self;
}

//New Features
- (void)setConnectAccessButtonEnabled:(BOOL)ConnectAccessButtonEnabled {
    _ConnectAccessButtonEnabled = ConnectAccessButtonEnabled;
    [_userDefaults setBool:ConnectAccessButtonEnabled forKey:ConnectAccessButton_KEY];
}
- (void)setHideCreatePlaylistEnabled:(BOOL)HideCreatePlaylistEnabled {
    _HideCreatePlaylistEnabled = HideCreatePlaylistEnabled;
    [_userDefaults setBool:HideCreatePlaylistEnabled forKey:HideCreatePlaylist_KEY];
}
- (void)setRealtimeLyricsButtonEnabled:(BOOL)RealtimeLyricsButtonEnabled {
    _RealtimeLyricsButtonEnabled = RealtimeLyricsButtonEnabled;
    [_userDefaults setBool:RealtimeLyricsButtonEnabled forKey:RealtimeLyricsButton_KEY];
}
- (void)setViewArtistsOfflineEnabled:(BOOL)ViewArtistsOfflineEnabled {
    _ViewArtistsOfflineEnabled = ViewArtistsOfflineEnabled;
    [_userDefaults setBool:ViewArtistsOfflineEnabled forKey:ViewArtistsOffline_KEY];
}
- (void)setRealtimeLyricsPopupEnabled:(BOOL)RealtimeLyricsPopupEnabled {
    _RealtimeLyricsPopupEnabled = RealtimeLyricsPopupEnabled;
    [_userDefaults setBool:RealtimeLyricsPopupEnabled forKey:RealtimeLyricsPopup_KEY];
}
- (void)setOpenCanvasPlaylistEnabled:(BOOL)OpenCanvasPlaylistEnabled {
    _OpenCanvasPlaylistEnabled = OpenCanvasPlaylistEnabled;
    [_userDefaults setBool:OpenCanvasPlaylistEnabled forKey:OpenCanvasPlaylist_KEY];
}


//Your Library Additions
- (void)setShowAlbumArtistRecommendationsEnabled:(BOOL)ShowAlbumArtistRecommendationsEnabled {
    _ShowAlbumArtistRecommendationsEnabled = ShowAlbumArtistRecommendationsEnabled;
    [_userDefaults setBool:ShowAlbumArtistRecommendationsEnabled forKey:ShowAlbumArtistRecommendations_KEY];
}
- (void)setOldArtistsPlaylistsInterfaceEnabled:(BOOL)OldArtistsPlaylistsInterfaceEnabled {
    _OldArtistsPlaylistsInterfaceEnabled = OldArtistsPlaylistsInterfaceEnabled;
    [_userDefaults setBool:OldArtistsPlaylistsInterfaceEnabled forKey:OldArtistsPlaylistsInterface_KEY];
} 
- (void)setCreatePlaylistNewInterfaceEnabled:(BOOL)CreatePlaylistNewInterfaceEnabled {
    _CreatePlaylistNewInterfaceEnabled = CreatePlaylistNewInterfaceEnabled;
    [_userDefaults setBool:CreatePlaylistNewInterfaceEnabled forKey:CreatePlaylistNewInterface_KEY];
}
- (void)setTrueShuffleEnabled:(BOOL)TrueShuffleEnabled {
    _TrueShuffleEnabled = TrueShuffleEnabled;
    [_userDefaults setBool:TrueShuffleEnabled forKey:TrueShuffle_KEY];
} 
- (void)setDisableShufflePlayButtonEnabled:(BOOL)DisableShufflePlayButtonEnabled {
    _DisableShufflePlayButtonEnabled = DisableShufflePlayButtonEnabled;
    [_userDefaults setBool:DisableShufflePlayButtonEnabled forKey:DisableShufflePlayButton_KEY];
}

//Now Playing Additions 
- (void)setAlignTextToTopEnabled:(BOOL)AlignTextToTopEnabled {
    _AlignTextToTopEnabled = AlignTextToTopEnabled;
    [_userDefaults setBool:AlignTextToTopEnabled forKey:AlignTextToTop_KEY];
}
- (void)setAutoHideDurationLabelsEnabled:(BOOL)AutoHideDurationLabelsEnabled {
    _AutoHideDurationLabelsEnabled = AutoHideDurationLabelsEnabled;
    [_userDefaults setBool:AutoHideDurationLabelsEnabled forKey:AutoHideDurationLabels_KEY];
}
- (void)setBlackoutModeEnabled:(BOOL)BlackoutModeEnabled {
    _BlackoutModeEnabled = BlackoutModeEnabled;
    [_userDefaults setBool:BlackoutModeEnabled forKey:BlackoutMode_KEY];
}
- (void)setCanvasChoiceButtonEnabled:(BOOL)CanvasChoiceButtonEnabled {
    _CanvasChoiceButtonEnabled = CanvasChoiceButtonEnabled;
    [_userDefaults setBool:CanvasChoiceButtonEnabled forKey:CanvasChoiceButton_KEY];
}
- (void)setCanvasTapEnabled:(BOOL)CanvasTapEnabled {
    _CanvasTapEnabled = CanvasTapEnabled;
    [_userDefaults setBool:CanvasTapEnabled forKey:CanvasTap_KEY];
}
- (void)setCarViewEnabled:(BOOL)CarViewEnabled {
    _CarViewEnabled = CarViewEnabled;
    [_userDefaults setBool:CarViewEnabled forKey:CarView_KEY];
}









//Now Playing Annoyances 
- (void)setDisableGeniusLyricsEnabled:(BOOL)DisableGeniusLyricsEnabled {
    _DisableGeniusLyricsEnabled = DisableGeniusLyricsEnabled;
    [_userDefaults setBool:DisableGeniusLyricsEnabled forKey:DisableGeniusLyrics_KEY];
}
- (void)setDisableStorylinesEnabled:(BOOL)DisableStorylinesEnabled {
    _DisableStorylinesEnabled = DisableStorylinesEnabled;
    [_userDefaults setBool:DisableStorylinesEnabled forKey:DisableStorylines_KEY];
}
- (void)setDisableCanvasEnabled:(BOOL)DisableCanvasEnabled {
    _DisableCanvasEnabled = DisableCanvasEnabled;
    [_userDefaults setBool:DisableCanvasEnabled forKey:DisableCanvas_KEY];
} 
- (void)setDisableQueueScreenControlsEnabled:(BOOL)DisableQueueScreenControlsEnabled {
    _DisableQueueScreenControlsEnabled = DisableQueueScreenControlsEnabled;
    [_userDefaults setBool:DisableQueueScreenControlsEnabled forKey:DisableQueueScreenControls_KEY];
}
- (void)setDisableSocialListeningSectionEnabled:(BOOL)DisableSocialListeningSectionEnabled {
    _DisableSocialListeningSectionEnabled = DisableSocialListeningSectionEnabled;
    [_userDefaults setBool:DisableSocialListeningSectionEnabled forKey:DisableSocialListeningSection_KEY];
}


//General Additions
- (void)setImportYourMusicEnabled:(BOOL)ImportYourMusicEnabled {
    _ImportYourMusicEnabled = ImportYourMusicEnabled;
    [_userDefaults setBool:ImportYourMusicEnabled forKey:ImportYourMusic_KEY];
}
- (void)setVoiceSearchEnabled:(BOOL)VoiceSearchEnabled {
    _VoiceSearchEnabled = VoiceSearchEnabled;
    [_userDefaults setBool:VoiceSearchEnabled forKey:VoiceSearch_KEY];
}
- (void)setShowStatusBarEnabled:(BOOL)ShowStatusBarEnabled {
    _ShowStatusBarEnabled = ShowStatusBarEnabled;
    [_userDefaults setBool:ShowStatusBarEnabled forKey:ShowStatusBar_KEY];
} 
- (void)setVerifiedProfileBadgeEnabled:(BOOL)VerifiedProfileBadgeEnabled {
    _VerifiedProfileBadgeEnabled = VerifiedProfileBadgeEnabled;
    [_userDefaults setBool:VerifiedProfileBadgeEnabled forKey:VerifiedProfileBadge_KEY];
} 
- (void)setNoBurgerButtonOnLockscreenEnabled:(BOOL)NoBurgerButtonOnLockscreenEnabled {
    _NoBurgerButtonOnLockscreenEnabled = NoBurgerButtonOnLockscreenEnabled;
    [_userDefaults setBool:NoBurgerButtonOnLockscreenEnabled forKey:NoBurgerButtonOnLockscreen_KEY];
} 
- (void)dealloc {
    [_userDefaults synchronize];
}


@end
