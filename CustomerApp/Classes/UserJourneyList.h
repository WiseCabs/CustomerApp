//
//  UserJourneyList.h
//  WiseCabs
//
//  Created by Nagraj G on 02/01/12.
//  Copyright 2012 Apppli Consulting Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserJourneyList : NSObject {
	NSArray *ScheduledJourney;
	NSArray *CompletedJourney;
	NSArray *CancelledJourney;
	NSArray *FavouriteJourney;
	NSArray *UnconfirmedParkedJourneys;
	NSArray *ConfirmedParkedJourneys;
}
@property(nonatomic,retain) NSArray *ScheduledJourney;
@property(nonatomic,retain) NSArray *CompletedJourney;
@property(nonatomic,retain) NSArray *CancelledJourney;
@property(nonatomic,retain) NSArray *FavouriteJourney;
@property(nonatomic,retain) NSArray *UnconfirmedParkedJourneys;
@property(nonatomic,retain) NSArray *ConfirmedParkedJourneys;
+(id)Journeys;
+(void)deallocJourneys;

@end
