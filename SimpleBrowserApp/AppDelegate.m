//
//  AppDelegate.m
//  SimpleBrowserApp
//
//  Created by Daniel Romano on 3/21/19.
//  Copyright © 2019 Citrix Systems, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <CTXMAMCore/CTXMAMCore.h>
#import <CTXMAMNetwork/CTXMAMNetwork.h>
#import <CTXMAMContainment/CTXMAMContainment.h>
#import <CTXMAMLocalAuth/CTXMAMLocalAuth.h>
#import "AppDelegate+ComplianceSDKDelegate.h"

@interface AppDelegate () <CTXMAMLocalAuthSdkDelegate,
                           CTXMAMContainmentSdkDelegate,
                           CTXMAMCoreSdkDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    CTXMAMNotificationEventBlock notificationHandler = ^(CTXMAMNotification * _Nonnull notification)
    {
        //Do something with the notification
        if([[notification Source] isEqualToString:CTXMAMNotificationSource_Core])
        {
            //Do something;
        }
        else if([[notification Source] isEqualToString:CTXMAMNotificationSource_Network])
        {
            //Do something else;
        }
        else if([[notification Source] isEqualToString:CTXMAMNotificationSource_Containment])
        {
            [self handleContainmentNotification:notification];
        }
    };
    [[CTXMAMNotificationCenter mainNotificationCenter] registerForNotificationsFromSource:CTXMAMNotificationSource_All usingNotificationBlock:notificationHandler];
    
    [CTXMAMLocalAuth setDelegate:self];
    [CTXMAMCompliance sharedInstance].delegate = self;
    [CTXMAMContainment setDelegate:self];
    [CTXMAMCore setDelegate:self];

    [CTXMAMCore initializeSDKs];

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


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Containment SDK
- (void) handleContainmentNotification:(CTXMAMNotification *)notification
{
    if (notification.Error.code == CTXAlertGeofenceOutsideOfAcceptedArea ||
        notification.Error.code == CTXAlertGeofenceLocationServicesRequired)
    {
        // For these events, usage of the app may be restricted. They will be handled by delegate callback.
    }
    else
    {
        // For these events, just display a notification

        NSString *alertMsg = [notification Message];

        NSLog(@"CTXMAM Containment Notification: [%@]", alertMsg);

        [self showAlertMsg:alertMsg];
    }
}

- (void) appIsOutsideGeofencingBoundary
{
    NSString *alertMsg = @"You have left the area that your organization designates for this app. Please return to the designated area and relaunch the app.";
    [self enforceAppUsageRestrictions:alertMsg];
}

- (void) appNeedsLocationServicesEnabled
{
    NSString *alertMsg = @"Your organization requires you to enable Location Services to run this app.";
    [self enforceAppUsageRestrictions:alertMsg];
}

-(void)showAlertMsg:(NSString *)alertMsg
{
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:alertMsg
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];

    int duration = 3; // duration in seconds
    if ([alertMsg length] > 40)
        duration = 5; // allow more time to read longer messages
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}

-(void)enforceAppUsageRestrictions:(NSString *)alertMsg
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:alertMsg
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * quitButton = [UIAlertAction actionWithTitle:@"Quit"
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



#pragma mark - Local Auth SDK
- (void) maxOfflinePeriodWillExceedWarning:(NSTimeInterval) secondsToExpire
{
    NSLog(@"Received maxOfflinePeriodWillExceedWarning");
    NSString * alertTitle = @"Warning message from App:";
    NSString * alertMsg = [NSString stringWithFormat:@"Offline lease will expire in %f seconds. Please go online and login.", secondsToExpire];
    UIAlertController * alert = [UIAlertController
        alertControllerWithTitle:alertTitle
                         message:alertMsg
                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:actionOk];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [topController presentViewController:alert animated:YES completion:nil];
    });
}

- (void) maxOfflinePeriodExceeded
{
    NSLog(@"Received maxOfflinePeriodExceeded");
    NSString * alertTitle = @"Error message from App:";
    NSString * alertMsg = @"Offline lease has expired. Please login again.";
    UIAlertController * alert = [UIAlertController
        alertControllerWithTitle:alertTitle
                         message:alertMsg
                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * quitButton = [UIAlertAction actionWithTitle:@"Quit"
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction * action) {
                                        NSLog(@"Application will terminate");
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

- (void) devicePasscodeRequired
{
    NSLog(@"Received devicePasscodeRequired");
    NSString * alertTitle = @"Error message from App:";
    NSString * alertMsg = @"Please set the device passcode and Touch ID/FaceID since it is required when Inactivity Timer expires.";
    UIAlertController * alert = [UIAlertController
        alertControllerWithTitle:alertTitle
                         message:alertMsg
                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * quitButton = [UIAlertAction actionWithTitle:@"Quit"
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction * action) {
                                        NSLog(@"Application will terminate");
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



#pragma mark - Core SDK
- (void) proxyServerSettingDetected
{
    NSLog(@"Received proxyServerSettingDetected");
    NSString * alertTitle = @"Error message from App:";
    NSString * alertMsg = @"Proxy server setting is detected. The network request is stopped, since configuring a proxy server is not allowed.";
    UIAlertController * alert = [UIAlertController
        alertControllerWithTitle:alertTitle
                         message:alertMsg
                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * quitButton = [UIAlertAction actionWithTitle:@"Quit"
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction * action) {
                                        NSLog(@"Application will terminate");
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
@end
