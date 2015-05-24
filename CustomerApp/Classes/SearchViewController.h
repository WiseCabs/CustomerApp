//
//  SearchViewController.h
//  WiseCabs
//
//  Created by Nagraj on 19/12/12.
//
//

#import <UIKit/UIKit.h>
#import "CoreLocation.h"
#import "MBProgressHUD.h"
#import "MainViewController.h"

@interface SearchViewController : MainViewController<CoreLocationDelegate,MBProgressHUDDelegate>
{
    CoreLocation *locationController;
   
    IBOutlet UILabel *textFromAddress;
	IBOutlet UILabel *textToAddress;
    IBOutlet UIButton *buttonSearch;
    IBOutlet UIButton *buttonBagsPlus;
    IBOutlet UIButton *buttonBagsMinus;
    IBOutlet UIButton *buttonPassengersPlus;
    IBOutlet UIButton *buttonPassengersMinus;
    
    IBOutlet UILabel *labelBags;
    IBOutlet UILabel *labelPassengers;
    IBOutlet UILabel *labelVehicleType;
    IBOutlet UILabel *labelPaymentType;
    
    IBOutlet UISegmentedControl *segControlTime;
   
    NSInteger countBagNo;
    NSInteger countPassengerNo;   
    NSString *CameFromLoginPage;
    
    NSString *formattedTimeIn12Hour;
     NSString *formattedTimeIn24Hour;
    NSString *formattedDate;
    NSString *serviceDate;
    NSString *expanedDate;
    NSString *addressFromGeoCode;
    NSString *userpostCode;
    NSString *userAddress;
    NSString *latitude;
    NSString *longitude;
    
    MBProgressHUD *HUD;
}
@property(nonatomic, retain) NSString *latitude;
@property(nonatomic, retain) NSString *longitude;

@property(nonatomic, retain) NSString *CameFromLoginPage;
@property(nonatomic, readwrite) NSInteger countBagNo;
@property(nonatomic, readwrite) NSInteger countPassengerNo;

@property(nonatomic, retain) NSString *formattedTimeIn12Hour;
@property(nonatomic, retain) NSString *formattedTimeIn24Hour;
@property(nonatomic, retain) NSString *formattedDate;
@property(nonatomic, retain) NSString *serviceDate;
@property(nonatomic, retain) NSString *expanedDate;
@property(nonatomic, retain) NSString *addressFromGeoCode;
@property(nonatomic, retain) NSString *userpostCode;
@property(nonatomic, retain) NSString *userAddress;

@property(nonatomic, retain) IBOutlet UILabel *textFromAddress;
@property(nonatomic, retain) IBOutlet UILabel *textToAddress;
@property(nonatomic, retain) IBOutlet UIButton *buttonSearch;
@property(nonatomic, retain) IBOutlet UIButton *buttonBagsPlus;
@property(nonatomic, retain) IBOutlet UIButton *buttonBagsMinus;
@property(nonatomic, retain) IBOutlet UIButton *buttonPassengersPlus;
@property(nonatomic, retain) IBOutlet UIButton *buttonPassengersMinus;

@property(nonatomic,retain) IBOutlet UILabel *labelBags;
@property(nonatomic,retain) IBOutlet UILabel *labelPassengers;
@property(nonatomic,retain) IBOutlet UISegmentedControl *segControlTime;
@property(nonatomic,retain) IBOutlet UILabel *labelVehicleType;
@property(nonatomic,retain) IBOutlet UILabel *labelPaymentType;


- (IBAction)valueChanged:(id)sender;

-(IBAction) segmentValueChanged:(id)sender;

-(IBAction)buttonBagsPlus:(id)sender;
-(IBAction)buttonBagsMinus:(id)sender;
-(IBAction)buttonPassengersPlus:(id)sender;
-(IBAction)buttonPassengersMinus:(id)sender;
-(IBAction)buttonChangeVehicle:(id)sender;
-(IBAction)buttonChangePayment:(id)sender;

-(IBAction)searchJourney:(id)sender;
-(void)showProgress;

-(IBAction)jnyConfirmed:(id)sender;
-(IBAction)jnyCancelled:(id)sender;
-(void)convertToDateAndTime:(NSDate*) date;

-(void) showLoginPage;

@end
