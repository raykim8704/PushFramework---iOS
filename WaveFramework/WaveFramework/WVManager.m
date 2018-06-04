//
//  WVManager.m
//  WaveFramework
//
//  Created by KwanghoonKim on 2017. 6. 11..
//  Copyright © 2017년 KwanghoonKim. All rights reserved.
//

#import "WVManager.h"

@implementation WVManager

+(id)sharedInstance{
    static WVManager *sharedWVManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedWVManager = [[self alloc]init];
    });
    return sharedWVManager;
}



+(BOOL)startWaveWithCustNo:(NSString *)cust_no agentId:(NSString*)agentId packageName:(NSString*)packagename url:(NSString*)url deviveToken:(nullable NSData*)deviceToken{
    
    WVDatabaseManager *wvdatabase = [[WVDatabaseManager alloc]initWithDatabaseFilename:DATABASE_FOR_WAVE];
    
    [[WVManager sharedInstance]setCust_no:cust_no];
    [[WVManager sharedInstance]setAgentId:agentId];
    
    if (cust_no && packagename && agentId && url) {
        [[NSUserDefaults standardUserDefaults] setValue:agentId forKey:@"agentid"];
        [[NSUserDefaults standardUserDefaults] setValue:cust_no forKey:@"custno"];
        [WVCore waveConfigure:[[UIApplication sharedApplication]delegate]];
        [[NSUserDefaults standardUserDefaults] setValue :packagename forKey:@"packagename"];
        [[NSUserDefaults standardUserDefaults] setValue :url forKey:@"url"];
        
        if(deviceToken){
            [[NSUserDefaults standardUserDefaults] setValue :deviceToken forKey:@"devicetoken"];
        }
        
        return true;

    }
    else
        return false;
    
}
+(int)startWaveWithCustNo:(NSString *)cust_no agentId:(NSString*)agentId packageName:(NSString*)packagename url:(NSString*)url{
    
    WVDatabaseManager *wvdatabase = [[WVDatabaseManager alloc]initWithDatabaseFilename:DATABASE_FOR_WAVE];
    
    [[WVManager sharedInstance]setCust_no:cust_no];
    [[WVManager sharedInstance]setAgentId:agentId];
    
    NSLog(@"WVManager Log  == cust no : %@ agentId : %@ packageName : %@ url : %@",cust_no,agentId,packagename,url);
    if (cust_no && packagename && agentId && url) {
        [[NSUserDefaults standardUserDefaults] setValue:agentId forKey:@"agentid"];
        [[NSUserDefaults standardUserDefaults] setValue:cust_no forKey:@"custno"];
        [WVCore waveConfigure:[[UIApplication sharedApplication]delegate]];
        [[NSUserDefaults standardUserDefaults] setValue :packagename forKey:@"packagename"];
        [[NSUserDefaults standardUserDefaults] setValue :url forKey:@"url"];
        
        return SUCCESS;
        
    }
    else
        return FAIL;
    
}

+(void)deviceRegistrationWithFcmToken:(nullable NSString*)fcmToken deviceToken:(nullable NSData*)deviceToken{

  
    
    /* 
     1. WVManager에서는 UserDefault SET만 함
     2. DB insert, update, delete는 해당 클래스에서 진행
     */
    
    if(deviceToken){
        NSLog(@"Ready to regist deviceToken to WaveServer");
        NSString *uuid = [deviceToken description];
        uuid=[uuid stringByReplacingOccurrencesOfString:@"<" withString:@" "];
        uuid=[uuid stringByReplacingOccurrencesOfString:@">" withString:@" "];
        uuid=[uuid stringByReplacingOccurrencesOfString:@" " withString:@""];
        uuid=[uuid substringToIndex:UUID_LENGTH];
        
        [[NSUserDefaults standardUserDefaults] setValue :uuid forKey:@"uuid"];
        
        
        [[WVManager sharedInstance]setDeviceToken:deviceToken];
        [[NSUserDefaults standardUserDefaults] setValue :deviceToken forKey:@"devicetoken"];
        [[NSUserDefaults standardUserDefaults] setValue :deviceToken forKey:@"tempdevicetoken"];
    }

    if (fcmToken) {
        [[NSUserDefaults standardUserDefaults] setValue :fcmToken forKey:@"fcmtoken"];
        NSLog(@"Ready to regist fcmToken to WaveServer");

    }
    
    NSString *cust_no=[[NSUserDefaults standardUserDefaults] stringForKey:@"custno"];
    NSString *agent_id= [[NSUserDefaults standardUserDefaults] stringForKey:@"agentid"];
    
    NSString *tempFcmToken= [[NSUserDefaults standardUserDefaults] stringForKey:@"fcmtoken"];
    NSData * tempDeviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"devicetoken"];
    NSLog(@"tempDeiveToken : %@",tempDeviceToken);
    
   

    
    if(tempFcmToken && tempDeviceToken){
        
        if (!cust_no && !agent_id) {
            NSString *tempCustNo = [self getCustNo];
            NSString *tempAgentId = [self getAgentId];
            
            cust_no = tempCustNo;
            agent_id = tempAgentId;
        }
    }
  

    if (!cust_no) {
        NSLog(@"Cust NO 가 존재하지 않습니다");
    }
    if (!agent_id) {
        NSLog(@"Agent Id 가 존재하지 않습니다");
    }
    
    if (tempFcmToken && tempDeviceToken && cust_no &&agent_id) {
        WVDeviceRegister *deviceRegist = [[WVDeviceRegister alloc]init];
        [deviceRegist deviceRegistToWaveServerWithfcmToken:tempFcmToken DeviceToken:tempDeviceToken Custno:cust_no AgentId:agent_id];
    }
    else
    {
        NSLog(@"Token이 생성되지 않았습니다.");
    }
  
    
}


