//
//  OldJourneyTableViewCell.h
//  WiseCabs
//
//  Created by Nagraj Gopalakrishnan on 07/12/11.
//  Copyright 2011 TeamDecode Software Private limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OldJourneyTableViewCell : UITableViewCell {

	IBOutlet UILabel *FromAddress2;
	IBOutlet UILabel *ToAddress1;
	IBOutlet UILabel *ToAddress2;
	IBOutlet UILabel *Date;
	IBOutlet UILabel *Time;
	IBOutlet UIImageView *ImageStar;
	
	
}

@property(nonatomic,retain) IBOutlet UILabel *FromAddress1;
@property(nonatomic,retain) IBOutlet UIImageView *ImageStar;
@property(nonatomic,retain) IBOutlet UILabel *FromAddress2;
@property(nonatomic,retain) IBOutlet UILabel *ToAddress1;
@property(nonatomic,retain) IBOutlet UILabel *ToAddress2;
@property(nonatomic, retain) IBOutlet UILabel * Date;
@property(nonatomic, retain) IBOutlet UILabel *Time;

@end
