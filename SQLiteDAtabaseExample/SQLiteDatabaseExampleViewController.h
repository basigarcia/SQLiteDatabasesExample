//
//  SQLiteDatabaseExampleViewController.h
//  SQLiteDAtabaseExample
//
//  Created by Basilio García Castillo on 7/27/14.
//  Copyright (c) 2014 Basilio García. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface SQLiteDatabaseExampleViewController : UIViewController

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *DB;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *address;
@property (strong, nonatomic) IBOutlet UITextField *phone;
- (IBAction)save:(id)sender;
- (IBAction)find:(id)sender;
- (IBAction)remove:(id)sender;


@end
