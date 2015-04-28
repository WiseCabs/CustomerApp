//
//  CityAddress.m
//  WiseCabs
//
//  Created by Nagraj Gopalakrishnan on 12/12/11.
//  Copyright 2011 Apppli. All rights reserved.
//


#import "ConfirmJourney.h"
#import "Common.h"
#import "JourneyHelper.h"
#import "JourneyReceipt.h"
#import "Journey.h"
#import "SQLHelper.h"
#import "MBProgressHUD.h"
#import "WiseCabsAppDelegate.h"
#import "LoginPage.h"

@implementation ConfirmJourney
@synthesize MainScrollView,textFirstName,textLastName,labelBookingNo, labelConfirmHelp,textEmail,lblDate,lblTime,textMobile,buttonConfirm,isGuestUser,totalFare,fareValue,totalFareLabel,ConfirmPriceLabel,isParked;
@synthesize  cameFromParkingTab,JourneyId,journey;

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


- (void)viewWillAppear:(BOOL)animated{
	
    WiseCabsAppDelegate *appDelegate = (WiseCabsAppDelegate *)[[UIApplication sharedApplication] delegate];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
	appDelegate.maintabBarController.tabBar.hidden=NO;
	if (![Common isGuestUser]) {
		
		WiseCabsAppDelegate *appDelegate = (WiseCabsAppDelegate *)[[UIApplication sharedApplication] delegate];
		UIViewController *myViewController1 = [appDelegate.maintabBarController.viewControllers objectAtIndex:1];
		[myViewController1 tabBarItem].enabled = TRUE;
        UIViewController *myViewController2 = [appDelegate.maintabBarController.viewControllers objectAtIndex:2];
        [myViewController2 tabBarItem].enabled = TRUE;
        UIViewController *myViewController3 = [appDelegate.maintabBarController.viewControllers objectAtIndex:3];
        [myViewController3 tabBarItem].enabled = TRUE;
		
		NSLog(@"view is goin to appear");
		textFirstName.text=[[Common loggedInUser] FirstName];
		textLastName.text=[[Common loggedInUser] LastName];
		NSLog(@"email:%@",[[Common loggedInUser] Email]);
		NSLog(@"mobile:%@",[[Common loggedInUser] MobileNumber]);
		textEmail.text=[[Common loggedInUser] Email];
		textMobile.text=[[Common loggedInUser] MobileNumber];
		textEmail.enabled=NO;
		textMobile.enabled=NO;
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(showLogoutPage:)  ] autorelease];
		
	}
	else {
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(showLoginPage:)  ] autorelease];
		
		[textEmail setPlaceholder:@"Email"];
		[textMobile setPlaceholder:@"Mobile"];
	}
	
	[textFirstName setPlaceholder:@"First Name"];
	[textLastName setPlaceholder:@"Last Name"];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    
    self.title=@"Your details";
    self.textFirstName.frame = CGRectMake(19, 93, 278, 38);
    self.textLastName.frame = CGRectMake(21, 146, 278, 38);
    self.textEmail.frame = CGRectMake(21, 199, 278, 38);
    self.textMobile.frame = CGRectMake(21, 257, 278, 38);
    lblDate.text= [NSString stringWithFormat:@"%@",self.jnyDate];
    lblTime.text= [NSString stringWithFormat:@"%@",self.jnyTime];
    
	
    if (![Common isGuestUser]) {
        textEmail.text=[[Common loggedInUser] Email];
        textFirstName.text=[[Common loggedInUser] FirstName];
        textLastName.text=[[Common loggedInUser] LastName];
        textMobile.text=[[Common loggedInUser] MobileNumber];
        //textEmail.enabled=NO;
    }
    totalFare.text=[NSString stringWithFormat:@"%@ %@",[[Journey searchedJourney] Currency], self.fare];
    labelBookingNo.text= [NSString stringWithFormat:@"%@",self.journeyID];
    [super viewDidLoad];
}




-(IBAction)showLoginPage:(id)sender {
	NSLog(@"User is guest");
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

    [self.navigationController presentViewController:loginPage animated:YES completion:nil];
}

