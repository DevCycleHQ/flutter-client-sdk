#import "DevCycleFlutterClientSdkPlugin.h"
#if __has_include(<devcycle_flutter_client_sdk/devcycle_flutter_client_sdk-Swift.h>)
#import <devcycle_flutter_client_sdk/devcycle_flutter_client_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "devcycle_flutter_client_sdk-Swift.h"
#endif

@implementation DevCycleFlutterClientSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDevCycleFlutterClientSdkPlugin registerWithRegistrar:registrar];
}
@end
