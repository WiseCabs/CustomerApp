//
//  FavoriteJourneys.m
//  WiseCabs
//
//  Created by Nagraj on 29/05/13.
//
//

#import "FavoriteJourneys.h"
#import "BookingTVC.h"
#import "Common.h"
#import "UserJourney.h"
#import "UserJourneyList.h"
#import "Journey.h"
#import "BookingDetail.h"
#import "WiseCabsAppDelegate.h"


@interface FavoriteJourneys ()

@end

@implementation FavoriteJourneys
@synthesize favoriteTableView,myBookingArray,groupedArray,uniqueArray,jnyDict,tabName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"Favorite Journeys";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(showLogoutPage:)  ] autorelease];
	
	
   

}

-(void) viewWillAppear:(BOOL)animated{
    self.myBookingArray=[[UserJourneyList Journeys] FavouriteJourney];
	NSLog(@"myBookingArray count is: %d",[myBookingArray count]);
	[self getUpdatedBookingArray];
}

-(IBAction)showLogoutPage:(id)sender {
	
	NSLog(@"User is logged in");
	UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	[logoutAlert addButtonWithTitle:@"Yes"];
	[logoutAlert addButtonWithTitle:@"No"];
	logoutAlert.cancelButtonIndex = 1;
	[logoutAlert show];
	[logoutAlert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [Journey deallocJourney];
        [Common setLoggedInUser:nil];
        //self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(showLoginPage:)  ] autorelease];
        WiseCabsAppDelegate *appDelegate = (WiseCabsAppDelegate *)[[UIApplication sharedApplication] delegate];
        UIViewController *myViewController1 = [appDelegate.maintabBarController.viewControllers objectAtIndex:1];
        [myViewController1 tabBarItem].enabled = FALSE;
        UIViewController *myViewController2 = [appDelegate.maintabBarController.viewControllers objectAtIndex:2];
        [myViewController2 tabBarItem].enabled = FALSE;
        UIViewController *myViewController3 = [appDelegate.maintabBarController.viewControllers objectAtIndex:3];
        [myViewController3 tabBarItem].enabled = FALSE;
        [appDelegate.maintabBarController setSelectedIndex:0];
        
        
    }
}


-(NSArray *)getUpdatedBookingArray
{
	
        if (self.myBookingArray!=nil && [self.myBookingArray count]>0) {
            
            
            self.jnyDict= [[[NSMutableDictionary alloc] init] autorelease];
            self.uniqueArray= [NSMutableArray array];
            NSString *dateString;
            NSMutableSet * mutableSet = [NSMutableSet set];
            for (Journey * jny in self.myBookingArray) {
                dateString=jny.userJourney.JourneyDate;
                [jnyDict setObject:jny forKey:dateString];
                
                if ([mutableSet containsObject:dateString] == NO) {
                    [self.uniqueArray addObject:jny];
                    [mutableSet addObject:dateString];
                }
            }
            NSArray *allArray;
            self.groupedArray=[[[NSMutableArray alloc] init] autorelease];
            for ( int i=0; i<=[self.uniqueArray count]-1; i++) {
                allArray=[NSString stringWithFormat:@"allArray%i",i];
                Journey *jny=[self.uniqueArray objectAtIndex:i];
                NSString *jnyDate=jny.userJourney.JourneyDate;
                NSLog(@"jnydate is %@",jnyDate);
                NSLog(@"myBookingArray count is %d",[self.myBookingArray count]);
                allArray=[self.myBookingArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(JourneyDate == %@)", jnyDate]];
                [self.groupedArray addObject:allArray];
            }
            
            
            
            NSLog(@"Completed Journey list count is %d",[self.myBookingArray count]);
        }
        
        
	
	
    return myBookingArray;
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
   
        return [uniqueArray count];
       
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger noOfSection=0;	
    noOfSection =[[groupedArray objectAtIndex:section] count];    
	return noOfSection;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *headerTitle=@"";
    Journey *journey=[uniqueArray objectAtIndex:section];
    headerTitle=journey.userJourney.JourneyDate;    
    NSLog(@"%@",headerTitle);
	return headerTitle;
    
}

// Customize the appearance of table view cells.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"BookingTVC";
	BookingTVC *cell = (BookingTVC *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell==nil){
		NSArray *toplevelObjects=[[NSBundle mainBundle] loadNibNamed:@"BookingTVC" owner:nil options:nil];
		
		
		for(id currentObject in toplevelObjects){
			
			if([currentObject isKindOfClass:[UITableViewCell class]])
			{
                Journey *journey=nil;
				NSArray *jny=[groupedArray objectAtIndex:indexPath.section];
                journey=[jny objectAtIndex:indexPath.row];
                cell=(BookingTVC *) currentObject;
				cell.fromAddress.text=journey.userJourney.FromAddress.AddressText;
				cell.toAddress.text=journey.userJourney.ToAddress.AddressText;
				NSString *CapitalTime=[journey.userJourney.JourneyTime uppercaseString];
				cell.timeLabel.text=[NSString stringWithFormat:@"%@",CapitalTime];
				
				UIImage *myImage = [UIImage imageNamed:@"telephonic.png"];
				UIImageView *imgView = [[UIImageView alloc] initWithImage:myImage];
				[cell setBackgroundView:imgView];
				[imgView release];

			}
			
		}
		
	}
	
	
    
    
	return cell;
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	if ([Common isNetworkExist]>0)
	{
		
                
        BookingDetail *bookingDetails = [[BookingDetail alloc] init];
        NSArray *jny;
        
            jny=[groupedArray objectAtIndex:indexPath.section];
            bookingDetails.journeyType=@"Favorite";
       
        bookingDetails.journey=[jny objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:bookingDetails animated:YES];
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [bookingDetails autorelease];
        
	}else {
		[Common showNetwokAlert];
	}
	
	
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([Common isNetworkExist]>0)
	{        
        BookingDetail *bookingDetails = [[BookingDetail alloc] init];
        NSArray *jny;
        
        jny=[groupedArray objectAtIndex:indexPath.section];
        bookingDetails.journeyType=@"Favorite";        
        bookingDetails.journey=[jny objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:bookingDetails animated:YES];
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [bookingDetails autorelease];
        
	}else {
		[Common showNetwokAlert];
	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    [favoriteTableView release];
    [groupedArray release];
    [myBookingArray release];
    [uniqueArray release];
    [jnyDict release];
    [tabName release];
    [super dealloc];
}

@end
