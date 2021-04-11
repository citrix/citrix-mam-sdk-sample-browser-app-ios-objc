//
//  AppDelegate+ComplianceSDKDelegate.m
//  SimpleBrowserApp
//
//  Created by Jaspreet Singh on 1/22/20.
//  Copyright © 2020 Citrix Systems, Inc. All rights reserved.
//

#import "AppDelegate+ComplianceSDKDelegate.h"

@implementation AppDelegate (ComplianceSDKDelegate)

#pragma mark - Compliance SDK
- (void) showAlertWithMessage:(NSString *)message andActions:(NSArray<UIAlertAction*>*) actions
{
    NSString * title = [NSString stringWithFormat:@"Compliance Error"];
    NSString * msg = [NSString stringWithFormat:@"%@", message];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];

    for (UIAlertAction* action in actions) {
        [alert addAction:action];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *app =(AppDelegate *) [UIApplication sharedApplication].delegate;
        UIViewController *topController = app.window.rootViewController;
        [topController presentViewController:alert animated:YES completion:nil];
    });
}

- (BOOL)handleAdminLockAppSecurityActionForError:(nonnull NSError *)error {
    [self showAlertWithMessage:error.userInfo[NSLocalizedDescriptionKey]
                    andActions:@[[self logonButtonWithTitle:@"Sign On" andErrorContext:error]]];
    return YES;
}

- (BOOL)handleAdminWipeAppSecurityActionForError:(nonnull NSError *)error {
    [self showAlertWithMessage:error.userInfo[NSLocalizedDescriptionKey]
                    andActions:@[[self logonButtonWithTitle:@"Sign On" andErrorContext:error]]];
    return YES;
}

- (BOOL)handleAppDisabledSecurityActionForError:(nonnull NSError *)error {
    [self showAlertWithMessage:error.userInfo[NSLocalizedDescriptionKey]
                    andActions:@[self.quitButton]];
    return YES;
}

- (BOOL)handleContainerSelfDestructSecurityActionForError:(nonnull NSError *)error {
    [self showAlertWithMessage:error.userInfo[NSLocalizedDescriptionKey]
                    andActions:@[[self logonButtonWithTitle:@"Continue" andErrorContext:error]]];
    return YES;
}

- (BOOL)handleDateAndTimeChangeSecurityActionForError:(nonnull NSError *)error {
    [self showAlertWithMessage:error.userInfo[NSLocalizedDescriptionKey]
                    andActions:@[[self logonButtonWithTitle:@"Sign On" andErrorContext:error]]];
    return YES;
}

- (BOOL)handleDevicePasscodeComplianceViolationForError:(nonnull NSError *)error {
    [self showAlertWithMessage:error.userInfo[NSLocalizedDescriptionKey]
                    andActions:@[self.quitButton]];
    return YES;
}

- (BOOL)handleEDPComplianceViolationForError:(nonnull NSError *)error {
        switch (error.code) {
            case CTXMAMCompliance_Violation_EDP_BlockApp:
                [self showAlertWithMessage:error.userInfo[NSLocalizedDescriptionKey]
                                andActions:@[self.quitButton]];
                break;
            case CTXMAMCompliance_Violation_EDP_WarnUser:
                 /// TODO: Need not to block app view
                 [self showAlertWithMessage:error.userInfo[NSLocalizedDescriptionKey]
                                 andActions:@[self.quitButton, self.okButton]];
                break;
            case CTXMAMCompliance_Violation_EDP_InformUser:
                  /// TODO: Need not to block app view
                  /// TODO: Show an alert of unobtrusive toast message.
                [self showAlertWithMessage:error.userInfo[NSLocalizedDescriptionKey]
                                andActions:@[self.okButton]];
                 break;
            default:
                [self showAlertWithMessage:error.userInfo[NSLocalizedDescriptionKey]
                                andActions:@[self.quitButton]];
                break;
        }
        return YES;
}

- (BOOL)handleJailbreakComplianceViolationForError:(nonnull NSError *)error {
    [self showAlertWithMessage:error.userInfo[NSLocalizedDescriptionKey]
                    andActions:@[self.quitButton]];
    return YES;
}

- (BOOL)handleUserChangeSecurityActionForError:(nonnull NSError *)error {
    [self showAlertWithMessage:error.userInfo[NSLocalizedDescriptionKey]
                    andActions:@[self.quitButton]];
    return YES;
}

#pragma mark - Action Behaviors
-(UIAlertAction*) quitButton
{
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Quit"
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       exit(0);
                                                   }];
    return action;
}
-(UIAlertAction*) okButton
{
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                   }];
    return action;
}

-(UIAlertAction*) logonButtonWithTitle:(NSString*)title andErrorContext:(NSError*)error
{
    UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
            [[CTXMAMCompliance sharedInstance] performLogonWithErrorContext:error
                                                          completionHandler:^(BOOL success) {
                                                            NSLog(@"Logon request result:%d", success);
                                                          }];
                                                   }];
    return action;
}


@end
