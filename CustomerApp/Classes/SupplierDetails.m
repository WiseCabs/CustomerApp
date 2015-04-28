//
//  SupplierDetails.m
//  WiseCabs
//
//  Created by Nagraj G on 13/12/11.
//  Copyright 2011 TeamDecode Software Private limited Consulting Pvt Ltd. All rights reserved.
//

#import "SupplierDetails.h"


@implementation SupplierDetails
@synthesize supplierName;
@synthesize cabNumber;
@synthesize cabDriverName;
@synthesize cabDriverMobile;
@synthesize totalFarePayable;
@synthesize cabDriverNumber;

-(void)dealloc{
	[supplierName release];
	[cabNumber release];
	[cabDriverName  release];
	[cabDriverMobile release];
	[totalFarePayable release];
    [cabDriverNumber release];
	
	[super dealloc];
}
@end
