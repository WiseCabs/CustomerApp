//
//  Location.h
//  WiseCabs
//
//  Created by Nagraj Gopalakrishnan on 11/12/11.
//  Copyright 2011 TeamDecode Software Private limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Location : NSObject {

	NSString *LocationId;
	NSString *LocationName;
	
}
@property (nonatomic,retain) NSString *LocationId;
@property (nonatomic,retain) NSString *LocationName;

@end
