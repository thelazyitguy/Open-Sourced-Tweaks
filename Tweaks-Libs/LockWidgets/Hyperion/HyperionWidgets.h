// This is the protocol that your HyperionWidget class must conform to
@protocol HyperionWidget <NSObject>

// These are the required methods
@required
-(void)setup; // The setup method is used to initially layout your contentView
-(UIView*)contentView; // Your contentView must be returned using this method
-(void)layoutForPreview; // This is called when a user accesses the 'HyperionWidget Manager', so make your widget look nice in the manager here.

// Optional methods
@optional
-(void)updateTime:(NSDate*)time; // This provides the current date as an NSDate when Hyperion updates it
-(void)updateWeather:(NSDictionary*)info; // This provides current weather information when Hyperion updates it
-(void)updateMusic:(NSDictionary*)info; // This provides music information when Hyperion updates it
-(void)updateBattery:(NSDictionary*)info; // This provides battery information when Hyperion updates it
-(void)didAppear; // This method is called when Hyperion will become visible
-(void)didHide; // This method is called when Hyperion is dismissed

@end