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


@interface WCHomeMapViewController : MainViewController <MKMapViewDelegate>

@property (retain, nonatomic) IBOutlet MKMapView *homeMapView;

- (IBAction)pickUpLocation:(id)sender;
- (IBAction)destination:(id)sender;

@end
