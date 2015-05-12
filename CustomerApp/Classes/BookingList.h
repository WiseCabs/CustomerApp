//
//  BookingList.h
//  WiseCabs
//
//  Created by Nagraj on 31/12/12.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MainViewController.h"

@interface BookingList : MainViewController<UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate,MBProgressHUDDelegate>{
    IBOutlet UITableView *jnyTableView;
    IBOutlet UISegmentedControl *mainSegmentControl;
    
     NSString *tabName;
    NSArray *myBookingArray;
    NSMutableArray *groupedScheduledArray;
    NSMutableArray *groupedCompletedArray;
     NSMutableArray * uniqueScheduledArray;
    NSMutableArray * uniqueCompletedArray;
    NSMutableDictionary *jnyDict;
    BOOL jnysloaded;
    
    NSTimer *updatetimer;
     MBProgressHUD *HUD;
}

@property (nonatomic, retain) NSTimer *updatetimer;

@property (nonatomic, readwrite) BOOL jnysloaded;
@property (nonatomic, retain) IBOutlet UITableView *jnyTableView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *mainSegmentControl;
@property (nonatomic, retain) NSString *tabName;
@property (nonatomic, retain) NSArray *myBookingArray;
@property (nonatomic, retain) NSMutableArray *groupedScheduledArray;
@property (nonatomic, retain) NSMutableArray *groupedCompletedArray;
@property (nonatomic, retain) NSMutableArray * uniqueScheduledArray;
@property (nonatomic, retain) NSMutableArray * uniqueCompletedArray;
@property (nonatomic, retain) NSMutableDictionary *jnyDict;

-(IBAction) SegmentedControlChanged;
-(NSArray *)getUpdatedBookingArray;
-(void)getJourney;
-(void)getJny;
@end
