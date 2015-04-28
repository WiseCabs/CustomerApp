//
//  SearchedJourneyDetail.h
//  WiseCabs
//
//  Created by Nagraj on 08/05/13.
//
//

#import <UIKit/UIKit.h>
#import "Journey.h"

@interface SearchedJourneyDetail : UIViewController<UIScrollViewDelegate>{
    IBOutlet UILabel *lblDate;
	IBOutlet UILabel *lblTime;
	IBOutlet UILabel *lblPassengers;
	IBOutlet UILabel *lblBags;
	
    IBOutlet UILabel *lblSuppName;
	IBOutlet UILabel *lblCabNumber;
	IBOutlet UILabel *lblDriverName;
	IBOutlet UILabel *lblFareValue;
	
    IBOutlet UILabel *lblPickupAddress;
	IBOutlet UILabel *lblDropAddress;
    
    IBOutlet UILabel *lblVehicleType;
    IBOutlet UILabel *lblPaymentType;
	
	IBOutlet UIScrollView *scrollView;
	Journey *searchedJourney;
	IBOutlet UIView *supplierView;
	IBOutlet UIView *waitView;
	
    IBOutlet UIWebView *updateProgressWebView;
	IBOutlet UIImageView *tableViewBackgroundImage;
	Journey *journey;
    
    NSString *fare;
    NSString *distance;
    NSString *noOfPassengers;
    NSString *noOfBags;
    NSString *dropAddress;
    NSString *pickUpAddress;
    NSString *jnyDate;
    NSString *jnyTime;
    NSString *vehicleType;
    NSString *paymentType;
    NSMutableDictionary *journeyDict;
}
@property(nonatomic, retain) IBOutlet UILabel *lblDate;
@property(nonatomic, retain) IBOutlet UILabel *lblTime;
@property(nonatomic, retain) IBOutlet UILabel *lblPassengers;
@property(nonatomic, retain) IBOutlet UILabel *lblBags;

@property(nonatomic, retain)  IBOutlet UILabel *lblSuppName;
@property(nonatomic, retain) IBOutlet UILabel *lblCabNumber;
@property(nonatomic, retain) IBOutlet UILabel *lblDriverName;
@property(nonatomic, retain)IBOutlet  UILabel *lblFareValue;

@property(nonatomic, retain) IBOutlet UILabel *lblPickupAddress;
@property(nonatomic, retain) IBOutlet UILabel *lblDropAddress;

@property(nonatomic, retain) IBOutlet UILabel *lblVehicleType;
@property(nonatomic, retain) IBOutlet UILabel *lblPaymentType;

@property(nonatomic, retain) Journey *searchedJourney;

@property(nonatomic, retain) IBOutlet UIView *supplierView;
@property(nonatomic, retain) IBOutlet UIView *waitView;

@property(nonatomic, retain) IBOutlet UIWebView *updateProgressWebView;
@property(nonatomic, retain) IBOutlet UIImageView *tableViewBackgroundImage;
@property(nonatomic, retain) Journey *journey;

@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property(nonatomic, retain) NSString *fare;
@property(nonatomic, retain) NSString *distance;
@property(nonatomic, retain) NSString *noOfPassengers;
@property(nonatomic, retain) NSString *noOfBags;
@property(nonatomic, retain) NSString *dropAddress;
@property(nonatomic, retain) NSString *pickUpAddress;
@property(nonatomic, retain) NSString *jnyDate;
@property(nonatomic, retain) NSString *jnyTime;
@property(nonatomic, retain) NSString *vehicleType;
@property(nonatomic, retain) NSString *paymentType;
@property(nonatomic, retain)  NSMutableDictionary *journeyDict;

-(IBAction)jnyConfirmed:(id)sender;
-(IBAction)jnyCancelled:(id)sender;

@end
