//
//  LocationTracker.m
//  WiseCabs
//
//  Created by Nagraj on 29/05/13.
//
//

#import "LocationTracker.h"
#import "Common.h"
#import "WebServiceHelper.h"
#import "DisplayMap.h"
#import "WiseCabsAppDelegate.h"
#import "ALToastView.h"
#import "Journey.h"

@interface LocationTracker ()

@end

@implementation LocationTracker
@synthesize mapView,latitude,longitude,journeyID,locationTimer,ann,driverNo,tabName,noDriverAlert;

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
    self.navigationItem.title=@"Track your Driver";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(showLogoutPage:)  ] autorelease];

    NSLog(@"Journey id is %@",journeyID);
    if([Common isNetworkExist]>0){
		[mapView setMapType:MKMapTypeStandard];
		[mapView setZoomEnabled:YES];
		[mapView setScrollEnabled:YES];
        
		[mapView setDelegate:self];
        MKCoordinateRegion region = { 51.5073, 0.12755 };
        region.span.longitudeDelta = 2;
		region.span.latitudeDelta = 2;
		[mapView setRegion:region animated:YES];
        
        
	}
	else {
		[Common showNetwokAlert];
	}
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"[Common TrackerDriverID] is--- %@",[Common TrackerDriverID]);
    NSLog(@"[Common TrackerJourneyID] is--- %@",[Common TrackerJourneyID]);


    
    if([[Common TrackerDriverID] length] ==0)
    {
       noDriverAlert= [[UIAlertView alloc] initWithTitle:@"You do not have a journey with a driver on-route." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [noDriverAlert addButtonWithTitle:@"My Journeys"];
        [noDriverAlert addButtonWithTitle:@"Cancel"];
        noDriverAlert.cancelButtonIndex = 1;
        [noDriverAlert show];
        [noDriverAlert release];
    }
    else
    {
        if([Common isNetworkExist]>0)
        {
            [NSThread detachNewThreadSelector:@selector(getDriverLocation) toTarget: self withObject: nil];
            locationTimer = [NSTimer scheduledTimerWithTimeInterval: 60.0 target: self selector:@selector(onTick:) userInfo: nil repeats:YES];
        }
        else{
            [ALToastView toastInView:self.view withText:@"No Internet Connection."];
        }
    }
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==self.noDriverAlert) {
        if (buttonIndex==0) {
            WiseCabsAppDelegate *appDelegate = (WiseCabsAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.maintabBarController setSelectedIndex:1];
        }
    }
    else
    {
        if (buttonIndex==0)
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
            [appDelegate.maintabBarController setSelectedIndex:0];        
        
        }
    }
}

-(void)getDriverLocation{
	
	NSAutoreleasePool *locationActionPool=[[NSAutoreleasePool alloc] init];
    if ([Common isNetworkExist]>0)
	{
        WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
        NSObject *obj=[[NSObject alloc]init];
        servicehelper.objEntity=obj;
        [obj release];
        NSArray *sdkeys = [NSArray arrayWithObjects:@"journeyId",@"driverNo",nil];
        NSArray *sdobjects = [NSArray arrayWithObjects:[Common TrackerJourneyID],[Common TrackerDriverID], nil];
        NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
        
        //NSArray *result=[servicehelper callWebService:[NSString stringWithFormat:@"%@customer/customerauth",[Common webserviceURL]] pms:sdparams];
        
        NSString *URL=[NSString stringWithFormat:@"%@search/driverlocation",[Common webserviceURL]];
        NSLog(@"service method get called");
        NSArray *resultArray=[servicehelper callWebService:URL pms:sdparams];
        
        
        if (resultArray!=nil) {
            
            NSDictionary *locDict=[resultArray objectAtIndex:0];
            
            if([[locDict objectForKey:@"success"] boolValue])
            {
                latitude=[locDict objectForKey:@"latitude"];
                longitude=[locDict objectForKey:@"longitude"];
                [self performSelectorOnMainThread:@selector(loadAnnotation) withObject:nil waitUntilDone:YES];
                
            }
        }
    }
    [locationActionPool release];
}
-(void) loadAnnotation
{
    if (ann!=nil) {
        [mapView removeAnnotation:ann];
        ann=nil;
    }
    MKCoordinateRegion region = { [self.latitude floatValue], [self.longitude floatValue] };
    region.center.latitude = [self.latitude floatValue];
    region.center.longitude = [self.longitude floatValue];
    region.span.longitudeDelta = 1;
    region.span.latitudeDelta = 1;
    [mapView setRegion:region animated:YES];
    
    
      
    ann= [[DisplayMap alloc] init];
    ann.title = @"";
    ann.coordinate = region.center;
    [mapView addAnnotation:ann];
    //mapView.zo
    //[mapView setCenterCoordinate:{ {0.0, 0.0 }, { 0.0, 0.0 } } zoomLevel:13 animated:YES];
    
    
    
    
    
    [ann release];
    
}

-(void)onTick:(NSTimer*) tm
{
    if ([Common isNetworkExist]) {
        [NSThread detachNewThreadSelector:@selector(getDriverLocation) toTarget: self withObject: nil];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated{
    [locationTimer invalidate];
	locationTimer=nil;
}

-(void) dealloc{
    [locationTimer release];
    [mapView release];
	[latitude release];
	[longitude release];
    [journeyID release];
    [ann release];
    [driverNo release];
    [tabName release];
    [noDriverAlert release];
    [super dealloc];
}

@end
