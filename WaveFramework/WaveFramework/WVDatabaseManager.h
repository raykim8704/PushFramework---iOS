//
//  WVDatabaseManager.h
//  WaveFramework
//
//  Created by KwanghoonKim on 2017. 6. 12..
//  Copyright © 2017년 KwanghoonKim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVDefines.h"
#import "sqlite3.h"

@interface WVDatabaseManager : NSObject

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;

@property (nonatomic, strong) NSMutableArray *arrResults;

@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

-(instancetype)initWithDatabaseFilename:(NSString*)dbFilename;

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

-(NSArray *)loadDataFromDB:(NSString *)query;

-(void)executeQuery:(NSString *)query;

@end
