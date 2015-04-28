//
//  LocationManager.m
//  WiseCabs
//
//  Created by Nagraj Gopalakrishnan on 15/12/11.
//  Copyright 2011 TeamDecode Software Private limited. All rights reserved.
//

#import "LocationManager.h"
#import "sqlite3.h"
#import "SQLHelper.h"
#import "WebServiceHelper.h"
#import "Common.h"

@implementation LocationManager
@synthesize documentsDirectory;
@synthesize sqlHelper,dbPath;

static sqlite3 *database = nil;

-(LocationManager *) initLocationManager{
	[super init];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docdir=[paths objectAtIndex:0];
	self.documentsDirectory = docdir;
	[docdir release];

	if (self.sqlHelper==nil) {
		SQLHelper *helper= [[SQLHelper alloc] init];
		self.sqlHelper = helper;
		[helper release];
	}
	
	self.dbPath=[self getDBPath];
	//[dbpath release];
	return self;
}
-(BOOL)updateMasterTables{
	
	if ([self deleteMasterData]) {
		return [self insertMasterTables];

	}else {
		return NO;
	}

}

-(BOOL)insertMasterTables{

	WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
	NSObject *obj=[[[NSObject alloc] init] autorelease];
	servicehelper.objEntity=obj;
	
	//NSArray *result=[servicehelper callWebService:[NSString stringWithFormat:@"%@customer/customerauth",[Common webserviceURL]] pms:sdparams];
	
	NSString *URL=[NSString stringWithFormat:@"%@search/location",[Common webserviceURL]];
	
	NSArray *allJourney=[servicehelper callWebService:URL pms:nil];
	NSDictionary *loc=[allJourney objectAtIndex:0];
	[servicehelper release];

	//NSArray *cityArray=[loc objectForKey:@"city"];
	//NSArray *locationArray=[loc objectForKey:@"location"];
	NSArray *airportArray=[loc objectForKey:@"airport"];
    NSArray *tubesArray=[loc objectForKey:@"tube"];
    NSArray *stationArray=[loc objectForKey:@"train"];
		BOOL isSuccess=YES;
	if ( [self insertAirports:airportArray] && [self insertTubes:tubesArray]  && [self insertStation:stationArray]) {
		isSuccess=YES;
	}else {
		isSuccess=NO;
	}
	return isSuccess;
}


