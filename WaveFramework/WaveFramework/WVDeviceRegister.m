//
//  WVDeviceRegister.m
//  WaveFramework
//
//  Created by KwanghoonKim on 2017. 6. 12..
//  Copyright © 2017년 KwanghoonKim. All rights reserved.
//

#import "WVDeviceRegister.h"

@implementation WVDeviceRegister

-(void)deviceRegistToWaveServerWithfcmToken:(NSString*)fcmToken DeviceToken:(NSData*)deviceToken Custno:(NSString *)cust_no AgentId:(NSString *)agent_id{
    
    
    NSString *uuid = [self generateUUID:deviceToken];
    NSLog(@"%@",cust_no);
    
    NSString *deviceType = @"1";
    NSString *deviceModel = [[UIDevice currentDevice]model];
    NSLog(@"%@",deviceModel);
    NSString *osTypeCode = OS_TYPE_CODE; // [[UIDevice currentDevice]systemName];
    NSString *osVer =[[UIDevice currentDevice]systemVersion];
    NSString *appVer = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *sdkVer = SDK_VER;
    
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setCalendar:gregorian];
    [DateFormatter setDateFormat:@"yyyyMMddHHmmss.mmm"];
    NSString *createAt = [NSString stringWithFormat:@"%@",[DateFormatter stringFromDate:[NSDate date]]];
    
    NSLog(@"%@",createAt);
    //NSString *packageName = [[NSBundle mainBundle]bundleIdentifier];
     NSString *packageName = [[NSUserDefaults standardUserDefaults] stringForKey:@"packagename"];
    int mode =1;
  
    if(![self isDupulicatedFcmToken:fcmToken uuid:uuid custNo:cust_no agentId:agent_id createAt:createAt]){
        
        
    NSMutableDictionary *body = [[NSMutableDictionary alloc]initWithCapacity:11];
    
    [body setObject:uuid forKey:@"uuid"];
    [body setObject:cust_no forKey:@"cust_no"];
    [body setObject:fcmToken forKey:@"fcm_token"];
    [body setObject:deviceType forKey:@"device_type"];
    [body setObject:deviceModel forKey:@"device_model"];
    [body setObject:osTypeCode forKey:@"os_type_code"];
    [body setObject:osVer forKey:@"os_ver"];
    [body setObject:appVer forKey:@"app_ver"];
    [body setObject:sdkVer forKey:@"sdk_ver"];
    [body setObject:createAt forKey:@"create_at"];
    [body setObject:packageName forKey:@"package_nm"];
    
    [WVHTTPCommunicator SendJsonToServer:body urlSuffix:API_SUFFIX_REGISTRATION];
    
    
    
    
        NSLog(@"Save Regist Data");
        NSString *url= [[NSUserDefaults standardUserDefaults] stringForKey:@"url"];
        
        NSString *query = [NSString stringWithFormat:@"insert into '%@' values(NULL,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%d, %d)",TABLE_NAME_FOR_USER,url,uuid,cust_no,agent_id,fcmToken,deviceType,deviceModel,osTypeCode,osVer,appVer,sdkVer,createAt,packageName,mode,mode];
        // (serverURL,uuid,cust_no,agent_id,fcmToken,device_type, device_model, os_type_code,os_ver,app_ver,sdk_Ver,create_at,package_nm,wave_mode
        NSLog(@"sqlite query : %@",query);
        WVDatabaseManager *dbManager = [[WVDatabaseManager alloc]init];
        [dbManager executeQuery:query];
    }
}
-(BOOL)isDupulicatedFcmToken:(NSString*)fcmToken uuid:(NSString*)uuid custNo:(NSString*)custno agentId:(NSString*)agentid createAt:(NSString*)createat{
    
    NSString *dbUUID = [WVManager getUUID];
    NSString *dbFcmToken = [WVManager getFcmToken];
    NSString *dbCustNo = [WVManager getCustNo];
    NSString *dbAgentId = [WVManager getAgentId];
    NSString *dbCreateAt = [WVManager getCreateAt];
    
    
    if([dbUUID isEqualToString:uuid] && [dbFcmToken isEqualToString:fcmToken] && [dbCustNo isEqualToString:custno] && [dbAgentId isEqualToString:agentid] &&[dbCreateAt isEqualToString:createat] ){
        NSLog(@"DATA already exist in database");
        
        return YES;
    }
    else if([dbUUID isEqualToString:uuid] && [dbFcmToken isEqualToString:fcmToken] && [dbCustNo isEqualToString:custno] && [dbAgentId isEqualToString:agentid])
    {
        NSLog(@"User ReLogin at different time");
        return YES;
    }
    else if ([dbUUID isEqualToString:uuid] && [dbCustNo isEqualToString:custno] && [dbAgentId isEqualToString:agentid] && ![dbFcmToken isEqualToString:fcmToken])
    {
        NSLog(@"fcm token refreshed");
        return NO;
    }
    else{
        NSLog(@"NEW data inserted");
        
        return NO;
    }
}

-(NSString*)generateUUID:(NSData*) deviceToken
{
    NSString *uuid = [deviceToken description];
   
    uuid=[uuid stringByReplacingOccurrencesOfString:@"<" withString:@" "];
    uuid=[uuid stringByReplacingOccurrencesOfString:@">" withString:@" "];
    uuid=[uuid stringByReplacingOccurrencesOfString:@" " withString:@""];
    uuid=[uuid substringToIndex:UUID_LENGTH];    
    NSLog(@"uuid:%@ ", uuid);
  
    return uuid;
}



@end
