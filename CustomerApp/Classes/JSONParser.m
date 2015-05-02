//
//  JSONParser.m
//  driverApp
//
//  Created by Nagraj G on 23/11/11.
//  Copyright 2011 TeamDecode Software Private limited Consulting Pvt Ltd. All rights reserved.
//

#import "JSONParser.h"
#import "JSON.h"
#import "UserJourney.h"
#import "SupplierDetails.h"
#import "Journey.h"
#import "Common.h"
#import "UserJourneyList.h"

@implementation JSONParser

@synthesize  objEntity,finalResultArray,resultArray,myJourneyDetailArray;

/*- (JSONParser *) initJSONParser{
	[super init];
	self.objEntity = [[NSObject alloc] init];
	return self;
}*/

- (NSArray *)getUserLocationParsedEntities:(NSString *)jsonData
{
     NSDictionary *jsonresultDict=[jsonData JSONValue];
    for (id key in jsonresultDict) {
        NSLog(@"key: %@, value: %@ \n", key, [jsonresultDict objectForKey:key]);
    }

    NSMutableArray *result=[[NSMutableArray alloc] init];
    self.finalResultArray=result;
    [result release];
    
    [self.finalResultArray addObject:jsonresultDict];

    return finalResultArray;
}
- (NSArray *)getParsedEntities:(NSString *)jsonData
{
    NSMutableArray *jsonresultArray=[jsonData JSONValue];
    
    NSDictionary *resultDictionary=[jsonresultArray objectAtIndex:0];
	NSString *sucess=[resultDictionary objectForKey:@"success"];
	if ([sucess isEqualToString:@"true"]) {
		
		if([self.objEntity isKindOfClass:[UserJourney class]])
		{
		resultArray=[resultDictionary objectForKey:@"co-passenger"];
		[self getCoPassengerJournies:resultArray];

		}
		else if([self.objEntity isKindOfClass:[SupplierDetails class]]){
		resultArray=[resultDictionary objectForKey:@"supp_detail"];
		[self getJourneySupplier:resultArray fare:[resultDictionary objectForKey:@"Fare"]];
		}
		else if([self.objEntity isKindOfClass:[Journey class]]){
		 [self getJourneyList:resultDictionary];
		}
		else
		{
		  NSMutableArray *result=[[NSMutableArray alloc] init];
		  self.finalResultArray=result;
		  [result release];
			
		  [self.finalResultArray addObject:resultDictionary];
		}

		return [self finalResultArray];
	}else {
		return nil;
	}

}



-(void)getJourneySupplier:(NSDictionary*)supplierArray fare:(NSString*)totalFare
{
	NSMutableArray *journey_supplier=[[NSMutableArray alloc]init];
	self.finalResultArray=journey_supplier;
	[journey_supplier release];
	
	SupplierDetails *supplier=[[SupplierDetails alloc] init];
	supplier.supplierName=[supplierArray objectForKey:@"Cab_Station_Name"];
	supplier.cabNumber=[supplierArray objectForKey:@"Cab_Number"];
	supplier.cabDriverName=[supplierArray objectForKey:@"Driver_Name"];
    supplier.cabDriverNumber=[supplierArray objectForKey:@"Driver_Number"];
	supplier.cabDriverMobile=[supplierArray objectForKey:@"Driver_Mobile"];
    supplier.totalFarePayable=totalFare;
	[self.finalResultArray addObject:supplier];
	[supplier release];
}

