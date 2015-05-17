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

#define METERS_PER_MILE 1609.344

@interface WCHomeMapViewController ()

@end

@implementation WCHomeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title=@"Home";
    
    if([Common isNetworkExist]>0){
        [self.homeMapView setMapType:MKMapTypeStandard];
        [self.homeMapView setZoomEnabled:YES];
        [self.homeMapView setScrollEnabled:YES];
        
        [self.homeMapView setDelegate:self];
    }
    else {
        [Common showNetwokAlert];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    // zoom to region containing the user location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 10*METERS_PER_MILE, 10*METERS_PER_MILE);
    [self.homeMapView setRegion:[self.homeMapView regionThatFits:region] animated:YES];
    
    // add the annotation
    MyAnnotation *myPin = [[MyAnnotation alloc] initWithCoordinate:userLocation.coordinate];
    [self.homeMapView addAnnotation:myPin];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState{
    NSLog(@"pin Drag");
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
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
}

- (IBAction)destination:(id)sender {
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
