//
//  WVOpenMessage.h
//  WaveFramework
//
//  Created by KwanghoonKim on 2017. 6. 15..
//  Copyright © 2017년 KwanghoonKim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVManager.h"
#import "WVHTTPCommunicator.h"
#import "WVDefines.h"

@interface WVOpenMessage : NSObject

-(void)openMessage:(NSString*)docID cmpNm:(NSString*)cmpNm sendAt:(NSString*)sendAt agentId:(NSString*)agentId;

@end
