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
@property(nonatomic,assign) BOOL isAnnotationAdded;
@property(nonatomic,strong) CLLocation *myCurrentLocation;

@end

@implementation WCHomeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title=@"ABBA Cars";
    self.myCurrentLocation = nil;
    
    self.isAnnotationAdded = NO;

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    if([Common isNetworkExist]>0){
        [self.homeMapView setMapType:MKMapTypeStandard];
        [self.homeMapView setZoomEnabled:YES];
        [self.homeMapView setScrollEnabled:YES];
        [self.homeMapView setShowsUserLocation:YES];
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
    NSLog(@"User Current Location: %@", self.homeMapView.userLocation.location);

    if (self.myCurrentLocation != nil)
    {
        NSLog(@"Annotation count - %ld", self.homeMapView.annotations.count);
        if (!self.isAnnotationAdded) {

        CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
        [geocoder reverseGeocodeLocation:currentLocation
                       completionHandler:^(NSArray *placemarks, NSError *error) {
                           NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
                           
                           if (error){
                               NSLog(@"Geocode failed with error: %@", error);
                               return;
                               
                           }
                           
                           if(placemarks && (placemarks.count > 0) && (!self.isAnnotationAdded))
                               
                           {
                               self.isAnnotationAdded = YES;

                               MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
                               [self.homeMapView setRegion:[self.homeMapView regionThatFits:region] animated:YES];

                               //do something
                               CLPlacemark *topResult = [placemarks objectAtIndex:0];
                               MyAnnotation *myPin;
                               myPin = [[MyAnnotation alloc] initWithCoordinate:currentLocation.coordinate];
                               myPin.title = [NSString stringWithFormat:@"%@, %@",[topResult thoroughfare], [topResult postalCode]];
                               self.homeMapView.userLocation.title = [NSString stringWithFormat:@"%@, %@",[topResult thoroughfare], [topResult postalCode]];
                               
                               NSMutableDictionary *placeDict=[[NSMutableDictionary alloc] init];
                               [placeDict setObject:@"0" forKey:@"placeId"];
                               [placeDict setObject:[NSString stringWithFormat:@"%@",[topResult thoroughfare]] forKey:@"placeName"];
                               [placeDict setObject:[topResult postalCode] forKey:@"postCode"];
                               [placeDict setObject: @"city" forKey:@"placeType"];
                               [placeDict setObject:[NSString stringWithFormat:@"%@",[topResult thoroughfare]] forKey:@"truncatedPlaceName"];

                               [Common setFromAddress:placeDict];
                               
                               [self.homeMapView addAnnotation:myPin];
                               
                           }
                           
                           [self.locationManager stopUpdatingLocation];
        }];

            
        }
        


        

    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    


}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    for (id<MKAnnotation> currentAnnotation in mapView.annotations) {
        if (![currentAnnotation isKindOfClass:[MKUserLocation class]])
            [mapView selectAnnotation:currentAnnotation animated:YES];
    }


//    [mapView selectAnnotation:[[mapView annotations] firstObject] animated:YES];

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.homeMapView.centerCoordinate = mapView.userLocation.location.coordinate;
    
    // zoom to region containing the user location
    
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
                ann.title = [NSString stringWithFormat:@"%@, %@",[topResult thoroughfare], [topResult postalCode]];
                
                NSMutableDictionary *placeDict=[[NSMutableDictionary alloc] init];
                [placeDict setObject:@"0" forKey:@"placeId"];
                [placeDict setObject:[NSString stringWithFormat:@"%@",[topResult thoroughfare]] forKey:@"placeName"];
                [placeDict setObject:[topResult postalCode] forKey:@"postCode"];
                [placeDict setObject: @"city" forKey:@"placeType"];
                [placeDict setObject:[NSString stringWithFormat:@"%@",[topResult thoroughfare]] forKey:@"truncatedPlaceName"];

                [Common setFromAddress:placeDict];
            }
        }];
    }
}

- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation {
    static NSString *defaultID = @"myLocation";

    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
//        ((MKUserLocation *)annotation).title = (self.currentLocation !=nil) ? self.currentLocation : @"Current Location";
        self.myCurrentLocation = mapView.userLocation.location;
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
