//
//  WVRecieveMessage.h
//  WaveFramework
//
//  Created by KwanghoonKim on 2017. 6. 22..
//  Copyright © 2017년 KwanghoonKim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVManager.h"
#import "WVHTTPCommunicator.h"
#import "WVDefines.h"

@interface WVReceiveMessage : NSObject

-(void)recieveMessage:(NSString*)docID cmpNm:(NSString*)cmpNm sendAt:(NSString*)sendAt;
@end
