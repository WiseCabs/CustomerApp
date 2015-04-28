//
//  SQLHelper.m
//  WiseCabs
//
//  Created by Nagraj Gopalakrishnan on 09/12/11.
//  Copyright 2011 TeamDecode Software Private limited. All rights reserved.
//

#import "SQLHelper.h"
#import "sqlite3.h"
#import "WiseCabsAppDelegate.h"

@implementation SQLHelper
static sqlite3 *database = nil;

-(NSString *)getLastErrorMsg {
	return lastErrorMsg;
}

-(BOOL)openDB: (NSString *) databaseName {
	int result = sqlite3_open([databaseName UTF8String], &m_database);
	if (result != SQLITE_OK)
	{
		sqlite3_close(m_database);
		lastErrorMsg = @"Failed to open database.";
		return NO;
	}
	else {
		return YES;
	}
}

-(BOOL)execute: (NSString *)sqlstmt {
	NSLog(@"sqlstmt is %@",sqlstmt);
	int result = sqlite3_exec(m_database, 
							  [sqlstmt UTF8String],
							  NULL, NULL, NULL);
	NSLog(@"result is %d",result);
	if (result != SQLITE_OK)
	{
		sqlite3_close(m_database);
		lastErrorMsg = @"Failed to execute sentence";
		NSLog(@"Failed to execute sentence");
		return NO;
	}
	else {
		return YES;
	}
}



-(BOOL)insertLoggedInUserTables:(NSDictionary*)userDetail{

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory  = [paths objectAtIndex:0];
	BOOL isSuccess=YES;
	//m_db = [[[SQLHelper alloc] init] autorelease];
	//[self 
	if (![self openDB:[documentsDirectory stringByAppendingPathComponent:@"WiseCabsAppDB.sqlite3"]]) {
		NSLog(@"%@",[self getLastErrorMsg]);
		isSuccess=NO;
	}
	else{
		if ([self deleteUser]) {
			NSString *insertUserQuery=[NSString stringWithFormat: @"INSERT INTO loggedInUser (UserId,FirstName,LastName,EmailId,MobileNo,SupplierId,Password,UserName) VALUES ('%@\', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", [userDetail objectForKey:@"UD_ID"],[userDetail objectForKey:@"Name"],@"",[userDetail objectForKey:@"UserName"],[userDetail objectForKey:@"Mob_Number"],[userDetail objectForKey:@"Supplier_Id"],[userDetail objectForKey:@"Password"],[userDetail objectForKey:@"UserName"]];
			NSLog(@"insertUserQuery  is %@",insertUserQuery);
			if(![self execute:insertUserQuery])
			{
				isSuccess=NO;
				NSLog(@"%@",[self getLastErrorMsg]);
			}else {
				isSuccess=YES;
			}

		}else {
			isSuccess=NO;
		}

	}
	return isSuccess;
	
}

-(BOOL)insertNewUserDetails:(NSDictionary*)userDetail{
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory  = [paths objectAtIndex:0];
	BOOL isSuccess=YES;
	//m_db = [[[SQLHelper alloc] init] autorelease];
	//[self
	if (![self openDB:[documentsDirectory stringByAppendingPathComponent:@"WiseCabsAppDB.sqlite3"]]) {
		NSLog(@"%@",[self getLastErrorMsg]);
		isSuccess=NO;
	}
	else{
		if ([self deleteUser]) {             
			NSString *insertUserQuery=[NSString stringWithFormat: @"INSERT INTO loggedInUser (UserId,FirstName,LastName,Password,EmailId,MobileNo,SupplierId,UserName) VALUES ('%@\', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", [userDetail objectForKey:@"UD_ID"],[userDetail objectForKey:@"First_Name"],[userDetail objectForKey:@"Last_Name"],[userDetail objectForKey:@"UD_Password"],[userDetail objectForKey:@"Email_Id"],[userDetail objectForKey:@"MobileNo"],[userDetail objectForKey:@"suppID"],[userDetail objectForKey:@"UserName"]];
			NSLog(@"insertUserQuery  is %@",insertUserQuery);
			if(![self execute:insertUserQuery])
			{
				isSuccess=NO;
				NSLog(@"%@",[self getLastErrorMsg]);
			}else {
				isSuccess=YES;
			}
            
		}else {
			isSuccess=NO;
		}
        
	}
	return isSuccess;
	
}

-(BOOL)isSavedUser{
	WiseCabsAppDelegate *appDelegate = (WiseCabsAppDelegate *)[[UIApplication sharedApplication] delegate];	
	NSString *dbpath = [appDelegate getDBPath];
	//NSString *selectUserQuery=[NSString stringWithFormat: @"INSERT INTO loggedInUser (UserId,FirstName,LastName,EmailId,MobileNo) VALUES ('%@\', '%@', '%@', '%@', '%@')",@"1",@"1",@"1",@"1",@"1"];
	NSString *selectUserQuery=[NSString stringWithFormat:@"SELECT UserId,FirstName,LastName,EmailId,MobileNo FROM loggedInUser"];
	sqlite3_stmt *selectStmt;
	BOOL isSucess=YES;
	if(sqlite3_open([dbpath UTF8String], &database) == SQLITE_OK) {
		const char *sql = [selectUserQuery UTF8String];
		
		if(sqlite3_prepare_v2(database, sql, -1, &selectStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating select statement. '%s'", sqlite3_errmsg(database));
		
		if(sqlite3_step(selectStmt) == SQLITE_ROW )
		{
			isSucess= YES;
		}
		else{
			isSucess= NO;
		}
		sqlite3_reset(selectStmt);
		sqlite3_finalize(selectStmt);
	}
	
	sqlite3_close(database);
	return isSucess;
		
}
-(BOOL)deleteUser{
	NSString *deleteUserQuery=[NSString stringWithFormat: @"DELETE FROM loggedInUser"];
	
	
	if(![self execute:deleteUserQuery])
	{
		NSLog(@"Not able to delete userdetails from user table");
		return NO;
	}else {
		return YES;
	}

	
}



-(BOOL)deleteUserDetails{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory  = [paths objectAtIndex:0];
	BOOL isSuccess=YES;
	
	if (![self openDB:[documentsDirectory stringByAppendingPathComponent:@"WiseCabsAppDB.sqlite3"]]) {
		NSLog(@"%@",[self getLastErrorMsg]);
		isSuccess=NO;
	}
	else{
		
		NSString *deleteUserQuery=[NSString stringWithFormat: @"DELETE FROM loggedInUser"];
			
			if(![self execute:deleteUserQuery])
			{
				isSuccess=NO;
				NSLog(@"%@",[self getLastErrorMsg]);
			}else {
				isSuccess=YES;
			}
		}
	return isSuccess;
	
}



@end
