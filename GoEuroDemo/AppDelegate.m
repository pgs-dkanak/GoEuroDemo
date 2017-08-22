//
//  AppDelegate.m
//  GoEuroDemo
//
//  Created by Damian Kanak on 22/08/2017.
//  Copyright © 2017 pgs. All rights reserved.
//

#import "AppDelegate.h"
#import "GoEuroDemo-Swift.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // AppDependency object is intended to be an Objective-C facade object, as it is impossible to create RidesViewModel from Objective-C directly. This is due to usage of NetworkingAPI protocol within RidesViewModel initializer, which is swift-only protocol. This is neat workaround that makes possible to manage Swift-only objects from Objective-C code.
    
    AppDependency *appDependency = [[AppDependency alloc] init];
    UIViewController *mainViewController = [appDependency createMainViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self.window setRootViewController:mainViewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
