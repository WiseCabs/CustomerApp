//
//  BookingDetail.m
//  WiseCabs
//
//  Created by Nagraj on 31/12/12.
//
//

#import "BookingDetail.h"
#import "MapViewController.h"
#import "Common.h"
#import "Places.h"
#import "WebServiceHelper.h"
#import "WiseCabsAppDelegate.h"
#import "JourneyHelper.h"
#import "ALToastView.h"

@interface BookingDetail ()

@end

@implementation BookingDetail
@synthesize lblDate,lblTime,lblPickUp,lblDropOff,lblSupplierName,lblDriverName,lblCabNo,btnDriverMobile,lblFare,mainScrollView,journey,lbljnyStatus,lblPassengers,lblBags,journeyType,ratedStar,btnRateJny,segControl,fromPlaceDict,toPlaceDict,jnyStatusTimer,favoriteValue;

@synthesize tapRateView = _tapRateView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void) viewWillAppear:(BOOL)animated{
    self.jnyStatusTimer = [NSTimer scheduledTimerWithTimeInterval: 60.0 target: self selector:@selector(onTick:) userInfo: nil repeats:YES];

}
- (void)viewDidLoad
{
    /*UIColor *tintcolor=[UIColor blackColor];
    [[self.segControl. setTintColor:tintcolor];
    for (UIView *v in [[self.segControl objectAtIndex:i] subviews]) {
        if ([v isKindOfClass:[UILabel class]]) {
            UILabel *label=(UILabel *)[v retain];
            label.textColor=[UIColor whiteColor];
        }
    }*/
    
    
    
    self.navigationItem.title=@"Journey Detail";
    [mainScrollView setContentSize:mainScrollView.frame.size];
    
    if ([self.journeyType isEqualToString:@"Completed"])
    {
       // NSLog(@"self.journey.userJourney.journeyRating %d",self.journey.userJourney.journeyRating);
        if(self.journey.userJourney.journeyRating>0)
        {
             _tapRateView = [[RSTapRateView alloc] initWithFrame:CGRectMake(30, 445, 270, 50.f)];
            btnRateJny.hidden=YES;
            [_tapRateView setRating:self.journey.userJourney.journeyRating];
        }
        else{
             _tapRateView = [[RSTapRateView alloc] initWithFrame:CGRectMake(0, 445, 270, 50.f)];
            btnRateJny.hidden=NO;
            
        }
           
            _tapRateView.delegate = self;
            [self.view addSubview:_tapRateView];
            self.view.backgroundColor = [UIColor clearColor];
            mainScrollView.contentSize= CGSizeMake(320, 510);
            
        
        
    }
    else
    {
        mainScrollView.contentSize= CGSizeMake(320, 450);
        btnRateJny.hidden=YES;
    }
   
    UIButton *ActionSheetButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    //[button setTitle:@"Options" forState:UIControlStateNormal];
    [ActionSheetButton setImage:[UIImage imageNamed:@"ActionSheetIcon2.png"] forState:UIControlStateNormal];
    [ActionSheetButton addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    [ActionSheetButton setFrame:CGRectMake(0, 0, 32, 32)];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:ActionSheetButton] autorelease];
       
    if(journey!=NULL){
        NSString *jnyDate=[[journey userJourney] JourneyDate];
        NSLog(@"jnyDate is %@",jnyDate);
        
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        NSString *dateString=[NSString stringWithFormat:@"%@",jnyDate];
        
        NSDate* convertedDate = [formatter dateFromString:dateString];
        NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"EEE, d MMMM"];
        NSString *formatedDateString=[dateFormatter stringFromDate:convertedDate];
        
        lblDate.text=[NSString stringWithFormat:@"%@",formatedDateString];
        NSString *jnyTime=[[[journey userJourney] JourneyTime] uppercaseString];
        lblTime.text=[NSString stringWithFormat:@"%@",jnyTime];
        lblPickUp.text= [NSString stringWithFormat:@"%@",journey.userJourney.FromAddress.AddressText];
        lbljnyStatus.text= [NSString stringWithFormat:@"%@",journey.jnyStatus];
        lblDropOff.text= [NSString stringWithFormat:@"%@",journey.userJourney.ToAddress.AddressText];
        lblSupplierName.text= [NSString stringWithFormat:@"%@",journey.JourneySupplier.supplierName];
        lblDriverName.text= [NSString stringWithFormat:@"%@",journey.JourneySupplier.cabDriverName];
        lblCabNo.text= [NSString stringWithFormat:@"%@",journey.JourneySupplier.cabDriverNumber];
        lblBags.text= [NSString stringWithFormat:@"%d",journey.userJourney.NumberOfBags];
        lblPassengers.text= [NSString stringWithFormat:@"%d",journey.userJourney.NumberOfPassenger];
         lblFare.text= [NSString stringWithFormat:@"%@ %d",[journey currencySymbol],[[journey userJourney] Fare]];
        
         [btnDriverMobile setTitle:[NSString stringWithFormat:@"%@",journey.JourneySupplier.cabDriverMobile] forState:UIControlStateNormal];
        [btnDriverMobile addTarget:self action:@selector(callDriver:) forControlEvents:UIControlEventTouchUpInside];
                 
        self.favoriteValue=journey.userJourney.IsFavorite;
       
        
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)onTick:(NSTimer*) tm
{
    if ([Common isNetworkExist]) {
        [NSThread detachNewThreadSelector:@selector(getJnyStatus) toTarget: self withObject: nil];
    }
}

