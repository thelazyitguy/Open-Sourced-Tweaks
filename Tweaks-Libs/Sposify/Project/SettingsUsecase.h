#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SettingsUsecase : NSObject

@property (nonatomic) BOOL ConnectAccessButtonEnabled;
@property (nonatomic) BOOL HideCreatePlaylistEnabled;
@property (nonatomic) BOOL RealtimeLyricsButtonEnabled; 
@property (nonatomic) BOOL RealtimeLyricsPopupEnabled; 
@property (nonatomic) BOOL ViewArtistsOfflineEnabled; 


@property (nonatomic) BOOL ShowAlbumArtistRecommendationsEnabled;
@property (nonatomic) BOOL OldArtistsPlaylistsInterfaceEnabled; 
@property (nonatomic) BOOL CreatePlaylistNewInterfaceEnabled;
@property (nonatomic) BOOL TrueShuffleEnabled;
@property (nonatomic) BOOL OpenCanvasPlaylistEnabled; 
@property (nonatomic) BOOL DisableShufflePlayButtonEnabled;

@property (nonatomic) BOOL AlignTextToTopEnabled; 
@property (nonatomic) BOOL AutoHideDurationLabelsEnabled;
@property (nonatomic) BOOL BlackoutModeEnabled;
@property (nonatomic) BOOL CanvasChoiceButtonEnabled;
@property (nonatomic) BOOL CanvasTapEnabled;
@property (nonatomic) BOOL CarViewEnabled; 
@property (nonatomic) BOOL DisableGeniusLyricsEnabled;
@property (nonatomic) BOOL DisableStorylinesEnabled;
@property (nonatomic) BOOL DisableCanvasEnabled; 
@property (nonatomic) BOOL DisableQueueScreenControlsEnabled;
@property (nonatomic) BOOL DisableSocialListeningSectionEnabled;

@property (nonatomic) BOOL ImportYourMusicEnabled;
@property (nonatomic) BOOL VoiceSearchEnabled;
@property (nonatomic) BOOL ShowStatusBarEnabled; 
@property (nonatomic) BOOL VerifiedProfileBadgeEnabled; 
@property (nonatomic) BOOL NoBurgerButtonOnLockscreenEnabled;


//Old features
@property (nonatomic) BOOL WhatsNewSectionEnabled;
+ (instancetype)sharedUsecase;

@end
