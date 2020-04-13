#import "private/AppearanceSelectionTableCell.h"

NSString *firstOptionName;
NSString *secondOptionName;
NSString *firstOptionImage;
NSString *secondOptionImage;
NSString *defaultsIdentifier;
NSString *postNotification;
NSString *key;
NSUserDefaults *userDefaults;

@implementation AppearanceTypeStackView

- (id)initWithType:(int)type
     forController:(AppearanceSelectionTableCell *)controller {
  self = [super init];
  if (self) {
    userDefaults = [[NSUserDefaults alloc]
        _initWithSuiteName:defaultsIdentifier
                 container:[NSURL URLWithString:@"/var/mobile"]];

    [userDefaults registerDefaults:@{ key : @0 }];

    self.hostController = controller;
    self.captionLabel = [[UILabel alloc] init];
    self.checkmarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkmarkButton.frame = CGRectMake(0, 0, 22, 22);

    self.feedbackGenerator = [[UIImpactFeedbackGenerator alloc]
        initWithStyle:(UIImpactFeedbackStyleMedium)];
    [self.feedbackGenerator prepare];

    self.type = type;

    if (self.type == 1) {
      self.iconImage = [UIImage imageWithContentsOfFile:secondOptionImage];
      self.captionLabel.text = secondOptionName;
    } else {
      self.iconImage = [UIImage imageWithContentsOfFile:firstOptionImage];
      self.captionLabel.text = firstOptionName;
    }

    NSNumber *appearanceStyle = (NSNumber *)[userDefaults objectForKey:key];
    if ([appearanceStyle isEqualToNumber:[NSNumber numberWithInt:self.type]]) {
      [self.checkmarkButton
          setImage:[UIImage
                       imageWithContentsOfFile:
                           @"/Library/Application Support/libappearancecell/"
                           @"selected.png"]
          forState:UIControlStateNormal];
    } else {
      [self.checkmarkButton
          setImage:[UIImage
                       imageWithContentsOfFile:
                           @"/Library/Application Support/libappearancecell/"
                           @"notselected.png"]
          forState:UIControlStateNormal];
    }

    self.iconView = [[UIImageView alloc] initWithImage:self.iconImage];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.iconView.heightAnchor constraintEqualToConstant:85].active = true;
    [self.iconView.widthAnchor constraintEqualToConstant:85].active = true;

    [self.captionLabel
        setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [self.captionLabel.heightAnchor constraintEqualToConstant:20].active = true;

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0")) {
      [self.captionLabel setTextColor:[UIColor labelColor]];
    } else {
      [self.captionLabel setTextColor:[UIColor blackColor]];
    }

    [self.checkmarkButton.heightAnchor constraintEqualToConstant:22].active =
        true;
    [self.checkmarkButton.widthAnchor constraintEqualToConstant:22].active =
        true;
    [self.checkmarkButton addTarget:self
                             action:@selector(buttonTapped)
                   forControlEvents:UIControlEventTouchUpInside];

    self.contentStackview = [[UIStackView alloc] init];
    self.contentStackview.axis = UILayoutConstraintAxisVertical;
    self.contentStackview.alignment = UIStackViewAlignmentCenter;
    self.contentStackview.spacing = 5;

    [self.contentStackview addArrangedSubview:self.iconView];
    [self.contentStackview addArrangedSubview:self.captionLabel];
    [self.contentStackview addArrangedSubview:self.checkmarkButton];

    self.contentStackview.translatesAutoresizingMaskIntoConstraints = false;
    self.translatesAutoresizingMaskIntoConstraints = false;

    self.tapGestureRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(buttonTapped)];
    self.tapGestureRecognizer.numberOfTapsRequired = 1;

    [self addSubview:self.contentStackview];
    [self.contentStackview setUserInteractionEnabled:YES];
    [self.contentStackview addGestureRecognizer:self.tapGestureRecognizer];

    [self.widthAnchor constraintEqualToConstant:85].active = true;
    [self.heightAnchor constraintEqualToConstant:140].active = true;
  }
  return self;
}

- (void)buttonTapped {
  [self.feedbackGenerator impactOccurred];

  [userDefaults setObject:[NSNumber numberWithInt:self.type] forKey:key];
  [userDefaults synchronize];

  CFNotificationCenterPostNotification(
      CFNotificationCenterGetDarwinNotifyCenter(),
      (__bridge CFStringRef)postNotification, NULL, NULL, YES);

  [self.hostController updateForType:self.type];
}

@end

@implementation AppearanceSelectionTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                    specifier:(PSSpecifier *)specifier {
  self = [super initWithStyle:style
              reuseIdentifier:reuseIdentifier
                    specifier:specifier];

  if (self) {
    firstOptionName = specifier.properties[@"firstOptionName"];
    secondOptionName = specifier.properties[@"secondOptionName"];
    firstOptionImage = specifier.properties[@"firstOptionImage"];
    secondOptionImage = specifier.properties[@"secondOptionImage"];
    defaultsIdentifier = specifier.properties[@"defaults"];
    postNotification = specifier.properties[@"PostNotification"];
    key = specifier.properties[@"key"];

    self.firstStackView =
        [[AppearanceTypeStackView alloc] initWithType:0 forController:self];
    self.secondStackView =
        [[AppearanceTypeStackView alloc] initWithType:1 forController:self];

    self.containerStackView = [[UIStackView alloc] init];
    self.containerStackView.axis = UILayoutConstraintAxisHorizontal;
    self.containerStackView.alignment = UIStackViewAlignmentCenter;
    self.containerStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.containerStackView.spacing = 50;
    self.containerStackView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.containerStackView addArrangedSubview:self.firstStackView];
    [self.containerStackView addArrangedSubview:self.secondStackView];
    [self.contentView addSubview:self.containerStackView];

    [self.containerStackView.centerXAnchor
        constraintEqualToAnchor:self.centerXAnchor]
        .active = true;
    [self.containerStackView.centerYAnchor
        constraintEqualToAnchor:self.centerYAnchor]
        .active = true;
    [self.heightAnchor constraintEqualToConstant:160].active = true;
  }

  return self;
}

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
  self = [self initWithStyle:UITableViewCellStyleDefault
             reuseIdentifier:@"AppearanceSelectionTableCell"
                   specifier:specifier];
  return self;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
  return 160.0f;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)width inTableView:(id)tableView {
  return [self preferredHeightForWidth:width];
}

- (void)updateForType:(int)type {
  AppearanceTypeStackView *notSelect;
  AppearanceTypeStackView *toSelect;

  if (type == 1) {
    notSelect = self.firstStackView;
    toSelect = self.secondStackView;
  } else {
    notSelect = self.secondStackView;
    toSelect = self.firstStackView;
  }

  [UIView transitionWithView:notSelect.checkmarkButton
      duration:0.2f
      options:UIViewAnimationOptionTransitionCrossDissolve
      animations:^{
        [notSelect.checkmarkButton
            setImage:[UIImage
                         imageWithContentsOfFile:
                             @"/Library/Application Support/libappearancecell/"
                             @"notselected.png"]
            forState:UIControlStateNormal];
      }
      completion:^(BOOL finished) {
        finished = YES;
      }];

  [UIView transitionWithView:toSelect.checkmarkButton
      duration:0.2f
      options:UIViewAnimationOptionTransitionCrossDissolve
      animations:^{
        [toSelect.checkmarkButton
            setImage:[UIImage
                         imageWithContentsOfFile:
                             @"/Library/Application Support/libappearancecell/"
                             @"selected.png"]
            forState:UIControlStateNormal];
      }
      completion:^(BOOL finished) {
        finished = YES;
      }];
}

@end