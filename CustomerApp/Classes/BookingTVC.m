//
//  BookingTVC.m
//  WiseCabs
//
//  Created by Nagraj on 07/01/13.
//
//

#import "BookingTVC.h"

@implementation BookingTVC
@synthesize timeLabel;
@synthesize fromAddress,toAddress;
@synthesize fare;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	[timeLabel release];
	[fromAddress release];
	[toAddress release];
	[fare release];
    [super dealloc];
}


@end
