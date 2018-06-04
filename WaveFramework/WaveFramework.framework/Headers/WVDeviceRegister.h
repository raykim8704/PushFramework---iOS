//
//  WVDeviceRegister.h
//  WaveFramework
//
//  Created by KwanghoonKim on 2017. 6. 12..
//  Copyright © 2017년 KwanghoonKim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVHTTPCommunicator.h"
#import "WVManager.h"
#import "WVDefines.h"


@interface WVDeviceRegister : NSObject

-(void)deviceRegistToWaveServerWithfcmToken:(NSString*)fcmToken DeviceToken:(NSData*)deviceToken Custno:(NSString*)cust_no AgentId:(NSString*)agent_id;
@end
