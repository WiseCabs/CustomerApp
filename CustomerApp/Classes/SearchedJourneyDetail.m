//
//  SearchedJourneyDetail.m
//  WiseCabs
//
//  Created by Nagraj on 08/05/13.
//
//

#import "SearchedJourneyDetail.h"
#import "ConfirmJourney.h"
#import "Common.h"

@interface SearchedJourneyDetail ()

@end

@implementation SearchedJourneyDetail
@synthesize lblDate,lblTime,lblPassengers,lblBags,lblSuppName,lblCabNumber,lblDriverName,lblFareValue,lblPickupAddress,lblDropAddress,lblPaymentType,lblVehicleType,scrollView,supplierView,waitView,updateProgressWebView,tableViewBackgroundImage;
@synthesize searchedJourney,journey;
@synthesize fare,distance,noOfPassengers,noOfBags,dropAddress,pickUpAddress,jnyDate,jnyTime,vehicleType,paymentType, journeyDict;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    	self.title=@"Results - Journey";
    scrollView.contentSize= CGSizeMake(320,455);
    
    lblDate.text= [NSString stringWithFormat:@"%@",self.jnyDate];
    lblTime.text= [NSString stringWithFormat:@"%@",self.jnyTime];
    lblPassengers.text= [NSString stringWithFormat:@"%@",self.noOfPassengers];
    lblBags.text= [NSString stringWithFormat:@"%@",self.noOfBags];
    //lblSuppName.text= [NSString stringWithFormat:@"%@",self.jnyDate];
    //lblCabNumber.text= [NSString stringWithFormat:@"%@",self.jnyDate];
    //lblDriverName.text= [NSString stringWithFormat:@"%@",self.jnyDate];
    
    Journey *jny=[[Journey alloc] init];
	lblFareValue.text= [NSString stringWithFormat:@"%@ - %@ %@",self.vehicleType,[jny currencySymbol] ,self.fare];
                        
    lblPickupAddress.text= [NSString stringWithFormat:@"%@",self.pickUpAddress];
    lblDropAddress.text= [NSString stringWithFormat:@"%@",self.dropAddress];
    NSLog(@"self.paymentType %@",self.paymentType);
    NSLog(@"self.paymentType %@",self.vehicleType);
    lblPaymentType.text=[NSString stringWithFormat:@"Payment:            %@",self.paymentType];
    //lblVehicleType.text=[NSString stringWithFormat:@"Vehicle:            %@",self.vehicleType];
    
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)jnyConfirmed:(id)sender{
    
    ConfirmJourney *confirmJourney= [[ConfirmJourney alloc] init];
    confirmJourney.fare=self.fare;
    confirmJourney.distance= self.distance;
    confirmJourney.noOfPassengers= self.noOfPassengers;
    confirmJourney.noOfBags= self.noOfBags;
    confirmJourney.dropAddress= self.dropAddress;
    confirmJourney.pickUpAddress= self.pickUpAddress;
    confirmJourney.vehicleType= self.vehicleType;
    confirmJourney.paymentType= self.paymentType;
    confirmJourney.jnyDate= self.jnyDate;
    confirmJourney.jnyTime= self.jnyTime;
    confirmJourney.journeyDict=self.journeyDict;
    
    [self.navigationController pushViewController:confirmJourney animated:YES];
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
}

-(IBAction)jnyCancelled:(id)sender
{
    /*[Common setToAddress:nil];
    [Common setFromAddress:nil];
    [Common setVehicleType:nil];
    [Common setPaymentType:nil];
    [Common setJourneyTimings:nil];*/
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) dealloc{
    
    [lblDate release];
    [lblTime release];
    [lblPassengers release];
    [lblBags release];
    [lblSuppName release];
    [lblCabNumber release];
    [lblDriverName release];
    [lblFareValue release];
    [lblPickupAddress release];
    [lblDropAddress release];
    [lblPaymentType release];
    [lblVehicleType release];
    [scrollView release];
    [supplierView release];
    [waitView release];
    [updateProgressWebView release];
    [tableViewBackgroundImage release];
    
    [fare release];
    [distance release];
    [noOfPassengers release];
    [noOfBags release];
    [dropAddress release];
    [pickUpAddress release];
    [jnyDate release];
    [jnyTime release];
    [vehicleType release];
    [paymentType release];
    [journeyDict release];
     [super dealloc];
}

@end
