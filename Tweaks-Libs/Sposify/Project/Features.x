#import "Storage.h"
#import "SettingsUsecase.h"
#import "ColorForHex.h" 
#import "SettingsViewController.h"
#import <AudioToolbox/AudioToolbox.h> 



%hook RootSettingsViewController
- (void)viewDidLoad {
    %orig;
        UIImage *settingsIcon = [UIImage imageForSPTIcon:77 size:CGSizeMake(20, 20)];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:settingsIcon
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(didTapMenu:)];
        [self.navigationItem setRightBarButtonItem:rightItem];


}
%new
- (void)didTapMenu:(id)sender {
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleLight];
    [generator prepare];
    [generator impactOccurred];
	SettingsViewController *settingsVC = 
	[[SettingsViewController alloc] initWithNibName: nil bundle: nil];
    UINavigationController *navController =
    [[UINavigationController alloc] initWithRootViewController:settingsVC];
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    navController.modalPresentationStyle = UIModalPresentationPageSheet;
  } else {
    navController.modalPresentationStyle = UIModalPresentationPopover;
  }
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}
%end


// 8.5.49 New Additons
%hook SPTConnectAccessButtonTestManagerImplementation
- (_Bool)buttonEnabled { //Connect Access Button
    if ([SettingsUsecase sharedUsecase].ConnectAccessButtonEnabled) { 
        return TRUE;
  }
  return %orig();
}
- (_Bool)connectAccessButtonEnabled { //Connect Access Button
    if ([SettingsUsecase sharedUsecase].ConnectAccessButtonEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end

%hook SPTConnectAccessButtonTestManager
- (_Bool)connectAccessButtonEnabled { //Connect Access Button
    if ([SettingsUsecase sharedUsecase].ConnectAccessButtonEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end

%hook SPTConnectUIFeatureProperties
- (_Bool)connectAccessButtonEnabled { //Connect Access Button
    if ([SettingsUsecase sharedUsecase].ConnectAccessButtonEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end 

%hook SPTFreeTierArtistFeatureProperties
- (_Bool)offlineArtistEnabled { 
    if ([SettingsUsecase sharedUsecase].ViewArtistsOfflineEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end

%hook SPTFreeTierArtistTestManager
- (_Bool)isOfflineArtistViewEnabled { 
    if ([SettingsUsecase sharedUsecase].ViewArtistsOfflineEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end

%hook SPTFreeTierArtistTestManagerImplementation
- (_Bool)isOfflineArtistViewEnabled { 
    if ([SettingsUsecase sharedUsecase].ViewArtistsOfflineEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end 

%hook SPTYourLibraryMusicFeatureProperties
- (_Bool)offlineArtistEnabled { 
    if ([SettingsUsecase sharedUsecase].ViewArtistsOfflineEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end

%hook SPTYourLibraryMusicTestManager
- (_Bool)isOfflineArtistEnabled { 
    if ([SettingsUsecase sharedUsecase].ViewArtistsOfflineEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end

%hook SPTYourLibraryMusicTestManagerImplementation
- (_Bool)isOfflineArtistEnabled { 
    if ([SettingsUsecase sharedUsecase].ViewArtistsOfflineEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end

//Realtime Lyrics
%hook SPTNowPlayingTestManagerImplementation 
- (_Bool)isContentLayerLyricsEnabled {
    if ([SettingsUsecase sharedUsecase].RealtimeLyricsButtonEnabled) { 
        return YES;
  }
  return %orig();
}
%end

%hook SPTNowPlayingTestManager 
- (_Bool)isContentLayerLyricsEnabled { 
    if ([SettingsUsecase sharedUsecase].RealtimeLyricsButtonEnabled) { 
        return YES;
  }
  return %orig();
}
%end 

%hook SPTLyricsV2TestManager
- (bool)isFeatureEnabled {
    if ([SettingsUsecase sharedUsecase].RealtimeLyricsPopupEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end

%hook SPTLyricsV2TestManagerImplementation
- (bool)isFeatureEnabled {
    if ([SettingsUsecase sharedUsecase].RealtimeLyricsPopupEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end

%hook SPTLyricsV2TextViewStyle
- (UIColor *)backgroundColor {
    if ([SettingsUsecase sharedUsecase].BlackoutModeEnabled) { 
    return [UIColor colorWithHexString:@"#000000"];
  }
  return %orig();
}
- (UIColor *)activeTextColor {
    if ([SettingsUsecase sharedUsecase].BlackoutModeEnabled) { 
    return [UIColor colorWithHexString:@"#FFFFFF"];
  }
  return %orig();
}
- (UIColor *)textColor {
    if ([SettingsUsecase sharedUsecase].BlackoutModeEnabled) { 
    return [UIColor colorWithHexString:@"#B0B0B0"];
  }
  return %orig();
}
%end

%hook SPTLyricsV2NowPlayingCardViewStyle
- (UIColor *)backgroundColor {
    if ([SettingsUsecase sharedUsecase].BlackoutModeEnabled) { 
    return [UIColor colorWithHexString:@"#000000"];
  }
  return %orig();
}
%end

%hook SPTLyricsV2LoadingViewStyle
- (UIColor *)backgroundColor {
    if ([SettingsUsecase sharedUsecase].BlackoutModeEnabled) { 
    return [UIColor colorWithHexString:@"#000000"];
  }
  return %orig();
}
- (UIColor *)beamColor {
    if ([SettingsUsecase sharedUsecase].BlackoutModeEnabled) { 
    return [UIColor colorWithHexString:@"#000000"];
  }
  return %orig();
}
%end

%hook SPTLyricsV2FullscreenViewStyle
- (UIColor *)backgroundColor {
    if ([SettingsUsecase sharedUsecase].BlackoutModeEnabled) { 
    return [UIColor colorWithHexString:@"#000000"];
  }
  return %orig();
}
%end

%hook SPTLyricsV2FullscreenHeaderViewStyle
- (UIColor *)shadowColor {
    if ([SettingsUsecase sharedUsecase].BlackoutModeEnabled) { 
    return [UIColor colorWithHexString:@"#000000"];
  }
  return %orig();
}
- (UIColor *)backgroundColor {
    if ([SettingsUsecase sharedUsecase].BlackoutModeEnabled) { 
    return [UIColor colorWithHexString:@"#000000"];
  }
  return %orig();
}
%end

%hook SPTLyricsV2FullscreenFooterViewStyle
- (UIColor *)backgroundColor {
    if ([SettingsUsecase sharedUsecase].BlackoutModeEnabled) { 
    return [UIColor colorWithHexString:@"#000000"];
  }
  return %orig();
}
%end

%hook SPTLyricsV2Colors
- (UIColor *)darkColor {
    if ([SettingsUsecase sharedUsecase].BlackoutModeEnabled) { 
    return [UIColor colorWithHexString:@"#121212"];
  }
  return %orig();
}
- (UIColor *)brightColor {
    if ([SettingsUsecase sharedUsecase].BlackoutModeEnabled) { 
    return [UIColor colorWithHexString:@"#FFFFFF"];
  }
  return %orig();
}
- (UIColor *)activeColor {
    if ([SettingsUsecase sharedUsecase].BlackoutModeEnabled) { 
    return [UIColor colorWithHexString:@"#121212"];
  }
  return %orig();
}
%end
//Realtime Lyrics


//Now Playing Annoyances 
%hook SPTCanvasTestManager
- (_Bool)isCanvasEnabled { // 8.5.49 Fixed Bug where the Canvas would show a black screen
    if ([SettingsUsecase sharedUsecase].DisableCanvasEnabled) { 
        return NO;
  }
  return %orig();
}
%end

%hook SPTGeniusService
-(_Bool)isTrackGeniusEnabled:(id)arg1 {  //Disable Genius Lyrics
    if ([SettingsUsecase sharedUsecase].DisableGeniusLyricsEnabled) { 
        return NO;
  }
  return %orig();
}
%end

%hook SPTStorylinesEnabledManager
-(_Bool)storylinesEnabledForTrack:(id)arg1 {//Disable Storylines
    if ([SettingsUsecase sharedUsecase].DisableStorylinesEnabled) { 
        return NO;
  }
  return %orig();
}
%end 



%hook SPTFreeTierPlaylistTestManagerImplementation
- (_Bool)isWeigthedShufflePlayDisabled { //True Shuffle
    if ([SettingsUsecase sharedUsecase].TrueShuffleEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end

%hook SPTFreeTierPlaylistTestManager 
- (_Bool)isWeigthedShufflePlayDisabled { //True Shuffle
    if ([SettingsUsecase sharedUsecase].TrueShuffleEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end

%hook SPTCreatePlaylistTestManagerImplementation
- (_Bool)isCreatePlaylistEnabled { //8.5.49 Fixed Create Playlist New User Interface
   if ([SettingsUsecase sharedUsecase].CreatePlaylistNewInterfaceEnabled) { 
        return YES;
  }
  return %orig();
}
%end 

%hook SPTYourLibraryMusicTestManager
-(_Bool)isHideCreatePlaylistEnabled { //Hide Create Playlist //8.5.49 New Additons
    if ([SettingsUsecase sharedUsecase].HideCreatePlaylistEnabled) { 
        return TRUE;
  }
  return %orig();
}
- (_Bool)isFilterChipsEnabled {return TRUE;}
%end

%hook SPTYourLibraryMusicTestManagerImplementation 
-(_Bool)isShowAlbumArtistRecommendationsEnabled { //Show Album Artist Recommendations //8.5.49 New Additons
    if ([SettingsUsecase sharedUsecase].ShowAlbumArtistRecommendationsEnabled) { 
        return TRUE;
  }
  return %orig();
}
-(_Bool)isHideCreatePlaylistEnabled { //Hide Create Playlist //8.5.49 New Additons
    if ([SettingsUsecase sharedUsecase].HideCreatePlaylistEnabled) { 
        return TRUE;
  }
  return %orig();
}
- (_Bool)isFilterChipsEnabled {return TRUE;}
%end



%hook SPTVISREFFlagsServiceImplementation
- (bool)offlineHeaderEnabledGreen {
   if ([SettingsUsecase sharedUsecase].OldArtistsPlaylistsInterfaceEnabled) { 
        return FALSE;
  }
  return %orig();
}
- (bool)offlineHeaderVariableEnabled {
   if ([SettingsUsecase sharedUsecase].OldArtistsPlaylistsInterfaceEnabled) { 
        return FALSE;
  }
  return %orig();
}
- (bool)offlineHeaderEnabled {
   if ([SettingsUsecase sharedUsecase].OldArtistsPlaylistsInterfaceEnabled) { 
        return FALSE;
  }
  return %orig();
} 
- (bool)trackCloudEnabled {
   if ([SettingsUsecase sharedUsecase].OldArtistsPlaylistsInterfaceEnabled) { 
        return FALSE;
  }
  return %orig();
}
- (bool)trackRowEnabled {
   if ([SettingsUsecase sharedUsecase].OldArtistsPlaylistsInterfaceEnabled) { 
        return FALSE;
  }
  return %orig();
}
- (bool)sectionHeaderEnabled {
   if ([SettingsUsecase sharedUsecase].OldArtistsPlaylistsInterfaceEnabled) { 
        return FALSE;
  }
  return %orig();
}

- (bool)greenButtonEnabled {
   if ([SettingsUsecase sharedUsecase].OldArtistsPlaylistsInterfaceEnabled) { 
        return FALSE;
  }
  return %orig();
}
- (bool)headerEnabled {
   if ([SettingsUsecase sharedUsecase].OldArtistsPlaylistsInterfaceEnabled) { 
        return FALSE;
  }
  return %orig();
}
- (bool)fullExperienceNewUsersGreenButtonEnabled {
   if ([SettingsUsecase sharedUsecase].OldArtistsPlaylistsInterfaceEnabled) { 
        return FALSE;
  }
  return %orig();
} 
- (bool)fullExperienceNewUsersEnabled {
   if ([SettingsUsecase sharedUsecase].OldArtistsPlaylistsInterfaceEnabled) { 
        return FALSE;
  }
  return %orig();
}
- (bool)fullExperienceExistingUsersGreenButtonEnabled {
   if ([SettingsUsecase sharedUsecase].OldArtistsPlaylistsInterfaceEnabled) { 
        return FALSE;
  }
  return %orig();
}
- (bool)fullExperienceExistingUsersEnabled {
   if ([SettingsUsecase sharedUsecase].OldArtistsPlaylistsInterfaceEnabled) { 
        return FALSE;
  }
  return %orig();
}
- (bool)isVisualRefreshLeftAlignedTrackCloudEnabled {
   if ([SettingsUsecase sharedUsecase].OldArtistsPlaylistsInterfaceEnabled) { 
        return FALSE;
  }
  return %orig();
} 
- (bool)isVisualRefreshPlaylistTrackRowArtworkEnabled {
   if ([SettingsUsecase sharedUsecase].OldArtistsPlaylistsInterfaceEnabled) { 
        return FALSE;
  }
  return %orig();
}
- (bool)isVisualRefreshSectionHeaderEnabled {
   if ([SettingsUsecase sharedUsecase].OldArtistsPlaylistsInterfaceEnabled) { 
        return FALSE;
  }
  return %orig();
}
- (bool)isVisualRefreshGreenButtonEnabled {
   if ([SettingsUsecase sharedUsecase].OldArtistsPlaylistsInterfaceEnabled) { 
        return FALSE;
  }
  return %orig();
}
- (bool)isVisualRefreshHeaderEnabled {
   if ([SettingsUsecase sharedUsecase].OldArtistsPlaylistsInterfaceEnabled) { 
        return FALSE;
  }
  return %orig();
}
%end 

%hook AVAudioSessionRouteDescription
- (bool)spt_isAudioRoutingToCarPlay {
    if ([SettingsUsecase sharedUsecase].CarViewEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end 

%hook SPTLocalFilesImportManager
- (bool)enabled {
    if ([SettingsUsecase sharedUsecase].ImportYourMusicEnabled) { 
        return TRUE;
  }
  return %orig();
}
- (bool)_enabled {
    if ([SettingsUsecase sharedUsecase].ImportYourMusicEnabled) { 
        return TRUE;
  }
  return %orig();
}
- (bool)shouldShowDialog {
    if ([SettingsUsecase sharedUsecase].ImportYourMusicEnabled) { 
        return TRUE;
  }
  return %orig();
}
- (bool)shouldStartWithSongs {
    if ([SettingsUsecase sharedUsecase].ImportYourMusicEnabled) { 
        return TRUE;
  }
  return %orig();
}
- (bool)shouldStartWithPlaylists {
    if ([SettingsUsecase sharedUsecase].ImportYourMusicEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end

%hook SPTCollectionSortingEntityManager
- (bool)isLocalFilesImportEnabled {
    if ([SettingsUsecase sharedUsecase].ImportYourMusicEnabled) { 
        return TRUE;
  }
  return %orig();
}
- (bool)localFilesImportEnabled {
    if ([SettingsUsecase sharedUsecase].ImportYourMusicEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end

%hook CollectionFeatureImplementation
- (bool)localFilesImportEnabled {
    if ([SettingsUsecase sharedUsecase].ImportYourMusicEnabled) { 
        return TRUE;
  }
  return %orig();
}
- (bool)isLocalFilesImportEnabled {
    if ([SettingsUsecase sharedUsecase].ImportYourMusicEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end

%hook CollectionFeature
- (bool)localFilesImportEnabled {
    if ([SettingsUsecase sharedUsecase].ImportYourMusicEnabled) { 
        return TRUE;
  }
  return %orig();
}
- (bool)isLocalFilesImportEnabled {
    if ([SettingsUsecase sharedUsecase].ImportYourMusicEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end

%hook PlaylistFeatureImplementation
- (bool)localFilesImportEnabled {
    if ([SettingsUsecase sharedUsecase].ImportYourMusicEnabled) { 
        return TRUE;
  }
  return %orig();
}
- (bool)isLocalFilesImportEnabled {
    if ([SettingsUsecase sharedUsecase].ImportYourMusicEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end

%hook PlaylistFeature
- (bool)localFilesImportEnabled {
    if ([SettingsUsecase sharedUsecase].ImportYourMusicEnabled) { 
        return TRUE;
  }
  return %orig();
}
- (bool)isLocalFilesImportEnabled {
    if ([SettingsUsecase sharedUsecase].ImportYourMusicEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end 

%hook SPTVoiceTestManagerImplementation
- (BOOL)isNewVoiceSearchEnabled { //Voice Search
    if ([SettingsUsecase sharedUsecase].VoiceSearchEnabled) { 
        return YES;
  }
  return %orig();
}
- (BOOL)isVoiceSearchEnabled { //Voice Search
    if ([SettingsUsecase sharedUsecase].VoiceSearchEnabled) { 
        return YES;
  }
  return %orig();
}
- (BOOL)isVoiceServiceEnabled { //Voice Search
    if ([SettingsUsecase sharedUsecase].VoiceSearchEnabled) { 
        return YES;
  }
  return %orig();
}
- (BOOL)newVoiceSearchExperienceEnabled { //Voice Search
    if ([SettingsUsecase sharedUsecase].VoiceSearchEnabled) { 
        return YES;
  }
  return %orig();
}
%end

%hook SPTVoiceTestManagerObserver
- (BOOL)isNewVoiceSearchEnabled { //Voice Search
    if ([SettingsUsecase sharedUsecase].VoiceSearchEnabled) { 
        return YES;
  }
  return %orig();
}
- (BOOL)isVoiceSearchEnabled { //Voice Search
    if ([SettingsUsecase sharedUsecase].VoiceSearchEnabled) { 
        return YES;
  }
  return %orig();
}
%end

%hook SPTVoiceTestManager
- (BOOL)isNewVoiceSearchEnabled { //Voice Search
    if ([SettingsUsecase sharedUsecase].VoiceSearchEnabled) { 
        return YES;
  }
  return %orig();
}
- (BOOL)isVoiceSearchEnabled { //Voice Search
    if ([SettingsUsecase sharedUsecase].VoiceSearchEnabled) { 
        return YES;
  }
  return %orig();
}
%end

%hook SPTProfileUserEntity
- (bool)isVerified {
    if ([SettingsUsecase sharedUsecase].VerifiedProfileBadgeEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end

%hook SPTNowPlayingInformationUnitViewController 
- (unsigned long long) leadingEdge {
    if ([SettingsUsecase sharedUsecase].AlignTextToTopEnabled) { 
        return 1;
  }
  return %orig();
}
%end 

%hook SPTCanvasTestManager
- (bool)shouldDisplayCanvasToggle { //Canvas Choice Button
    if ([SettingsUsecase sharedUsecase].CanvasChoiceButtonEnabled) { 
        return TRUE;
  }
  return %orig();
}
- (bool)shouldDisplayCanvasSettings { //Canvas Choice Button
    if ([SettingsUsecase sharedUsecase].CanvasChoiceButtonEnabled) { 
        return TRUE;
  }
  return %orig();
}
- (bool)shouldEnableCanvasPlaylist { //Open Canvas Playlist
    if ([SettingsUsecase sharedUsecase].OpenCanvasPlaylistEnabled) { 
        return TRUE;
  }
  return %orig();
}
- (bool)shouldEnableCanvasTap { //Canvas Tap
    if ([SettingsUsecase sharedUsecase].CanvasTapEnabled) { 
        return TRUE;
  }
  return %orig();
}

%end 

%hook SPTStatusBarToken
- (bool)hidden {
    if ([SettingsUsecase sharedUsecase].ShowStatusBarEnabled) { 
        return NO;
  }
  return %orig();
}
%end 

%hook SPTNowPlayingBackgroundViewModel
- (bool)shouldExtractColorForTrack:(id)arg1 playerState:(id)arg2 {
    if ([SettingsUsecase sharedUsecase].BlackoutModeEnabled) { 
        return FALSE;
  }
  return %orig();
}
%end 

%hook SPTFreeTierPlaylistViewModelConfiguration
- (bool)isPlayButtonPausingPlay {
    if ([SettingsUsecase sharedUsecase].DisableShufflePlayButtonEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end

%hook SPTFreeTierPlaylistViewModelConfigurationFull
- (bool)isPlayButtonPausingPlay {
    if ([SettingsUsecase sharedUsecase].DisableShufflePlayButtonEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end

%hook VISREFPlayButtonForegroundView
- (bool)shouldShowShuffleBadge { 
    if ([SettingsUsecase sharedUsecase].DisableShufflePlayButtonEnabled) { 
        return FALSE;
  }
  return %orig();
}
- (bool)isShuffleBadgeShown {
    if ([SettingsUsecase sharedUsecase].DisableShufflePlayButtonEnabled) { 
        return FALSE;
  }
  return %orig();
}
%end


%hook SPTRadioRemoteControlPolicy
- (bool)_useThumbUpDownUI { 
    if ([SettingsUsecase sharedUsecase].NoBurgerButtonOnLockscreenEnabled) { 
        return FALSE;
  }
  return %orig();
}
- (bool)isEnabled { 
    if ([SettingsUsecase sharedUsecase].NoBurgerButtonOnLockscreenEnabled) { 
        return FALSE;
  }
  return %orig();
}
%end

%hook SPTExternalIntegrationRadioController
- (BOOL)thumbIsDownForTrackWithURI:(NSURL *)arg1 {
    if ([SettingsUsecase sharedUsecase].NoBurgerButtonOnLockscreenEnabled) { 
        return FALSE;
  }
  return %orig();
}
%end

%hook SPTPlayerState
+ (BOOL)isDailyMixContext:(id)arg1 {
    if ([SettingsUsecase sharedUsecase].NoBurgerButtonOnLockscreenEnabled) { 
        return FALSE;
  }
  return %orig();
}
%end 

%hook SPTNowPlayingInformationUnitViewModel
- (BOOL)isFeedbackButtonEnabled {
    if ([SettingsUsecase sharedUsecase].NoBurgerButtonOnLockscreenEnabled) { 
        return FALSE;
  }
  return %orig();
}
%end

%hook SPTInAppMessageFeatureFlagChecks
- (BOOL)isFeedbackEnabled {
    if ([SettingsUsecase sharedUsecase].NoBurgerButtonOnLockscreenEnabled) { 
        return FALSE;
  }
  return %orig();
}
- (BOOL)isFeedbackButtonEnabled {
    if ([SettingsUsecase sharedUsecase].NoBurgerButtonOnLockscreenEnabled) { 
        return FALSE;
  }
  return %orig();
}
%end

%hook SPTPSXTestManagerImplementation
- (BOOL)isFeedbackEnabled {
    if ([SettingsUsecase sharedUsecase].NoBurgerButtonOnLockscreenEnabled) { 
        return FALSE;
  }
  return %orig();
}
- (BOOL)isFeedbackButtonEnabled {
    if ([SettingsUsecase sharedUsecase].NoBurgerButtonOnLockscreenEnabled) { 
        return FALSE;
  }
  return %orig();
}
%end

%hook SPTQueueViewControllerImplementation
- (BOOL)isFooterHidden {
    if ([SettingsUsecase sharedUsecase].DisableQueueScreenControlsEnabled) { 
        return TRUE;
  }
  return %orig();
}
%end

%hook SPTGaiaDevicePickerViewModel
- (BOOL)shouldShowSocialListeningSection {
    if ([SettingsUsecase sharedUsecase].DisableSocialListeningSectionEnabled) { 
        return FALSE;
  }
  return %orig();
}
%end

%hook SPTNowPlayingBarViewController
- (_Bool)nowPlayingDurationViewShouldAlwaysShowDurationLabels:(id)arg1 {
    if ([SettingsUsecase sharedUsecase].AutoHideDurationLabelsEnabled) { 
        return FALSE;
  }
  return %orig();
}
%end

%hook SPTNowPlayingDurationUnitViewController
- (_Bool)nowPlayingDurationViewShouldAlwaysShowDurationLabels:(id)arg1 {
    if ([SettingsUsecase sharedUsecase].AutoHideDurationLabelsEnabled) { 
        return FALSE;
  }
  return %orig();
}
%end

%hook SPTNowPlayingSideBarDurationUnitViewController
- (_Bool)nowPlayingDurationViewShouldAlwaysShowDurationLabels:(id)arg1 {
    if ([SettingsUsecase sharedUsecase].AutoHideDurationLabelsEnabled) { 
        return FALSE;
  }
  return %orig();
}
%end 

%hook SPTNowPlayingVideoViewController
- (_Bool)nowPlayingDurationViewShouldAlwaysShowDurationLabels:(id)arg1 {
    if ([SettingsUsecase sharedUsecase].AutoHideDurationLabelsEnabled) { 
        return FALSE;
  }
  return %orig();
}
%end


#define Version [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#import "SettingsViewController.h" 
%hook SpotifyAppDelegate
  -(BOOL)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2 {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"v8.5.49"]) {
      SPTPopupButton *ContinueAction = [%c(SPTPopupButton) buttonWithTitle:@"Continue"];

      SPTPopupButton *Action = [%c(SPTPopupButton) buttonWithTitle:@"Settings" actionHandler:^{
	    SettingsViewController *settingsVC = 
	  	[[SettingsViewController alloc] initWithNibName: nil bundle: nil];
	    UINavigationController *navigationController = 
	  	[[UINavigationController alloc] initWithRootViewController: settingsVC];
	    UIViewController *rootVC = 
	  	[[[UIApplication sharedApplication] keyWindow] rootViewController];
	    [rootVC presentViewController: navigationController animated: YES completion: nil];
      }];

      NSArray *buttons = [[NSArray alloc] initWithObjects:ContinueAction, Action, nil];
      SPTPopupDialog *playlistURIErrorPopup = [%c(SPTPopupDialog) popupWithTitle:@"What's New v8.5.49" message:[NSString stringWithFormat:@"\n∙ Added Connect Access Button\n∙ Added View Artists Offline\n∙ Added Hide Create Playlist\n∙ Added Show Album & Artist Recommendations\n∙ Added Realtime Lyrics Button\n\n∙ Fixed some non working features as the class names changed\n∙ Removed no longer working features due to Spotify removing the code"] buttons:buttons];

      [[%c(SPTPopupManager) sharedManager].presentationQueue addObject:playlistURIErrorPopup];
      [[%c(SPTPopupManager) sharedManager] presentNextQueuedPopup];

        [[NSUserDefaults standardUserDefaults] setValue:@"v8.5.49" forKey:@"v8.5.49"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    return %orig;
  }
%end

%hook GLUELabel
-(void)setText:(NSString *)arg1{
		arg1 = [arg1 stringByReplacingOccurrencesOfString:@"Millions of songs." withString:@"Sposify v8.5.49" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [arg1 length])];
		arg1 = [arg1 stringByReplacingOccurrencesOfString:@"Free on Spotify." withString:@"by aesthyrica" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [arg1 length])];
	%orig(arg1);
}
%end


%hook SPTCanvasContentLayerViewController
- (void)viewDidLoad {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"SaveAnyCanvasPopup"]) {
                SPTPopupDialog *popup;
                    popup = [%c(SPTPopupDialog) popupWithTitle:@"Save any Canvas"
                                                       message:@"Long-Press on any Canvas to Save them, any Canvas you Save will be Saved to your Photos in an Album called Canvas."
                                            dismissButtonTitle:@"dismiss"];

                    [[%c(SPTPopupManager) sharedManager].presentationQueue addObject:popup];
                    [[%c(SPTPopupManager) sharedManager] presentNextQueuedPopup];
        [[NSUserDefaults standardUserDefaults] setValue:@"SaveAnyCanvasPopup" forKey:@"SaveAnyCanvasPopup"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    return %orig;
  }
%end 



/*
@interface UITabBarButtonLabel : UIView
@end

%hook UITabBarButtonLabel

- (void)didMoveToWindow {

	%orig;

		self.hidden = YES;


}

%end


@interface UITabBarButton : UIControl

@property (nonatomic, assign, readwrite) CGPoint center;

@end

%hook UITabBarButton

- (void)layoutSubviews {

    %orig;

    CGPoint newCenter = self.center;
    newCenter.y = 30;
    self.center = newCenter;

}

%end


