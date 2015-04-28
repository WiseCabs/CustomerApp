//
//  Journey.m
//  driverApp
//
//  Created by Nagraj G on 23/11/11.
//  Copyright 2011 TeamDecode Software Private limited Consulting Pvt Ltd. All rights reserved.
//

#import "Journey.h"
#import "UserJourney.h"

static Journey *_searchedJourney = nil;
@implementation Journey
@synthesize userJourney,Currency,totalpassengers,JourneyDate;
@synthesize CoPassengers,JourneySupplier,customerMobile,customerEmail,JourneyID,alllocatedJnyID,jnyStatus,jnyDate;

+ (id)searchedJourney {
    @synchronized(self) {
        if (_searchedJourney == nil){
            _searchedJourney = [[self alloc] init];
			NSLocale* london = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
			NSNumberFormatter* fmtr = [[NSNumberFormatter alloc] init];
			[fmtr setNumberStyle:NSNumberFormatterCurrencyStyle];
			[fmtr setLocale:london];
			
			_searchedJourney.Currency=[fmtr currencySymbol];
			
			if(_searchedJourney.userJourney==nil)
			{
				_searchedJourney.userJourney=[[UserJourney alloc] init];
			}
			[london release];
			[fmtr release];
		}
    }
    return _searchedJourney;
}

-(NSString*)currencySymbol{
NSLocale* london = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
NSNumberFormatter *fmtr = [[NSNumberFormatter alloc] init];
[fmtr setNumberStyle:NSNumberFormatterCurrencyStyle];
[fmtr setLocale:london];
[london release];
london=nil;
	

self.Currency=[fmtr currencySymbol];
[fmtr release];
return Currency;

}

+(void)deallocJourney{
	if (_searchedJourney!=nil) {
		if(_searchedJourney.userJourney!=nil)
		{
			//[[_searchedJourney userJourney] release];
			_searchedJourney.userJourney=nil;
		}
		if(_searchedJourney.JourneySupplier!=nil)
		{
		//[[_searchedJourney JourneySupplier] release];
			_searchedJourney.JourneySupplier=nil;
		}
		if(_searchedJourney.CoPassengers!=nil && _searchedJourney.CoPassengers.count>0)
		{
		 // [[_searchedJourney CoPassengers] release];
			_searchedJourney.CoPassengers=nil;
		}
	}
	_searchedJourney=nil;
}
-(void)dealloc
{
    [JourneyDate release];
    [jnyDate release];
    [jnyStatus release];
	[userJourney release];
	[Currency  release];
	[CoPassengers release];
	[JourneySupplier release];
	[customerMobile release];
	[customerEmail release];
	[super dealloc];
}
@end
