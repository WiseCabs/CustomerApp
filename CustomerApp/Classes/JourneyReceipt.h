//
//  OldjourneyDetails.h
//  JourneySearchApp
//
//  Created by Nagraj Gopalakrishnan on 05/12/11.
//  Copyright 2011 TeamDecode Software Private limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Journey.h"
#import "SupplierDetails.h"


@interface JourneyReceipt : UIViewController<UIActionSheetDelegate,UIAlertViewDelegate> {
	IBOutlet UILabel *DateLabel;
	IBOutlet UILabel *TimeLabel;
	IBOutlet UILabel *PassengersLabel;
	IBOutlet UILabel *BagsLabel;
	IBOutlet UILabel *GenderLabel;
	IBOutlet UILabel *CoPassengersLabel;
	IBOutlet UILabel *SupplierNameLabel;
	IBOutlet UILabel *CabNumberLabel;
	IBOutlet UILabel *CabDriverNameLabel;
	IBOutlet UILabel *FareValueLabel;
	IBOutlet UILabel *FareLabel;
	IBOutlet UILabel *thanksMessage;
	IBOutlet UILabel *pickupAddress;
	IBOutlet UILabel *lblDropAddress;
	IBOutlet UILabel *JourneyType;
    IBOutlet UILabel *lblVehicleType;
    IBOutlet UILabel *lblPaymentType;
    
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIButton *coPassengerDetailButton;
	BOOL isActionSheetOpened;
	float fareValue;
	UserJourney *userJourney;
	NSArray *CoPassengers;
	SupplierDetails *JourneySupplier;
	NSString *isParked;
	NSString *customerEmail;
	NSString *customerMobile;
	NSString *Currency;
	BOOL wasGuest;
	IBOutlet UIImageView *CoPassengerView;
	IBOutlet UIImageView *SupplierView;
	IBOutlet UILabel *labelBookingNo;
	BOOL ShowCoPassenger;
	NSInteger JourneyId;
	BOOL cameFromParkingTab;
	Journey *journey;
    
    NSString *fare;
    NSString *distance;
    NSString *noOfPassengers;
    NSString *noOfBags;
    NSString *pickUpAddress;
    NSString *journeyID;
    NSString *allocatedJnyID;
    NSString *jnyDate;
    NSString *jnyTime;
    NSString *vehicleType;
    NSString *paymentType;
    NSMutableDictionary *journeyDict;
}
@property (nonatomic, retain) Journey *journey;
@property(nonatomic,readwrite) NSInteger JourneyId;
@property (nonatomic, readwrite) BOOL cameFromParkingTab;
@property(nonatomic, readwrite) BOOL ShowCoPassenger;
@property(nonatomic, retain) IBOutlet UILabel *labelBookingNo;
@property(nonatomic, retain) IBOutlet UIImageView *CoPassengerView;
@property(nonatomic, retain) IBOutlet UIImageView *SupplierView;;
@property(nonatomic,readwrite) float fareValue;

//@property(nonatomic, retain) IBOutlet UIButton *actionSheetButton;
@property(nonatomic, retain) IBOutlet UILabel *DateLabel;
@property(nonatomic, retain) IBOutlet UILabel *TimeLabel;
@property(nonatomic, retain) IBOutlet UILabel *PassengersLabel;
@property(nonatomic, retain) IBOutlet UILabel *BagsLabel;
@property(nonatomic, retain) IBOutlet UILabel *GenderLabel;
@property(nonatomic, retain) IBOutlet UILabel *CoPassengersLabel;
@property(nonatomic, retain) IBOutlet UILabel *SupplierNameLabel;
@property(nonatomic, retain) IBOutlet UILabel *CabNumberLabel;
@property(nonatomic, retain) IBOutlet UILabel *CabDriverNameLabel;
@property(nonatomic, retain) IBOutlet UILabel *FareValueLabel;
@property(nonatomic, retain) IBOutlet UILabel *FareLabel;
@property(nonatomic, retain) IBOutlet UILabel *thanksMessage;
@property(nonatomic, retain) IBOutlet UILabel *pickupAddress;
@property(nonatomic, retain) IBOutlet UILabel *lblDropAddress;

@property(nonatomic, retain) IBOutlet UILabel *lblVehicleType;
@property(nonatomic, retain) IBOutlet UILabel *lblPaymentType;

@property(nonatomic, retain) IBOutlet UILabel *JourneyType;
@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) IBOutlet UIButton *coPassengerDetailButton;
@property(nonatomic, readwrite) BOOL isActionSheetOpened;
@property(nonatomic, readwrite) BOOL wasGuest;
@property(nonatomic, retain) UserJourney *userJourney;
@property(nonatomic, retain) NSArray *CoPassengers;
@property(nonatomic, retain) SupplierDetails *JourneySupplier;
@property(nonatomic, retain) NSString *isParked;
@property(nonatomic, retain) NSString *customerEmail;
@property(nonatomic, retain) NSString *customerMobile;
@property(nonatomic, retain) NSString *Currency;

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
@property(nonatomic, retain) NSMutableDictionary *journeyDict;


-(IBAction)ShowCoPassengerDetails:(id)sender;
-(void)setJourneyDetails;
@end
