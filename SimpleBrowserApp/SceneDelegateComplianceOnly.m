//
//  SceneDelegateComplianceOnly.m
//  SimpleBrowserApp
//
//  Created by Jaspreet Singh on 1/14/20.
//  Copyright © 2020 Citrix Systems, Inc. All rights reserved.
//

#import "SceneDelegateComplianceOnly.h"

@interface SceneDelegateComplianceOnly ()

@end

@implementation SceneDelegateComplianceOnly

- (void)scene:(UIScene *)scene openURLContexts:(nonnull NSSet<UIOpenURLContext *> *)URLContexts
API_AVAILABLE(ios(13.0)){
    NSLog(@"%s: In.", __func__);
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions  API_AVAILABLE(ios(13.0)){
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSessi@on` instead).
    NSLog(@"%s: In.", __func__);
}


- (void)sceneDidDisconnect:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    NSLog(@"%s: In.", __func__);
}


- (void)sceneDidBecomeActive:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    NSLog(@"%s: In.", __func__);
}


- (void)sceneWillResignActive:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
    NSLog(@"%s: In.", __func__);
}


- (void)sceneWillEnterForeground:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
    NSLog(@"%s: In.", __func__);
}


- (void)sceneDidEnterBackground:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    NSLog(@"%s: In.", __func__);
}

- (void)scene:(UIScene *)scene willContinueUserActivityWithType:(NSString *)userActivityType
API_AVAILABLE(ios(13.0)){
    NSLog(@"%s: In.", __func__);
}

- (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity
API_AVAILABLE(ios(13.0)){
    NSLog(@"%s: In.", __func__);
}

- (void)scene:(UIScene *)scene didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error
API_AVAILABLE(ios(13.0)){
    NSLog(@"%s: In.", __func__);
}

- (void)scene:(UIScene *)scene didUpdateUserActivity:(NSUserActivity *)userActivity
API_AVAILABLE(ios(13.0)){
    NSLog(@"%s: In.", __func__);
}

@end
