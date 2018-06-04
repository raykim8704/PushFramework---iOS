//
//  AppDelegate.h
//  WaveSampleApp
//
//  Created by KwanghoonKim on 2017. 6. 9..
//  Copyright © 2017년 KwanghoonKim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <UserNotifications/UserNotifications.h>
#import <WaveFramework/WaveFramework.h>

@import Firebase;



@interface AppDelegate : UIResponder <UIApplicationDelegate, FIRMessagingDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