+(NSString*)isNewFcmToken:(NSString*)token{
    
    WVDatabaseManager *dbManager = [[WVDatabaseManager alloc]init];
    NSString *query = [NSString stringWithFormat: @"SELECT [index], fcm_token FROM %@ ORDER BY create_at DESC LIMIT 1",TABLE_NAME_FOR_USER ];
    NSArray *result= [[NSArray alloc]initWithArray:[dbManager loadDataFromDB:query]];
    
    if([result count]){
        NSString *db_fcmToken = [[result objectAtIndex:0] objectAtIndex:[dbManager.arrColumnNames indexOfObject:@"fcm_token"]];
        NSString *db_fcmToken_index = [[result objectAtIndex:0] objectAtIndex:[dbManager.arrColumnNames indexOfObject:@"index"]];
        NSLog(@"db fcm_token_index : %@",db_fcmToken_index);
        
        if(![token isEqualToString:db_fcmToken]){
            NSLog(@"New fcm token is arrived");
             return db_fcmToken_index;
        }
    }
    return NULL;
}
+(void)updateFCMToken:(NSString*)fcmToken withDbFcmToken:(NSString*)index{
    WVDatabaseManager *dbManager = [[WVDatabaseManager alloc]init];
    NSString * query = [NSString stringWithFormat:@"UPDATE %@ set fcm_token = '%@' where [index] = '%@'",TABLE_NAME_FOR_USER,fcmToken,index];
    [dbManager executeQuery:query];
    
}

+(NSString*)getFcmToken{
    NSLog(@"get fcmToken");
    WVDatabaseManager *dbManager = [[WVDatabaseManager alloc]init];
    NSString *query = [NSString stringWithFormat: @"SELECT fcm_token FROM %@ ORDER BY create_at DESC LIMIT 1 ",TABLE_NAME_FOR_USER ];
    NSArray *result= [[NSArray alloc]initWithArray:[dbManager loadDataFromDB:query]];
    if ([result count]) {
        NSString *fcmToken = [[result objectAtIndex:0] objectAtIndex:[dbManager.arrColumnNames indexOfObject:@"fcm_token"]];
        NSLog(@"exist fcm_token : %@",fcmToken);
        return  fcmToken;
    }
        return NULL;
}

+(NSString*)getUUID{
     NSLog(@"get uuid");
//    WVDatabaseManager *dbManager = [[WVDatabaseManager alloc]init];
//    NSString *query = [NSString stringWithFormat: @"SELECT uuid FROM %@ ORDER BY create_at DESC LIMIT 1 ",TABLE_NAME_FOR_USER ];
//    NSArray *result= [[NSArray alloc]initWithArray:[dbManager loadDataFromDB:query]];
//    if ([result count]) {
//         NSString *uuid = [[result objectAtIndex:0] objectAtIndex:[dbManager.arrColumnNames indexOfObject:@"uuid"]];
//        NSLog(@"exist uuid : %@",uuid);
//        return  uuid;
//    }
//     else
//        return NULL;
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"uuid"];
}
+(NSString*)getCustNo{
    WVDatabaseManager *dbManager = [[WVDatabaseManager alloc]init];
    NSString *query = [NSString stringWithFormat: @"SELECT cust_no FROM %@ ORDER BY create_at DESC LIMIT 1 ",TABLE_NAME_FOR_USER ];
    NSArray *result= [[NSArray alloc]initWithArray:[dbManager loadDataFromDB:query]];
    if ([result count]) {
        NSString *custNo = [[result objectAtIndex:0] objectAtIndex:[dbManager.arrColumnNames indexOfObject:@"cust_no"]];
        NSLog(@"exist custno : %@",custNo);
        return  custNo;
    }
    else
        return NULL;
}
+(NSString*)getAgentId{
    
    WVDatabaseManager *dbManager = [[WVDatabaseManager alloc]init];
    NSString *query = [NSString stringWithFormat: @"SELECT agent_id FROM %@ ORDER BY create_at DESC LIMIT 1 ",TABLE_NAME_FOR_USER ];
    NSArray *result= [[NSArray alloc]initWithArray:[dbManager loadDataFromDB:query]];
    if ([result count]) {
        NSString *agentID = [[result objectAtIndex:0] objectAtIndex:[dbManager.arrColumnNames indexOfObject:@"agent_id"]];
        NSLog(@"exist agentId : %@",agentID);
        return  agentID;
    }
    else
        return NULL;
}

