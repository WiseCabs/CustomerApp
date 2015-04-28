//
//  Places.h
//  WiseCabs
//
//  Created by Nagraj on 19/12/12.
//
//

#import <Foundation/Foundation.h>

@interface Places : NSObject{
    
	NSString *placesId;
	NSString *placeName;
    NSString *postCode;
    NSString *truncatedPlaceName;
	
}
@property (nonatomic,retain) NSString *placeId;
@property (nonatomic,retain) NSString *placeName;
@property (nonatomic,retain) NSString *postCode;
@property (nonatomic,retain) NSString *truncatedPlaceName;

@end
