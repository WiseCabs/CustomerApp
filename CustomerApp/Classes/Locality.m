//
//  Locality.m
//  WiseCabs
//
//  Created by Nagraj Gopalakrishnan on 11/12/11.
//  Copyright 2011 TeamDecode Software Private limited. All rights reserved.
//

#import "Locality.h"


@implementation Locality
@synthesize LocalityName,LocalityId;

-(void)dealloc{
[LocalityName release];
[LocalityId release]; 
LocalityName = nil;
LocalityId = nil; 
[super dealloc]; 
}
@end
