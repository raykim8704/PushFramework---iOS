//
//  WVCore.m
//  WaveFramework
//
//  Created by KwanghoonKim on 2017. 6. 9..
//  Copyright © 2017년 KwanghoonKim. All rights reserved.
//

#import "WVCore.h"






@implementation WVCore



+(BOOL)waveConfigure:(id)context{
    
    
    /* Database file이 정상 생성 되었는지 확인하는 메소드 추가 */
    
   

    NSLog(@"Start Wave APNs registration");
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        
         NSLog(@"Start Wave APNs registration iOS_9_MAX ");
        
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
        NSLog(@"Start Wave APNs registration iOS_10_MAX ");

        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge ;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            if(error){
            NSLog(@"Notification registration failed : %@",error);
              
            }
        }];
        
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = context;
        


    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    return true;

}


@end
