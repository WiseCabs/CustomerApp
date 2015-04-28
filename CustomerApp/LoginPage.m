//
//  LoginPage.m
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 22/11/11.
//  Copyright 2011 TeamDecode Software Private limited. All rights reserved.
//

#import "LoginPage.h"
#import "WebServiceHelper.h"
#import "Common.h"
#import "sqlite3.h"
#import "WiseCabsAppDelegate.h"
#import "SQLHelper.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "JourneyNotification.h"
#import "SearchViewController.h"

//static sqlite3 *database = nil;

@implementation LoginPage
@synthesize LogInButton;
@synthesize GuestVisitorButton;
@synthesize emailIdText;
@synthesize PasswordText,RememberMe,isUserGuest,paths,documentsDirectory,AlreadyWentToCity,allJourney;



// The designated initializer.  Override if you create the controller programmatically and want to perform Customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(@synthesize)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */
-(void) viewWillAppear:(BOOL)animtated{
	
	WiseCabsAppDelegate *appDelegate = (WiseCabsAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[appDelegate isUserloggedIn];
	NSUInteger viewControllerCount = self.navigationController.viewControllers.count;
	NSLog(@"controller count is:%i",viewControllerCount);
	if (![Common isGuestUser]) {
		NSLog(@"email:%@",[[Common loggedInUser] Email]);
		NSLog(@"mobile:%@",[[Common loggedInUser] MobileNumber]);
		NSLog(@"User is logged in ");
		emailIdText.text=[[Common loggedInUser] userName];
		PasswordText.text=[[Common loggedInUser] password];
	}
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)awakeFromNib{
	 [super awakeFromNib];
	NSLog(@"awakeFromNib");
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    WiseCabsAppDelegate *appDelegate = (id)[[UIApplication sharedApplication] delegate];
	
	[self.navigationController.view setNeedsLayout];
	self.emailIdText.frame = CGRectMake(21, 108, 278, 38);
    self.PasswordText.frame = CGRectMake(21, 165, 278, 38);
	self.title=@"Book a Cab";
	self.navigationItem.title = @"Login";
	//[self updateTables];
	
	appDelegate.maintabBarController.tabBar.hidden=YES;
	
	CGRect newFrame = appDelegate.maintabBarController.view.frame;
	newFrame.size.height += appDelegate.maintabBarController.tabBar.frame.size.height;
	[appDelegate.maintabBarController.view setFrame:CGRectMake(newFrame.origin.x, newFrame.origin.y, newFrame.size.width, newFrame.size.height)];
	
	[emailIdText setPlaceholder:@"Email ID"];
	[PasswordText setPlaceholder:@"Password"];
    [super viewDidLoad];
}

- (IBAction)dismissKeyboard:(id)sender
{
	[self.emailIdText resignFirstResponder];
	[self.PasswordText resignFirstResponder];
	self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.rightBarButtonItem = nil;
}

- (IBAction)textFieldReturn:(id)sender;
{
	[sender resignFirstResponder];
	self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.rightBarButtonItem = nil;
} 

	
- (IBAction) cancelEdit:(id)sender
{
	if (self.emailIdText.isFirstResponder) {
		[emailIdText setText:@""];
		[self.emailIdText resignFirstResponder];
	}
	else {
		[PasswordText setText:@""];
		[self.PasswordText resignFirstResponder];
	}
	self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.rightBarButtonItem = nil;
	
}


- (void)viewWillDisappear:(BOOL)animtated {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification {
	// locate keyboard view
	
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



- (void)myTask {
    // Do something usefull in here instead of sleeping ...
	//  sleep(3);
}



- (IBAction)loginIn:(id)sender{
	//[NSThread detachNewThreadSelector:@selector(showProgress) toTarget: self withObject: nil];
    if ([Common isNetworkExist]>0)
	//{
	     [NSThread detachNewThreadSelector:@selector(authenticateUser) toTarget: self withObject: nil];
   // }
else //{
		[Common showNetwokAlert];
	//}
}

	
-(void)showProgress{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText=@"Authenticating..";
	//hud.detailsLabelText=@"Updating";
	hud.square=YES;
	[pool release];
}

-(void)authenticateUser{
    

	NSAutoreleasePool *authenticateActionPool=[[NSAutoreleasePool alloc] init];
	BOOL isSuccess=NO;
	
		if ( ([emailIdText.text length] > 0 ) && ([PasswordText.text length] > 0 ) )
		{
			//if ([Common NSStringIsValidEmail:emailIdText.text])
			//{
			[NSThread detachNewThreadSelector:@selector(showProgress) toTarget: self withObject: nil];
			//WiseCabsAppDelegate *appDelegate = (WiseCabsAppDelegate *)[[UIApplication sharedApplication] delegate];	
			//NSString *dbpath = [appDelegate getDBPath];
			WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
			NSObject *obj=[[NSObject alloc]init];
			servicehelper.objEntity=obj;
				[obj release];
			NSArray *sdkeys = [NSArray arrayWithObjects:@"username", @"password",nil];
			NSArray *sdobjects = [NSArray arrayWithObjects:emailIdText.text,PasswordText.text, nil];
			NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
			
			//NSArray *result=[servicehelper callWebService:[NSString stringWithFormat:@"%@customer/customerauth",[Common webserviceURL]] pms:sdparams];
			
			NSString *URL=[NSString stringWithFormat:@"%@customer/customerauth",[Common webserviceURL]];
			NSLog(@"service method get called");
			NSArray *resultArray=[servicehelper callWebService:URL pms:sdparams];

				
			if (resultArray!=nil) {
				
				allJourney=[resultArray objectAtIndex:0];

				if([[allJourney objectForKey:@"success"] boolValue])
				{
					
					//Redirecting to home Page
					// set the variables to the values in the text fields
					
					if(RememberMe.on)
					{
                        NSMutableDictionary *userDict=[allJourney mutableCopy];
                        [userDict setObject:PasswordText.text forKey:@"Password"];
                        [userDict setObject:emailIdText.text forKey:@"UserName"];
						m_db = [[[SQLHelper alloc] init] autorelease];
						[m_db insertLoggedInUserTables:userDict];
					}
					else if ([[Common loggedInUser] Email] &&([[Common loggedInUser] MobileNumber])){
						//[m_db retain];
						[m_db deleteUserDetails];
						
					}

					[Common setLoggedInUser:nil];
					User *user=[[User alloc] init];
					user.FirstName=[allJourney objectForKey:@"Name"];
					//user.LastName=[allJourney objectForKey:@"Last_Name"];
					user.ID=[allJourney objectForKey:@"UD_ID"];
					user.Email=emailIdText.text;
					user.MobileNumber=[allJourney objectForKey:@"Mob_Number"];
                    user.suppID=[allJourney objectForKey:@"Supplier_Id"];
                    user.password=PasswordText.text;
					NSLog(@"Contact_Number %@",[allJourney objectForKey:@"Mob_Number"]);
					[Common setLoggedInUser:user];
					//[user release];
					[MBProgressHUD hideHUDForView:self.view animated:YES];
					
					isSuccess=YES;
				/*	CitySearch *citySearch=[[[CitySearch alloc] init] autorelease];
					citySearch.CameFromLoginPage=@"Yes1";
					[self.navigationController pushViewController: citySearch animated:YES]; */
					
				}else {
					isSuccess=NO;
					[MBProgressHUD hideHUDForView:self.view animated:YES];
					[Common showAlert:@"Login Failed" message:@"Enter correct credentials"];
				}
				
			}
			else {
				isSuccess=NO;
				[MBProgressHUD hideHUDForView:self.view animated:YES];
				[Common showAlert:@"Login Failed" message:@"Enter correct credentials"];
			}
			
			[servicehelper release];
		/*}
			else {
				isSuccess=NO;
				[Common showAlert:@"Invalid Email" message:@"Please fill valid email."];
			}*/
		}
		else {	
			isSuccess=NO;
			[Common showAlert:@"Credential Required" message:@"Enter correct credentials"];			
			//}
		}
	
	[authenticateActionPool release];
	
	if (isSuccess) {
		[self performSelectorOnMainThread:@selector(pushCitysearch) withObject:nil waitUntilDone:NO];
	}
}
-(void)pushCitysearch{
	[NSThread detachNewThreadSelector:@selector(getJourneyList) toTarget:self withObject:nil];
	 SearchViewController *citySearch=[[SearchViewController alloc] init];
	 citySearch.CameFromLoginPage=@"Yes";
	
	 [self.navigationController pushViewController: citySearch animated:YES];
	[self dismissModalViewControllerAnimated:YES];
}

-(void)getJourneyList{
	NSAutoreleasePool *pool =[[NSAutoreleasePool alloc] init];
	JourneyNotification *jnyNotification=[[JourneyNotification alloc] init];
	[jnyNotification updateAllJourneyList];
	[jnyNotification release];
	[pool release];
}

- (IBAction)continueAsGuest:(id)sender{
	
	[Common setLoggedInUser:nil];
    
	
	[self dismissModalViewControllerAnimated:YES];
	
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
	
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	//[[NSNotificationCenter defaultCenter] removeObserver:self];
	//[m_db release];
	[allJourney release];
    [super dealloc];
}


@end