-(void)getJnyStatus{
	
	NSAutoreleasePool *statusActionPool=[[NSAutoreleasePool alloc] init];
    if ([Common isNetworkExist]>0)
	{
        WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
        NSObject *obj=[[NSObject alloc]init];
        servicehelper.objEntity=obj;
        [obj release];
        
        
        NSArray *sdkeys = [NSArray arrayWithObjects:@"ajID",nil];
        NSArray *sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",self.journey.alllocatedJnyID], nil];
        NSDictionary *sdParams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
        
       
        
        NSString *statusURL=[NSString stringWithFormat:@"%@search/journeystatus",[Common webserviceURL]];
        NSLog(@"service method get called");
        NSArray *resultArray=[servicehelper callWebService:statusURL pms:sdParams];
        
        
        if (resultArray!=nil) {
            
            NSDictionary *statusDict=[resultArray objectAtIndex:0];
            
            if([[statusDict objectForKey:@"success"] boolValue])
            {
                lbljnyStatus.text= [NSString stringWithFormat:@"%@",[statusDict objectForKey:@"JS_Mobile_Status"]];
                
            }
        }
    }
    [statusActionPool release];
}


#pragma mark -
#pragma mark RSTapRateViewDelegate

- (void)tapDidRateView:(RSTapRateView*)view rating:(NSInteger)rating {
    NSLog(@"Current rating: %i", rating);
    ratedStar=rating;
}

#pragma mark -
#pragma mark private

- (void)send:(id)object {
    UIAlertView *alertResult = [[UIAlertView alloc] initWithTitle:@"Thanks" message:[NSString stringWithFormat:@"You gave it %i-Stars rating!", self.tapRateView.rating] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertResult show];
    [alertResult release];
}


-(IBAction)showActionSheet:(UIButton*)button{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Take Action" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Quick Journey", nil];
    
    if([journey.jnyStatus isEqualToString:@"On Route"] || [journey.jnyStatus isEqualToString:@"Passenger On Board"])
     {
          
         [actionSheet addButtonWithTitle:@"Make Journey Favourite"];
         [actionSheet addButtonWithTitle:@"View Driver Location"];
         [actionSheet addButtonWithTitle:@"Cancel"];
         actionSheet.cancelButtonIndex = 3;
     }
    else{
        if (self.favoriteValue==0) {
            [actionSheet addButtonWithTitle:@"Make Journey Favourite"];
            [actionSheet addButtonWithTitle:@"Cancel"];
            actionSheet.cancelButtonIndex = 2;
        }
        else{
            [actionSheet addButtonWithTitle:@"Cancel"];
            actionSheet.cancelButtonIndex = 1;
        }
        
    }
    
    
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];
}



-(IBAction)callDriver:(UIButton*)button{
	
	NSString *mobile=[NSString stringWithFormat:@"tel://%@",journey.JourneySupplier.cabDriverMobile];
    NSLog(@"Mobile no is %@",mobile);
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mobile]];
	//}
}

