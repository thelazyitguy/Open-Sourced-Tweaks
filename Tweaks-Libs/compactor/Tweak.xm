#import <substrate.h>
#import <os/log.h>

#import "pac_helpers.h"

extern "C" {
    size_t (*UIApplicationInitialize)(void) = NULL;
    void *(*fakeCTFontSetAltTextStyleSpec)(void) = NULL;
    void *CTFontSetAltTextStyleSpec(void) __attribute__((weak_import));
}

MSHook(size_t, UIApplicationInitialize) {
        size_t orig = _UIApplicationInitialize();
        CTFontSetAltTextStyleSpec();
        return orig;
}

%ctor {
    MSImageRef image = MSGetImageByName("/System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore");
    if (!image) {
        NSLog(@"[compactor] no UIKit");
        return;
    }

    UIApplicationInitialize = (size_t (*)(void))MSFindSymbol(image, "_UIApplicationInitialize");
    if (!UIApplicationInitialize) {
        NSLog(@"[compactor] no _UIApplicationInitialize wtf???");
        return;
    }

    MSHookFunction(UIApplicationInitialize, MSHake(UIApplicationInitialize));
}