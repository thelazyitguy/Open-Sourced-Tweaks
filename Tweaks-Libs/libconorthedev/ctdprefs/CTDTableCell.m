#import "CTDPrefs.h"

@implementation CTDTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                    specifier:(PSSpecifier *)specifier {
  self = [super initWithStyle:style
              reuseIdentifier:reuseIdentifier
                    specifier:specifier];
  if (self) {
    if ([CTDPreferenceSettings sharedInstance].tintColor) {
      self.textLabel.textColor =
          [CTDPreferenceSettings sharedInstance].tintColor;
    }
  }
  return self;
}

- (void)tintColorDidChange {
  [super tintColorDidChange];

  if ([CTDPreferenceSettings sharedInstance].tintColor) {
    self.textLabel.textColor = [CTDPreferenceSettings sharedInstance].tintColor;
  }
}

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
  [super refreshCellContentsWithSpecifier:specifier];

  if ([CTDPreferenceSettings sharedInstance].tintColor) {
    self.textLabel.textColor = [CTDPreferenceSettings sharedInstance].tintColor;
  }
}
@end