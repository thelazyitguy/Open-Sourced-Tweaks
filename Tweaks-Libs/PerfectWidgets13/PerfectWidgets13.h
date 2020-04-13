@interface WGWidgetListHeaderView: UIView
@end

@interface MTMaterialView: UIView
@property(nonatomic, retain) NSString *groupNameBase;
- (void)applyColor:(UIColor*)backgroundColor borderColor: (UIColor*)borderColor;
@end

@interface WGWidgetListItemViewController: UIViewController
@end

@interface WGWidgetPlatterView: UIView
@property(nonatomic, retain) UIColor *bgColor;
@property(nonatomic, retain) UIColor *borderColor;
- (WGWidgetListItemViewController*)listItem;
- (UIView*)contentView;
- (void)colorizeWidget;
- (UIButton*)showMoreButton;
- (UIColor*)calculateWidgetBgColor;
@end

@interface PLPlatterHeaderContentView: UIView
- (void)_updateTextAttributesForDateLabel;
- (UILabel*)_titleLabel;
@end

@interface WGPlatterHeaderContentView: PLPlatterHeaderContentView
- (NSArray*)iconButtons;
@property(nonatomic, copy) NSArray *icons;
@end