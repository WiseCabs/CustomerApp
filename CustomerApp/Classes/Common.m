//
//  Common.m
//  driverApp
//
//  Created by Nagraj G on 24/11/11.
//  Copyright 2011 TeamDecode Software Private limited Consulting Pvt Ltd. All rights reserved.
//

#import "Common.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#include <netinet/in.h>

static NSString* url;
static User *_loggedInuser;
static NSMutableDictionary* FromAddress;
static NSMutableDictionary* ToAddress;
static NSString* VehicleType;
static NSString* paymentType;
static NSString *TableUpdated;
static NSDate *JourneyTimings;
static NSString *TrackerDriverID;
static NSString *TrackerJourneyID;
static NSString *SearchedJourneyID;

@implementation Common


+ (NSString*)webserviceURL {
    return url;
}

+ (void)setWebServiceURL:(NSString*)newUrl{
	if (url != newUrl) {
        [url release];
        url = [newUrl copy];
    }
	
}
+(User*)loggedInUser{
	return _loggedInuser;
}
+ (void)setLoggedInUser:(User*)newuser{
	if (_loggedInuser != newuser) {
        [_loggedInuser release];
        _loggedInuser = newuser;
    }
}

+ (BOOL)isGuestUser{

	if (_loggedInuser!=nil && [[_loggedInuser ID] intValue]>0) {
		return NO;
	}else {
		return YES;
	}

}


+ (NSString *)SearchedJourneyID {
    return SearchedJourneyID;
}

+ (void)setSearchedJourneyID:(NSString*)searchedJourneyID{
    if (SearchedJourneyID != searchedJourneyID) {
        [SearchedJourneyID release];
        SearchedJourneyID = [searchedJourneyID copy];
    }
    
}

+ (NSString *)TrackerDriverID {
    return TrackerDriverID;
}

+ (void)setTrackerDriverID:(NSString*)trackerDriverID{
    if (TrackerDriverID != trackerDriverID) {
        [TrackerDriverID release];
        TrackerDriverID = [trackerDriverID copy];
    }
    
}

+ (NSString *) TrackerJourneyID {
    return TrackerJourneyID;
}

+ (void)setTrackerJourneyID:(NSString*)trackerJourneyID{
    if (TrackerJourneyID != trackerJourneyID) {
        [TrackerJourneyID release];
        TrackerJourneyID = [trackerJourneyID copy];
    }
    
}

+ (NSString *)tableUpdated {
    return TableUpdated;
}

+ (void)setTableUpdated:(NSString*)tableUpdated{
    if (TableUpdated != tableUpdated) {
        [TableUpdated release];
        TableUpdated = [tableUpdated copy];
    }
    
}

+ (NSMutableDictionary *)fromAddress {
    return FromAddress;
}

+ (void)setFromAddress:(NSMutableDictionary*)fromAddress{
    if (FromAddress != fromAddress) {
        [FromAddress release];
        FromAddress = [fromAddress copy];
    }
		
}

+ (NSMutableDictionary *)toAddress {
    return ToAddress;
}

+ (void)setToAddress:(NSMutableDictionary*)toAddress{
    if (ToAddress != toAddress) {
        [ToAddress release];
        ToAddress = [toAddress copy];
    }
    
}

+ (NSDate *)JourneyTimings {
    return JourneyTimings;
}

+ (void)setJourneyTimings:(NSDate*)journeyTimings{
    if (JourneyTimings != journeyTimings) {
        [JourneyTimings release];
        JourneyTimings = [journeyTimings copy];
    }
    
}

+ (NSString *)truncateAddress:(NSString*)address{
    
    NSString *truncatedName=[address stringByReplacingOccurrencesOfString:@" Train Station" withString:@""];
    truncatedName=[address stringByReplacingOccurrencesOfString:@" Tube Station" withString:@""];
    
    return truncatedName;
}


+ (NSString *)paymentType {
    return paymentType;
}

+ (void)setPaymentType:(NSString*)paymenttype{
    if (paymentType != paymenttype) {
        [paymentType release];
        paymentType = [paymenttype copy];
    }
	
}


+ (NSString *)vehicleType {
    return VehicleType;
}

