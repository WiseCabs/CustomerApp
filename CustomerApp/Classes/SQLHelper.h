//
//  SQLHelper.h
//  WiseCabs
//
//  Created by Nagraj Gopalakrishnan on 09/12/11.
//  Copyright 2011 TeamDecode Software Private limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "sqlite3.h"

@interface SQLHelper : NSObject {
	//UIView *view;
	NSString *lastErrorMsg;
	sqlite3 *m_database;
}

-(BOOL)openDB: (NSString *) databaseName;
-(BOOL)execute: (NSString *) sqlstmt;
-(NSString *)getLastErrorMsg;
-(BOOL)deleteUser;
-(BOOL)deleteUserDetails;
-(BOOL)isSavedUser;
-(BOOL)insertLoggedInUserTables:(NSDictionary*)allJourney;
-(BOOL)insertNewUserDetails:(NSDictionary*)userDetail;
@end
