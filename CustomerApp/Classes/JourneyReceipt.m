
//
//  Created by Nagraj Gopalakrishnan on 05/12/11.
//  Copyright 2011 Teamdecode. All rights reserved.
//

#import "JourneyReceipt.h"
#import "SupplierDetails.h"
#import "JourneyHelper.h"
#import	"Common.h"
#import "JourneyNotification.h"
#import "LoginPage.h"
#import "WiseCabsAppDelegate.h"
#import "Journey.h"

@implementation JourneyReceipt
@synthesize scrollView,DateLabel,TimeLabel,PassengersLabel,BagsLabel,GenderLabel,CoPassengersLabel,SupplierNameLabel,CabNumberLabel,CabDriverNameLabel,FareValueLabel;
@synthesize lblDropAddress,pickupAddress,JourneyType,wasGuest,labelBookingNo,ShowCoPassenger,JourneyId,journey;
@synthesize thanksMessage,isActionSheetOpened,coPassengerDetailButton,isParked,SupplierView,CoPassengerView,FareLabel,lblPaymentType;
@synthesize userJourney,CoPassengers,JourneySupplier,customerEmail,customerMobile,Currency,fareValue,cameFromParkingTab;

@synthesize fare,distance,noOfPassengers,noOfBags,dropAddress,pickUpAddress,journeyID,allocatedJnyID,jnyDate,jnyTime,vehicleType,paymentType,journeyDict;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

-(void)viewWillAppear:(BOOL)animated
{
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//if (self.wasGuest) {
		[NSThread detachNewThreadSelector:@selector(getJourneyList) toTarget:self withObject:nil];
        WiseCabsAppDelegate *appDelegate = (WiseCabsAppDelegate *)[[UIApplication sharedApplication] delegate];
		UIViewController *myViewController= [appDelegate.maintabBarController.viewControllers objectAtIndex:1];
		[myViewController tabBarItem].enabled = TRUE;
    UIViewController *myViewController2 = [appDelegate.maintabBarController.viewControllers objectAtIndex:2];
    [myViewController2 tabBarItem].enabled = TRUE;
    UIViewController *myViewController3 = [appDelegate.maintabBarController.viewControllers objectAtIndex:3];
    [myViewController3 tabBarItem].enabled = TRUE;
	//}
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(showLogoutPage:)  ] autorelease];	NSLog(@"loaded view");
    
    UIButton *actionSheetButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    //[button setTitle:@"Options" forState:UIControlStateNormal];
    [actionSheetButton setImage:[UIImage imageNamed:@"ActionSheetIcon2.png"] forState:UIControlStateNormal];
    [actionSheetButton addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    [actionSheetButton setFrame:CGRectMake(0, 0, 32, 32)];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:actionSheetButton] autorelease];
    
	//isActionSheetOpened=NO;
    self.title=@"Receipt";
	self.navigationItem.hidesBackButton=YES;		
		
		pickupAddress.text=self.pickUpAddress; 
        lblDropAddress.text=self.dropAddress;
    
		DateLabel.text=[NSString stringWithFormat:@"%@",self.jnyDate];		
		TimeLabel.text=[NSString stringWithFormat:@"%@",self.jnyTime];
		labelBookingNo.text=@"";
		PassengersLabel.text=[NSString stringWithFormat:@"%@",self.noOfPassengers];
        //lblPaymentType.text=[NSString stringWithFormat:@"Passengers: %@",self.paymentType];
        //lblVehicleType.text=[NSString stringWithFormat:@"Passengers: %@",self.vehicleType];
		BagsLabel.text=[NSString stringWithFormat:@"%@",self.noOfBags];
				
		FareValueLabel.text=[NSString stringWithFormat:@"%@ - %@ %@",self.vehicleType,[[Journey searchedJourney] Currency],self.fare];
		
        thanksMessage.text=[NSString stringWithFormat:@"Thanks for booking with us. You will receive a confirmation at %@ shortly.",[[Common loggedInUser] MobileNumber]];
		
        //[self setJourneyDetails];
		[super viewDidLoad];
	
}

