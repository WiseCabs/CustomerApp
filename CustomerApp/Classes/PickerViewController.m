//
//  PickerViewController.m
//  WiseCabs
//
//  Created by Nagraj on 20/12/12.
//
//

#import "PickerViewController.h"
#import "Common.h"

@interface PickerViewController ()

@end

@implementation PickerViewController
@synthesize myparentIs,pickerTime,pickerVehicle,doneButton,vehicleArray,vehicleName,lblPickerValue,lblPickerType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneSelecting:)  ] autorelease];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit:)] autorelease];
}

-(void)doneButtonTapped:(id)sender{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([myparentIs isEqualToString:@"lblVehicleType"]) {
               
        pickerVehicle=[[UIPickerView alloc] initWithFrame:CGRectMake(0,100,320, 500)];
       
        
        
        pickerVehicle=[[UIPickerView alloc] initWithFrame:CGRectMake(0,100,320, 500)];
        NSArray *tempArray=[[NSArray alloc] initWithObjects:@"Saloon",@"Estate",@"MPV",nil ];
        self.vehicleArray = [NSMutableArray arrayWithArray:tempArray];
        [tempArray release];
        pickerVehicle.showsSelectionIndicator = YES;
        [pickerVehicle setDelegate:self];
        pickerVehicle.dataSource=self;
        pickerVehicle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:pickerVehicle];
        
        self.lblPickerType.text=@"Vehicle Type:";
        NSString *vhicleName= [self.vehicleArray objectAtIndex:0];
        //[Common setVehicleType:vhicleName];
        self.lblPickerValue.text=vhicleName;
        
    }
    else if ([myparentIs isEqualToString:@"lblPaymentType"]){
        pickerVehicle=[[UIPickerView alloc] initWithFrame:CGRectMake(0,100,320, 500)];
        
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneSelecting:)  ] autorelease];
        
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit:)] autorelease];
        pickerVehicle=[[UIPickerView alloc] initWithFrame:CGRectMake(0,100,320, 500)];
        NSArray *tempArray=[[NSArray alloc] initWithObjects:@"Cash",@"Card",@"Account",nil ];
        self.vehicleArray = [NSMutableArray arrayWithArray:tempArray];
        [tempArray release];
        pickerVehicle.showsSelectionIndicator = YES;
        [pickerVehicle setDelegate:self];
        pickerVehicle.dataSource=self;
        pickerVehicle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:pickerVehicle];
        
        self.lblPickerType.text=@"Payment Type:";
        NSString *vhicleName= [self.vehicleArray objectAtIndex:0];
        //[Common setVehicleType:vhicleName];
        self.lblPickerValue.text=vhicleName;
    }
    else{
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm a"];
        NSDate* datetoday = [NSDate date];
        NSDate *minDate = [datetoday dateByAddingTimeInterval:900];
       // NSString *dateToday = [dateFormatter stringFromDate:minDate];
       // [dateFormatter release];
        
        pickerTime=[[UIDatePicker alloc] initWithFrame:CGRectMake(0,100,320, 500)];
        [pickerTime addTarget:self action:@selector(updateValueFromPicker:) forControlEvents:UIControlEventValueChanged];
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneSelecting:)  ] autorelease];
        
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit:)] autorelease];
               
        pickerTime.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        NSLog(@"date to setted is:-  %@",minDate);
        [pickerTime setDate:minDate animated:NO];
        pickerTime.minimumDate=minDate;
        [self.view addSubview:pickerTime];
         lblPickerType.text=@"Journey Time:";
        
        NSDate *myDate = minDate;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd MMM hh:mm a"];
        NSString *formattedDate = [dateFormat stringFromDate:myDate];
        NSLog(@"formattedDate is %@",formattedDate);
        //[Common setJourneyTime:formattedDate];
       // [dateFormat release];
        lblPickerValue.text=formattedDate;
        
    }
    
    //segControlTime
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)updateValueFromPicker:(id)sender {
	//UserJourney *journey =[[Journey searchedJourney] userJourney];
    NSDate *myDate = pickerTime.date;
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"dd MMM hh:mm a"];
	NSString *formattedDate = [dateFormat stringFromDate:myDate];
    NSLog(@"formattedDate is %@",formattedDate);
    //[Common setJourneyTime:formattedDate];
	[dateFormat release];
    lblPickerValue.text=formattedDate;
	//journey.JourneyDate=textDate.text;
}

- (IBAction) doneSelecting:(id)sender
{
    if ([myparentIs isEqualToString:@"lblVehicleType"]) {
       /* if ([Common vehicleType]==nil) {
            NSString *vhicleName= [self.vehicleArray objectAtIndex:0];
            [Common setVehicleType:vhicleName];
        }
        else{*/
            [Common setVehicleType:lblPickerValue.text];
            NSLog(@"[common vehicleType is %@", [Common vehicleType]);
        //}
    }
    else if([myparentIs isEqualToString:@"lblPaymentType"]){
        [Common setPaymentType:lblPickerValue.text];
        NSLog(@"[common vehicleType is %@", [Common paymentType]);
    }
    else{
        NSDate *myDate = pickerTime.date;
        [Common setJourneyTimings:myDate];
        /*NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd MMM hh:mm A"];
        NSString *formattedDate = [dateFormat stringFromDate:myDate];
        NSLog(@"formattedDate is %@",formattedDate);
        [Common setJourneyTime:formattedDate];
        [dateFormat release];*/
        
        
       /* NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        NSString *formattedDate = [dateFormat stringFromDate:myDate];
        [Common setJourneyDate:formattedDate];
        
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"HH:mm"];
        NSString *formattedTime = [timeFormat stringFromDate:myDate];
        [Common setJourneyTime:formattedTime];*/
        
        //NSDate *myDate = PickerDate.date;
        /*NSDateFormatter *timeFormat1 = [[NSDateFormatter alloc] init];
        [timeFormat1 setDateFormat:@"hh:mm a"];
        NSString *formattedTime1 = [timeFormat1 stringFromDate:myDate];
        //searchedJny.=formattedTime1;
        journey.JourneyTimein12Hr=formattedTime1;
        NSLog(@"JourneyTimein12Hr:-",journey.JourneyTimein12Hr);*/
            }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction) cancelEdit:(id)sender
{
    if ([myparentIs isEqualToString:@"lblVehicleType"]) {
        NSString *vehiclename=nil;
        //[Common setJourneyTime:vehiclename];
    }
    else{
        NSString *formattedDate=nil;
        //[Common setJourneyTime:formattedDate];
    }
    //[Common JourneyTimings:nil];
    [self.navigationController popViewControllerAnimated:YES];

}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [self.vehicleArray count];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
    NSString *categoryName= [self.vehicleArray objectAtIndex:row];
    return categoryName;
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.vehicleName= [self.vehicleArray objectAtIndex:row];
    lblPickerValue.text=self.vehicleName;
     
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.rightBarButtonItem=nil;
}

-(void) dealloc{
   
    [myparentIs release];
    [pickerTime release];
    [pickerVehicle release];
    [doneButton release];
    [vehicleArray release];
    [vehicleName release];
    [lblPickerValue release ];
    [lblPickerType release];
    [super dealloc];
}

@end

