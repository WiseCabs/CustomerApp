//
//  Common.h
//  driverApp
//
//  Created by Nagraj G on 24/11/11.
//  Copyright 2011 TeamDecode Software Private limited Consulting Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Address.h"

@interface Common : NSObject {

}
+ (NSString*)webserviceURL;
+ (void)setWebServiceURL:(NSString*)newUrl;
+ (NSInteger)isNetworkExist;
+ (void)showAlert:(NSString*) title message:(NSString*)msg;
+ (void)showNetwokAlert;
+ (BOOL)isGuestUser;
//- (NSDictionary *)readPlist; 
//- (void)writePlist:(NSDictionary *)keys; 

+(User*)loggedInUser;
+ (void)setLoggedInUser:(User*)newuser;

+(BOOL) NSStringIsValidEmail:(NSString *)email;
+(NSString*)getAddressText:(Address*)address;

+ (NSMutableDictionary *)fromAddress;
+ (void)setFromAddress:(NSMutableDictionary*)fromAddress;
+ (NSMutableDictionary *)toAddress;
+ (void)setToAddress:(NSMutableDictionary*)fromAddress;

+ (NSString *)JourneyTimings;
+(void)setJourneyTimings:(NSDate*)journeyTimings;


+ (void)setVehicleType:(NSString*)vehicleType;
+ (NSString *)vehicleType;

+ (void)setTableUpdated:(NSString*)tableUpdated;
+ (NSString *)tableUpdated;

+ (NSString *)paymentType;
+ (void)setPaymentType:(NSString*)paymenttype;

+ (NSString *) TrackerJourneyID;
+ (void)setTrackerJourneyID:(NSString*)trackerJourneyID;

+ (NSString *)TrackerDriverID;
+ (void)setTrackerDriverID:(NSString*)trackerDriverID;

+ (NSString *)SearchedJourneyID;
+ (void)setSearchedJourneyID:(NSString*)searchedJourneyID;

+ (NSString *)truncateAddress:(NSString*)address;

//+ (NSString*)loadJourney;
//+ (void)setLoadJourney:(NSString*)journeyFlag;

@end
