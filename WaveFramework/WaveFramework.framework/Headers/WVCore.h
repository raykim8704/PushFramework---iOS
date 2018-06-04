//
//  WVCore.h
//  WaveFramework
//
//  Created by KwanghoonKim on 2017. 6. 9..
//  Copyright © 2017년 KwanghoonKim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "WVDefines.h"
#import "WVDatabaseManager.h"
#import "Firebase.h"

@interface WVCore : NSObject
+(void)waveConfigure:(id)context;
@end
