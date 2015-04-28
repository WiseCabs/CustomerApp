//
//  PickerViewController.h
//  WiseCabs
//
//  Created by Nagraj on 20/12/12.
//
//

#import <UIKit/UIKit.h>

@interface PickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
    NSString *myparentIs;
    NSString *vehicleName;
    
    UIDatePicker *pickerTime;
    UIPickerView *pickerVehicle;
    IBOutlet UIButton *doneButton;
    IBOutlet UILabel *lblPickerValue;
    IBOutlet UILabel *lblPickerType;
    NSMutableArray *vehicleArray;
}
@property(nonatomic,retain) NSString *myparentIs;
@property(nonatomic,retain) NSString *vehicleName;
@property(nonatomic,retain)NSMutableArray *vehicleArray;

@property(nonatomic, retain) UIDatePicker *pickerTime;
@property(nonatomic, retain) UIPickerView *pickerVehicle;
@property(nonatomic, retain) IBOutlet UIButton *doneButton;
@property(nonatomic, retain) IBOutlet UILabel *lblPickerValue;
@property(nonatomic, retain) IBOutlet UILabel *lblPickerType;

//-(void)doneButtonTapped:(id)sender;
- (IBAction) doneSelecting:(id)sender;
@end
