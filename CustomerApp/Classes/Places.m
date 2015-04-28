//
//  Places.m
//  WiseCabs
//
//  Created by Nagraj on 19/12/12.
//
//

#import "Places.h"

@implementation Places
@synthesize placeId, placeName,postCode,truncatedPlaceName;


-(void)dealloc{
    
	[placeName release];
	[placeId release];
    [postCode release];
    [truncatedPlaceName release];
	placeName = nil;
	placeId = nil;
    postCode = nil;
    truncatedPlaceName=nil;
	[super dealloc];
}
@end