-(IBAction)showLogoutPage:(id)sender {
	
	NSLog(@"User is logged in");
	UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	[logoutAlert addButtonWithTitle:@"Yes"];
	[logoutAlert addButtonWithTitle:@"No"];
	logoutAlert.cancelButtonIndex = 1;
	[logoutAlert show];
	[logoutAlert release];
	//LogoutPage *logoutPage=[[LogoutPage alloc] init];
	//[logoutPage setModalTransitionStyle:UIModalTransitionStylePartialCurl];
	//[self.navigationController pushViewController:logoutPage animated:YES];
	//
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
		if (buttonIndex==0) {
			if ([Common isNetworkExist]>0)
			{
			[Common setLoggedInUser:nil];
			[Journey deallocJourney];
                self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(showLoginPage:)  ] autorelease];
                WiseCabsAppDelegate *appDelegate = (WiseCabsAppDelegate *)[[UIApplication sharedApplication] delegate];
                UIViewController *myViewController1 = [appDelegate.maintabBarController.viewControllers objectAtIndex:1];
                [myViewController1 tabBarItem].enabled = FALSE;
                UIViewController *myViewController2 = [appDelegate.maintabBarController.viewControllers objectAtIndex:2];
                [myViewController2 tabBarItem].enabled = FALSE;
                UIViewController *myViewController3 = [appDelegate.maintabBarController.viewControllers objectAtIndex:3];
                [myViewController3 tabBarItem].enabled = FALSE;
			}
			else {
				[Common showNetwokAlert];
			}

		}
}


- (IBAction)textFieldReturn:(id)sender
{
	[sender resignFirstResponder];
	self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.rightBarButtonItem = nil;
	MainScrollView.contentSize= CGSizeMake(320, 372);
	[MainScrollView setContentOffset:CGPointMake(0,0) animated:YES];
	if (![Common isGuestUser]) {
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(showLogoutPage:)  ] autorelease];
		
	}
	else {
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(showLoginPage:)  ] autorelease];
		
	}
} 

- (IBAction)dismissKeyboard:(id)sender
{
	[self.textFirstName resignFirstResponder];
	[self.textLastName resignFirstResponder];
	[self.textEmail resignFirstResponder];
	[self.textMobile resignFirstResponder];
	self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.rightBarButtonItem = nil;
	MainScrollView.contentSize= CGSizeMake(320, 372);
	[MainScrollView setContentOffset:CGPointMake(0,0) animated:YES];
	if (![Common isGuestUser]) {
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(showLogoutPage:)  ] autorelease];
		
	}
	else {
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(showLoginPage:)  ] autorelease];
		
	}
}


- (IBAction) cancelEdit:(id)sender
{
	MainScrollView.contentSize= CGSizeMake(320, 372);
	[MainScrollView setContentOffset:CGPointMake(0,0) animated:YES];
	
	if (self.textFirstName.isFirstResponder) {
		[textFirstName setText:@""];
		[self.textFirstName resignFirstResponder];
	}
	else if (self.textLastName.isFirstResponder) {
		[textLastName setText:@""];
		[self.textLastName resignFirstResponder];
	}
	else if (self.textEmail.isFirstResponder) {
		[textEmail setText:@""];
		[self.textEmail resignFirstResponder];
	}
	else {
		[textMobile setText:@""];
		[self.textMobile resignFirstResponder];
	}
	self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.rightBarButtonItem = nil;
	if (![Common isGuestUser]) {
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(showLogoutPage:)  ] autorelease];
		
	}
	else {
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(showLoginPage:)  ] autorelease];
		
	}
}


- (void)viewWillDisappear:(BOOL)animtated {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)keyboardWillShow:(NSNotification *)notification {
	// locate keyboard view
	if (self.textEmail.isFirstResponder) {
		
			MainScrollView.contentSize= CGSizeMake(320, MainScrollView.contentSize.height+35);
			[MainScrollView setContentOffset:CGPointMake(0,35) animated:YES];

		
	}else if (self.textMobile.isFirstResponder) {
		
			MainScrollView.contentSize= CGSizeMake(320, MainScrollView.contentSize.height+90);
			[MainScrollView setContentOffset:CGPointMake(0,90) animated:YES];

		
	}
	UIWindow *tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	UIView *keyboard;
	for (int i = 0; i < [tempWindow.subviews count]; i++) {
		keyboard = [tempWindow.subviews objectAtIndex:i];
		// keyboard view found; add the Custom button to it
		if ([[keyboard description] hasPrefix:@"<UIPeripheralHostView"] == YES) {
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard:)  ] autorelease];
			
			//self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit:)] autorelease];
			self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit:)] autorelease];
		}
	}
}


