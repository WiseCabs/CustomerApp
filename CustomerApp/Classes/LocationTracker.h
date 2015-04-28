//
//  LocationTracker.h
//  WiseCabs
//
//  Created by Nagraj on 29/05/13.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DisplayMap.h"

@interface LocationTracker : UIViewController<MKMapViewDelegate, UIAlertViewDelegate> {
	IBOutlet MKMapView *mapView;
	NSString *latitude;
	NSString *longitude;
    NSString *journeyID;
    NSTimer *locationTimer;
    DisplayMap *ann;
    NSString *driverNo;
    NSString *tabName;
    UIAlertView *noDriverAlert;
}

@property(nonatomic, retain) UIAlertView *noDriverAlert;
@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) NSString *latitude;
@property(nonatomic, retain) NSString *longitude;
@property(nonatomic, retain) NSString *journeyID;
@property(nonatomic, retain) NSTimer *locationTimer;
@property(nonatomic, retain) DisplayMap *ann;
@property(nonatomic, retain) NSString *driverNo;
@property(nonatomic, retain) NSString *tabName;

-(void) loadAnnotation;
@end
