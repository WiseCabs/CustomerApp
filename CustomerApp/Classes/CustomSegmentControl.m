//
//  CustomSegmentControl.m
//  WiseCabs
//
//  Created by Nagraj on 20/12/12.
//
//

#import "CustomSegmentControl.h"

@implementation CustomSegmentControl

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    int oldValue = self.selectedSegmentIndex;
    [super touchesBegan:touches withEvent:event];
    if ( oldValue == self.selectedSegmentIndex )
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    
    
    
   /* int oldValue = self.selectedSegmentIndex;
    [super touchesBegan:touches withEvent:event];
    if (oldValue == self.selectedSegmentIndex)
    {
        [super setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }*/
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    for (int i=0; i<[self.subviews count]; i++)
    {
        if ([[self.subviews objectAtIndex:i]isSelected] )
        {
            
            UIColor *tintcolor=[UIColor blackColor];
            [[self.subviews objectAtIndex:i] setTintColor:tintcolor];
            for (UIView *v in [[[self subviews] objectAtIndex:i] subviews]) {
                if ([v isKindOfClass:[UILabel class]]) {
                    UILabel *label=(UILabel *)[v retain];
                    label.textColor=[UIColor whiteColor];
                }
            }
        } else {
            UIColor *tintcolor=[UIColor whiteColor]; // default color
            [[self.subviews objectAtIndex:i] setTintColor:tintcolor];
            for (UIView *v in [[[self subviews] objectAtIndex:i] subviews]) {
                if ([v isKindOfClass:[UILabel class]]) {
                    UILabel *label=(UILabel *)[v retain];
                    label.textColor=[UIColor grayColor];
                }
            }
        }
    }
    
}
@end
