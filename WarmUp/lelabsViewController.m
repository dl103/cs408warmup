//
//  lelabsViewController.m
//  WarmUp
//
//  Created by davile2 on 9/16/13.
//  Copyright (c) 2013 Le Labs. All rights reserved.
//

#import "lelabsViewController.h"
@interface lelabsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *testUsername;
@property (weak, nonatomic) IBOutlet UITextField *testPassword;
@property (weak, nonatomic) IBOutlet UITextField *nameInsertText;
@property (weak, nonatomic) IBOutlet UITextField *phoneInsertText;
@property (weak, nonatomic) IBOutlet UITextField *nameSearchText;
@property (retain, nonatomic) NSString *databasePath;
@property (weak, nonatomic) IBOutlet UILabel *status;
@end

@implementation lelabsViewController
@synthesize testUsername;
@synthesize testPassword;
@synthesize nameInsertText;
@synthesize phoneInsertText;
@synthesize nameSearchText;
@synthesize databasePath;
@synthesize status;

- (void)viewDidLoad
{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"login3.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    status.text = @"Table searchin'";
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
		const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &loginDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS NAMES (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, PHONE TEXT)";
            
            if (sqlite3_exec(loginDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                status.text = @"Failed to create table";
            }
            
            sqlite3_close(loginDB);
            
        } else {
            status.text = @"Failed to open/create database";
        }
    }
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nameSave:(UIBarButtonItem *)sender {
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &loginDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO NAMES (name, phone) VALUES (\"%@\", \"%@\")", nameInsertText.text, phoneInsertText.text];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(loginDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            status.text = @"Contact added";
            nameInsertText.text = @"";
            phoneInsertText.text = @"";
        } else {
            status.text = @"Failed to add contact";
        }
        sqlite3_finalize(statement);
        sqlite3_close(loginDB);
    }
}
- (IBAction)nameSearch:(UIBarButtonItem *)sender {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &loginDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT phone FROM names WHERE name=\"%@\"", nameSearchText.text];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(loginDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *phoneField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                status.text = @"";
                status.text = [status.text stringByAppendingString:nameSearchText.text];
                status.text = [status.text stringByAppendingString:@"'s phone number is "];
                status.text = [status.text stringByAppendingString:phoneField];
                
            } else {
                status.text = @"Match not found";
            }
            nameSearchText.text = @"";
            sqlite3_finalize(statement);
        }
        sqlite3_close(loginDB);
    }
}

- (IBAction)loginButton:(UIBarButtonItem *)sender {
    if([testUsername.text isEqualToString:@"admin"] && [testPassword.text isEqualToString:@"admin"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations"
                                                        message:@"Login successful!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
@end
