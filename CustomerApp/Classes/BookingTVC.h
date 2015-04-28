//
//  BookingTVC.h
//  WiseCabs
//
//  Created by Nagraj on 07/01/13.
//
//

#import <UIKit/UIKit.h>

@interface BookingTVC : UITableViewCell {
	IBOutlet UILabel *timeLabel;
	IBOutlet UILabel *fromAddress;
	IBOutlet UILabel *toAddress;
	IBOutlet UILabel *fare;
	
}
@property(nonatomic, retain) IBOutlet UILabel *timeLabel;
@property(nonatomic, retain) IBOutlet UILabel *fromAddress;
@property(nonatomic, retain) IBOutlet UILabel *toAddress;
@property(nonatomic, retain) IBOutlet UILabel *fare;



@end