+(NSString*)getCreateAt{
    WVDatabaseManager *dbManager = [[WVDatabaseManager alloc]init];
    NSString *query = [NSString stringWithFormat: @"SELECT create_at FROM %@ ORDER BY create_at DESC LIMIT 1 ",TABLE_NAME_FOR_USER ];
    NSArray *result= [[NSArray alloc]initWithArray:[dbManager loadDataFromDB:query]];
    if ([result count]) {
        NSString *create_at = [[result objectAtIndex:0] objectAtIndex:[dbManager.arrColumnNames indexOfObject:@"create_at"]];
        NSLog(@"exist create_at : %@",create_at);
        return  create_at;
    }
    else
        return NULL;
    
}
+(int)stopWAVE{
    
    [[NSUserDefaults standardUserDefaults] setValue :NULL forKey:@"fcmtoken"];
    

    if([[FIRInstanceID instanceID] token]){
        [[FIRInstanceID instanceID]deleteIDWithHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"delete instanceId error : %@",error);
                
                
            }
            else
            {
                
                [[FIRInstanceID instanceID] token];
                [[NSUserDefaults standardUserDefaults] setValue :NULL forKey:@"devicetoken"];
                
            }
        }];
    }
    return SUCCESS;
}

+(void)receiveMessage:(NSDictionary *)message{
    NSString *doc_id = [message objectForKey:@"doc_id"];
    NSString *cmp_nm = [message objectForKey:@"cmp_nm"];
    NSString *send_at = [message objectForKey:@"create_at"];
    NSString *agent_id = [message objectForKey:@"agent_id"];
    if(doc_id && cmp_nm &&send_at){
        WVReceiveMessage *recieveMsg = [[WVReceiveMessage alloc]init];
        [recieveMsg recieveMessage:doc_id cmpNm:cmp_nm sendAt:send_at agentId:agent_id];
    }
    else
    {
        NSLog(@"doc_id 또는 cmp_nm가 없습니다");
    }
}
+(void)openMessage:(NSDictionary*)message{
    NSString *doc_id = [message objectForKey:@"doc_id"];
    NSString *cmp_nm = [message objectForKey:@"cmp_nm"];
    NSString *send_at = [message objectForKey:@"create_at"];
    NSString *agent_id = [message objectForKey:@"agent_id"];
    if(doc_id && cmp_nm &&send_at){
        WVOpenMessage *openMsg = [[WVOpenMessage alloc]init];
        [openMsg openMessage:doc_id cmpNm:cmp_nm sendAt:send_at agentId:agent_id];
    }
    else
    {
        NSLog(@"doc_id 또는 cmp_nm가 없습니다");
    }
    
}

//+(void)recieveMessageFromForeground:(NSDictionary*)message
//{
//    NSString *doc_id = [message objectForKey:@"doc_id"];
//    NSString *cmp_nm = [message objectForKey:@"cmp_nm"];
//    NSString *send_at = [message objectForKey:@"create_at"];
//
//    if(doc_id && cmp_nm &&send_at){
//        WVRecieveMessage *recieveMsg = [[WVRecieveMessage alloc]init];
//        [recieveMsg recieveMessage:doc_id cmpNm:cmp_nm sendAt:send_at];
//    }
//    else
//    {
//        NSLog(@"doc_id 또는 cmp_nm가 없습니다");
//    }
//}
//+(void)recieveMessageFromBackground:(NSDictionary*)message
//{
//    NSString *doc_id = [message objectForKey:@"doc_id"];
//    NSString *cmp_nm = [message objectForKey:@"cmp_nm"];
//    NSString *send_at = [message objectForKey:@"create_at"];
//    if(doc_id && cmp_nm &&send_at){
//        WVOpenMessage *opneMsg = [[WVOpenMessage alloc]init];
//         [opneMsg openMessage:doc_id cmpNm:cmp_nm sendAt:send_at];
//    }
//    else
//    {
//        NSLog(@"doc_id 또는 cmp_nm가 없습니다");
//    }
//}

- (nonnull FIRMessagingMessageInfo *)appDidReceiveMessage:(nonnull NSDictionary *)message{
    NSLog(@"Does this method work in background? %@",message);
    return message;
}

@end
