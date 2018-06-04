//
//  WVOpenMessage.m
//  WaveFramework
//
//  Created by KwanghoonKim on 2017. 6. 15..
//  Copyright © 2017년 KwanghoonKim. All rights reserved.
//

#import "WVOpenMessage.h"

@implementation WVOpenMessage

-(void)openMessage:(NSString*)docID cmpNm:(NSString*)cmpNm sendAt:(NSString*)sendAt agentId:(NSString *)agentId{
    
    
    if(![self isDocIdExist:docID]){
        
        [self tableRowCheck];
        NSLog(@"Save DOC_ID");
        NSString *query = [NSString stringWithFormat:@"insert into '%@' values(NULL,'%@')",TABLE_NAME_FOR_OPEN_DOCID,docID];
        WVDatabaseManager *dbManager = [[WVDatabaseManager alloc]init];
        [dbManager executeQuery:query];
        
        
        
        NSString *doc_id = docID;
        NSString *cmp_nm = cmpNm;
        NSString *send_at = sendAt;
        NSString *agent_id = agentId;
        NSString *uuid = [WVManager getUUID];
        NSString *cust_no = [WVManager getCustNo];
        NSString *fcm_token = [WVManager getFcmToken];
        NSString *os_type_code = OS_TYPE_CODE;
        //NSString *packageName = [[NSBundle mainBundle]bundleIdentifier];
        NSString *packageName = [[NSUserDefaults standardUserDefaults] stringForKey:@"packagename"];
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [DateFormatter setCalendar:gregorian];
        
        [DateFormatter setDateFormat:@"yyyyMMddHHmmss.mmm"];
        NSString *createAt = [NSString stringWithFormat:@"%@",[DateFormatter stringFromDate:[NSDate date]]];
        NSString *result_code = @"1";
        
        
        NSMutableDictionary *body = [[NSMutableDictionary alloc]initWithCapacity:11];
        
        [body setObject:doc_id forKey:@"doc_id"];
        [body setObject:agent_id forKey:@"agent_id"];
        [body setObject:uuid forKey:@"uuid"];
        [body setObject:cust_no forKey:@"cust_no"];
        [body setObject:fcm_token forKey:@"fcm_token"];
        [body setObject:os_type_code forKey:@"os_type_code"];
        [body setObject:packageName forKey:@"package_nm"];
        [body setObject:cmp_nm forKey:@"cmp_nm"];
        [body setObject:createAt forKey:@"create_at"];
        [body setObject:send_at forKey:@"send_at"];
        [body setObject:result_code forKey:@"result_code"];
        
        
        [WVHTTPCommunicator SendJsonToServer:body urlSuffix:API_SUFFIX_OPEN];
        
    }
    else{
        NSLog(@"open doc_id already exist");
    }
    
}
-(BOOL)isDocIdExist:(NSString*)doc_id{
    WVDatabaseManager *dbManager = [[WVDatabaseManager alloc]init];
    NSString *query = [NSString stringWithFormat: @"SELECT * FROM %@ WHERE doc_id = '%@' ",TABLE_NAME_FOR_OPEN_DOCID,doc_id];
    NSArray *result= [[NSArray alloc]initWithArray:[dbManager loadDataFromDB:query]];
    
    if ([result count]) {
        NSLog(@"Doc Id : %@",[[result objectAtIndex:0] objectAtIndex:[dbManager.arrColumnNames indexOfObject:@"doc_id"]]);
        return YES;
    }
    return NO;
    
}

-(void)tableRowCheck{
    WVDatabaseManager *dbManager = [[WVDatabaseManager alloc]init];
    NSString *query = [NSString stringWithFormat: @"SELECT COUNT(*) FROM '%@' ",TABLE_NAME_FOR_OPEN_DOCID];
    NSArray *result= [[NSArray alloc]initWithArray:[dbManager loadDataFromDB:query]];
    if([result count])
    {
        NSLog(@"ROW COUNT : %@",result);
        //  NSSTio[[result objectAtIndex:0] objectAtIndex:[dbManager.arrColumnNames indexOfObject:@"COUNT(*)"]]);
    }
    NSString *rowCount=[[result objectAtIndex:0] objectAtIndex:[dbManager.arrColumnNames indexOfObject:@"COUNT(*)"]];
    long iRowCount = [rowCount integerValue];
    if(iRowCount>TABLE_DOCID_MAX_ROW)
    {
        NSString *qry = [NSString stringWithFormat: @"DELETE FROM '%@' ",TABLE_NAME_FOR_OPEN_DOCID];
        NSArray *rst= [[NSArray alloc]initWithArray:[dbManager loadDataFromDB:qry]];
        NSLog(@"delete result : %@",rst);
        
    }
    
}


@end
