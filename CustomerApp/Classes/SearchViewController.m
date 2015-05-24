//
//  SearchViewController.m
//  WiseCabs
//
//  Created by Nagraj on 19/12/12.
//
//

#import "SearchViewController.h"
#import "WiseCabsAppDelegate.h"
#import "LoginPage.h"
#import "Journey.h"
#import "UserJourney.h"
#import "Common.h"
#import "AddressSearchController.h"
#import "PickerViewController.h"
#import "LocationManager.h"
#import "Common.h"
#import "WebServiceHelper.h"
#import "SearchedJourneyDetail.h"
#import "ALToastView.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize CameFromLoginPage,textFromAddress,textToAddress,countBagNo,countPassengerNo;
@synthesize buttonSearch,buttonBagsPlus,buttonBagsMinus,buttonPassengersPlus,buttonPassengersMinus,labelBags,labelPassengers,segControlTime,labelVehicleType,labelPaymentType,formattedDate,formattedTimeIn12Hour,formattedTimeIn24Hour,serviceDate,addressFromGeoCode,userpostCode,userAddress,expanedDate;

@synthesize latitude,longitude;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animtated{
    
    NSLog(@"[[Common loggedInUser] suppID]-- %@",[[Common loggedInUser] suppID]);
    
    WiseCabsAppDelegate *appDelegate = (WiseCabsAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![Common isGuestUser]) {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(showLogoutPage:)  ] autorelease];
        UIViewController *myViewController1 = [appDelegate.maintabBarController.viewControllers objectAtIndex:1];
        [myViewController1 tabBarItem].enabled = TRUE;
        UIViewController *myViewController2 = [appDelegate.maintabBarController.viewControllers objectAtIndex:2];
        [myViewController2 tabBarItem].enabled = TRUE;
        UIViewController *myViewController3 = [appDelegate.maintabBarController.viewControllers objectAtIndex:3];
        [myViewController3 tabBarItem].enabled = TRUE;
        
    }
    else {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(showLoginPage:)  ] autorelease];
        UIViewController *myViewController1 = [appDelegate.maintabBarController.viewControllers objectAtIndex:1];
        [myViewController1 tabBarItem].enabled = FALSE;
        UIViewController *myViewController2 = [appDelegate.maintabBarController.viewControllers objectAtIndex:2];
        [myViewController2 tabBarItem].enabled = FALSE;
        UIViewController *myViewController3 = [appDelegate.maintabBarController.viewControllers objectAtIndex:3];
        [myViewController3 tabBarItem].enabled = FALSE;
        
        
    }
    
    UserJourney *journey =[[Journey searchedJourney] userJourney];
    NSLog(@"[Common fromAddress] %@",[Common fromAddress]);
     NSLog(@"[Common toAddress] %@",[Common toAddress]);
    if ([Common fromAddress]==nil) {
       // if([CLLocationManager locationServicesEnabled] &&
           //[CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)	{
        if ([Common isNetworkExist]) {
            if ([locationController.locationManager respondsToSelector:@selector
                 (requestWhenInUseAuthorization)]) {
                [locationController.locationManager requestWhenInUseAuthorization];
            }
            [locationController.locationManager startUpdatingLocation];
            textFromAddress.text=@"Finding current Location..";
            addressFromGeoCode=@"Yes";
            NSLog(@"Updating location");
        }
        else{
            addressFromGeoCode=@"No";
            NSLog(@"Not Updating location");
            //[locationController.locationManager stopUpdatingLocation];
        }
            
       // }
        //else {
            //[locationController.locationManager stopUpdatingLocation];
        //}
        
    }
    else{
        NSMutableDictionary *addressDict=[[Common fromAddress] mutableCopy];
        textFromAddress.text=[addressDict objectForKey:@"placeName"] ;
    }
    if ([Common toAddress]!=nil) {
        NSMutableDictionary *addressDict=[[Common toAddress]  mutableCopy];
        textToAddress.text=[addressDict objectForKey:@"placeName"];
    }
    if ([Common JourneyTimings]!=nil) {
        [self convertToDateAndTime:[Common JourneyTimings]];
        NSString *segmentText=[NSString stringWithFormat:@"%@  %@",self.formattedDate,self.formattedTimeIn12Hour];
        [segControlTime setTitle:segmentText forSegmentAtIndex:1];
        segControlTime.selectedSegmentIndex=1;
    }
    else{
        [segControlTime setTitle:@"Later-Click to specify" forSegmentAtIndex:1];
        segControlTime.selectedSegmentIndex=0;
        NSDate *currentDate=[NSDate date];
        NSDate *dateAheadby15Mins = [currentDate dateByAddingTimeInterval:15*60];
        [self convertToDateAndTime:dateAheadby15Mins];
       
    }
    if ([Common vehicleType]!=nil) {
        labelVehicleType.text=[Common vehicleType];
    }
    if ([Common paymentType]!=nil) {
        labelPaymentType.text=[Common paymentType];
        NSLog(@"[common vehicleType is %@", [Common paymentType]);
    }
    //64 bit changes
	NSLog(@"self.navigationController.viewControllers %lu",(unsigned long)[self.navigationController.viewControllers count]);
	//self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetPage:)  ] autorelease];
    
	NSLog(@"from address is :-%@",[[journey FromAddress] AddressText]);
	NSLog(@"to address is :-%@",[[journey ToAddress] AddressText]);
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
	
	appDelegate.maintabBarController.tabBar.hidden=NO;
	self.navigationItem.hidesBackButton = NO;
   
	
	
}



