//
//  WCSearchBarTableViewController.h
//  WiseCabs
//
//  Created by Apoorv Garg on 23/05/15.
//
//

#import <UIKit/UIKit.h>

@interface WCSearchBarTableViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UISearchBar *addressSearchBar;
@property (retain, nonatomic) IBOutlet UITableView *addressTableView;
@property (retain, nonatomic) IBOutlet UIButton *doneButton;

- (IBAction)clickDone:(id)sender;

@property (strong,nonatomic) NSMutableArray *filteredListContent;

@property(nonatomic, retain) NSString *myParentIS;


@end