-(void)getJourneyList{
	NSAutoreleasePool *pool =[[NSAutoreleasePool alloc] init];
	JourneyNotification *jnyNotification=[[JourneyNotification alloc] init];
	[jnyNotification updateAllJourneyList];
	[jnyNotification release];
	[pool release];
}

-(IBAction)showLogoutPage:(id)sender {
	
	NSLog(@"User is logged in");
	UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	[logoutAlert addButtonWithTitle:@"Yes"];
	[logoutAlert addButtonWithTitle:@"No"];
	logoutAlert.cancelButtonIndex = 1;
	[logoutAlert show];
	[logoutAlert release];
}

-(IBAction)showActionSheet:(id)sender {

	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Take Action" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Mark As Favourite", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];
	isActionSheetOpened=YES;

}
//ActionSheet Button action goes here

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex==0) {
		if ([Common isNetworkExist]>0)
		{
			[Journey deallocJourney];
			[Common setLoggedInUser:nil];
			//self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(showLoginPage:)  ] autorelease];
            WiseCabsAppDelegate *appDelegate = (WiseCabsAppDelegate *)[[UIApplication sharedApplication] delegate];
            UIViewController *myViewController1 = [appDelegate.maintabBarController.viewControllers objectAtIndex:1];
            [myViewController1 tabBarItem].enabled = FALSE;
            UIViewController *myViewController2 = [appDelegate.maintabBarController.viewControllers objectAtIndex:2];
            [myViewController2 tabBarItem].enabled = FALSE;
            UIViewController *myViewController3 = [appDelegate.maintabBarController.viewControllers objectAtIndex:3];
            [myViewController3 tabBarItem].enabled = FALSE;
            [self showLoginPage];
            
		}
			else {
				[Common showNetwokAlert];
			}
		
	}
}

-(void) showLoginPage{
    
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
    
    
	//LoginPage *loginPage=[[[LoginPage alloc] init] autorelease];
	//[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
    // [self.navigationController presentModalViewController:loginPage YES];
    [self.navigationController presentViewController:loginPage
                                            animated:YES
                                          completion:nil];

}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	//WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
	if ([Common isNetworkExist]>0)
	{	
			
		if (buttonIndex == 0) 
		{
			JourneyHelper *helper=[[JourneyHelper alloc] init];
			NSLog(@" my JourneyID is %@",[Common SearchedJourneyID]);
			
				if ([helper markAsFavourite:[Common SearchedJourneyID]]) {
					[Common showAlert:@"Favourite" message:@"Favourite Marked"];
					//actionSheetButton.hidden=YES;
					self.navigationItem.leftBarButtonItem=nil;
					
				}else {
					[Common showAlert:@"Favourite" message:@"Error in marking favourite"];
				}
            [helper release];
						
		} else if (buttonIndex == 1)
		{
		} 
	}else {
		[Common showNetwokAlert];
	}
	
	isActionSheetOpened=NO;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillDisappear:(BOOL)animated
{
	[Journey deallocJourney];
	if (self.cameFromParkingTab) {
	[Journey deallocJourney];
	}
}

- (void)dealloc {
	[journey release];
	[DateLabel release];
    [TimeLabel release];
	[PassengersLabel release];
	[BagsLabel release];
	[GenderLabel release];
	[CoPassengersLabel release];
	[SupplierNameLabel release];
	[CabNumberLabel release];
	[CabDriverNameLabel release];
	[FareValueLabel release];
    [lblPaymentType release];
    [lblVehicleType release];
    
	[scrollView release];
	[thanksMessage release];
	[lblDropAddress release];
	[pickupAddress release];
	[JourneyType release];
	[userJourney release];
	[CoPassengers release];
	//[JourneySupplier release];
	//[actionSheetButton release];
	[customerEmail release];
	[customerMobile release];
	[Currency release];
	[coPassengerDetailButton release];
	[Journey deallocJourney];
    
    [fare release];
    [distance release];
    [noOfPassengers release];
    [noOfBags release];
    [dropAddress release];
    [pickUpAddress release];
    [journeyID release];
    [allocatedJnyID release];
    [jnyDate release];
    [jnyTime release];
    [vehicleType release];
    [paymentType release];
    [journeyDict release];

	//[[Journey searchedJourney] release];
    [super dealloc];
}


@end