- (void)viewDidLoad
{
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            
        }
        if(result.height == 568)
        {
//            self.textFromAddress.frame = CGRectMake(62, 21, 202, 38);
//            self.textToAddress.frame = CGRectMake(62, 90, 202, 38);
            self.segControlTime.frame = CGRectMake(10, 158, 300, 38);
        }
    }
    
    
    buttonPassengersMinus.enabled=NO;
	buttonBagsMinus.enabled=NO;
	buttonPassengersPlus.enabled=YES;
	buttonBagsPlus.enabled=YES;
	countBagNo=0;
	countPassengerNo=1;
	labelBags.text = [NSString stringWithFormat:@"%i", (int)countBagNo];
	labelPassengers.text = [NSString stringWithFormat:@"%i", (int)countPassengerNo];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeVehicle)];
    self.labelVehicleType.userInteractionEnabled = YES;
    [self.labelVehicleType addGestureRecognizer:tap];
        
//    [textFromAddress addTarget:self action:@selector(textFieldBecameActive:) forControlEvents:UIControlEventEditingDidBegin];
//    [textToAddress addTarget:self action:@selector(textFieldBecameActive:) forControlEvents:UIControlEventEditingDidBegin];
    
    self.title=@"Quote and Book";
    self.navigationItem.title=@"ABBA CARS";
    WiseCabsAppDelegate *appDelegate = (WiseCabsAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.maintabBarController.tabBar.hidden=NO;
	self.navigationItem.hidesBackButton = NO;
    
	//WiseCabsAppDelegate *appDelegate = (WiseCabsAppDelegate *)[[UIApplication sharedApplication] delegate];
	if ([self.CameFromLoginPage isEqualToString:@"Yes"] || [self.CameFromLoginPage isEqualToString:@"Yes1"] )
	{		appDelegate.maintabBarController.tabBar.hidden=NO;
		CGRect newFrame = appDelegate.maintabBarController.view.frame;
		newFrame.size.height -= appDelegate.maintabBarController.tabBar.frame.size.height;
		appDelegate.maintabBarController.view.frame = newFrame;
	}
	
    
    
    locationController = [[CoreLocation alloc] init];
    locationController.delegate = self;
	locationController.locationManager.distanceFilter=1;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



-(IBAction)showLogoutPage:(id)sender{
	NSLog(@"User is logged in");
	UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	[logoutAlert addButtonWithTitle:@"Yes"];
	[logoutAlert addButtonWithTitle:@"No"];
	logoutAlert.cancelButtonIndex = 1;
	[logoutAlert show];
	[logoutAlert release];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	/*if (alertView==dateAlert) {
		if (buttonIndex==0) {
			[self.textDate becomeFirstResponder];
		}
	}
	else {*/
		if (buttonIndex==0) {
			[self logOutUser];
		}
	//}
}

-(void)logOutUser{
	if ([Common isNetworkExist]>0)
	{
        [Journey deallocJourney];
		[Common setLoggedInUser:nil];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(showLoginPage:)  ] autorelease];
        WiseCabsAppDelegate *appDelegate = (WiseCabsAppDelegate *)[[UIApplication sharedApplication] delegate];
        UIViewController *myViewController1 = [appDelegate.maintabBarController.viewControllers objectAtIndex:1];
        [myViewController1 tabBarItem].enabled = FALSE;
        UIViewController *myViewController2 = [appDelegate.maintabBarController.viewControllers objectAtIndex:2];
        [myViewController2 tabBarItem].enabled = FALSE;
        UIViewController *myViewController3 = [appDelegate.maintabBarController.viewControllers objectAtIndex:3];
        [myViewController3 tabBarItem].enabled = FALSE;
		[self showLogin];
		
	}
	else {
		[Common showNetwokAlert];
	}
    
}
-(void) showLogin{
    
    LoginPage *loginPage;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            loginPage= [[LoginPage alloc] initWithNibName:@"LoginPage" bundle:nil];
        }
        if(result.height == 568)
        {
            loginPage= [[LoginPage alloc] initWithNibName:@"LoginPage@iPhone5" bundle:nil];
        }
    }
    
    
	//[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
    // [self.navigationController presentModalViewController:loginPage YES];
    [self.navigationController presentViewController:loginPage
                                            animated:YES
                                          completion:nil];
    
}


