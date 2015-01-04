//
//  SQLiteDatabaseExampleViewController.m
//  SQLiteDAtabaseExample
//
//  Created by Basilio García Castillo on 7/27/14.
//  Copyright (c) 2014 Basilio García. All rights reserved.
//

#import "SQLiteDatabaseExampleViewController.h"

@interface SQLiteDatabaseExampleViewController ()

@end

@implementation SQLiteDatabaseExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    //Build the path to keep the database
    _databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"myUsers.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if([filemgr fileExistsAtPath:_databasePath] == NO){
        const char *dbpath = [_databasePath UTF8String];
        
        if(sqlite3_open(dbpath, &_DB) == SQLITE_OK){
            char *errorMessage;
            const char *sql_statement = "CREATE TABLE IF NOT EXISTS users (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)";
            
            if(sqlite3_exec(_DB, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK){
                [self showUIAlertWithMessage:@"Failed to create the table" andTitle:@"Error"];
            }
            sqlite3_close(_DB);
        }
        else{
            [self showUIAlertWithMessage:@"Failed to open/create the table" andTitle:@"Error"];
        }
    }
}

-(void) showUIAlertWithMessage:(NSString*)message andTitle:(NSString*)title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender {
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if(sqlite3_open(dbpath, &_DB) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO users (name, address, phone) VALUES (\"%@\", \"%@\", \"%@\")", _name.text, _address.text, _phone.text];
        
        const char *insert_statement = [insertSQL UTF8String];
        sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
        
        if(sqlite3_step(statement) == SQLITE_DONE){
            [self showUIAlertWithMessage:@"User added to the database" andTitle:@"Message"];
            _name.text = @"";
            _address.text = @"";
            _phone.text = @"";
        }
        else{
            [self showUIAlertWithMessage:@"Failed to add the user" andTitle:@"Error"];
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
}


- (IBAction)find:(id)sender {
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if(sqlite3_open(dbpath, &_DB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT address, phone FROM users WHERE name = \"%@\"", _name.text];
        const char *query_statement = [querySQL UTF8String];
        
        if(sqlite3_prepare_v2(_DB, query_statement, -1, &statement, NULL) == SQLITE_OK){
            if(sqlite3_step(statement) == SQLITE_ROW){
                NSString *addressField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                _address.text = addressField;
                NSString *phoneField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                _phone.text = phoneField;
                [self showUIAlertWithMessage:@"Match found in database" andTitle:@"Message"];

            }
            else{
                [self showUIAlertWithMessage:@"Match not found in databse" andTitle:@"Message"];
                _address.text = @"";
                _phone.text = @"";
            }
            sqlite3_finalize(statement);
        }
        else{
            [self showUIAlertWithMessage:@"Failed to search the database" andTitle:@"Error"];
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
}

- (IBAction)remove:(id)sender {
    const char *dbpath = [_databasePath UTF8String];
    char *errorMessage;
    
    if(sqlite3_open(dbpath, &_DB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM users WHERE name = \"%@\"", _name.text];
        const char *query_statement = [querySQL UTF8String];
        
        
        if(sqlite3_exec(_DB, query_statement, NULL, NULL, &errorMessage) == SQLITE_OK){
            [self showUIAlertWithMessage:@"Deleted from database" andTitle:@"Message"];
        }
        else{
            [self showUIAlertWithMessage:@"Failed to delete from database" andTitle:@"Error"];
        }
    }
    else{
        [self showUIAlertWithMessage:@"Failed to delete from database" andTitle:@"Error"];
    }
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [[event allTouches] anyObject];
    if([_phone isFirstResponder] && [touch view] != _phone){
        [_phone resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}






@end
