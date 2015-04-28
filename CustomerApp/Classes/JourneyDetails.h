//
//  JourneyDetails.h
//  WiseCabs
//
//  Created by Nagraj Gopalakrishnan on 29/12/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Journey.h"

@interface JourneyDetails : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	IBOutlet UILabel *DateLabel;
	IBOutlet UILabel *TimeLabel;
	IBOutlet UILabel *PassengersLabel;
	IBOutlet UILabel *BagsLabel;
	//IBOutlet UILabel *GenderLabel;
	IBOutlet UILabel *CoPassengersLabel;
	IBOutlet UILabel *SupplierNameLabel;
	IBOutlet UILabel *CabNumberLabel;
	IBOutlet UILabel *CabDriverNameLabel;
	IBOutlet UILabel *FareValueLabel;
	IBOutlet UIImageView *ImageStar;
	IBOutlet UIImageView *ImageTableViewContanier;
	IBOutlet UITableView *COPassengersTableView;
	IBOutlet UIScrollView *MainScrollView;
	IBOutlet UIView *ViewDriverDetails;
	IBOutlet UIView *ViewTableView;
	Journey *journey;
	BOOL Isparked;
	NSInteger totalCopassenger;
}
@property(nonatomic, readwrite)NSInteger totalCopassenger;
@property(nonatomic, readwrite)BOOL Isparked;
@property(nonatomic, retain) IBOutlet UIView *ViewDriverDetails;
@property(nonatomic, retain) IBOutlet UIView *ViewTableView;
@property(nonatomic, retain) IBOutlet UILabel *DateLabel;
@property(nonatomic, retain) IBOutlet UIScrollView *MainScrollView;
@property(nonatomic, retain) IBOutlet UIImageView *ImageStar;
@property(nonatomic, retain) IBOutlet UIImageView *ImageTableViewContanier;
@property(nonatomic, retain) IBOutlet UILabel *TimeLabel;
@property(nonatomic, retain) IBOutlet UILabel *PassengersLabel;
@property(nonatomic, retain) IBOutlet UILabel *BagsLabel;
//@property(nonatomic, retain) IBOutlet UILabel *GenderLabel;
@property(nonatomic, retain) IBOutlet UILabel *CoPassengersLabel;
@property(nonatomic, retain) IBOutlet UILabel *SupplierNameLabel;
@property(nonatomic, retain) IBOutlet UILabel *CabNumberLabel;
@property(nonatomic, retain) IBOutlet UILabel *CabDriverNameLabel;
@property(nonatomic, retain) IBOutlet UILabel *FareValueLabel;
@property(nonatomic, retain) IBOutlet UITableView *COPassengersTableView;
@property (nonatomic, retain) Journey *journey;

@end
