//
//  MyAnnotation.m
//  WiseCabs
//
//  Created by Apoorv Garg on 18/05/15.
//
//

#import "MyAnnotation.h"

@implementation MyAnnotation

@synthesize coordinate;

- (NSString *)subtitle{
    return nil;
}

- (NSString *)title{
    return nil;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord {
    coordinate=coord;
    return self;
}

-(CLLocationCoordinate2D)coord
{
    return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}
@end