+ (void)setVehicleType:(NSString*)vehicleType{
    if (VehicleType != vehicleType) {
        [VehicleType release];
        VehicleType = [vehicleType copy];
    }
	
}


+ (NSInteger)isNetworkExist
{
	//return 1;
	Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
	{
		return 0;
	}else {
		return 1;
	}
	

}


+ (void)showAlert:(NSString*)title message:(NSString*)msg
{
	UIAlertView *InternetConnectionAlert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[InternetConnectionAlert show];
	[InternetConnectionAlert release];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex==0) {
		//NSLog(@"button 1 is clicked");
	}
	else {
		//NSLog("button 2 was clicked");
	}


}



+ (void)showNetwokAlert
{
	[self showAlert:@"Network Error" message:@"No Internet Available" ];
		}


/*
- (NSDictionary *)readPlist{
	
	//reading data from plist
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	// get documents path
	NSString *documentsPath = [paths objectAtIndex:0];
	// get the path to our Data/plist file
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Custom.plist"];
	
	// check to see if Data.plist exists in documents
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) 
	{
		// if not in documents, get property list from main bundle
		plistPath = [[NSBundle mainBundle] pathForResource:@"Custom" ofType:@"plist"];
	}
	
	// read property list into memory as an NSData object
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	// convert static property liost into dictionary object
	NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];

	for (id key in temp) {
		
        NSLog(@"key: %@, value: %@", key, [temp objectForKey:key]);
		
    }
	if (!temp) 
	{
		NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
	}	
	return temp;
}


- (void)writePlist:(NSDictionary *)keys {
	//Saving Data to Custom.plist
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	// get documents path
	NSString *documentsPath = [paths objectAtIndex:0];
	// get the path to our Data/plist file
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Custom.plist"];
	
	NSString *error = nil;
	// create NSData from dictionary
	NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:keys format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
	
	// check is plistData exists
	if(plistData) 
	{
		// write plistData to our Data.plist file
		[plistData writeToFile:plistPath atomically:YES];
		NSLog(@"sucess in saveData");
	}
	else 
	{
		NSLog(@"Error in saveData: %@", error);
		[error release];
	}
	
}*/


+(BOOL) NSStringIsValidEmail:(NSString *)email
{
	BOOL stricterFilter = YES; 
	NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
	NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:email];
}


+(NSString*)getAddressText:(Address*)address{
	NSString *PickUpFrom=@"";
	
	if ((NSString *)[NSNull null]!=address.HouseNumber && address.HouseNumber!=nil && [[address.HouseNumber stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
		PickUpFrom=[PickUpFrom stringByAppendingString:[NSString stringWithFormat:@"%@,",address.HouseNumber]];
	}
	if ((NSString *)[NSNull null]!=address.StreetNumber && address.StreetNumber!=nil && [[address.StreetNumber stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
		PickUpFrom=[PickUpFrom stringByAppendingString:[NSString stringWithFormat:@" %@",address.StreetNumber]];
	}
	if ((NSString *)[NSNull null]!=address.LocationName && address.LocationName!=nil &&   address.LocationName!=nil && [[address.LocationName stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
		if ([PickUpFrom length]>0) {
			PickUpFrom=[PickUpFrom stringByAppendingString:[NSString stringWithFormat:@", %@",address.LocationName]];
		}else {
			PickUpFrom=[PickUpFrom stringByAppendingString:[NSString stringWithFormat:@"%@",address.LocationName]];
			
		}
	}
	if ((NSString *)[NSNull null]!=address.LocalityName && address.LocalityName!=nil && [[address.LocalityName stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
		PickUpFrom=[PickUpFrom stringByAppendingString:[NSString stringWithFormat:@" %@",address.LocalityName]];
	}
	if ((NSString *)[NSNull null]!=address.PostalCode && address.PostalCode!=nil && [[address.PostalCode stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0) {
		PickUpFrom=[PickUpFrom stringByAppendingString:[NSString stringWithFormat:@", %@",address.PostalCode]];
	}
	NSLog(@"concatenated address is %@",PickUpFrom);
	return PickUpFrom;
}
@end