-(IBAction)rateJnyAction:(UIButton*)button{
    if ([Common isNetworkExist]) {
        if (self.ratedStar>0) {
            [NSThread detachNewThreadSelector:@selector(rateJny) toTarget:self withObject:nil];
            NSLog(@"Jny rated out of 5 is %d",self.ratedStar);
        }
        else{
            [ALToastView toastInView:self.view withText:@"Select one or more stars."];
        }
        
    }
    else{
        [ALToastView toastInView:self.view withText:@"No Internet Connection"];
    }
    
}

-(void) rateJny{
    WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
    NSObject *obj=[[NSObject alloc]init];
    servicehelper.objEntity=obj;
    [obj release];
    
   // http://test.wisecabs.com/customer/custrating?jid=55758&rating=4
    
    NSArray *sdkeys = [NSArray arrayWithObjects:@"jid",@"rating",nil];
    NSArray *sdobjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",self.journey.JourneyID],[NSString stringWithFormat:@"%d",self.ratedStar], nil];
    NSDictionary *sdParams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
    
    
    
    NSString *statusURL=[NSString stringWithFormat:@"%@customer/custrating",[Common webserviceURL]];
    NSLog(@"service method get called");
    NSArray *resultArray=[servicehelper callWebService:statusURL pms:sdParams];
    
    
    if (resultArray!=nil) {
        
        NSDictionary *statusDict=[resultArray objectAtIndex:0];
        
        if([[statusDict objectForKey:@"success"] boolValue])
        {
            _tapRateView.frame = CGRectMake(30, 445, 270, 50.f);
            btnRateJny.hidden=YES;
            [_tapRateView setRating:self.ratedStar];
            [self performSelectorOnMainThread:@selector(showSuccessToast) withObject:nil waitUntilDone:YES];
        }

    }
}

-(void) showSuccessToast{
    [ALToastView toastInView:self.view withText:[NSString stringWithFormat:@"Journey rated as %d stars",self.ratedStar]];
}

