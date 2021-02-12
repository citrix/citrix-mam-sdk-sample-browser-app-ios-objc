//
//  AppDelegateComplianceOnly.m
//  SimpleBrowserAppComplianceOnly
//
//  Created by Jaspreet Singh on 11/7/19.
//  Copyright © 2019-2020 Citrix Systems, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <CTXMAMCore/CTXMAMCore.h>
#import "AppDelegate+ComplianceSDKDelegate.h"

@interface AppDelegate () 
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[CTXMAMSDKModeControl sharedInstance] registerSdkModeAlertDelegate:self];
    
    [CTXMAMCore initializeSDKs];
    
    [CTXMAMCompliance sharedInstance].delegate = self;

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark - SDK Mode Control
- (void) sdkModeControlCallback:(NSError *)error
{
    if (error)
    {
        if (error.code == sdkModeErrorSdkMismatch)
        {
            // The loaded SDK doesn't match the target SDK indicated by policies. Let the user know that the app
            // must be restarted, and provide a uit buttom that will exit the app.
            NSString *alertTitle = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
            if (alertTitle == nil || [alertTitle  isEqual:@""] || [alertTitle  isEqual:@"PolicyChangeRequiresRestartAlertTitle"])
            {
                // The CTXMAM didn't give us a localized string. Provide our own string.
                alertTitle = @"Policy Change Requires Restart";
            }
            NSString *alertMsg = [error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
            if (alertMsg == nil || [alertMsg  isEqual:@""] || [alertMsg  isEqual:@"PolicyChangeRequiresRestartAlertMsg"])
            {
                // The CTXMAM didn't give us a localized string. Provide our own string.
                alertMsg = @"A policy change that requires this app to restart has been detected.";
            }
            
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:alertTitle
                                        message:alertMsg
                                        preferredStyle:UIAlertControllerStyleAlert];
            //Add Quit Button
            UIAlertAction *quitButton = [UIAlertAction
                                         actionWithTitle:@"Quit"
                                         style:UIAlertActionStyleDestructive
                                         handler:^(UIAlertAction * action) {
                                             id appdelegate =   [[UIApplication sharedApplication] delegate];
                                             [appdelegate applicationWillTerminate:[UIApplication sharedApplication]];
                                             exit(0); // terminate the app
                                         }];
            [alert addAction:quitButton];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
                [topController presentViewController:alert animated:YES completion:nil];
            });
        }
    } // end if error
}

@end
