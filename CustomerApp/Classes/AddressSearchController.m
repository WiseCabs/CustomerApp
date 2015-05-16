//
//  AddressSearchController.m
//  WiseCabs
//
//  Created by Nagraj on 17/12/12.
//
//

#import "AddressSearchController.h"
#import "OLGhostAlertView.h"
#import "ALToastView.h"
#import "SearchBarController.h"
#import "UserJourney.h"
#import "Journey.h"
#import "Common.h"
#import "LocationManager.h"
#import "MBProgressHUD.h"

@interface AddressSearchController ()

@end

@implementation AddressSearchController

@synthesize textKeyDetails,textCategoryType,myParentIS,/*CategoryPicker,*/categoryArray,selectedLocationID,selectedLocationName,selectedcategoryName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
//    textCategoryType.inputView=CategoryPicker;
//     CategoryPicker.hidden=NO;
    if ([myParentIS isEqualToString:@"From Address"]) {
        self.navigationItem.title=@"From Address";
    }
    else{
        self.navigationItem.title=@"To Address";
    }
//    if ([textCategoryType.text isEqualToString:@""]) {
//        textKeyDetails.enabled = NO;
//        textKeyDetails.placeholder=@"Select Category type first";
//    }
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
}

-(void)updateTable{
	//NSString *dbpath = [self getDBPath];
    [NSThread detachNewThreadSelector:@selector(showProgress) toTarget: self withObject: nil];
    LocationManager *locManager=[[[LocationManager alloc]initLocationManager] autorelease];
    [locManager updateTables];
	[MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)showProgress{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText=@"Fetching Search data..";
	//hud.detailsLabelText=@"Updating";
	hud.square=YES;
	[pool release];
}
-(void)checkIfTablesUpdated{
    if (![[Common tableUpdated] isEqualToString:@"Yes"] || [Common tableUpdated]==nil) {
        if ([Common isNetworkExist]) {
            [NSThread detachNewThreadSelector:@selector(updateTable) toTarget:self withObject:nil];
            
        }
        else{
            [Common showNetwokAlert];
        }
        
    }
}

- (void)getUpdatedTables:(NSNotification *)notification {
    [self checkIfTablesUpdated];
}
- (void)viewDidLoad
{
   
    [self checkIfTablesUpdated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUpdatedTables:) name:@"needToUpdateTables" object:nil];
    [super viewDidLoad];
   
    [textCategoryType addTarget:self action:@selector(textFieldBecameActive:) forControlEvents:UIControlEventEditingDidBegin];
    [textKeyDetails addTarget:self action:@selector(textFieldBecameActive:) forControlEvents:UIControlEventEditingDidBegin];
    
    textCategoryType.text = @"City";
    textKeyDetails.placeholder=@"Search..";
    textCategoryType.enabled = NO;

    
//    self.CategoryPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0,100,320, 500)];
//	[self.CategoryPicker setDelegate:self];
//	self.CategoryPicker.dataSource=self;
//    //[CategoryPicker selectRow:0 inComponent:0 animated:YES];
//	CategoryPicker.showsSelectionIndicator = YES;
    
    NSArray *tempArray=[[NSArray alloc] initWithObjects:@"City",@"Airport",@"Tube",@"Train",nil ];
	self.categoryArray = [NSMutableArray arrayWithArray:tempArray];
    [tempArray release];
    // Do any additional setup after loading the view from its nib.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}


-(void)touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event {
    NSArray *subviews = [self.view subviews];
    for (id objects in subviews) {
        if ([objects isKindOfClass:[UITextField class]]) {
            UITextField *theTextField = objects;
            if ([objects isFirstResponder]) {
                [theTextField resignFirstResponder];
            }
        }
    }
}


- (IBAction)textFieldBecameActive:(id)sender{
    
    if ([self.textKeyDetails isFirstResponder]){
       
        
        self.navigationItem.leftBarButtonItem=nil;
        self.navigationItem.rightBarButtonItem=nil;
        SearchBarController *searchController=[[SearchBarController alloc]init];
            searchController.myParentIS=self.myParentIS;
            searchController.placeType=[NSString stringWithFormat:@"%@",textCategoryType.text];
            [ self.navigationController pushViewController:searchController animated:NO];
            self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
               
    }
    else if([self.textCategoryType isFirstResponder]){
        
        if ([self.textCategoryType.text isEqualToString:@""] && [categoryArray count]>0) {
            
            NSString *categoryName=[categoryArray objectAtIndex:0];
            self.textCategoryType.text=categoryName;           
            self.textKeyDetails.enabled=YES;
            textKeyDetails.placeholder=@"Search..";
        }
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard:)  ] autorelease];
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit:)] autorelease];
    }
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
   	
	UIWindow *tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	UIView *keyboard;
	for (int i = 0; i < [tempWindow.subviews count]; i++) {
		keyboard = [tempWindow.subviews objectAtIndex:i];
		// keyboard view found; add the Custom button to it
		if ([[keyboard description] hasPrefix:@"<UIPeripheralHostView"] == YES) {
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard:)  ] autorelease];
			
			//self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit:)] autorelease];
			self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit:)] autorelease];
		}
	}
}


- (IBAction)dismissKeyboard:(id)sender
{
    if ([self.textCategoryType isFirstResponder]) {
        
        [self.textCategoryType resignFirstResponder];
        selectedcategoryName=[NSString stringWithFormat:@"%@",textCategoryType.text];
       
    }
    
    [self.textKeyDetails resignFirstResponder];
    self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.rightBarButtonItem = nil;
}


- (IBAction) cancelEdit:(id)sender
{
    if (self.textCategoryType.isFirstResponder) {
		[textCategoryType setText:@""];
		[self.textCategoryType resignFirstResponder];
       // if (![textCategoryType.text isEqualToString:@""]) {
            textKeyDetails.enabled = NO;
            textKeyDetails.placeholder=@"Select Category type first";
        //}
	}
    else{
        [textKeyDetails setText:@""];
        [self.textKeyDetails resignFirstResponder];
    }
    
	self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.rightBarButtonItem = nil;
	//NSLog(@"[[journey ToAddress]LocationName] is %@",[[journey ToAddress]LocationName]);
    
}

//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//	return 1;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//	return [self.categoryArray count];
//		
//}
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//	
//		NSString *categoryName= [self.categoryArray objectAtIndex:row];
//    return categoryName;
//	    
//}
//
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    NSString *categoryName= [self.categoryArray objectAtIndex:row];
//	textCategoryType.text=categoryName;
//    /*if (![textCategoryType.text isEqualToString:@""]) {
//        textKeyDetails.enabled = YES;
//        textKeyDetails.placeholder=@"Search..";
//    }*/
//}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated{
    if (self.textKeyDetails.isFirstResponder) {
        [self.textKeyDetails resignFirstResponder];
    }
//    CategoryPicker.hidden=YES;
    
}

- (void)viewDidDisappear:(BOOL)animated{
    if (self.textKeyDetails.isFirstResponder) {
        [self.textKeyDetails resignFirstResponder];
    }
//    CategoryPicker.hidden=YES;
    
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[myParentIS release];
//    [CategoryPicker release];
    [textCategoryType release];
    [textKeyDetails release];
    [categoryArray release];
    [selectedLocationID release];
    [selectedLocationName release];
    [selectedcategoryName release];
    [super dealloc];
}


@end