-(IBAction)showLoginPage:(id)sender {
    [self showLogin];
}
   

-(IBAction)buttonChangePayment:(id)sender{
    PickerViewController *pickerViewController=[[PickerViewController alloc]init];
    pickerViewController.myparentIs=@"lblPaymentType";
    [self.navigationController pushViewController:pickerViewController animated:YES];
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
}

-(IBAction)buttonChangeVehicle:(id)sender{
    [self changeVehicle];
}


-(void)changeVehicle{
    PickerViewController *pickerViewController=[[PickerViewController alloc]init];
    pickerViewController.myparentIs=@"lblVehicleType";
    [self.navigationController pushViewController:pickerViewController animated:YES];
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
}


- (void)locationUpdate:(CLLocation *)loc {
	
    //CLLocation *loc = [[CLLocation alloc] initWithLatitude:51.50754 longitude:-0.13244];
	self.latitude=[NSString stringWithFormat:@"%f", loc.coordinate.latitude];
	self.longitude=[NSString stringWithFormat:@"%f", loc.coordinate.longitude];
    
    //////////////////////////////////////////////////////////////Sending Driver Location/////////////////////////////////////////////
    if (self.latitude == (id)[NSNull null] || self.latitude.length == 0 ){
	}
	else
	{
        
        CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
        [geocoder reverseGeocodeLocation:loc
                       completionHandler:^(NSArray *placemarks, NSError *error) {
                           NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
                           
                           if (error){
                               NSLog(@"Geocode failed with error: %@", error);
                               return;
                               
                           }
                           
                           if(placemarks && placemarks.count > 0)
                               
                           {
                               //do something
                               self.userAddress=@"";
                               self.userpostCode=@"";
                               CLPlacemark *topResult = [placemarks objectAtIndex:0];
                               self.userAddress= [NSString stringWithFormat:@"%@, %@",[topResult subLocality],[topResult locality]];
                               NSLog(@"userAddress--%@",self.userAddress);
                              [NSThread detachNewThreadSelector:@selector(setuserLocation) toTarget:self withObject:nil];
                              // NSString *addressTxt = [NSString stringWithFormat:@"%@, %@, %@",                                                       [topResult   postalCode],[topResult subLocality],[topResult locality]];
                              // NSLog(@"%@",addressTxt);
                               
                               /*self.userpostCode=[NSString stringWithFormat:@"%@",[topResult   postalCode]];
                               NSLog(@"lat is %@    nad long is   %@",latitude,longitude);
                               textFromAddress.text=[NSString stringWithFormat:@"%@",addressTxt];
                               self.addressFromGeoCode=@"Yes";
                               
                               NSMutableDictionary *placeDict=[[NSMutableDictionary alloc] init];
                               [placeDict setObject:@"0" forKey:@"placeId"];
                               [placeDict setObject:self.userAddress forKey:@"placeName"];
                               [placeDict setObject:[topResult postalCode] forKey:@"postCode"];
                               [placeDict setObject: @"city" forKey:@"placeType"];
                               [placeDict setObject:self.userAddress forKey:@"truncatedPlaceName"];
                               [Common setFromAddress:placeDict];*/
                               
                               
                           }
                       }];
    }

}

