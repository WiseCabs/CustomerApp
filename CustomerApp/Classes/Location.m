//
//  Location.m
//  WiseCabs
//
//  Created by Nagraj Gopalakrishnan on 11/12/11.
//  Copyright 2011 TeamDecode Software Private limited. All rights reserved.
//

#import "Location.h"


@implementation Location
@synthesize LocationName,LocationId;

-(void)dealloc{
	[LocationName release];
	[LocationId release]; 
	LocationName = nil;
	LocationId = nil; 
	[super dealloc]; 
}
@end
