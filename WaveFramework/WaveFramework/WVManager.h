//
//  WVManager.h
//  WaveFramework
//
//  Created by KwanghoonKim on 2017. 6. 11..
//  Copyright © 2017년 KwanghoonKim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVHTTPCommunicator.h"
#import "WVDeviceRegister.h"
#import "WVCore.h"
#import "WVOpenMessage.h"
#import "WVReceiveMessage.h"
#import "WVDefines.h"

@interface WVManager : NSObject

+(id)sharedInstance;
+(void)deviceRegistrationWithFcmToken:(NSString*)fcmToken deviceToken:(NSData*)deviceToken ;
+(BOOL)startWaveWithCustNo:(NSString *)cust_no agentId:(NSString*)agentId packageName:(NSString*)packagename url:(NSString*)url deviveToken:(nullable NSData*)deviceToken; //DEPRECATED_FROM_1.0.2
+(int)startWaveWithCustNo:(NSString *)cust_no agentId:(NSString*)agentId packageName:(NSString*)packagename url:(NSString*)url;
+(int)stopWAVE;
+(void)receiveMessage:(NSDictionary*)message;
+(void)openMessage:(NSDictionary*)message;


//+(void)recieveMessageFromForeground:(NSDictionary*)message;
//+(void)recieveMessageFromBackground:(NSDictionary*)message;

+(NSString*)getUUID;
+(NSString*)getFcmToken;
+(NSString*)getCustNo;
+(NSString*)getAgentId;
+(NSString*)getCreateAt;


@property (nullable,copy)NSString *fcmToken;
@property (nullable,copy)NSData *deviceToken;
@property (nullable,copy)NSString *cust_no;
@property (nullable,copy)NSString *agentId;



@end
