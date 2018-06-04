//
//  WVHTTPCommunicator.m
//  WaveFramework
//
//  Created by KwanghoonKim on 2017. 6. 9..
//  Copyright © 2017년 KwanghoonKim. All rights reserved.
//

#import "WVHTTPCommunicator.h"

@implementation WVHTTPCommunicator


+(BOOL)SendJsonToServer:(NSDictionary*)dictionary urlSuffix:(NSString*)urlSuffix
{

  
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSError * err;
    NSData * requestJson = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&err];
    NSLog(@"requestJson :  %@",requestJson);
    NSString *jsonString = [[NSString alloc] initWithData:requestJson encoding:NSUTF8StringEncoding];
     NSLog(@"requestString :  %@",jsonString);
    
    NSString *urlPrefix= [[NSUserDefaults standardUserDefaults] stringForKey:@"url"];
    NSString *apiURL = [NSString stringWithFormat:@"%@%@",urlPrefix,urlSuffix];
    
    [request setURL:[NSURL URLWithString:apiURL]];
    
     [request setHTTPBody:requestJson];
    NSURLSessionDataTask *postDataTask;
    postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         if (!error) {
             NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             NSLog(@"response Dictionary : %@",responseDict);
             NSLog(@"response Data %@",data);
             NSLog(@"URL response : %@",response);
         } else {
             NSLog(@"error %@",error);
         }
        
    }];
     [postDataTask resume];
     
     
     return YES;
     }
     
     @end
