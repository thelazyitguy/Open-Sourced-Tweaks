@interface _UIStatusBarStringView : UILabel
@property(nullable, nonatomic, copy) NSString *text;
@property(nonatomic) NSTextAlignment textAlignment;
@property(nonatomic) NSInteger numberOfLines;
@property(nullable, nonatomic, copy) NSAttributedString *attributedText;
@end