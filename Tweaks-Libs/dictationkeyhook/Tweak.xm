@interface UIKBTree : NSObject
@property (nonatomic,retain) NSString * name;
@property (nonatomic,retain) NSMutableDictionary * properties;
@end

@interface UIKeyboardInputMode : NSObject
@property (nonatomic,retain) NSString * normalizedIdentifier; 
@end

@interface UIKeyboardInputModeController : NSObject
@property (retain) UIKeyboardInputMode * currentInputMode;
@property (nonatomic,retain) UIKeyboardInputMode * nextInputModeToUse;
+(id)sharedInputModeController;
-(id)activeInputModes;
@end

@interface MyCode : NSObject
+(void)switchToEmojiKeyboard;
@end

@implementation MyCode
+(void)switchToEmojiKeyboard {
  UIKeyboardInputModeController *kimController = [UIKeyboardInputModeController sharedInputModeController];

  UIKeyboardInputMode *currentInputMode = [kimController currentInputMode];
  if ([currentInputMode.normalizedIdentifier isEqual:@"emoji"]) {
    kimController.currentInputMode = kimController.nextInputModeToUse;
    return;
  }

  NSArray* activeInputModes = [kimController activeInputModes];
  for (int i = 0; i < [activeInputModes count]; i++) {
    UIKeyboardInputMode *mode = [activeInputModes objectAtIndex:i];
    if ([mode.normalizedIdentifier isEqual:@"emoji"]) {
      kimController.nextInputModeToUse = currentInputMode;
      kimController.currentInputMode = mode;
      break;
    }
  }
}
@end

%hook UISystemKeyboardDockController
-(void)dictationItemButtonWasPressed:(id)arg1 withEvent:(id)arg2 {
  NSSet *event = [arg2 allTouches];
  if (event) {
    id uiTouch = event.allObjects[0];
    if([NSStringFromClass([uiTouch classForCoder]) isEqual:@"UITouch"]){
      // check if phase is UITouchPhase.UITouchPhaseBegan);
      if ([uiTouch phase] == 0) {
        [MyCode switchToEmojiKeyboard];
      }
    }
  }
}
%end

%hook UIKeyboardLayoutStar
-(UIKBTree*)keyHitTest:(CGPoint)arg1 {
  UIKBTree* orig = %orig;
  if (orig && [orig.name isEqualToString:@"Dictation-Key"]) {
    orig.properties[@"KBinteractionType"] = @(0);
    [MyCode switchToEmojiKeyboard];
  }
  return orig;
}

%end