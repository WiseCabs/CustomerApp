//
//  Locality.h
//  WiseCabs
//
//  Created by Nagraj Gopalakrishnan on 11/12/11.
//  Copyright 2011 TeamDecode Software Private limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Locality : NSObject {
	NSString *LocalityId;
	NSString *LocalityName;

}
@property (nonatomic,retain) NSString *LocalityId;
@property (nonatomic,retain) NSString *LocalityName;

@end
