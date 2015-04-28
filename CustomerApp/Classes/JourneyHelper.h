//
//  JourneyHelper.h
//  WiseCabs
//
//  Created by Nagraj G on 13/12/11.
//  Copyright 2011 Apppli Consulting Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	"SupplierDetails.h"
#import "UserJourney.h"

@interface JourneyHelper : NSObject {
	NSArray *resultArray;
}
@property(nonatomic,retain) NSArray *resultArray;
-(NSArray*)getJourneySupplier:(NSInteger)journeyID;
-(NSArray*)getCoPassenger:(NSInteger)journeyID;
-(BOOL)convertToDedicatedJourney:(NSInteger)journeyID;

-(BOOL)confirmJourney:(NSString*)journeyID firstName:(NSString*)fname lastName:(NSString*)lname userEmail:(NSString*)email userMobile:(NSString*)mobile supplierID:(NSString*)suppID distance:(NSString*)distance fare:(NSString*)fare journeyDict:(NSDictionary*)jnyDict;
-(BOOL)markAsFavourite:(NSString *)journeyID;
-(NSInteger)addJourney:(UserJourney*)searchedJourney;
-(NSArray *)getMyBookings;
-(BOOL)convertToDedicatedJourney:(NSInteger)journeyID;
-(BOOL)cancelJourney:(NSInteger)journeyID;
-(BOOL)confirmParkedJourney:(NSInteger)journeyID  userId:(NSString*)uid;
@end
