/*
    Generated for Injection of class implementations
*/

#define INJECTION_NOIMPL
#define INJECTION_BUNDLE InjectionBundle3

#define INJECTION_ENABLED
#import "/Users/zzdjk6/Library/Application Support/Developer/Shared/Xcode/Plug-ins/InjectionPlugin.xcplugin/Contents/Resources//BundleInjection.h"

#undef _instatic
#define _instatic extern

#undef _inglobal
#define _inglobal extern

#undef _inval
#define _inval( _val... ) /* = _val */

#import "BundleContents.h"

extern
#if __cplusplus
"C" {
#endif
    int injectionHook(void);
#if __cplusplus
};
#endif

@interface InjectionBundle3 : NSObject
@end
@implementation InjectionBundle3

+ (void)load {
    Class bundleInjection = NSClassFromString(@"BundleInjection");
    [bundleInjection autoLoadedNotify:16 hook:(void *)injectionHook];
}

@end

int injectionHook() {
    NSLog( @"injectionHook():" );
    [InjectionBundle3 load];
    return YES;
}

#import "/Users/zzdjk6/Projects/CocoaProjects_Team/GeekBand-I150009_zzdjk6/MCDiary/MCDiary/Classes/ViewControllers/User/MCDUserInfoContentViewController.m"



