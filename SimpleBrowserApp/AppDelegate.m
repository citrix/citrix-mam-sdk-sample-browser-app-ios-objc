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

    [CTXMAMCore initializeSDKsWithCompletionBlock:^(NSError * _Nullable nilOrError) {
        if(nilOrError) {
            NSLog(@"Error initializing SDKs -> %@", nilOrError);
        }
    }];

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
    if (notification.Error.code == CTXAlertAppContainment_GEOFENCE_LocationServicesRequired ||
        notification.Error.code == CTXAlertAppContainment_GEOFENCE_OutsideOfAcceptedArea)
    {
        // For these events, usage of the app may be restricted. They will be handled by delegate callback.
    }
    else
    {
        // For these events, just display a notification
        NSString *alertMsg = [notification Message];
        NSLog(@"CTXMAM Containment Notification: [%@]", alertMsg);
        [self showAlertMsg:alertMsg isFatal:NO];
    }
}

- (BOOL) appIsOutsideGeofencingBoundaryWithDefaultHandlerOption
{
    NSString *alertMsg = @"You have left the area that your organization designates for this app. Please return to the designated area and relaunch the app.";
    [self showAlertMsg:alertMsg isFatal:YES];
    
    return YES;
}

- (BOOL) appNeedsLocationServicesEnabledWithDefaultHandlerOption
{
    NSString *alertMsg = @"Your organization requires you to enable Location Services to run this app.";
    [self showAlertMsg:alertMsg isFatal:YES];
    
    return YES;
}

#pragma mark - Local Auth SDK
- (BOOL) maxOfflinePeriodWillExceedWarning:(NSTimeInterval) secondsToExpire
{
    NSLog(@"Received maxOfflinePeriodWillExceedWarning");
    NSString * alertMsg = [NSString stringWithFormat:@"Offline lease will expire in %f seconds. Please go online and login.", secondsToExpire];
    [self showAlertMsg:alertMsg isFatal:NO];
    return YES;
}

- (BOOL) maxOfflinePeriodExceeded
{
    NSLog(@"Received maxOfflinePeriodExceeded");
    NSString * alertMsg = @"Offline lease has expired. Please login again.";
    [self showAlertMsg:alertMsg isFatal:YES];
    return YES;
}

- (BOOL) devicePasscodeRequired
{
    NSLog(@"Received devicePasscodeRequired");
    NSString * alertMsg = @"Please set the device passcode and Touch ID/FaceID since it is required when Inactivity Timer expires.";
    [self showAlertMsg:alertMsg isFatal:YES];
    return YES;
}

#pragma mark - Core SDK
- (BOOL) proxyServerSettingDetectedWithDefaultHandlerOption
{
    NSLog(@"Received proxyServerSettingDetected");
    NSString * alertMsg = @"Proxy server setting is detected. The network request is stopped, since configuring a proxy server is not allowed.";
    [self showAlertMsg:alertMsg isFatal:YES];
    
    return YES;
}

#pragma mark - Helper Method
-(void)showAlertMsg:(NSString *)alertMsg isFatal:(BOOL)isFatal
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray<__kindof UIWindow *> *windows = [UIApplication sharedApplication].windows;
        UIWindow * keyWindow = windows.lastObject;
        UIViewController *topController = keyWindow.rootViewController;

        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Citrix Alert"
                                                                       message:alertMsg
                                                                preferredStyle:UIAlertControllerStyleAlert];
        NSString *buttonText = nil;
        if (isFatal) {
            buttonText = NSLocalizedString(@"Quit", comment="");
        } else {
            buttonText = NSLocalizedString(@"OK", comment="");
        }
        
        UIAlertAction* uiButton = [UIAlertAction actionWithTitle:buttonText
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
            if (isFatal) {
                id appdelegate = [[UIApplication sharedApplication] delegate];
                [appdelegate applicationWillTerminate:[UIApplication sharedApplication]];
                exit(0); // terminate the app
            }
        }];
         
        [alert addAction:uiButton];
        [topController presentViewController:alert animated:YES completion:nil];
    });
}

@end
