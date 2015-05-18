//
//  WCHomeMapViewController.h
//  WiseCabs
//
//  Created by Apoorv Garg on 17/05/15.
//
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import <MapKit/MapKit.h>
#import "SearchBarController.h"


@interface WCHomeMapViewController : MainViewController <MKMapViewDelegate,WCSearchBarControllerDelegate,CLLocationManagerDelegate>

@property (retain, nonatomic) IBOutlet MKMapView *homeMapView;
@property(nonatomic, retain) CLLocationManager *locationManager;


- (IBAction)pickUpLocation:(id)sender;
- (IBAction)destination:(id)sender;

@end
