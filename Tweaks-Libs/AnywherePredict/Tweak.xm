#import "../PS.h"
#import <substrate.h>
#import <UIKit/UIKeyboardImpl.h>
#import <UIKit/UITextInputTraits+Private.h>

int prehook(UIKeyboardImpl *self) {
    int r = 0;
    UITextInputTraits *traits = MSHookIvar<UITextInputTraits *>(self, "m_traits");
    BOOL wasNo1 = traits.autocorrectionType == UITextAutocorrectionTypeNo;
    BOOL wasNo2 = traits.disablePrediction;
    if (wasNo1) {
        traits.autocorrectionType = UITextAutocorrectionTypeYes;
        r |= 1;
    }
    if (wasNo2) {
        traits.disablePrediction = NO;
        r |= 1 << 1;
    }
    return r;
}

void posthook(UIKeyboardImpl *self, int x) {
    UITextInputTraits *traits = MSHookIvar<UITextInputTraits *>(self, "m_traits");
    if (x & 1)
        traits.autocorrectionType = UITextAutocorrectionTypeNo;
    if (x & (1 << 1))
        traits.disablePrediction = YES;
}

%group iOS13Up2

%hook UIPredictionViewController

- (BOOL)isVisibleForInputDelegate:(id)delegate inputViews:(id)inputViews {
    UIKeyboardImpl *impl = [UIKeyboardImpl sharedInstance];
    int x = prehook(impl);
    BOOL orig = %orig;
    posthook(impl, x);
    return orig;
}

%end

%end

%hook UIKeyboardImpl

%group iOS13Up

- (BOOL)canUseCandidateBarAsSupplementToInlineView {
    int x = prehook(self);
    BOOL orig = %orig;
    posthook(self, x);
    return orig;
}

- (BOOL)candidateSelectionPredictionForTraits {
    int x = prehook(self);
    BOOL orig = %orig;
    posthook(self, x);
    return orig;
}

- (BOOL)_shouldLoadPredictionsBasedOnCurrentTraits {
    int x = prehook(self);
    BOOL orig = %orig;
    posthook(self, x);
    return orig;
}

%end

%group iOS10Up

- (BOOL)predictionForTraitsWithForceEnable:(BOOL)force {
    int x = prehook(self);
    BOOL orig = %orig;
    posthook(self, x);
    return orig;
}

%end

%group preiOS10

- (BOOL)predictionForTraits {
    int x = prehook(self);
    BOOL orig = %orig;
    posthook(self, x);
    return orig;
}

%end

%end

%ctor {
    if (isiOS13Up) {
        %init(iOS13Up2);
        %init(iOS13Up);
    } else if (isiOS10Up) {
        %init(iOS10Up);
    } else {
        %init(preiOS10);
    }
}
