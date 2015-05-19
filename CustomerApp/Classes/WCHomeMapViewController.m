//
//  WCHomeMapViewController.m
//  WiseCabs
//
//  Created by Apoorv Garg on 17/05/15.
//
//

#import "WCHomeMapViewController.h"
#import "Common.h"
#import "MyAnnotation.h"
#import "AddressSearchController.h"
#import "SearchViewController.h"
#import "WiseCabsAppDelegate.h"
#import "LoginPage.h"

#define METERS_PER_MILE 1609.344

@interface WCHomeMapViewController ()

@property(nonatomic,strong) SearchViewController *searchViewController;
@end

@implementation WCHomeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title=@"Home";
    

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    
    if([Common isNetworkExist]>0){
        [self.homeMapView setMapType:MKMapTypeStandard];
        [self.homeMapView setZoomEnabled:YES];
        [self.homeMapView setScrollEnabled:YES];
        
        [self.homeMapView setDelegate:self];
    }
    else {
        [Common showNetwokAlert];
    }
    
    _searchViewController = [[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
    
    // add the annotation
    MyAnnotation *myPin = [[MyAnnotation alloc] initWithCoordinate:self.locationManager.location.coordinate];
    [self.homeMapView addAnnotation:myPin];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];
    [self.searchViewController locationUpdate:location];
    
    // zoom to region containing the user location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 10*METERS_PER_MILE, 10*METERS_PER_MILE);
    [self.homeMapView setRegion:[self.homeMapView regionThatFits:region] animated:YES];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(IBAction)showLoginPage:(id)sender {
    [self showLogin];
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

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState{
    NSLog(@"pin Drag");
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:droppedAt.latitude longitude:droppedAt.longitude];
        [self.searchViewController locationUpdate:location];
    }
}

- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation {
    static NSString *defaultID = @"myLocation";

    if ([annotation isKindOfClass:MKUserLocation.class])
    {
        //user location view is being requested,
        //return nil so it uses the default which is a blue dot...
        return nil;
    }
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [self.homeMapView dequeueReusableAnnotationViewWithIdentifier: defaultID];
    if (pin == nil) {
        pin = [[[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: defaultID] autorelease];
    } else {
        pin.annotation = annotation;
    }
    pin.animatesDrop = YES;
    pin.draggable = YES;
    pin.selected = YES;
    
    return pin;
    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"map Drag");
}

- (IBAction)pickUpLocation:(id)sender {
    AddressSearchController *addressController=[[AddressSearchController alloc] init];
    addressController.myParentIS=@"From Address";
    addressController.delegate = self;
    [self.navigationController pushViewController:addressController animated:YES];
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
}

- (IBAction)destination:(id)sender {
    AddressSearchController *addressController=[[AddressSearchController alloc] init];
    addressController.myParentIS=@"To Address";
    addressController.delegate = self;
    [self.navigationController pushViewController:addressController animated:YES];
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
}

- (void)dismissSearchBarController{
    NSLog(@"CAll Back - ASC");
    [self.navigationController pushViewController:self.searchViewController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_homeMapView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setHomeMapView:nil];
    [super viewDidUnload];
}

@end
