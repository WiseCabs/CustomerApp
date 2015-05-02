//
//  LocationManager.h
//  WiseCabs
//
//  Created by Nagraj Gopalakrishnan on 15/12/11.
//  Copyright 2011 TeamDecode Software Private limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLHelper.h"

@interface LocationManager : NSObject {
	NSString* documentsDirectory;
	NSString* dbPath;
	SQLHelper *sqlHelper;
}
@property(nonatomic, retain) NSString* documentsDirectory;
@property(nonatomic, retain) NSString* dbPath;
@property(nonatomic, retain) SQLHelper *sqlHelper;

-(LocationManager *) initLocationManager;

-(BOOL)updateMasterTables;
-(BOOL)insertMasterTables;
-(BOOL)insertLocality:(NSArray*)locality;
-(BOOL)insertLocation:(NSArray*)location;
-(BOOL)insertCity:(NSArray*)city;
-(BOOL)deleteMasterData;
-(BOOL)deleteLocations;
-(BOOL)deleteLocalities;
-(BOOL)deleteTables:(NSString*)DeleteQuery;
-(BOOL)deleteCities;
-(NSInteger)getUpdatedDateDiff:(NSString*)dbPath;
-(NSInteger)howManyDaysHavePast:(NSDate*)lastDate;      //64 bit changes
-(void)updateTables;
@end
