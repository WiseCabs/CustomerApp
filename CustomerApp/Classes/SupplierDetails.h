//
//  SupplierDetails.h
//  WiseCabs
//
//  Created by Nagraj G on 13/12/11.
//  Copyright 2011 TeamDecode Software Private limited Consulting Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SupplierDetails : NSObject {
	NSString *supplierName;
	NSString *cabNumber;
	NSString *cabDriverName;
	NSString *cabDriverMobile;
	NSString *totalFarePayable;
    NSString *cabDriverNumber;
}
@property(nonatomic, retain) NSString *supplierName;
@property(nonatomic, retain) NSString *cabNumber;
@property(nonatomic, retain) NSString *cabDriverName;
@property(nonatomic, retain) NSString *cabDriverMobile;
@property(nonatomic, retain) NSString *totalFarePayable;
@property (nonatomic, retain) NSString *cabDriverNumber;
@end
