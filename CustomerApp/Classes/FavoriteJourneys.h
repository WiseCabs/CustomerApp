//
//  FavoriteJourneys.h
//  WiseCabs
//
//  Created by Nagraj on 29/05/13.
//
//

#import <UIKit/UIKit.h>

@interface FavoriteJourneys : UIViewController <UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>

{
IBOutlet UITableView *favoriteTableView;
    NSArray *myBookingArray;
    NSMutableArray *groupedArray;
    NSMutableArray * uniqueArray;
    NSMutableDictionary *jnyDict;
    NSString *tabName;
}

@property(nonatomic, retain) IBOutlet UITableView *favoriteTableView;
@property(nonatomic, retain) NSArray *myBookingArray;
@property(nonatomic, retain) NSMutableArray *groupedArray;
@property(nonatomic, retain) NSMutableArray * uniqueArray;
@property(nonatomic, retain) NSMutableDictionary *jnyDict;
@property(nonatomic, retain) NSString *tabName;


@end
