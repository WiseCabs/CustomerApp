//
//  Airport.h
//  WiseCabs
//
//  Created by Nagraj Gopalakrishnan on 22/12/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Airport : NSObject {

	NSString *AirportId;
	NSString *AirportName;
	
}
@property (nonatomic,retain) NSString *AirportId;
@property (nonatomic,retain) NSString *AirportName;

@end