-(void)setuserLocation{
   
    WebServiceHelper *serviceHelper=[[WebServiceHelper alloc] init];
    NSObject *nsObject= [[NSObject alloc] init];
    serviceHelper.objEntity=nsObject;
    [nsObject release];
    NSString *latlng=[NSString stringWithFormat:@"%@,%@",self.latitude,self.longitude];
    
    NSArray *sdkeys = [NSArray arrayWithObjects:@"latlng",@"sensor",nil];
    NSArray *sdobjects = [NSArray arrayWithObjects:latlng,@"false", nil];
    NSDictionary *sdParams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
    
//http://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&sensor=true_or_false

    NSString *locationURL=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@&sensor=%@",latlng,@"false"];
    NSArray *resArray=[serviceHelper callWebService:locationURL pms:nil];
    NSDictionary *resultDict=[ resArray objectAtIndex:0];
    
    if ([[resultDict objectForKey:@"status"] isEqualToString:@"OK"])
    {
        NSArray *resultArray= [resultDict objectForKey:@"results"];
        //NSDictionary *firstDict= [resultArray objectAtIndex:0];
        //NSArray *firstDictArray=[firstDict objectForKey:@"address_components"];
        
        
        NSDictionary *secondDict= [resultArray objectAtIndex:1];        
        NSArray *secondDictArray=[secondDict objectForKey:@"address_components"];
        for (int i=0; i<=[secondDictArray count]-1; i++) {
            NSDictionary *addressComponentDict= [secondDictArray objectAtIndex:i];
            NSLog(@"addressComponentDict-----%@ ",[[addressComponentDict objectForKey:@"types"] description]);
            //NSString *myArrayString = [array description];
             if ([[[addressComponentDict objectForKey:@"types"] description] rangeOfString:@"postal_code"].location == NSNotFound) {
            }
             else{
                 self.userpostCode = [addressComponentDict objectForKey:@"long_name"];

             }
        }
        NSLog(@"userAddress--%@",self.userAddress);
        self.userAddress = [NSString stringWithFormat:@"%@, %@",self.userAddress,self.userpostCode];
        self.textFromAddress.text=[NSString stringWithFormat:@"%@",self.userAddress];
         NSLog(@"userAddress--%@",self.userAddress);
        NSLog(@"userpostCode--%@",self.userpostCode);
       
        
    }
    
    
    /*self.userpostCode=[NSString stringWithFormat:@"%@",[topResult   postalCode]];
    self.userAddress= [NSString stringWithFormat:@"%@, %@",[topResult subLocality],[topResult locality]];
    NSLog(@"lat is %@    nad long is   %@",latitude,longitude);
    textFromAddress.text=[NSString stringWithFormat:@"%@",addressTxt];*/
    self.addressFromGeoCode=@"Yes";
    
    NSMutableDictionary *placeDict=[[NSMutableDictionary alloc] init];
    [placeDict setObject:@"0" forKey:@"placeId"];
    [placeDict setObject:self.userAddress forKey:@"placeName"];
    [placeDict setObject:self.userpostCode forKey:@"postCode"];
    [placeDict setObject: @"city" forKey:@"placeType"];
    [placeDict setObject:self.userAddress forKey:@"truncatedPlaceName"];
    [Common setFromAddress:placeDict];
    self.textFromAddress.text=[NSString stringWithFormat:@"%@, %@",self.userAddress,self.userpostCode];
    
}

- (void)locationError:(NSError *)error {
	//NSString *errorString=[NSString stringWithFormat:@"%@",[error description]];
	//[ALToastView toastInView:self.view withText:errorString];
}


