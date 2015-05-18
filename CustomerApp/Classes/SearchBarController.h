//
//  SearchBarController.h
//  WiseCabs
//
//  Created by Nagraj on 19/12/12.
//
//

#import <UIKit/UIKit.h>

@protocol WCSearchBarControllerDelegate <NSObject>

- (void)dismissSearchBarController;

@end

@interface SearchBarController : UIViewController<UISearchDisplayDelegate, UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UISearchDisplayController	*searchDisplayController;
    IBOutlet UITableView *searchTableView;
    IBOutlet UISearchBar *mySearchBar;
   
    NSMutableArray *placesArray;
    NSArray	*listContent;			// The master content.
	NSMutableArray *filteredListContent;	// The content filtered as a result of a search.
    NSString *myParentIS;
     NSString *placeType;
    NSString *searchedCityString;
}
@property (nonatomic, retain) UISearchDisplayController	*searchDisplayController;
@property (nonatomic, retain) IBOutlet UITableView *searchTableView;
@property (nonatomic, retain) IBOutlet UISearchBar *mySearchBar;

@property(nonatomic, retain) NSString *searchedCityString;
@property(nonatomic, retain) NSString *myParentIS;
@property(nonatomic, retain) NSString *placeType;
@property (nonatomic, retain) NSMutableArray *placesArray;
@property (nonatomic, retain) NSArray *listContent;	
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic)   id<WCSearchBarControllerDelegate> delegate;

-(void)getCityAddresses;

@end
