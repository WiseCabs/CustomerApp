//
//  Airport.m
//  WiseCabs
//
//  Created by Nagraj Gopalakrishnan on 22/12/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import "Airport.h"


@implementation Airport
@synthesize AirportId, AirportName;


-(void)dealloc{

	[AirportName release];
	[AirportId release]; 
	AirportName = nil;
	AirportId = nil; 
	[super dealloc]; 
}
@end
