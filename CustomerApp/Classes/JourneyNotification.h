//
//  JourneyNotification.h
//  WiseCabs
//
//  Created by Nagraj G on 02/01/12.
//  Copyright 2012 Apppli Consulting Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JourneyNotification : NSObject {
	NSTimer *updateTimer;
}
@property(nonatomic,retain) NSTimer *updateTimer;
- (void)notifyJourneyListObservers;
- (void)updateAllJourneyList;
- (void)getAllJourneyList;
- (void)getJourneyList;
@end