-(void)getJourneyList:(NSDictionary*)Journeys{

	[UserJourneyList deallocJourneys];
	UserJourneyList *journeyList=[UserJourneyList Journeys];
	
	NSArray *scheduledArray=[Journeys objectForKey:@"scheduled"];
	if (scheduledArray !=nil && scheduledArray.count>0) {
        NSArray *scheduledJourneys=[self getMyBookings:scheduledArray];
        
        NSSortDescriptor *dateDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"jnyDate"  ascending:YES] autorelease];
        
        NSArray *sortDescriptors  = [NSArray arrayWithObjects:dateDescriptor, nil];
        
        if ([scheduledJourneys count]>0) {
            journeyList.ScheduledJourney= [scheduledJourneys sortedArrayUsingDescriptors:sortDescriptors];
            
        }
		//journeyList.ScheduledJourney=[self getMyBookings:scheduledJourneys];
	}
    
    
    NSArray *completedArrays=[Journeys objectForKey:@"completed"];
	if (completedArrays !=nil && completedArrays.count>0) {
        NSArray *completedJourneys=[self getMyBookings:completedArrays];
        
        NSSortDescriptor *dateDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"jnyDate"  ascending:NO] autorelease];
        
        NSArray *sortDescriptors  = [NSArray arrayWithObjects:dateDescriptor, nil];
        
        if ([completedJourneys count]>0) {
            journeyList.CompletedJourney= [completedJourneys sortedArrayUsingDescriptors:sortDescriptors];
            
        }

        
        
		//journeyList.CompletedJourney=[self getMyBookings:completedJourneys];
	}
	
	NSArray *cancelledJourneys=[Journeys objectForKey:@"canceled"];
	if (cancelledJourneys !=nil && cancelledJourneys.count>0) {
		journeyList.CancelledJourney=[self getMyBookings:cancelledJourneys];
	}
	
	NSArray *favoriteJourneys=[Journeys objectForKey:@"favorite"];
	if (favoriteJourneys !=nil && favoriteJourneys.count>0) {
		journeyList.FavouriteJourney=[self getMyBookings:favoriteJourneys];
	}
	
	NSArray *confirmedParkedJourneys=[Journeys objectForKey:@"parked_confirmed"];
	if (confirmedParkedJourneys !=nil && confirmedParkedJourneys.count>0) {
		journeyList.ConfirmedParkedJourneys=[self getMyBookings:confirmedParkedJourneys];
	}
	
	NSArray *unConfirmedParkedJourneys=[Journeys objectForKey:@"parked"];
	if (unConfirmedParkedJourneys !=nil && unConfirmedParkedJourneys.count>0) {
		journeyList.UnconfirmedParkedJourneys=[self getMyBookings:unConfirmedParkedJourneys];
	}

}

