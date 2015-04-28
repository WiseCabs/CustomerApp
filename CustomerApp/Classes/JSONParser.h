//
//  JSONParser.h
//  driverApp
//
//  Created by Nagraj G on 23/11/11.
//  Copyright 2011 TeamDecode Software Private limited Consulting Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JSONParser : NSObject {
	NSObject *objEntity;
	//NSDictionary *resultDictionary;
	NSMutableArray *finalResultArray;
	//NSArray *resArray;
	//NSMutableArray *coPassengerJournies;
	NSMutableArray *myJourneyDetailArray;
	NSMutableArray *resultArray;
	//NSMutableArray *journeySupplier;
}
@property(nonatomic, retain) NSObject *objEntity;
//@property(nonatomic, retain) NSDictionary *resultDictionary;
@property(nonatomic, retain) NSMutableArray *finalResultArray;
@property(nonatomic, retain) NSMutableArray *resultArray;
//@property(nonatomic, retain) NSMutableArray *coPassengerJournies;
@property(nonatomic, retain) NSMutableArray *myJourneyDetailArray;
//@property(nonatomic, retain) NSMutableArray *journeySupplier;
//@property(nonatomic, retain)  NSMutableArray *resArray;

//- (JSONParser *) initJSONParser;
- (NSArray *)getParsedEntities:(NSString *)jsonData;
- (NSArray *)getUserLocationParsedEntities:(NSString *)jsonData;

-(void)getJourneySupplier:(NSDictionary*)supplierArray fare:(NSString*)totalFare;
-(void)getCoPassengerJournies:(NSArray*)JourneyArray;
-(NSArray *)getMyBookings:(NSArray*)JourneyArray;
-(void)getJourneyList:(NSDictionary*)Journeys;
@end
