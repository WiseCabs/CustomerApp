//
//  MyAnnotation.h
//  WiseCabs
//
//  Created by Apoorv Garg on 18/05/15.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation>{
    
    CLLocationCoordinate2D coordinate;
    
}
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;



@end
