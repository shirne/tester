//
//  FlutterPluginOtherPlugin.m
//  Runner
//

#import "FlutterPluginOtherPlugin.h"
#import "otherViewController.h"

@implementation FlutterPluginOtherPlugin


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.shirne.tester/channel"
            binaryMessenger:[registrar messenger]];
  FlutterPluginOtherPlugin* instance = [[FlutterPluginOtherPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"openOther" isEqualToString:call.method]) {

      otherViewController * other = [[otherViewController alloc] init];

      UIViewController * vc = [FlutterPluginOtherPlugin xs_getCurrentViewController];
      other.modalPresentationStyle = 0;
      [vc presentViewController:other animated:YES completion:nil];

  }
  else {
    result(FlutterMethodNotImplemented);
  }
}



+ (UIViewController *)xs_getCurrentViewController{


    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");

    
    //获取根控制器
    UIViewController* currentViewController = window.rootViewController;
    //获取当前页面控制器
    
    BOOL runLoopFind = YES;
    
    while (runLoopFind){
        
        if (currentViewController.presentedViewController){
            currentViewController = currentViewController.presentedViewController;
        }else if([currentViewController isKindOfClass:[UINavigationController class]]){
            
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
            
        }else if([currentViewController isKindOfClass:[UITabBarController class]]){
            
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        }else{
            
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                currentViewController = currentViewController.childViewControllers.lastObject;
                return currentViewController;
            }else{
                return currentViewController;
            }
            
        }
        
        
    }
    
    return currentViewController;
}

@end
