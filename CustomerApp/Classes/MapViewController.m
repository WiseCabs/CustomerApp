//
//  MapViewController.m
//  WiseCabs
//
//  Created by Nagraj on 08/01/13.
//
//

#import "MapViewController.h"
#import "Common.h"
#import "WebServiceHelper.h"
#import "DisplayMap.h"

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapView,latitude,longitude,journeyID,locationTimer,ann,driverNo;

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
    self.navigationItem.title=@"Map";
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
         [NSThread detachNewThreadSelector:@selector(getDriverLocation) toTarget: self withObject: nil];
        locationTimer = [NSTimer scheduledTimerWithTimeInterval: 60.0 target: self selector:@selector(onTick:) userInfo: nil repeats:YES];
	}
	else {
		[Common showNetwokAlert];
	}

    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
        NSArray *sdobjects = [NSArray arrayWithObjects:self.journeyID,self.driverNo, nil];
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
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = [latitude floatValue];
    region.center.longitude = [longitude floatValue];
    region.span.longitudeDelta = 1;
    region.span.latitudeDelta = 1;
    [mapView setRegion:region animated:YES];
     ann= [[DisplayMap alloc] init];
    ann.title = @"";
    ann.coordinate = region.center;
    [mapView addAnnotation:ann];
    [ann release];

}

-(void)onTick:(NSTimer*) tm
{
  [NSThread detachNewThreadSelector:@selector(getDriverLocation) toTarget: self withObject: nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    [locationTimer release];
    [mapView release];
	[latitude release];
	[longitude release];
    [journeyID release];
    [ann release];
    [driverNo release];
    [super dealloc];
}

@end
