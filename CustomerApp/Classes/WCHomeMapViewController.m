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
#import "WCSearchBarTableViewController.h"


#define METERS_PER_MILE 1609.344

@interface WCHomeMapViewController ()

@property(nonatomic,strong) SearchViewController *searchViewController;

@end

@implementation WCHomeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title=@"ABBA Cars";
    

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
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
    
    [self.locationManager startUpdatingLocation];

    
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation * currentLocation = (CLLocation *)[locations lastObject];

    NSLog(@"Location: %@", currentLocation);
    if (currentLocation != nil)
    {
        if (!self.homeMapView.annotations.count) {

        CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
        [geocoder reverseGeocodeLocation:currentLocation
                       completionHandler:^(NSArray *placemarks, NSError *error) {
                           NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
                           
                           if (error){
                               NSLog(@"Geocode failed with error: %@", error);
                               return;
                               
                           }
                           
                           if(placemarks && placemarks.count > 0)
                               
                           {
                               //do something
                               CLPlacemark *topResult = [placemarks objectAtIndex:0];
                               MyAnnotation *myPin;
                               myPin = [[MyAnnotation alloc] initWithCoordinate:currentLocation.coordinate];
                               myPin.title = [NSString stringWithFormat:@"%@, %@, %@",[topResult subLocality],[topResult locality], [topResult postalCode]];
                               self.homeMapView.userLocation.title = [NSString stringWithFormat:@"%@, %@, %@",[topResult subLocality],[topResult locality], [topResult postalCode]];
                               [self.homeMapView addAnnotation:myPin];
                               
                           }
        }];

            
        }
        


        [self.locationManager stopUpdatingLocation];

    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    


}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
//    for (id<MKAnnotation> currentAnnotation in mapView.annotations) {
//            [mapView selectAnnotation:currentAnnotation animated:YES];
//    }
    [mapView selectAnnotation:[[mapView annotations] firstObject] animated:YES];

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    userLocation.title = self.currentLocation;
    
    // zoom to region containing the user location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1*METERS_PER_MILE, 1*METERS_PER_MILE);
    [self.homeMapView setRegion:[self.homeMapView regionThatFits:region] animated:YES];
    

}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState{
    NSLog(@"pin Drag");
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:droppedAt.latitude longitude:droppedAt.longitude];

        CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
        [geocoder reverseGeocodeLocation:location
                       completionHandler:^(NSArray *placemarks, NSError *error)
        {
            
            NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");

            if (error){
               NSLog(@"Geocode failed with error: %@", error);
               return;
               
            }

            if(placemarks && placemarks.count > 0)
               
            {
               //do something
                CLPlacemark *topResult = [placemarks objectAtIndex:0];
                MyAnnotation *ann = annotationView.annotation;
                ann.title = [NSString stringWithFormat:@"%@, %@, %@",[topResult subLocality],[topResult locality], [topResult postalCode]];
            }
        }];
    }
}

- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation {
    static NSString *defaultID = @"myLocation";

    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
//        ((MKUserLocation *)annotation).title = (self.currentLocation !=nil) ? self.currentLocation : @"Current Location";
        return nil;  //return nil to use default blue dot view
    }
    
    MKAnnotationView *pinView;
    if([annotation isKindOfClass:[MyAnnotation class]])
    {
        pinView = (MKAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: defaultID];
        
        if (pinView == nil) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation: (MyAnnotation *)annotation reuseIdentifier: defaultID];
        } else {
            pinView.annotation = annotation;
        }
        //    pin.animatesDrop = YES;
        pinView.draggable = YES;
        pinView.selected = YES;
        pinView.canShowCallout = YES;
        
    if ([Common fromAddress]!=nil) {
        NSMutableDictionary *addressDict=[[Common fromAddress]  mutableCopy];
        MyAnnotation *ann = annotation;
        ann.title = [addressDict objectForKey:@"placeName"];
    }
        return pinView;

    }


    
    return nil;
    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"map Drag");
}

- (IBAction)pickUpLocation:(id)sender {
//    AddressSearchController *addressController=[[AddressSearchController alloc] init];
//    addressController.myParentIS=@"From Address";
//    addressController.delegate = self;
//    [self.navigationController pushViewController:addressController animated:YES];
//    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
    
    WCSearchBarTableViewController *wcSearchBarTableViewController = [[WCSearchBarTableViewController alloc]initWithNibName:@"WCSearchBarTableViewController" bundle:nil];
    wcSearchBarTableViewController.myParentIS = @"From Address";
    [self.navigationController pushViewController:wcSearchBarTableViewController animated:YES];
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];

}

- (IBAction)destination:(id)sender {
//    AddressSearchController *addressController=[[AddressSearchController alloc] init];
//    addressController.myParentIS=@"To Address";
//    addressController.delegate = self;
//    [self.navigationController pushViewController:addressController animated:YES];
//    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
    
    
    WCSearchBarTableViewController *wcSearchBarTableViewController = [[WCSearchBarTableViewController alloc]initWithNibName:@"WCSearchBarTableViewController" bundle:nil];
    wcSearchBarTableViewController.myParentIS = @"To Address";
    [self.navigationController pushViewController:wcSearchBarTableViewController animated:YES];
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
