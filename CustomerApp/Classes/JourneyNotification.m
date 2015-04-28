//
//  JourneyNotification.m
//  WiseCabs
//
//  Created by Nagraj G on 02/01/12.
//  Copyright 2012 Apppli Consulting Pvt Ltd. All rights reserved.
//

#import "JourneyNotification.h"
#import "JourneyHelper.h"
#import "Common.h"
#import "UserJourneyList.h"

@implementation JourneyNotification
@synthesize updateTimer;

- (void)notifyJourneyListObservers {
	NSDictionary *dictionary = [[NSDictionary alloc] init];
    [[NSNotificationCenter defaultCenter]
	 postNotificationName:@"DataUpdatedNotification"
	 object:nil userInfo:dictionary];
}


- (void)getJourneyList{
	[self getAllJourneyList];
	    
}



- (void)updateAllJourneyList{
	[self getAllJourneyList];
	[self notifyJourneyListObservers];
	NSLog(@"set timer");
if ([NSThread isMainThread]) {
	NSLog(@"main thread");
}else {
	NSLog(@"secondry threading");
}

	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	NSLog(@"update timer called on %@",[NSDate date]);
    if (updateTimer ==nil) {
        updateTimer=[NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(update:) userInfo:nil repeats:YES];
    }
    
	[runLoop run];

}

-(void)update:(NSTimer*) tm{
	
	//MyBookings *myBooking=[[[MyBookings alloc] init] autorelease];
	//NSLog(@"refresh button is not tapped now");
    if (![Common isGuestUser]) {
        NSLog(@"timer called");
        [self getAllJourneyList];
		[self notifyJourneyListObservers];
    }
		
	

	
}

-(void)getAllJourneyList{
	NSLog(@"update date:%@",[NSDate date]);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

	if ([Common isNetworkExist]>0)
	{
            JourneyHelper *helper=[[JourneyHelper alloc] init];
            [helper getMyBookings];
            [helper release];
      	
		
	}else {
		[Common showNetwokAlert];
	}

	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
-(void)dealloc{
	[updateTimer invalidate];
	updateTimer=nil;
	[super dealloc];
}
@end