-(void)setAddresses:(Journey *)jny{
    /*if ([jny.userJourney.FromAddress.PostalCode isEqualToString:@""]) {
        
        [self.fromPlaceDict placeDict setObject:places.placeId forKey:@"placeId"];
        [self.fromPlaceDict setObject:places.placeName forKey:@"placeName"];
        [self.fromPlaceDict setObject:jny.userJourney.FromAddress.PostalCode forKey:@"postCode"];
        [self.fromPlaceDict setObject: [self.placeType  lowercaseString] forKey:@"placeType"];
        [self.fromPlaceDict setObject:places.truncatedPlaceName forKey:@"truncatedPlaceName"];
    }
    else{
        
    }*/
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	//WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
	
        if (buttonIndex==0) {
            if ([Common isNetworkExist]>0)
            {
            self.fromPlaceDict=[[NSMutableDictionary alloc] init];
            self.toPlaceDict=[[NSMutableDictionary alloc] init];
            
            ////////////////////////// Setting FromAddress ///////////////////////////
            if ([journey.userJourney.FromAddress.placeType isEqualToString:@"City"]) {
                [self.fromPlaceDict setObject:@"0" forKey:@"placeId"];
                [self.fromPlaceDict setObject:journey.userJourney.FromAddress.AddressText forKey:@"placeName"];
                [self.fromPlaceDict setObject:journey.userJourney.FromAddress.PostalCode forKey:@"postCode"];
                [self.fromPlaceDict setObject: @"city" forKey:@"placeType"];
                
                [self.fromPlaceDict setObject:journey.userJourney.FromAddress.AddressText forKey:@"truncatedPlaceName"];

            }
            else{
                [self.fromPlaceDict setObject:journey.userJourney.FromAddress.placeID forKey:@"placeId"];
                [self.fromPlaceDict setObject:journey.userJourney.FromAddress.AddressText forKey:@"placeName"];
                [self.fromPlaceDict setObject:@"" forKey:@"postCode"];
                [self.fromPlaceDict setObject: journey.userJourney.FromAddress.placeType forKey:@"placeType"];
                NSString *truncatedName=[Common truncateAddress:journey.userJourney.FromAddress.AddressText];
                [self.fromPlaceDict setObject:truncatedName forKey:@"truncatedPlaceName"];

            }
////////////////////////// Setting ToAddress ///////////////////////////
            
            if ([journey.userJourney.ToAddress.placeType isEqualToString:@"City"]) {
                [self.toPlaceDict setObject:@"0" forKey:@"placeId"];
                [self.toPlaceDict setObject:journey.userJourney.ToAddress.AddressText forKey:@"placeName"];
                [self.toPlaceDict setObject:journey.userJourney.ToAddress.PostalCode forKey:@"postCode"];
                [self.toPlaceDict setObject: @"city" forKey:@"placeType"];
                [self.toPlaceDict setObject:journey.userJourney.ToAddress.AddressText forKey:@"truncatedPlaceName"];
                
            }
            else{
                [self.toPlaceDict setObject:journey.userJourney.ToAddress.placeID forKey:@"placeId"];
                [self.toPlaceDict setObject:journey.userJourney.ToAddress.AddressText forKey:@"placeName"];
                [self.toPlaceDict setObject:@"" forKey:@"postCode"];
                [self.toPlaceDict setObject: journey.userJourney.ToAddress.placeType forKey:@"placeType"];
                 NSString *truncatedName=[Common truncateAddress:journey.userJourney.ToAddress.AddressText];
                [self.toPlaceDict setObject:truncatedName forKey:@"truncatedPlaceName"];
                
            }

            [Common setFromAddress:self.fromPlaceDict];
            [Common setToAddress:self.toPlaceDict];
            
            WiseCabsAppDelegate *appDelegate = (WiseCabsAppDelegate *)[[UIApplication sharedApplication] delegate];           
            [appDelegate.maintabBarController setSelectedIndex:0];
            }
            else
            {
                [ALToastView toastInView:self.view withText:@"No Internet connection"];
            }
                      
        }
        else if (buttonIndex==1) {
            if (self.favoriteValue==0)
            {
            if ([Common isNetworkExist]>0)
            {
                JourneyHelper *helper=[[JourneyHelper alloc] init];
                NSLog(@" my JourneyID is %d",journey.JourneyID );
			
                if ([helper markAsFavourite:[NSString stringWithFormat:@"%d",journey.JourneyID]]) {
                //[Common showAlert:@"Favourite" message:@"Favourite Marked"];
                    [ALToastView toastInView:self.view withText:@"Journey marked as Favourite."];
                    self.favoriteValue=1;
                //actionSheetButton.hidden=YES;
                self.navigationItem.leftBarButtonItem=nil;
                
            }
            else
            {
                [ALToastView toastInView:self.view withText:@"Error in marking favourite."];
            }
            [helper release];                
        }
        else
        {
            [ALToastView toastInView:self.view withText:@"No Internet connection"];
        }
            }
            else{
                NSLog(@"Journey already marked as favorite.");
            }
        }
        else if (buttonIndex==2) {
            if ([Common isNetworkExist]>0)
            {
           
                if ([journey.jnyStatus isEqualToString:@"On Route"] || [journey.jnyStatus isEqualToString:@"Passenger On Board"]) {
                    MapViewController *mapViewController=[[MapViewController alloc] init];
                    mapViewController.journeyID=[NSString stringWithFormat:@"%d",journey.JourneyID];
                    mapViewController.driverNo=[NSString stringWithFormat:@"%@",lblCabNo.text];
                    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
                    [self.navigationController pushViewController:mapViewController animated:YES];
                    NSLog(@"journey id %d",journey.JourneyID);
                }      
            
            }
            else
            {
                [ALToastView toastInView:self.view withText:@"No Internet connection"];
            }
        
        }
        
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated{
    [jnyStatusTimer invalidate];
	jnyStatusTimer=nil;
}

-(void) dealloc{
    [segControl release];
    [journeyType release];
    [lblPassengers release];
    [lblBags release];
    [lblDate release];
    [lblTime release];
    [lblPickUp release];
    [lblDropOff release];
    [lblSupplierName release];
    [lblDriverName release];
    [lblCabNo release];
    [btnDriverMobile release];
    [lblFare release];
    [mainScrollView release];
    [journey release];
    [lbljnyStatus release];
    [fromPlaceDict release];
    [toPlaceDict release];
    [super dealloc];
}

@end
