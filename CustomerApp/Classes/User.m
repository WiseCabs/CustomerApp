//
//  User.m
//  WiseCabs
//
//  Created by Nagraj Gopalakrishnan on 19/12/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import "User.h"


@implementation User
@synthesize	FirstName,LastName,Email,ID,MobileNumber,suppID,password, userName;

-(void) dealloc
{
    [suppID release];
	[FirstName release];
	[LastName release];
	[Email release];
	[ID release];
	[MobileNumber release];
    [password release];
    [userName release];
    
	[super dealloc];
}
@end
