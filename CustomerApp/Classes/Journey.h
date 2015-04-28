//
//  Journey.h
//  driverApp
//
//  Created by Nagraj G on 23/11/11.
//  Copyright 2011 TeamDecode Software Private limited Consulting Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupplierDetails.h"
#import "UserJourney.h"

@interface Journey : NSObject {
    UserJourney *userJourney;
	NSArray *CoPassengers;
	SupplierDetails *JourneySupplier;
	NSInteger JourneyID;
    NSInteger alllocatedJnyID;
	NSString *customerEmail;
	NSString *customerMobile;
    NSString *jnyStatus;
	NSString *Currency;
	NSInteger totalpassengers;
    NSDate *jnyDate;
    NSString *JourneyDate;
}

@property (nonatomic, retain) NSString *JourneyDate;
@property (nonatomic, retain) NSDate *jnyDate;
@property (nonatomic, retain) NSString *jnyStatus;
@property (nonatomic, readwrite) NSInteger totalpassengers;
@property (nonatomic, readwrite) NSInteger JourneyID;
@property (nonatomic, readwrite)NSInteger alllocatedJnyID;
@property (nonatomic, retain) NSString *Currency;
@property (nonatomic, retain) UserJourney *userJourney;
@property (nonatomic, retain) NSArray *CoPassengers;
@property (nonatomic, retain) SupplierDetails *JourneySupplier;

@property (nonatomic, retain) NSString *customerEmail;
@property (nonatomic, retain) NSString *customerMobile;
+(id)searchedJourney;
+(void)deallocJourney;
-(NSString*)currencySymbol;
@end
