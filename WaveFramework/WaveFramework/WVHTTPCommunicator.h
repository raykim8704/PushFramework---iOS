//
//  WVHTTPCommunicator.h
//  WaveFramework
//
//  Created by KwanghoonKim on 2017. 6. 9..
//  Copyright © 2017년 KwanghoonKim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVDefines.h"

@interface WVHTTPCommunicator : NSObject

+(BOOL)SendJsonToServer:(NSDictionary*)dictionary urlSuffix:(NSString*)urlSuffix;

@end
