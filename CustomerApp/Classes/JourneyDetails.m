//
//  JourneyDetails.m
//  WiseCabs
//
//  Created by Nagraj Gopalakrishnan on 29/12/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import "JourneyDetails.h"
#import "CoPassengerTableViewCell.h"

@implementation JourneyDetails
@synthesize DateLabel,TimeLabel,PassengersLabel,BagsLabel,CoPassengersLabel,SupplierNameLabel,CabNumberLabel,CabDriverNameLabel,FareValueLabel, COPassengersTableView;
@synthesize journey,ImageStar,ImageTableViewContanier,MainScrollView,ViewDriverDetails,ViewTableView,Isparked,totalCopassenger;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


- (void)viewDidLoad {
	self.title=@"Journey Details";
	if (self.Isparked) {
		NSLog(@"Journey is parked");
		ViewDriverDetails.hidden=YES;
	}
	else {
		NSLog(@"Journey is not parked");
	}
	
	DateLabel.text=[NSString stringWithFormat:@"Date: %@",journey.userJourney.JourneyDate];
	NSString *CapitalTime=[journey.userJourney.JourneyTime uppercaseString];
	TimeLabel.text=[NSString stringWithFormat:@"Time: %@",CapitalTime];
	PassengersLabel.text=[NSString stringWithFormat:@"Passengers: %d",journey.userJourney.NumberOfPassenger];
	BagsLabel.text=[NSString stringWithFormat:@"Bags: %d",journey.userJourney.NumberOfBags];
	//GenderLabel.text=[NSString stringWithFormat:@"Gender: %@",journey.userJourney.Gender];
	CoPassengersLabel.text=[NSString stringWithFormat:@"Co-Passengers: %d",[journey.CoPassengers count]];
	SupplierNameLabel.text=[NSString stringWithFormat:@"Supplier Name: %@",journey.JourneySupplier.supplierName];
	CabNumberLabel.text=[NSString stringWithFormat:@"Cab Number: %@",journey.JourneySupplier.cabNumber];
	CabDriverNameLabel.text=[NSString stringWithFormat:@"Driver Name: %@",journey.JourneySupplier.cabDriverName];
	NSLog(@"fare is %d",journey.userJourney.Fare);
	
	
	
	
	NSLog(@"totalpassengers is %d",journey.totalpassengers);
	float IndFare = (float)journey.userJourney.Fare /journey.totalpassengers;
	float AllFare=(float)IndFare*journey.userJourney.NumberOfPassenger;
	NSLog(@"IndividualFare is %f",IndFare);
	NSLog(@"IndividualFare is %.2f",IndFare);
	NSLog(@"AllFare is %.2f",AllFare);
	NSString *asd=[NSString stringWithFormat:@"%f",IndFare];
	//[NSString stringWithFormat:@"%.2f", [sum doubleValue]];
	NSLog(@"JourneyType is %@",journey.userJourney.JourneyType);
	Journey *jny=[[Journey alloc] init];
	if ([journey.userJourney.JourneyType isEqualToString:@"DEDICATED"]) {
		FareValueLabel.text=[NSString stringWithFormat:@"%@ %.2f",[jny currencySymbol],(float)journey.userJourney.Fare];
	}
	else {
		FareValueLabel.text=[NSString stringWithFormat:@"%@ %.2f",[jny currencySymbol],[asd floatValue]*journey.userJourney.NumberOfPassenger];
	}
	[jny release];	
	//NSLog(@"IsFavorite: %@", journey.userJourney.IsFavorite?@"1":@"0");
	
	if (journey.userJourney.IsFavorite==0) {
		self.ImageStar.hidden=YES;
	}
	else {
		self.ImageStar.hidden=NO;
	}		
	
	CGFloat height=0.0;
	if ([journey.CoPassengers count]>1) {
		height=280.0;
		MainScrollView.contentSize= CGSizeMake(320, 500);
		[ViewDriverDetails setFrame:CGRectMake(0.0, 388.0, 271.0, 31.0)];
	}else if ([journey.CoPassengers count]>0){
		height=140.0;
	}
	if ([journey.CoPassengers count]==0)
	{
		ViewTableView.hidden=YES;
		//ImageTableViewContanier.hidden=YES;
		//COPassengersTableView.hidden=YES;
		[ViewDriverDetails setFrame:CGRectMake(0.0, 68.0, 271.0, 31.0)];
		
	}
    [ImageTableViewContanier setFrame:CGRectMake(ImageTableViewContanier.frame.origin.x, ImageTableViewContanier.frame.origin.y, ImageTableViewContanier.frame.size.width, height+10)];
	[COPassengersTableView setFrame:CGRectMake(COPassengersTableView.frame.origin.x, COPassengersTableView.frame.origin.y, COPassengersTableView.frame.size.width, height)];
	
	
	
	
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSLog(@" count is %d",[journey.CoPassengers count]);
	 return [journey.CoPassengers count];
	//return 1;
	
}

- (void)viewWillDisappear:(BOOL)animated
{
	
}
// Customize the appearance of table view cells.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"CoPassengerTableViewCell";	
	CoPassengerTableViewCell *cell = (CoPassengerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell==nil){
		NSArray *toplevelObjects=[[NSBundle mainBundle] loadNibNamed:@"CoPassengerTableViewCell" owner:nil options:nil];
		
		
		for(id currentObject in toplevelObjects){
			
			if([currentObject isKindOfClass:[UITableViewCell class]]){
				
				cell=(CoPassengerTableViewCell *) currentObject;
				UserJourney *jny=[journey.CoPassengers objectAtIndex:indexPath.row];
				cell.FromAddress1.text=[NSString stringWithFormat:@" %@",jny.FromAddress.AddressText];
				cell.ToAddress1.text=[NSString stringWithFormat:@"%@",jny.ToAddress.AddressText];
				NSString *CapitalCopassengerTime=[jny.JourneyTime uppercaseString];
				cell.Time.text=[NSString stringWithFormat:@"Time: %@",CapitalCopassengerTime];
				cell.Date.text=[NSString stringWithFormat:@"Date: %@",jny.JourneyDate];
				totalCopassenger+=jny.NumberOfPassenger;
				NSLog(@"total co passenger is %d",totalCopassenger);
				cell.Passengers.text=[NSString stringWithFormat:@"Passengers: %d",jny.NumberOfPassenger];
				cell.Bags.text=[NSString stringWithFormat:@"Bags: %d",jny.NumberOfBags];
				cell.Gender.text=[NSString stringWithFormat:@"Gender: %@",jny.Gender];
				UIImage *myImage = [UIImage imageNamed:@"tableViewCellBackground.png"];
				UIImageView *imgView = [[UIImageView alloc] initWithImage:myImage];
				[cell setBackgroundView:imgView];
				[imgView release];
				break;
			}
			
		}
		
	}
		
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[DateLabel release];
	[TimeLabel release];
	[PassengersLabel release];
	[BagsLabel release];
	//[GenderLabel release];
	[CoPassengersLabel release];
	[SupplierNameLabel release];
	[CabNumberLabel release];
	[CabDriverNameLabel release];
	[FareValueLabel release];
	[COPassengersTableView release];
	[journey release];
	[ImageStar release];
	[ImageTableViewContanier release ];
	[MainScrollView release];
	[ViewDriverDetails release];
	[ViewTableView release];

    [super dealloc];
}


@end
