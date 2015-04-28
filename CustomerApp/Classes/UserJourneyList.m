//
//  UserJourneyList.m
//  WiseCabs
//
//  Created by Nagraj G on 02/01/12.
//  Copyright 2012 Apppli Consulting Pvt Ltd. All rights reserved.
//

#import "UserJourneyList.h"

static UserJourneyList *_Journeys = nil;
@implementation UserJourneyList

@synthesize ScheduledJourney;
@synthesize CompletedJourney;
@synthesize CancelledJourney;
@synthesize FavouriteJourney,UnconfirmedParkedJourneys,ConfirmedParkedJourneys;

+ (id)Journeys {
    @synchronized(self) {
        if (_Journeys == nil){
            _Journeys = [[self alloc] init];
		}
    }
    return _Journeys;
}
+(void)deallocJourneys{
	[_Journeys release];
	_Journeys=nil;
}
-(void)dealloc{
	NSLog(@"releasing all journey list objects");
	[ScheduledJourney release];
	[CompletedJourney release];
	[CancelledJourney release];
	[FavouriteJourney release];
	[UnconfirmedParkedJourneys release];
	[ConfirmedParkedJourneys release];
	[super dealloc];
}

@end

