//
//  BookingDetail.h
//  WiseCabs
//
//  Created by Nagraj on 31/12/12.
//
//

#import <UIKit/UIKit.h>
#import "Journey.h"
#import "RSTapRateView.h"

@interface BookingDetail : UIViewController<UIActionSheetDelegate,RSTapRateViewDelegate>{
    IBOutlet UILabel *lblDate;
    IBOutlet UILabel *lblTime;
    IBOutlet UILabel *lblPickUp;
    IBOutlet UILabel *lblDropOff;
    IBOutlet UILabel *lblSupplierName;
    IBOutlet UILabel *lblDriverName;
    IBOutlet UILabel *lblCabNo;
    IBOutlet UIButton *btnDriverMobile;
    IBOutlet UILabel *lblFare;
    IBOutlet UIScrollView *mainScrollView;
    IBOutlet UILabel *lbljnyStatus;
    IBOutlet UILabel *lblPassengers;
    IBOutlet UILabel *lblBags;
    IBOutlet UISegmentedControl *segControl;
    
    IBOutlet UIButton *btnRateJny;
    Journey *journey;
    NSString *journeyType;
    NSInteger ratedStar;
    
    NSMutableDictionary *fromPlaceDict;
    NSMutableDictionary *toPlaceDict;
    NSTimer *jnyStatusTimer;
    NSInteger favoriteValue;
}

@property(nonatomic, readwrite)  NSInteger favoriteValue;
@property(nonatomic, retain) NSTimer *jnyStatusTimer;
@property (nonatomic, retain) NSMutableDictionary *fromPlaceDict;
@property (nonatomic, retain) NSMutableDictionary *toPlaceDict;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segControl;
@property (nonatomic, retain) RSTapRateView *tapRateView;
@property (nonatomic, retain) NSString *journeyType;
@property(nonatomic,retain) IBOutlet UILabel *lblPassengers;
@property(nonatomic,retain) IBOutlet UILabel *lblBags;
@property(nonatomic,retain) IBOutlet UILabel *lblDate;
@property(nonatomic,retain) IBOutlet UILabel *lblTime;
@property(nonatomic,retain) IBOutlet UILabel *lblPickUp;
@property(nonatomic,retain) IBOutlet UILabel *lblDropOff;
@property(nonatomic,retain) IBOutlet UILabel *lblSupplierName;
@property(nonatomic,retain) IBOutlet UILabel *lblDriverName;
@property(nonatomic,retain) IBOutlet UILabel *lblCabNo;
@property(nonatomic,retain) IBOutlet UIButton *btnDriverMobile;
@property(nonatomic,retain) IBOutlet UIButton *btnRateJny;
@property(nonatomic,retain) IBOutlet UILabel *lblFare;
@property(nonatomic,retain) IBOutlet UILabel *lbljnyStatus;
@property(nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic, retain) Journey *journey;
@property(nonatomic, readwrite) NSInteger ratedStar;

-(IBAction)callDriver:(UIButton*)button;
-(IBAction)rateJnyAction:(UIButton*)button;
@end
