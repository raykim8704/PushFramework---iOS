//
//  WVDatabaseManager.m
//  WaveFramework
//
//  Created by KwanghoonKim on 2017. 6. 12..
//  Copyright © 2017년 KwanghoonKim. All rights reserved.
//

#import "WVDatabaseManager.h"

@implementation WVDatabaseManager

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename{
    self = [super init];
    if (self) {
        // Set the documents directory path to the documentsDirectory property.
       
        
        
        // Keep the database filename.
        self.databaseFilename = dbFilename;
        
        [self createDB:dbFilename];

        // Copy the database file into the documents directory if necessary.
       // [self copyDatabaseIntoDocumentsDirectory];
      
    }
    return self;
}
-(void)createDB:(NSString*)dbFilename{
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.documentsDirectory = [paths objectAtIndex:0];

    
     NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
//    sqlite3 *database;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSError *err = NULL;
    
    if(![fm isWritableFileAtPath: self.documentsDirectory]){
        // Directory가 없는 경우 생성해준다
        if([fm createDirectoryAtPath: self.documentsDirectory withIntermediateDirectories:YES attributes:nil error:&err]){
            // Directory가 생성된 경우
            NSLog(@"Log Directory Create!");
        }
        else{
            // Directory 생성에 실패한 경우
            NSLog(@"Directory Create Fails ! : %@",[err localizedDescription]);
        }
    }
        
    
    
    if([fm fileExistsAtPath:destinationPath isDirectory:nil]){
        //[self tableCheck:destinationPath];
        NSLog(@"Database exists %@",destinationPath);
        [self tableCheck:destinationPath];
        }
    else
    {
        
         NSLog(@"Database does not exist -> create new db %@",destinationPath);
        
        [[NSFileManager defaultManager] createFileAtPath:destinationPath contents:nil attributes:nil];
        [self tableCheck:destinationPath];
   

    }
    
}
-(void)tableCheck:(NSString*)destinationPath {
    sqlite3 *database;
//
    
    if(sqlite3_open([destinationPath UTF8String], &database) == SQLITE_OK)
    {
        NSLog(@"Opened sqlite database at %@", destinationPath);
        
        char *err;
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('index' INTEGER PRIMARY KEY AUTOINCREMENT,'serverURL' TEXT,'uuid' TEXT,'cust_no' TEXT,'agent_id' TEXT,'fcm_token' TEXT,'device_type' TEXT,'device_model' TEXT,'os_type_code' TEXT,'os_ver' TEXT,'app_ver' TEXT,'sdk_ver' TEXT,'create_at' TEXT,'package_nm' TEXT,'created' INTEGER,'wave_mode' INTEGER);", TABLE_NAME_FOR_USER];
        if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
        {
            sqlite3_close(database);
            NSAssert(0, @"Table failed to create.");
        }
        
        NSString *sql2 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('index' INTEGER PRIMARY KEY AUTOINCREMENT,'doc_id' TEXT);", TABLE_NAME_FOR_RECEIVE_DOCID];
        if (sqlite3_exec(database, [sql2 UTF8String], NULL, NULL, &err) != SQLITE_OK)
        {
            sqlite3_close(database);
            NSAssert(0, @"Table failed to create.");
        }
        
        NSString *sql3 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('index' INTEGER PRIMARY KEY AUTOINCREMENT,'doc_id' TEXT);", TABLE_NAME_FOR_OPEN_DOCID];
        if (sqlite3_exec(database, [sql3 UTF8String], NULL, NULL, &err) != SQLITE_OK)
        {
            sqlite3_close(database);
            NSAssert(0, @"Table failed to create.");
        }
        //...stuff
    }
    else
    {
        NSLog(@"Failed to open database at %@ with error %s", destinationPath, sqlite3_errmsg(database));
        sqlite3_close (database);
    }


    
}

-(void)copyDatabaseIntoDocumentsDirectory{
    // Check if the database file exists in the documents directory.
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    

        NSLog(@"destication searching path : %@",destinationPath);

    
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        // Check if any error occurred during copying and display it.
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
    
    sqlite3 *sqlite3Database;
    
    // Set the database file path.
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:DATABASE_FOR_WAVE];
  
    
    NSLog(@"Destination database path : %@",databasePath);
    
    // Initialize the results array.
    if (self.arrResults != nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = [[NSMutableArray alloc] init];
    
    // Initialize the column names array.
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK)
    {
        // Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
        sqlite3_stmt *compiledStatement;
        
        // Load all data from database to memory.
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK) {
            // Check if the query is non-executable.
            if (!queryExecutable){
                // In this case data must be loaded from the database.
                
                // Declare an array to keep the data for each fetched row.
                NSMutableArray *arrDataRow;
                
                // Loop through the results and add them to the results array row by row.
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    // Initialize the mutable array that will contain the data of a fetched row.
                    arrDataRow = [[NSMutableArray alloc] init];
                    
                    // Get the total number of columns.
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    // Go through all columns and fetch each column data.
                    for (int i=0; i<totalColumns; i++){
                        // Convert the column data to text (characters).
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        // If there are contents in the currenct column (field) then add them to the current row array.
                        if (dbDataAsChars != NULL) {
                            // Convert the characters to string.
                            [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        // Keep the current column name.
                        if (self.arrColumnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    // Store each fetched data row in the results array, but first check if there is actually data.
                    if (arrDataRow.count > 0) {
                        [self.arrResults addObject:arrDataRow];
                    }
                }
            }
            else{
                //BOOL executeQueryResults = sqlite3_step(compiledStatement);
                if (sqlite3_step(compiledStatement) == SQLITE_DONE) {
                    NSLog(@"DB operation working well");
                    
                    // Keep the affected rows.
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    
                    // Keep the last inserted row ID.
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                    
                }
                else {
                    // If could not execute the query show the error message on the debugger.
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
                
            }
        }
        else
        {
            // In the database cannot be opened then show the error message on the debugger.
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
            
        }
        
        // Release the compiled statement from memory.
        sqlite3_finalize(compiledStatement);
    }
    
    //Close the database
    sqlite3_close(sqlite3Database);
    
}


-(NSArray *)loadDataFromDB:(NSString *)query{
    // Run the query and indicate that is not executable.
    // The query string is converted to a char* object.
    [self createDB:DATABASE_FOR_WAVE];
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    // Returned the loaded results.
    return (NSArray *)self.arrResults;
}

-(void)executeQuery:(NSString *)query{
    // Run the query and indicate that is executable.
     [self createDB:DATABASE_FOR_WAVE];
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}

@end
