//
//  UserJourney.m
//  WiseCabs
//
//  Created by Nagraj G on 17/12/11.
//  Copyright 2011 TeamDecode Software Private limited Consulting Pvt Ltd. All rights reserved.
//

#import "UserJourney.h"


@implementation UserJourney
@synthesize JourneyID,NumberOfPassenger,JourneyFare,Gender,NumberOfBags,JourneyTime,Fare,TotalCoPassenger;

@synthesize IsFromAirport,IsToAirport;
@synthesize FromAddress,ToAddress,IsFavorite;
@synthesize JourneyType;
@synthesize JourneyDate,JourneyTimein12Hr,journeyRating;


-(void)dealloc{
	[JourneyFare release];
	[Gender release];
	[JourneyTime release];
	[IsFromAirport release];
	[IsToAirport release];
	[FromAddress release];
	[ToAddress release];
	[JourneyType release];
	[JourneyDate release];
	[JourneyTimein12Hr release];
	[super dealloc];	
}
@end
