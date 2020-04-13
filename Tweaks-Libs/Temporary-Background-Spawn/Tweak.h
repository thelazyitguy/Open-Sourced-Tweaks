@interface SBApplicationProcessState : NSObject
-(long long)taskState;
-(long long)visibility;
-(BOOL)isRunning;
-(BOOL)isForeground;
@end

@interface SBApplication : NSObject
-(BOOL)isSystemApplication;
-(NSString *)bundleIdentifier;
-(NSString *)displayName;
-(SBApplicationProcessState *)processState;
-(BOOL)isPlayingAudio;
-(BOOL)isNowRecordingApplication;
-(BOOL)isConnectedToExternalAccessory;
@end

@interface TempSpawnTracker : NSObject
@property NSMutableDictionary<NSString*, NSNumber*> *counts;
@property SBApplication* app;

+(NSArray*)tracked;

-(TempSpawnTracker*)initWithApp:(SBApplication*)app;
-(void)launchedInBackground;
-(void)terminatedInBackground;
-(void)cancelledTermination;
@end

@interface TempSpawnProcessState : NSObject
@property BOOL seen;
@property (nonatomic) BOOL launchedInBackground;
@property SBApplicationProcessState *processState;
@property NSString *displayName;
@property SBApplication *app;
@property TempSpawnTracker *tracker;
@end;

@interface TempSpawn : NSObject
@property NSMutableDictionary<NSString*, NSTimer*> *terminationTimers;
@property NSMutableDictionary<NSString*, TempSpawnProcessState*> *processStates;
@property NSUserDefaults *prefs;
@property NSUserDefaults *killOnExit;
@property NSUserDefaults *trackerList;
@property NSUserDefaults *userBlacklist;
@property NSDictionary *systemBlacklist;

-(void)addObservers;
-(void)loadPrefs;
-(void)loadKillOnExit;
-(void)loadUserBlacklist;
-(void)loadSystemBlacklist;
-(BOOL)shouldKillOnExit:(NSString*)bundleIdentifier;
-(BOOL)isBlacklisted:(NSString*)bundleIdentifier;
-(void)terminateAppFromTimer:(NSTimer*)timer;
-(void)terminateAppSoon:(NSString*)bundleIdentifier;
-(void)terminateAppNow:(NSString*)bundleIdentifier withReason:(NSString*)reason;
-(void)cancelTerminationTimer:(NSString*)bundleIdentifier;
@end
 
@interface CPNotification : NSObject
+(void)showAlertWithTitle:(NSString*)title message:(NSString*)message userInfo:(NSDictionary*)userInfo badgeCount:(int)badgeCount soundName:(NSString*)soundName delay:(double)delay repeats:(BOOL)repeats bundleId:(NSString*)bundleId;
@end

@interface TUCallProvider : NSObject
-(NSString *)bundleIdentifier;
@end

@interface TUCall : NSObject
-(TUCallProvider *)backingProvider;
@end

@interface TUProxyCall : TUCall
-(int)callStatus;
@end
