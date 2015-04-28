//
//  UserJourney.h
//  WiseCabs
//
//  Created by Nagraj G on 17/12/11.
//  Copyright 2011 TeamDecode Software Private limited Consulting Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"

@interface UserJourney : NSObject {

	NSInteger JourneyID;
	Address *FromAddress;
	Address *ToAddress;
	/*NSString *FromLocalityName;
	NSString *FromLocalityId;
	NSString *FromLocationName;
	NSString *FromLocationId;
	NSString *FromHouseNumber;
	NSString *FromStreetNumber;
	NSString *FromPostalCode;
	NSString *FromAddressText;
	
	NSString *ToLocalityName;
	NSString *ToLocalityId;
	NSString *ToLocationName;
	NSString *ToLocationId;
	NSString *ToHouseNumber;
	NSString *ToStreetNumber;
	NSString *ToPostalCode;
	NSString *ToAddressText;
*/
	NSInteger NumberOfPassenger;
	NSString *JourneyFare;
	NSString *Gender;
	NSInteger NumberOfBags;
	NSString *JourneyDate;
	NSString *JourneyTime;
	NSString *JourneyTimein12Hr;
	NSString *JourneyType;
	NSInteger Fare;
	//Checking if Airport Search
	NSString *IsFromAirport;
	NSString *IsToAirport;
	NSInteger IsFavorite;
	NSInteger TotalCoPassenger;
    NSInteger journeyRating;
}

@property (nonatomic, readwrite) NSInteger journeyRating;
@property (nonatomic, readwrite)  NSInteger JourneyID;
@property (nonatomic, readwrite)  NSInteger TotalCoPassenger;
/*@property (nonatomic, retain) NSString *FromLocalityName;
@property (nonatomic, retain) NSString *FromLocalityId;
@property (nonatomic, retain) NSString *FromLocationName;
@property (nonatomic, retain) NSString *FromLocationId;
@property (nonatomic, retain) NSString *ToLocalityName;
@property (nonatomic, retain) NSString *ToLocalityId;
@property (nonatomic, retain) NSString *ToLocationName;
@property (nonatomic, retain) NSString *ToLocationId;
@property (nonatomic, retain) NSString *ToAddressText;
@property (nonatomic, retain) NSString *FromAddressText;
@property (nonatomic, retain) NSString *FromHouseNumber;
@property (nonatomic, retain) NSString *FromStreetNumber;
@property (nonatomic, retain) NSString *FromPostalCode;
@property (nonatomic, retain) NSString *ToHouseNumber;
@property (nonatomic, retain) NSString *ToStreetNumber;
@property (nonatomic, retain) NSString *ToPostalCode;
*/
@property (nonatomic, readwrite)  NSInteger Fare;
@property (nonatomic, retain) Address *FromAddress;
@property (nonatomic, retain) Address *ToAddress;
@property(nonatomic, retain) NSString *IsFromAirport;
@property(nonatomic, retain) NSString *IsToAirport;
@property (nonatomic, readwrite) NSInteger IsFavorite;
@property (nonatomic, readwrite)  NSInteger NumberOfPassenger;
@property (nonatomic, readwrite)  NSInteger NumberOfBags;
@property (nonatomic, retain) NSString *JourneyFare;
@property (nonatomic, retain) NSString *Gender;
@property (nonatomic, retain) NSString *JourneyDate;
@property (nonatomic, retain) NSString *JourneyTime;
@property (nonatomic, retain) NSString *JourneyType;
@property (nonatomic, retain) NSString *JourneyTimein12Hr;
@end
