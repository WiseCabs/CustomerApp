//
//  AddressSearchController.h
//  WiseCabs
//
//  Created by Nagraj on 17/12/12.
//
//

#import <UIKit/UIKit.h>
#import "SearchBarController.h"


@interface AddressSearchController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate,WCSearchBarControllerDelegate >
{
    IBOutlet UITextField *textCategoryType;
	IBOutlet UITextField *textKeyDetails;
//    IBOutlet UIPickerView *CategoryPicker;
    
    NSMutableArray *categoryArray;
    
    NSString *myParentIS;
    NSString *selectedLocationID;
    NSString *selectedLocationName;
    NSString *selectedcategoryName;
}
@property(nonatomic, retain) IBOutlet UITextField *textCategoryType;
@property(nonatomic, retain) IBOutlet UITextField *textKeyDetails;
//@property(nonatomic, retain) IBOutlet UIPickerView *CategoryPicker;

@property (nonatomic, retain) NSMutableArray *categoryArray;

@property(nonatomic, retain) NSString *myParentIS;
@property(nonatomic, retain) NSString *selectedLocationID;
@property(nonatomic, retain) NSString *selectedLocationName;
@property(nonatomic, retain) NSString *selectedcategoryName;
@property(nonatomic, retain) id delegate;


-(void)checkIfTablesUpdated;
-(void)updateTable;
@end
