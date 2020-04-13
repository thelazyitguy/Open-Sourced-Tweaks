#import "CTDPrefs.h"

@implementation CTDHeaderCell
@synthesize titleLabel;
@synthesize backgroundView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                    specifier:(PSSpecifier *)specifier {
  self = [super initWithStyle:style
              reuseIdentifier:reuseIdentifier
                    specifier:specifier];

  if (self) {
    UIView *backgroundColourView = [[UIView alloc] initWithFrame:[self frame]];

    if ([CTDPreferenceSettings sharedInstance].tintColor) {
      backgroundColourView.backgroundColor =
          [CTDPreferenceSettings sharedInstance].tintColor;
    } else {
      if (@available(iOS 13.0, *)) {
        backgroundColourView.backgroundColor =
            [UIColor secondarySystemGroupedBackgroundColor];
      } else {
        backgroundColourView.backgroundColor = [UIColor whiteColor];
      }
    }

    self.iconView = [[UIImageView alloc]
        initWithImage:[UIImage imageWithContentsOfFile:specifier.properties
                                                           [@"iconPath"]]];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.iconView.heightAnchor constraintEqualToConstant:65].active = true;
    [self.iconView.widthAnchor constraintEqualToConstant:65].active = true;

    UIStackView *labelStackView = [[UIStackView alloc] init];
    labelStackView.axis = UILayoutConstraintAxisVertical;
    labelStackView.alignment = UIStackViewAlignmentLeading;
    labelStackView.distribution = UIStackViewDistributionEqualSpacing;
    labelStackView.spacing = 5;

    self.titleLabel = [[UILabel alloc] initWithFrame:[self frame]];
    [self.titleLabel setNumberOfLines:1];
    [self.titleLabel setText:specifier.properties[@"title"]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setShadowColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];

    self.subtitleLabel = [[UILabel alloc] initWithFrame:[self frame]];
    [self.subtitleLabel setNumberOfLines:1];
    [self.subtitleLabel setText:specifier.properties[@"subtitle"]];
    [self.subtitleLabel setBackgroundColor:[UIColor clearColor]];
    [self.subtitleLabel setShadowColor:[UIColor clearColor]];
    [self.subtitleLabel setFont:[UIFont systemFontOfSize:22]];

    [self.titleLabel.heightAnchor constraintEqualToConstant:33].active = true;
    [self.subtitleLabel.heightAnchor constraintEqualToConstant:23].active =
        true;

    self.containerStackView = [[UIStackView alloc] init];
    self.containerStackView.axis = UILayoutConstraintAxisHorizontal;
    self.containerStackView.alignment = UIStackViewAlignmentCenter;
    self.containerStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.containerStackView.spacing = 10;

    self.containerStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    labelStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    backgroundColourView.translatesAutoresizingMaskIntoConstraints = NO;

    [labelStackView addArrangedSubview:self.titleLabel];
    [labelStackView addArrangedSubview:self.subtitleLabel];
    [self.containerStackView addArrangedSubview:self.iconView];
    [self.containerStackView addArrangedSubview:labelStackView];
    [self.contentView addSubview:self.containerStackView];
    [self.contentView insertSubview:backgroundColourView atIndex:0];

    [backgroundColourView.centerXAnchor
        constraintEqualToAnchor:self.centerXAnchor]
        .active = true;
    [backgroundColourView.centerYAnchor
        constraintEqualToAnchor:self.centerYAnchor]
        .active = true;
    [backgroundColourView.widthAnchor constraintEqualToAnchor:self.widthAnchor]
        .active = true;
    [backgroundColourView.heightAnchor constraintEqualToConstant:150].active =
        true;

    [self.containerStackView.centerXAnchor
        constraintEqualToAnchor:self.centerXAnchor]
        .active = true;
    [self.containerStackView.centerYAnchor
        constraintEqualToAnchor:self.centerYAnchor]
        .active = true;
    [self.heightAnchor constraintEqualToConstant:150].active = true;
  }

  return self;
}

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
  self = [self initWithStyle:UITableViewCellStyleDefault
             reuseIdentifier:nil
                   specifier:specifier];
  return self;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
  return 150.0f;
}

@end