//
//  Address.h
//  WiseCabs
//
//  Created by Nagraj G on 28/12/11.
//  Copyright 2011 Apppli Consulting Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Address : NSObject {
	NSString *LocalityName;
	NSString *LocalityId;
	NSString *LocationName;
	NSString *LocationId;
	NSString *HouseNumber;
	NSString *StreetNumber;
	NSString *PostalCode;
	NSString *AddressText;
    NSString *placeID;
    NSString *placeType;
}
@property(nonatomic,retain) NSString *placeID;
@property(nonatomic,retain) NSString *placeType;
@property(nonatomic,retain) NSString *LocalityName;
@property(nonatomic,retain) NSString *LocalityId;
@property(nonatomic,retain) NSString *LocationName;
@property(nonatomic,retain) NSString *LocationId;
@property(nonatomic,retain) NSString *HouseNumber;
@property(nonatomic,retain) NSString *StreetNumber;
@property(nonatomic,retain) NSString *PostalCode;
@property(nonatomic,retain) NSString *AddressText;

@end
