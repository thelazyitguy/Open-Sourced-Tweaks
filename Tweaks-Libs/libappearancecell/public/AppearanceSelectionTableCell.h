#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@interface UIColor (ios13fix)
@property(class, nonatomic, readonly) UIColor *labelColor;
@end

@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(PSSpecifier *)specifier;
- (CGFloat)preferredHeightForWidth:(CGFloat)width;
@end

@interface AppearanceTypeStackView : UIView
@end

@interface AppearanceSelectionTableCell
    : PSTableCell <PreferencesTableCustomView>
@property(nonatomic, retain) UIStackView *containerStackView;
@property(nonatomic, retain) AppearanceTypeStackView *firstStackView;
@property(nonatomic, retain) AppearanceTypeStackView *secondStackView;

- (void)updateForType:(int)type;
@end

@interface AppearanceTypeStackView ()
@property(nonatomic, retain) UIImage *iconImage;
@property(nonatomic, retain) UIImageView *iconView;
@property(nonatomic, retain) UILabel *captionLabel;
@property(nonatomic, retain) UIButton *checkmarkButton;
@property(nonatomic, retain) UIStackView *contentStackview;
@property(nonatomic, retain) AppearanceSelectionTableCell *hostController;
@property(nonatomic, retain) UIImpactFeedbackGenerator *feedbackGenerator;
@property(nonatomic, retain) UITapGestureRecognizer *tapGestureRecognizer;
@property(nonatomic, assign) int type;

- (id)initWithType:(int)type
     forController:(AppearanceSelectionTableCell *)controller;
- (void)buttonTapped;
@end