#import "../PS.h"
#import "Header.h"

#import <dlfcn.h>
#import <mach/port.h>
#import <mach/kern_return.h>

typedef struct HXISPCaptureStream *HXISPCaptureStreamRef;
typedef struct HXISPCaptureDevice *HXISPCaptureDeviceRef;
typedef struct HXISPCaptureGroup *HXISPCaptureGroupRef;

int (*SetTorchLevel)(CFNumberRef, HXISPCaptureStreamRef, HXISPCaptureDeviceRef) = NULL;
int (*SetTorchLevelWithGroup)(CFNumberRef, HXISPCaptureStreamRef, HXISPCaptureGroupRef, HXISPCaptureDeviceRef) = NULL;
SInt32 (*GetCFPreferenceNumber)(CFStringRef const, CFStringRef const, SInt32) = NULL;

%group SetTorchLevelHook

%hookf(int, SetTorchLevel, CFNumberRef level, HXISPCaptureStreamRef stream, HXISPCaptureDeviceRef device) {
    BOOL enabled = GetCFPreferenceNumber(key, kDomain, 0);
    bool *highCurrentEnabled = (bool *)((uintptr_t)stream + 0x90C);
    bool original = *highCurrentEnabled;
    if (enabled)
        *highCurrentEnabled = YES;
    int result = %orig(level, stream, device);
    *highCurrentEnabled = original;
    return result;
}

%end

%group SetTorchLevelWithGroupHook

%hookf(int, SetTorchLevelWithGroup, CFNumberRef level, HXISPCaptureStreamRef stream, HXISPCaptureGroupRef group, HXISPCaptureDeviceRef device) {
    BOOL enabled = GetCFPreferenceNumber(key, kDomain, 0);
    bool *highCurrentEnabled = (bool *)((uintptr_t)stream + 0xA6C);
    bool original = *highCurrentEnabled;
    if (enabled)
        *highCurrentEnabled = YES;
    int result = %orig(level, stream, group, device);
    *highCurrentEnabled = original;
    return result;
}

%end

%ctor {
    int HVer = 0;
    void *IOKit = dlopen("/System/Library/Frameworks/IOKit.framework/IOKit", RTLD_NOW);
    if (IOKit) {
        mach_port_t *kIOMasterPortDefault = (mach_port_t *)dlsym(IOKit, "kIOMasterPortDefault");
        CFMutableDictionaryRef (*IOServiceMatching)(const char *name) = (CFMutableDictionaryRef (*)(const char *))dlsym(IOKit, "IOServiceMatching");
        mach_port_t (*IOServiceGetMatchingService)(mach_port_t masterPort, CFDictionaryRef matching) = (mach_port_t (*)(mach_port_t, CFDictionaryRef))dlsym(IOKit, "IOServiceGetMatchingService");
        kern_return_t (*IOObjectRelease)(mach_port_t object) = (kern_return_t (*)(mach_port_t))dlsym(IOKit, "IOObjectRelease");
        if (kIOMasterPortDefault && IOServiceGetMatchingService && IOObjectRelease) {
            mach_port_t h10 = IOServiceGetMatchingService(*kIOMasterPortDefault, IOServiceMatching("AppleH10CamIn"));
            if (h10) {
                HVer = 10;
                IOObjectRelease(h10);
            }
            if (HVer == 0) {
                mach_port_t h9 = IOServiceGetMatchingService(*kIOMasterPortDefault, IOServiceMatching("AppleH9CamIn"));
                if (h9) {
                    HVer = 9;
                    IOObjectRelease(h9);
                }
            }
        }
        dlclose(IOKit);
        HBLogDebug(@"Detected ISP version: %d", HVer);
    }
    if (HVer == 0) return;
    MSImageRef hxRef;
    switch (HVer) {
        case 10:
            dlopen("/System/Library/MediaCapture/H10ISP.mediacapture", RTLD_LAZY);
            hxRef = MSGetImageByName("/System/Library/MediaCapture/H10ISP.mediacapture");
            SetTorchLevel = (int (*)(CFNumberRef, HXISPCaptureStreamRef, HXISPCaptureDeviceRef))_PSFindSymbolCallable(hxRef, "__ZL13SetTorchLevelPKvP19H10ISPCaptureStreamP19H10ISPCaptureDevice");
            if (SetTorchLevel == NULL)
                SetTorchLevelWithGroup = (int (*)(CFNumberRef, HXISPCaptureStreamRef, HXISPCaptureGroupRef, HXISPCaptureDeviceRef))_PSFindSymbolCallable(hxRef, "__ZL13SetTorchLevelPKvP19H10ISPCaptureStreamP18H10ISPCaptureGroupP19H10ISPCaptureDevice");
            GetCFPreferenceNumber = (SInt32 (*)(CFStringRef const, CFStringRef const, SInt32))_PSFindSymbolCallable(hxRef, "__ZN6H10ISP27H10ISPGetCFPreferenceNumberEPK10__CFStringS2_i");
            break;
        case 9:
            dlopen("/System/Library/MediaCapture/H9ISP.mediacapture", RTLD_LAZY);
            hxRef = MSGetImageByName("/System/Library/MediaCapture/H9ISP.mediacapture");
            SetTorchLevel = (int (*)(CFNumberRef, HXISPCaptureStreamRef, HXISPCaptureDeviceRef))_PSFindSymbolCallable(hxRef, "__ZL13SetTorchLevelPKvP18H9ISPCaptureStreamP18H9ISPCaptureDevice");
            if (SetTorchLevel == NULL)
                SetTorchLevelWithGroup = (int (*)(CFNumberRef, HXISPCaptureStreamRef, HXISPCaptureGroupRef, HXISPCaptureDeviceRef))_PSFindSymbolCallable(hxRef, "__ZL13SetTorchLevelPKvP18H9ISPCaptureStreamP17H9ISPCaptureGroupP18H9ISPCaptureDevice");
            GetCFPreferenceNumber = (SInt32 (*)(CFStringRef const, CFStringRef const, SInt32))_PSFindSymbolCallable(hxRef, "__ZN5H9ISP26H9ISPGetCFPreferenceNumberEPK10__CFStringS2_i");
            break;
    }
    HBLogDebug(@"SetTorchLevel found: %d", SetTorchLevel != NULL);
    HBLogDebug(@"SetTorchLevelWithGroup found: %d", SetTorchLevelWithGroup != NULL);
    HBLogDebug(@"GetCFPreferenceNumber found: %d", GetCFPreferenceNumber != NULL);
    if (SetTorchLevelWithGroup) {
        %init(SetTorchLevelWithGroupHook);
    } else {
        %init(SetTorchLevelHook);
    }
    %init;
}