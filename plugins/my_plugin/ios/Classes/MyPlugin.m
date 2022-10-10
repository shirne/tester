#import "MyPlugin.h"
#if __has_include(<my_plugin/my_plugin-Swift.h>)
#import <my_plugin/my_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "my_plugin-Swift.h"
#endif

@implementation MyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMyPlugin registerWithRegistrar:registrar];
}
@end