-(void)convertToDateAndTime:(NSDate*) date{
  //  NSDate *currentDate=[NSDate date];
    //NSDate *dateAheadby15Mins = [mydate dateByAddingTimeInterval:15*60];
    
       
    
    NSDateFormatter *serviceDateFormat = [[NSDateFormatter alloc] init];
    [serviceDateFormat setDateFormat:@"yyyy-MM-dd"];
    self.serviceDate= [serviceDateFormat stringFromDate:date];
    
    NSDateFormatter *timeFormatIn24 = [[NSDateFormatter alloc] init];
    [timeFormatIn24 setDateFormat:@"HH:mm"];
    self.formattedTimeIn24Hour= [timeFormatIn24 stringFromDate:date];
    
    NSDateFormatter *timeFormatIn12 = [[NSDateFormatter alloc] init];
    [timeFormatIn12 setDateFormat:@"hh:mm a"];
    self.formattedTimeIn12Hour = [timeFormatIn12 stringFromDate:date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd"];
    self.formattedDate= [dateFormat stringFromDate:date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, d MMMM"];
    self.expanedDate= [dateFormatter stringFromDate:date];
    
    NSLog(@"self,date  %@",self.formattedDate);
    NSLog(@"self,formattedTimeIn24Hour  %@",self.formattedTimeIn24Hour);
    NSLog(@"self,formattedTimeIn12Hour  %@",self.formattedTimeIn12Hour);
    
    [timeFormatIn12 release];
    [timeFormatIn24 release];
    [dateFormat release];
    [dateFormatter release];
    

}

- (IBAction)valueChanged:(UISegmentedControl*)sender{
    
  /*  for (int i=0; i<[sender.subviews count]; i++)
    {
        if ([[sender.subviews objectAtIndex:i]isSelected] )
        {
            UIColor *tintcolor=[UIColor colorWithRed:127.0/255.0 green:161.0/255.0 blue:183.0/255.0 alpha:1.0];
            [[sender.subviews objectAtIndex:i] setTintColor:tintcolor];
            break;
        }
    }*/
    
    
    
    UISegmentedControl *segmentedControl = (UISegmentedControl*) sender;
    switch ([segmentedControl selectedSegmentIndex]) {
        case 0:
            NSLog(@"segment 0 selected");
            [segControlTime setTitle:@"Later-Click to specify" forSegmentAtIndex:1];
            NSDate *currentDate=[NSDate date];
            NSDate *dateAheadby15Mins = [currentDate dateByAddingTimeInterval:15*60];
            [self convertToDateAndTime:dateAheadby15Mins];
            
            [[sender.subviews objectAtIndex:0] setTintColor:[UIColor whiteColor]];
            [[sender.subviews objectAtIndex:1] setTintColor:[UIColor blackColor]];
            for (UIView *v in [[[sender subviews] objectAtIndex:0] subviews]) {
                if ([v isKindOfClass:[UILabel class]]) {
                    UILabel *lable=(UILabel *)[v retain];
                    lable.textColor=[UIColor grayColor];
                }
            }
            for (UIView *v in [[[sender subviews] objectAtIndex:1] subviews]) {
                if ([v isKindOfClass:[UILabel class]]) {
                    UILabel *lable=(UILabel *)[v retain];
                    lable.textColor=[UIColor whiteColor];
                }
            }
            
            break;
        case 1:
        {
            [[sender.subviews objectAtIndex:0] setTintColor:[UIColor blackColor]];
            [[sender.subviews objectAtIndex:1] setTintColor:[UIColor whiteColor]];
            
            for (UIView *v in [[[sender subviews] objectAtIndex:0] subviews]) {
                if ([v isKindOfClass:[UILabel class]]) {
                    UILabel *lable=(UILabel *)[v retain];
                    lable.textColor=[UIColor whiteColor];
                }
            }
            for (UIView *v in [[[sender subviews] objectAtIndex:1] subviews]) {
                if ([v isKindOfClass:[UILabel class]]) {
                    UILabel *lable=(UILabel *)[v retain];
                    lable.textColor=[UIColor grayColor];
                }
            }

            
            
            PickerViewController *pickerViewController=[[PickerViewController alloc]init];
            pickerViewController.myparentIs=@"segControlTime";
            [self.navigationController pushViewController:pickerViewController animated:YES];
            self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
            NSLog(@"segment 1 selected");
        }
            break;
        case UISegmentedControlNoSegment:
            // do something
            
            break;
        default:
            NSLog(@"No option for: %ld", (long)[segmentedControl selectedSegmentIndex]);    //64 bit changes
    }
}

/*-(IBAction) segmentValueChanged:(id)sender{
    if(segControlTime.selectedSegmentIndex == 0){
        
    }
    else{
        PickerViewController *pickerViewController=[[PickerViewController alloc]init];
        pickerViewController.myparentIs=@"segControlTime";
        [self.navigationController pushViewController:pickerViewController animated:YES];
    }
}*/

-(IBAction)buttonBagsPlus:(id)sender{
	countBagNo=countBagNo+1;
	
    labelBags.text = [NSString stringWithFormat:@"%i", (int)countBagNo];
	if (countBagNo==10) {
		buttonBagsPlus.enabled=NO;
	}
	else {
		buttonBagsMinus.enabled=YES;
	}
	
}
-(IBAction)buttonBagsMinus:(id)sender{
    
    //NSString *suppID=[[Common loggedInUser] suppID];
    NSLog(@"suppID is %@",[[Common loggedInUser] suppID]);
    // NSLog(@"suppID is %@",[[Common loggedInUser] Email]);
	countBagNo=countBagNo-1;
	
    labelBags.text = [NSString stringWithFormat:@"%i", (int)countBagNo];
	if (countBagNo==0) {
		buttonBagsMinus.enabled=NO;
	}
	else {
		buttonBagsPlus.enabled=YES;
	}
}
-(IBAction)buttonPassengersPlus:(id)sender
{
	countPassengerNo=countPassengerNo+1;
	
    labelPassengers.text = [NSString stringWithFormat:@"%i", (int)countPassengerNo];
	
        if (countPassengerNo==10) {
            buttonPassengersPlus.enabled=NO;
        }
        else {
            buttonPassengersMinus.enabled=YES;
        }
	
		if (countPassengerNo==5) {
			buttonPassengersPlus.enabled=NO;
		}
		else {
			buttonPassengersMinus.enabled=YES;
		
	}
}
-(IBAction)buttonPassengersMinus:(id)sender
{
	NSLog(@"countPassengerNo is: %ld",(long)countPassengerNo);      //64 bit changes
	countPassengerNo=countPassengerNo-1;
	
    labelPassengers.text = [NSString stringWithFormat:@"%i", (int)countPassengerNo];
	if (countPassengerNo==1) {
		buttonPassengersMinus.enabled=NO;
	}
	else {
		buttonPassengersPlus.enabled=YES;
	}
	
}


//- (IBAction)textFieldBecameActive:(id)sender{
//    AddressSearchController *addressController=[[AddressSearchController alloc] init];
//    
//    if (self.textFromAddress.isFirstResponder) {
//        // [self.textFromAddress resignFirstResponder];
//        addressController.myParentIS=@"From Address";
//    }
//    else{
//        // [self.textToAddress resignFirstResponder];
//        addressController.myParentIS=@"To Address";
//    }
//    
//    [self.navigationController pushViewController:addressController animated:YES];
//    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
//   // [addressController release];
//}



-(IBAction)ButtonToTapped:(id)sender
{
    AddressSearchController *addressController=[[AddressSearchController alloc] init];
    addressController.myParentIS=@"To Address";
    [self.navigationController pushViewController:addressController animated:YES];
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
   // [addressController release];
	
}
-(IBAction)ButtonFromTapped:(id)sender
{
    AddressSearchController *addressController=[[AddressSearchController alloc] init];
    addressController.myParentIS=@"From Address";
    [self.navigationController pushViewController:addressController animated:YES];
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
   // [addressController release];
	
	
}

-(void)showProgress{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText=@"Searching..";
	//hud.detailsLabelText=@"Updating";
	hud.square=YES;
	[pool release];
}


-(IBAction)searchJourney:(id)sender
{
    NSLog(@"self,date  %@",self.formattedDate);
    NSLog(@"self,formattedTimeIn24Hour  %@",self.formattedTimeIn24Hour);
     NSLog(@"self,formattedTimeIn12Hour  %@",self.formattedTimeIn12Hour);
    NSMutableDictionary *fromAddressDict=[[Common fromAddress] mutableCopy];
    NSMutableDictionary *toAddressDict=[[Common toAddress] mutableCopy];
    
    if (![textFromAddress.text isEqualToString:@""] && ![textToAddress.text isEqualToString:@""] && countPassengerNo>0 ) {
        if([[fromAddressDict objectForKey:@"placeName"] isEqualToString:[toAddressDict objectForKey:@"placeName"]])
        {
            [ALToastView toastInView:self.view withText:@"Pick-up and drop address can't be same."];
        }
        else{
            NSLog(@"[fromAddressDict placeType]  %@",[fromAddressDict objectForKey:@"placeType"] );
            
                          
                [NSThread detachNewThreadSelector:@selector(searchJny) toTarget: self withObject: nil];
                   }
        
    }
    else{
       [ALToastView toastInView:self.view withText:@"Please enter all details."];
    }
}



-(void) searchJny{
    NSAutoreleasePool *actionPool=[[NSAutoreleasePool alloc] init];
    [NSThread detachNewThreadSelector:@selector(showProgress) toTarget: self withObject: nil];
    WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
    NSObject *obj=[[NSObject alloc]init];
    servicehelper.objEntity=obj;
    [obj release];
    
  //  NSArray *sdkeys = [NSArray arrayWithObjects:@"srcFrom", @"dstFrom,"@"srcPostcode",@"dstPostcode",@"src",@"dst",@"supId",@"noOfBag",@"noOfPassenger",@"date",@"time",@"srcId",@"dstId",@"vehicleType",nil];
  
    NSString *supplierID;
    if ([[Common loggedInUser] suppID]==nil) {
        supplierID=@"228";
    }
    else{
        supplierID=[[Common loggedInUser] suppID];
    }
    NSLog(@"supplierid is------%@",supplierID);
    
    NSMutableDictionary *fromAddressDict=[[Common fromAddress] mutableCopy];
    
    NSMutableDictionary *toAddressDict=[[Common toAddress] mutableCopy];
    
    
    NSString *toPlaceKeyName;
    NSString *fromPlaceKeyName;
    
    if ([[fromAddressDict objectForKey:@"placeType"] isEqualToString:@"city" ]) {
       fromPlaceKeyName=@"srcStreetName";
    }
    else{
         fromPlaceKeyName=@"src";
    }
    
    if ([[toAddressDict objectForKey:@"placeType"] isEqualToString:@"city"] ) {
       toPlaceKeyName=@"dstStreetName";
    }
    else{
        toPlaceKeyName=@"dst";
    }
    
      NSArray *sdkeys = [NSArray arrayWithObjects:@"srcFrom",@"dstFrom",@"srcPostcode",@"dstPostcode",fromPlaceKeyName,toPlaceKeyName,@"supId",@"noOfBag",@"noOfPassenger",@"date",@"time",@"srcId",@"dstId",@"vehicleType", nil];

   /* srcFrom=city&
    supId=1&
    dstFrom=city&
    srcPostcode=CM0%207BT&
    dstPostcode=W5%201AG&
    vehicleType=Saloon&
    srcStreetName=Whitby%20Road,%20Southminster,%20Essex&
    dstStreetName=Brunswick%20Road,%20Ealing,%20London*/
    
    NSArray *dictKeys=[NSArray arrayWithObjects:@"srcFrom",@"dstFrom",@"srcPostcode",@"dstPostcode",fromPlaceKeyName,toPlaceKeyName,@"supId",@"srcId",@"dstId",@"vehicleType", nil];
    
     NSArray *dictValues=[NSArray arrayWithObjects:[fromAddressDict objectForKey:@"placeType"],[toAddressDict objectForKey:@"placeType"],[fromAddressDict objectForKey:@"postCode"],[toAddressDict objectForKey:@"postCode"],[fromAddressDict objectForKey:@"truncatedPlaceName"],[toAddressDict objectForKey:@"truncatedPlaceName"],supplierID,[fromAddressDict objectForKey:@"placeId"],[toAddressDict objectForKey:@"placeId"],labelVehicleType.text, nil];
    
    NSArray *sdobjects = [NSArray arrayWithObjects:[fromAddressDict objectForKey:@"placeType"],[toAddressDict objectForKey:@"placeType"],[fromAddressDict objectForKey:@"postCode"],[toAddressDict objectForKey:@"postCode"],[fromAddressDict objectForKey:@"truncatedPlaceName"],[toAddressDict objectForKey:@"truncatedPlaceName"],supplierID,[NSString stringWithFormat:@"%ld",(long)countBagNo],[NSString stringWithFormat:@"%ld",(long)countPassengerNo],self.serviceDate,self.formattedTimeIn24Hour,[fromAddressDict objectForKey:@"placeId"],[toAddressDict objectForKey:@"placeId"],labelVehicleType.text, nil];        //64 bit changes

    NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
     NSDictionary *serviceParams = [NSDictionary dictionaryWithObjects:dictValues forKeys:dictKeys];
   
    NSArray *searchedJourneyArray=[servicehelper callWebService:[NSString stringWithFormat:@"%@search/calculatefare",[Common webserviceURL]] pms:serviceParams];
    NSDictionary *resultDict= [[NSDictionary alloc] init];
    resultDict= [searchedJourneyArray objectAtIndex:0];
    if ([resultDict objectForKey:@"IsFareCalculated"]) {
        SearchedJourneyDetail *seachedJourneyDetails= [[SearchedJourneyDetail alloc] init];
        
        NSString *fare=[resultDict objectForKey:@"Fare"];
        //NSArray *arrayWithTwoStrings = [fare componentsSeparatedByString:@"."];

        //seachedJourneyDetails.fare=[arrayWithTwoStrings objectAtIndex:0];
        seachedJourneyDetails.fare=[NSString stringWithFormat:@"%@",fare];
        seachedJourneyDetails.distance=[resultDict objectForKey:@"Distance"];
        seachedJourneyDetails.noOfPassengers=[NSString stringWithFormat:@"%ld",(long)countPassengerNo];     //64 bit changes
        seachedJourneyDetails.noOfBags=[NSString stringWithFormat:@"%ld",(long)countBagNo];     //64 bit changes
        seachedJourneyDetails.dropAddress=textToAddress.text;
        seachedJourneyDetails.pickUpAddress= textFromAddress.text;
        seachedJourneyDetails.vehicleType= labelVehicleType.text;
        seachedJourneyDetails.paymentType= labelPaymentType.text;
        seachedJourneyDetails.jnyDate=self.expanedDate;
        seachedJourneyDetails.jnyTime=self.formattedTimeIn12Hour;
        seachedJourneyDetails.journeyDict=[sdparams mutableCopy];
        
        [self.navigationController pushViewController:seachedJourneyDetails animated:YES];
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
    }
    else{
        NSLog(@"reset journey Details");
        [self performSelectorOnMainThread:@selector(searchAnotherAddress) withObject:nil waitUntilDone:NO];    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [actionPool release];
}


-(void) searchAnotherAddress{
    [ALToastView toastInView:self.view withText:@"Please select other Address."]; 
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
//    if (self.textFromAddress.isFirstResponder) {
//        [self.textFromAddress resignFirstResponder];
//    }
//    else{
//        [self.textToAddress resignFirstResponder];
//    }
    [locationController.locationManager stopUpdatingLocation];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [buttonSearch release];
    [buttonBagsPlus release];
    [buttonBagsMinus release];
    [buttonPassengersPlus release];
    [buttonPassengersMinus release];
    [labelBags release];
    [labelPassengers release];
	[CameFromLoginPage release];
    [segControlTime release];
    [labelVehicleType release];
    [labelPaymentType release];
    [formattedDate release];
    [formattedTimeIn12Hour release];
    [formattedTimeIn24Hour release];
    [serviceDate release];
    [addressFromGeoCode release];
    [userAddress release];
    [userpostCode release];
    [expanedDate release];
    
    [latitude release];
    [longitude release];
    [super dealloc];
}



@end
