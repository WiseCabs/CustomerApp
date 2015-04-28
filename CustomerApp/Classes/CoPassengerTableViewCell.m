//
//  CoPassengerTableViewCell.m
//  WiseCabs
//
//  Created by Nagraj Gopalakrishnan on 07/12/11.
//  Copyright 2011 TeamDecode Software Private limited. All rights reserved.
//

#import "CoPassengerTableViewCell.h"


@implementation CoPassengerTableViewCell
@synthesize FromAddress1,FromAddress2,ToAddress1,ToAddress2,Date,Time,Passengers,Bags,Gender;

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
    [super dealloc];
}


@end
