//
//  CityAddress.h
//  WiseCabs
//
//  Created by Nagraj Gopalakrishnan on 12/12/11.
//  Copyright 2011 TeamDecode Software Private limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLHelper.h"
#import "Journey.h"
@interface ConfirmJourney : UIViewController <UIAlertViewDelegate> {
	IBOutlet UITextField *textFirstName;
	IBOutlet UITextField *textLastName;
	IBOutlet UITextField *textEmail;
	IBOutlet UITextField *textMobile;
	IBOutlet UIButton *buttonConfirm;
	IBOutlet UIScrollView *MainScrollView;
	IBOutlet UILabel *totalFare;
	IBOutlet UILabel *totalFareLabel;
	IBOutlet UILabel *ConfirmPriceLabel;
	IBOutlet UILabel *labelConfirmHelp;
	IBOutlet UILabel *labelBookingNo;
    IBOutlet UILabel *lblDate;
	IBOutlet UILabel *lblTime;
    
    
	//IBOutlet UILabel *labelBookingNoValue;
	BOOL isGuestUser;
	NSString *isParked;
	float fareValue;
	NSInteger JourneyId;
	BOOL cameFromParkingTab;
	Journey *journey;
	
    
    NSString *fare;
    NSString *distance;
    NSString *noOfPassengers;
    NSString *noOfBags;
    NSString *dropAddress;
    NSString *pickUpAddress;
    NSString *journeyID;
    NSString *allocatedJnyID;
    NSString *jnyDate;
    NSString *jnyTime;
    NSString *vehicleType;
    NSString *paymentType;
    NSMutableDictionary *journeyDict;

}
@property(nonatomic, retain) IBOutlet UILabel *lblDate;
@property(nonatomic, retain) IBOutlet UILabel *lblTime;

@property (nonatomic, retain) Journey *journey;
@property(nonatomic,readwrite) NSInteger JourneyId;
@property (nonatomic, readwrite) BOOL cameFromParkingTab;
@property(nonatomic, retain) IBOutlet UITextField *textFirstName;
@property(nonatomic,readwrite) float fareValue;
@property(nonatomic, retain) IBOutlet UITextField *textLastName;
@property(nonatomic, retain) IBOutlet UITextField *textEmail;
@property(nonatomic, retain) IBOutlet UITextField *textMobile;
@property(nonatomic, retain) IBOutlet UIButton *buttonConfirm;
@property(nonatomic, retain) IBOutlet UIScrollView *MainScrollView;
@property(nonatomic, retain) IBOutlet UILabel *totalFare;
@property(nonatomic, retain) IBOutlet UILabel *labelConfirmHelp;
@property(nonatomic, retain) IBOutlet UILabel *totalFareLabel;
@property(nonatomic, retain) IBOutlet UILabel *labelBookingNo;
@property(nonatomic, retain) IBOutlet UILabel *ConfirmPriceLabel;
//@property(nonatomic, retain)IBOutlet UILabel *labelBookingNoValue;
@property(nonatomic, readwrite) BOOL isGuestUser;
@property(nonatomic, retain)  NSString *isParked;
- (IBAction)textFieldReturn:(id)sender;
-(IBAction) buttonDoneTapped;

@property(nonatomic, retain) NSString *fare;
@property(nonatomic, retain) NSString *distance;
@property(nonatomic, retain) NSString *noOfPassengers;
@property(nonatomic, retain) NSString *noOfBags;
@property(nonatomic, retain) NSString *dropAddress;
@property(nonatomic, retain) NSString *pickUpAddress;
@property(nonatomic, retain) NSString *journeyID;
@property(nonatomic, retain) NSString *allocatedJnyID;
@property(nonatomic, retain) NSString *jnyDate;
@property(nonatomic, retain) NSString *jnyTime;
@property(nonatomic, retain) NSString *vehicleType;
@property(nonatomic, retain) NSString *paymentType;
@property(nonatomic, retain)  NSMutableDictionary *journeyDict;
@end
