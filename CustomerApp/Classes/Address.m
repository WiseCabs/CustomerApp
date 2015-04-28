//
//  Address.m
//  WiseCabs
//
//  Created by Nagraj G on 28/12/11.
//  Copyright 2011 Apppli Consulting Pvt Ltd. All rights reserved.
//

#import "Address.h"


@implementation Address

@synthesize LocalityName;
@synthesize LocalityId;
@synthesize LocationName;
@synthesize LocationId;
@synthesize HouseNumber;
@synthesize StreetNumber;
@synthesize PostalCode;
@synthesize AddressText,placeID,placeType;

-(void)dealloc{
	[LocalityName release];
	[LocalityId release];
	[LocationName release];
	[LocationId release];
	[HouseNumber release];
	[StreetNumber release];
	[PostalCode release];
	[AddressText release];
    [placeID release];
    [placeType release];
	[super dealloc];
}
@end