-(IBAction) buttonDoneTapped
{
	[NSThread detachNewThreadSelector:@selector(confirmJourney) toTarget: self withObject: nil];
	
}

-(void)showProgress{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText=@"Confirming Journeys";
	//hud.detailsLabelText=@"Updating";
	hud.square=YES;
	[pool release];
}


-(void)confirmJourney{
	NSAutoreleasePool *authenticateActionPool=[[NSAutoreleasePool alloc] init];
	BOOL isSuccess=NO;
	if ([Common isNetworkExist]>0)
	{
		if (textFirstName.text.length>0 && textEmail.text.length>0 && textMobile.text.length==11) {
			if ([Common NSStringIsValidEmail:textEmail.text]) {
                [NSThread detachNewThreadSelector:@selector(showProgress) toTarget: self withObject: nil];
                JourneyHelper *helper=[[JourneyHelper alloc] init];
                if (textLastName.text.length==0) {
                    textLastName.text=@"";
                }
                NSString *supplierID;
                if ([[Common loggedInUser] suppID]==nil) {
                    supplierID=@"228";
                }
                else{
                    supplierID=[[Common loggedInUser] suppID];
                }
                NSLog(@"supplierid is------%@",supplierID);
                
                if ([helper confirmJourney:self.journeyID firstName: textFirstName.text lastName:textLastName.text userEmail:textEmail.text userMobile:textMobile.text supplierID:supplierID distance:(NSString*)self.distance fare:(NSString*)self.fare journeyDict:self.journeyDict])
                {
                    
                    [self performSelectorOnMainThread:@selector(pushToJourneyReceipt) withObject:nil waitUntilDone:NO];

                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
				
			}else {
				isSuccess=NO;
				[Common showAlert:@"Invalid Email" message:@"Please fill valid email."];
			}
			
		}
		else {
			isSuccess=NO;
			[Common showAlert:@"Required Field" message:@"Please fill valid data in the field."];
		}
	}
	else {
		isSuccess=NO;
		[Common showNetwokAlert];
	}
    [MBProgressHUD hideHUDForView:self.view animated:YES];
	[authenticateActionPool release];
	
	/*if (isSuccess) {
		[self performSelectorOnMainThread:@selector(pushToJourneyReceipt) withObject:nil waitUntilDone:NO];
	}*/
}


-(void)pushToJourneyReceipt{
    /*WiseCabsAppDelegate *appDelegate = (WiseCabsAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *myViewController= [appDelegate.maintabBarController.viewControllers objectAtIndex:1];
    [myViewController tabBarItem].enabled = YES;*/
    
	JourneyReceipt *receipt=[[[JourneyReceipt alloc] init] autorelease];
    receipt.fare=self.fare;
    receipt.distance= self.distance;
    receipt.allocatedJnyID= self.allocatedJnyID;
    receipt.journeyID=self.journeyID;
    receipt.noOfPassengers= self.noOfPassengers;
    receipt.noOfBags= self.noOfBags;
    receipt.dropAddress= self.dropAddress;
    receipt.pickUpAddress= self.pickUpAddress;
    receipt.vehicleType= self.vehicleType;
    receipt.paymentType= self.paymentType;
    receipt.jnyDate= self.jnyDate;
    receipt.jnyTime= self.jnyTime;
    receipt.journeyID=self.journeyID;
    if ([Common isGuestUser]) {
        receipt.wasGuest=YES;
    }
    
	[self.navigationController pushViewController:receipt animated:YES];
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


- (void)dealloc {
    [lblDate release];
    [lblTime release];
    
	  [journey release];
	  [textFirstName release];
	  [textLastName release];
	  [textEmail release];
	  [textMobile release];
	  [buttonConfirm release];
	  [MainScrollView release];
	  [totalFare release];
	  [labelConfirmHelp release];
	  [totalFareLabel release];
	  [labelBookingNo release];
	  [ConfirmPriceLabel release];
	  [isParked release];
    
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
    

      [super dealloc];
}


@end