-(void)updateTables{
	NSAutoreleasePool *pool =[[NSAutoreleasePool alloc] init];
	if ([Common isNetworkExist]>0)
	{
		BOOL isSuccess=YES;
		NSString *dbpath = [self getDBPath];
        [Common setTableUpdated:@"Yes"];
		//LocationManager *locManager=[[[LocationManager alloc]initLocationManager:dbpath] autorelease];
		NSInteger diff=[self getUpdatedDateDiff:dbpath];
		if (diff>=0) {
			
			if (diff>10) {
				[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
				NSLog(@"Updating all data from table");
				isSuccess=[self updateMasterTables];
				[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			}
		}
		else{
			NSLog(@"Inserting all data into table");
			[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
			isSuccess=[self insertMasterTables];
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		}
		
		//[locManager release];
		if (!isSuccess) {
			//show alert for error in insert
		}
		//[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}else {
        [self performSelectorOnMainThread:@selector(showalert) withObject:nil waitUntilDone:NO];
		//[self showalert];
	}
	[pool release];
	
}

-(void)showalert{
    [Common showNetwokAlert];
}

-(NSString*)getLastSyncDate{
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];

	[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
	//NSDate *now = [[NSDate alloc] init];
	NSString *lastsyncDate=[dateFormatter stringFromDate:[NSDate date]];

	return lastsyncDate;
	
}


-(BOOL)insertTubes:(NSArray*)tubesArray{
	BOOL isSuccess=YES;
	if (![self.sqlHelper openDB:[self.documentsDirectory stringByAppendingPathComponent:@"WiseCabsAppDB.sqlite3"]]) {
		NSLog(@"error is %@",[self.sqlHelper getLastErrorMsg]);
		return NO;
	}
	else{
		NSString *lastsyncDate=[self getLastSyncDate];
		
		for (id tubeDictionary in tubesArray) {
			NSMutableString *tubeName=[tubeDictionary objectForKey:@"Station_Name"];
			[tubeName replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tubeName length])];
            
            NSMutableString *postCode;
            if ((NSString *)[NSNull null]!=[tubeDictionary objectForKey:@"LO_Location_Postcode"] && [tubeDictionary objectForKey:@"LO_Location_Postcode"]!=nil && [[[tubeDictionary objectForKey:@"LO_Location_Postcode"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
                postCode=[tubeDictionary objectForKey:@"LO_Location_Postcode"];
            }
            else{
                postCode= [NSString stringWithFormat:@"No PostCode"];
            }
            
            NSString *truncatedName=[tubeName stringByReplacingOccurrencesOfString:@" Tube Station" withString:@"" ];
			
			NSString *insertLocalitiesQuery=[NSString stringWithFormat: @"INSERT INTO Tube (PlaceId,PlaceName,PostCode,LastSyncedDate,TruncatedName) VALUES ('%@', '%@', '%@', '%@', '%@')",[tubeDictionary objectForKey:@"Station_ID"],tubeName,[tubeDictionary objectForKey:@"Station_Postcode"],lastsyncDate,truncatedName];
			NSLog(@"InsertQuery for Localities is %@",insertLocalitiesQuery);
			if(![self.sqlHelper execute:insertLocalitiesQuery])
			{
				isSuccess=NO;
				break;
				NSLog(@"error is %@",[self.sqlHelper getLastErrorMsg]);
			}
		}
	}
	return isSuccess;
}


-(BOOL)insertStation:(NSArray*)stationArray{
	BOOL isSuccess=YES;
	if (![self.sqlHelper openDB:[self.documentsDirectory stringByAppendingPathComponent:@"WiseCabsAppDB.sqlite3"]]) {
		NSLog(@"error is %@",[self.sqlHelper getLastErrorMsg]);
		return NO;
	}
	else{
		NSString *lastsyncDate=[self getLastSyncDate];
		
		for (id stationDictionary in stationArray) {
			NSMutableString *StationName=[stationDictionary objectForKey:@"Station_Name"];
			[StationName replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [StationName length])];
            NSMutableString *postCode;
            if ((NSString *)[NSNull null]!=[stationDictionary objectForKey:@"LO_Location_Postcode"] && [stationDictionary objectForKey:@"LO_Location_Postcode"]!=nil && [[[stationDictionary objectForKey:@"LO_Location_Postcode"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
                postCode=[stationDictionary objectForKey:@"LO_Location_Postcode"];
            }
            else{
                postCode= [NSString stringWithFormat:@"No PostCode"];
            }
            NSString *truncatedName=[StationName stringByReplacingOccurrencesOfString:@" Train Station" withString:@"" ];
			
			NSString *insertLocalitiesQuery=[NSString stringWithFormat: @"INSERT INTO Train (PlaceId,PlaceName,PostCode,LastSyncedDate,TruncatedName) VALUES ('%@', '%@', '%@', '%@', '%@')",[stationDictionary objectForKey:@"Station_ID"],StationName,postCode,lastsyncDate,truncatedName];
			NSLog(@"InsertQuery for Localities is %@",insertLocalitiesQuery);
			if(![self.sqlHelper execute:insertLocalitiesQuery])
			{
				isSuccess=NO;
				break;
				NSLog(@"error is %@",[self.sqlHelper getLastErrorMsg]);
			}
		}
	}
	return isSuccess;
}







-(BOOL)insertAirports:(NSArray*)airportArray{
	BOOL isSuccess=YES;
	if (![self.sqlHelper openDB:[self.documentsDirectory stringByAppendingPathComponent:@"WiseCabsAppDB.sqlite3"]]) {
		NSLog(@"error is %@",[self.sqlHelper getLastErrorMsg]);
		return NO;
	}
	else{
		NSString *lastsyncDate=[self getLastSyncDate];
		
		for (id airportDict in airportArray) {
			NSMutableString *LocalityName=[airportDict objectForKey:@"LO_Location_Name"];
            			
            [LocalityName replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [LocalityName length])];
            
            NSMutableString *postCode;
            if ((NSString *)[NSNull null]!=[airportDict objectForKey:@"LO_Location_Postcode"] && [airportDict objectForKey:@"LO_Location_Postcode"]!=nil && [[[airportDict objectForKey:@"LO_Location_Postcode"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
                postCode=[airportDict objectForKey:@"LO_Location_Postcode"];
            }
            else{
                postCode= [NSString stringWithFormat:@"No PostCode"];
            }
            
			
			NSString *insertLocalitiesQuery=[NSString stringWithFormat: @"INSERT INTO Airport (PlaceId,PlaceName,LastSyncedDate,PostCode,LocalityId,TruncatedName) VALUES ( '%@', '%@', '%@', '%@', '%@','%@')",[airportDict objectForKey:@"LO_ID"],LocalityName,lastsyncDate,postCode,[airportDict objectForKey:@"LO_Locality"],LocalityName];
			NSLog(@"InsertQuery for Localities is %@",insertLocalitiesQuery);
			if(![self.sqlHelper execute:insertLocalitiesQuery])
			{
				isSuccess=NO;
				break;
				NSLog(@"error is %@",[self.sqlHelper getLastErrorMsg]);
			}
		}
	}
	return isSuccess;
}


- (NSString *) getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"WiseCabsAppDB.sqlite3"];
}


-(BOOL)deleteMasterData{
	//NSString *dbpath = [self getDBPath];
	BOOL isSuccess=YES;
	NSString *deleteCityQuery=[NSString stringWithFormat: @"DELETE FROM Airport"];
	NSString *deleteLocationQuery=[NSString stringWithFormat: @"DELETE FROM Train"];
	NSString *deleteLocalityQuery=[NSString stringWithFormat: @"DELETE FROM Tube"];
	if ([self deleteTables:deleteCityQuery] && [self deleteTables:deleteLocationQuery] && [self deleteTables:deleteLocalityQuery]) {
		isSuccess=YES;
	}else {
		isSuccess=NO;
		//[self insertWebServiceData];
		
	}
	return YES;
}
-(BOOL)deleteTables:(NSString*)DeleteQuery
{
	//NSString *deleteDataQuery=[NSString stringWithFormat: @"DELETE FROM AllCities"];
	sqlite3_stmt *DeleteStmt;
	//NSDate *syncedDate=[[NSDate alloc] init]; 
	NSString *dbpath = [self getDBPath];
	if(sqlite3_open([dbpath UTF8String], &database) == SQLITE_OK) 
	{
		const char *sql = [DeleteQuery UTF8String];
		
		if(sqlite3_prepare_v2(database, sql, -1, &DeleteStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
		
		if (sqlite3_step(DeleteStmt) == SQLITE_ROW)
		{
			
		}
		//[self insertWebServiceData];
		
	}
	sqlite3_reset(DeleteStmt);
	sqlite3_finalize(DeleteStmt);
	//sqlite3_finalize(addStmt);
	sqlite3_close(database);
	return YES;
}

-(NSInteger)getUpdatedDateDiff:(NSString*)dbpath {
	//Checking on which date table and pickerview was synced
	NSString *slectDateQuery=[NSString stringWithFormat:@"SELECT LastSyncedDate from Train"];
	sqlite3_stmt *selectStmt;
	NSString *syncedDate;
	//NSDate *syncedDate=[[NSDate alloc] init]; 
	
	if(sqlite3_open([dbpath UTF8String], &database) == SQLITE_OK) 
	{
		const char *sql = [slectDateQuery UTF8String];
		
		if(sqlite3_prepare_v2(database, sql, -1, &selectStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating select statement. '%s'", sqlite3_errmsg(database));
		
		if (sqlite3_step(selectStmt) == SQLITE_ROW)
		{
			//syncedDate= [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStmt,0)];
			syncedDate=[NSString stringWithUTF8String:(char *)(sqlite3_column_text(selectStmt,0) == nil ? "1970-01-01 12:00:00" : (char *)sqlite3_column_text(selectStmt, 0))];
			NSLog(@"synceDate is %@",syncedDate);
		}
		else {
			syncedDate=@"";
		}
		
		
	}
	sqlite3_reset(selectStmt);
	sqlite3_finalize(selectStmt);
	//sqlite3_finalize(addStmt);
	sqlite3_close(database);
	

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
	//NSString *syncDate=@"2012-03-18 06:00:20";
	NSDate *date = [dateFormatter dateFromString:syncedDate];
	NSLog(@"cnverted synceddate is %@",date);
	int daydiff=-1;
	
	if (syncedDate!=@"") {
		daydiff=[self howManyDaysHavePast:date];
	}
	else{			
		daydiff= -1;		
	}
	NSLog(@"daydiff is %d",daydiff);
	[dateFormatter release];
	return daydiff;
	
}
-(int)howManyDaysHavePast:(NSDate*)lastDate {
	
	NSDate *startDate = lastDate;
	NSDate *endDate = [[NSDate alloc] init];
	
	NSCalendar *gregorian = [[[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	unsigned int unitFlags = NSDayCalendarUnit;
	NSDateComponents *components = [gregorian components:unitFlags
												fromDate:startDate
												  toDate:endDate options:0];
	int days = [components day];
	[endDate release];
	//[gregorian release];
	//[components release];
	return days;
}
-(void)dealloc{
	[sqlHelper release];
	[super	dealloc];
}
@end