-(NSArray *)getMyBookings:(NSArray*)JourneyArray
{

	NSMutableArray *myJnyArray=[[NSMutableArray alloc]init];
	self.myJourneyDetailArray=myJnyArray;
	[myJnyArray release];
	//[Common setTrackerJourneyID:@""];
    //[Common setTrackerDriverID:@""];
	
	for(id currentObject in JourneyArray){ 
		Journey *journey=[[Journey alloc] init];
		UserJourney *passenger=[[UserJourney alloc]init];
		journey.JourneyID=[[currentObject objectForKey:@"journeyId"] intValue];
        passenger.journeyRating= [[currentObject objectForKey:@"Customer_Rating"] intValue];
        journey.alllocatedJnyID=[[currentObject objectForKey:@"Allocated_JourneyID"] intValue];
        
        NSString *dateString=[currentObject objectForKey:@"Date"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        NSDate *date = [dateFormat dateFromString:dateString];
        journey.jnyDate=date;
        journey.JourneyDate =[currentObject objectForKey:@"Date"];
        journey.jnyStatus=[currentObject objectForKey:@"Journey_Status"];
        
        
		NSLog(@"journey id is %ld",(long)journey.JourneyID);        //64 bit changes
		NSInteger totalpassenger=[[currentObject objectForKey:@"Total-Passenger"] intValue];
		journey.totalpassengers=totalpassenger;
		NSString *journeyType=[currentObject objectForKey:@"Type_of_Journey"];
		if ([journeyType isEqualToString:@"S"]) {
			passenger.JourneyType=@"SHARED";
		}
		else if([journeyType isEqualToString:@"D"])
		{
			passenger.JourneyType=@"DEDICATED";
		}
		Address *fromaddress=[[Address alloc] init];
		passenger.FromAddress=fromaddress;
		[fromaddress release];
		[passenger FromAddress].LocalityName= [currentObject objectForKey:@"Start_Locality"];
		[passenger FromAddress].LocationName=[currentObject objectForKey:@"Start_Location"];
		[passenger FromAddress].HouseNumber=[currentObject objectForKey:@"Start_House_No"];
		[passenger FromAddress].StreetNumber=[currentObject objectForKey:@"Start_Street_No"];
		[passenger FromAddress].PostalCode=[currentObject objectForKey:@"Start_Postcode"];
        [passenger FromAddress].placeType=[currentObject objectForKey:@"StartLocalityType"];
        [passenger FromAddress].placeID=[currentObject objectForKey:@"StartLocationId"];
                
		[passenger FromAddress].AddressText=[Common getAddressText:passenger.FromAddress];
		passenger.IsFavorite=[[currentObject objectForKey:@"Favorite"] intValue];
		if([currentObject objectForKey:@"Fare"]!=[NSNull null])
		{
		passenger.Fare=[[currentObject objectForKey:@"Fare"] intValue];
		}
		//journey.Currency= [[currentObject objectForKey:@"Fare"] intValue];
		
		Address *toaddress=[[Address alloc] init];
		passenger.ToAddress=toaddress;
		[toaddress release];
		[passenger ToAddress].LocalityName= [currentObject objectForKey:@"End_Locality"];
		[passenger ToAddress].LocationName=[currentObject objectForKey:@"End_Location"];
		[passenger ToAddress].HouseNumber=[currentObject objectForKey:@"End_House_No"];
		[passenger ToAddress].StreetNumber=[currentObject objectForKey:@"End_Street_No"];
		[passenger ToAddress].PostalCode=[currentObject objectForKey:@"End_Postcode"];
		[passenger ToAddress].AddressText=[Common getAddressText:passenger.ToAddress];
        [passenger ToAddress].placeType=[currentObject objectForKey:@"EndLocalityType"];
        [passenger ToAddress].placeID=[currentObject objectForKey:@"EndLocationId"];
		
		passenger.JourneyTime=[currentObject objectForKey:@"Time"];
		passenger.JourneyDate=[currentObject objectForKey:@"Date"];
		passenger.NumberOfBags=[[currentObject objectForKey:@"No_Bag"] intValue];
		passenger.NumberOfPassenger=[[currentObject objectForKey:@"No_Passenger"] intValue];
		//passenger.Gender=[currentObject objectForKey:@"Gender"];
		
		journey.userJourney=passenger;
		[passenger release];
	 
		NSDictionary *supplierArray=[currentObject objectForKey:@"Supplier"];
        SupplierDetails *suppdetails=[[SupplierDetails alloc] init];
		
		suppdetails.supplierName=[supplierArray objectForKey:@"Cab_Station_Name"];
		suppdetails.cabNumber=[supplierArray objectForKey:@"Cab_Number"];
        if (suppdetails.cabNumber ==NULL) {
            suppdetails.cabNumber=@" ";
        }
		suppdetails.cabDriverName=[supplierArray objectForKey:@"Driver_Name"];  
        suppdetails.cabDriverNumber=[supplierArray objectForKey:@"Driver_Number"];
		suppdetails.cabDriverMobile=[supplierArray objectForKey:@"Driver_Number"];
        
        if([currentObject objectForKey:@"Journey_Status"]!=[NSNull null])
		{
            if ([[currentObject objectForKey:@"Journey_Status"] isEqualToString:@"Passenger On Board"] || [[currentObject objectForKey:@"Journey_Status"] isEqualToString:@"On Route"])
            {
                [Common setTrackerJourneyID:[currentObject objectForKey:@"journeyId"]];
                [Common setTrackerDriverID:[supplierArray objectForKey:@"Driver_Number"]];
                  NSLog(@"[Common TrackerDriverID] is--- %@",[Common TrackerDriverID]);
                  NSLog(@"[Common setTrackerJourneyID] is--- %@",[Common TrackerJourneyID]);
            }
        }
        
		//supplierdetails.totalFarePayable=Fare;
        journey.JourneySupplier=suppdetails;
		[suppdetails release];

		NSArray *copassArray=[currentObject objectForKey:@"Co-Passenger"];
		if (copassArray !=nil && [copassArray count]>0) {
			[self getCoPassengerJournies:[currentObject objectForKey:@"Co-Passenger"]];
			journey.CoPassengers=self.finalResultArray;
		}
		[myJourneyDetailArray addObject:journey];

		[journey release];
		NSLog(@"journey count:%lu",(unsigned long)[myJourneyDetailArray count]);        //64 bit changes

	}
	
	return myJourneyDetailArray;
	
}

-(void)getCoPassengerJournies:(NSArray*)JourneyArray
{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
	self.finalResultArray=arr;
	[arr release];
	

	for(id currentObject in JourneyArray){ 
		UserJourney *copassenger=[[UserJourney alloc] init];
		copassenger.TotalCoPassenger=[[currentObject objectForKey:@"total-co-passenger"] intValue];
		NSLog(@"total copassenger number is %ld",(long)copassenger.TotalCoPassenger);       //64 bit changes
		Address *fromaddress=[[Address alloc] init];
		copassenger.FromAddress=fromaddress;
		[fromaddress release];
        
        
		[copassenger FromAddress].LocalityName= [currentObject objectForKey:@"Start_Locality"];
		[copassenger FromAddress].LocationName=[currentObject objectForKey:@"Start_Location"];
		[copassenger FromAddress].HouseNumber=[currentObject objectForKey:@"Start_House_No"];
		[copassenger FromAddress].StreetNumber=[currentObject objectForKey:@"Start_Street_Name"];
		[copassenger FromAddress].PostalCode=[currentObject objectForKey:@"Start_Post_Code"];
		[copassenger FromAddress].AddressText=[Common getAddressText:copassenger.FromAddress];
		
		
		Address *toaddress=[[Address alloc] init];
		copassenger.ToAddress=toaddress;
		[toaddress release];
		[copassenger ToAddress].LocalityName= [currentObject objectForKey:@"End_Locality"];
		[copassenger ToAddress].LocationName=[currentObject objectForKey:@"End_Location"];
		[copassenger ToAddress].HouseNumber=[currentObject objectForKey:@"End_House_No"];
		[copassenger ToAddress].StreetNumber=[currentObject objectForKey:@"End_Street_Name"];
		[copassenger ToAddress].PostalCode=[currentObject objectForKey:@"End_Post_Code"];
		[copassenger ToAddress].AddressText=[Common getAddressText:copassenger.ToAddress];
		
		//copassenger.JourneyID=[currentObject objectForKey:@""];
		copassenger.JourneyTime=[currentObject objectForKey:@"Time"];
		copassenger.JourneyDate=[currentObject objectForKey:@"Date"];
		copassenger.NumberOfBags=[[currentObject objectForKey:@"No_Bag"] intValue];
		
		copassenger.NumberOfPassenger=[[currentObject objectForKey:@"No_Passenger"] intValue];
		if ([[[currentObject objectForKey:@"Gender"] lowercaseString] isEqualToString:@"m"]) {
			copassenger.Gender=@"Male";
		}else {
			copassenger.Gender=@"Female";
		}
		
		[self.finalResultArray addObject:copassenger];
		[copassenger release];
	}

}
-(void)dealloc{
	[finalResultArray release];
	[myJourneyDetailArray release];
	[objEntity release];
	[super	dealloc];
}
@end
