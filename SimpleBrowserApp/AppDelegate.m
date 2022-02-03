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

@interface AppDelegate () <CTXMAMCoreSdkDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [[CTXMAMNotificationCenter mainNotificationCenter] registerForNotificationsFromSource:CTXMAMNotificationSource_Core
     usingNotificationBlock:^(CTXMAMNotification * _Nonnull notification) {
         NSLog(@"%@", [notification Message]);
     }];
    
    [[CTXMAMNotificationCenter mainNotificationCenter] registerForNotificationsFromSource:CTXMAMNotificationSource_Network
     usingNotificationBlock:^(CTXMAMNotification * _Nonnull notification) {
         [self handleNetworkNotification:notification];
     }];

    [CTXMAMCore setDelegate:self];

    [CTXMAMCore initializeSDKsWithCompletionBlock:^(NSError * _Nullable nilOrError) {
        if (nilOrError) {
            NSString * alertMsg = [NSString stringWithFormat:@"Error initializing SDKs -> %@", nilOrError];
            NSLog(@"%@", alertMsg);
            [self showAlertMsg:alertMsg isFatal:NO];
        }
        else {
            NSString * alertMsg = [NSString stringWithFormat:@"SDKs initialized and ready for use."];
            NSLog(@"%@", alertMsg);
            [self showAlertMsg:alertMsg isFatal:NO];
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
    [CTXMAMCore logoffApp];
}

#pragma mark - Network SDK
 - (void) handleNetworkNotification:(CTXMAMNotification *)notification
 {

     switch(notification.Error.code) {
         case vpnNoError :
             break;
         case vpnClientCertificateExpired :
         case vpnClientCertificateRenewalRequired :
         case vpnDerivedCredentialsCertificateExpired :
         case vpnFullVPNNotSupported :
         case vpnLogonRequiredForNetworkAccess :
         case vpnUnableToGetProxyConfiguration :
         {
             // For these events, just display a notification
             NSString *alertMsg = [notification Message];
             NSLog(@"CTXMAM Network Notification: [%@]", alertMsg);
             [self showAlertMsg:alertMsg isFatal:YES];
         }
             break;
     }

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
