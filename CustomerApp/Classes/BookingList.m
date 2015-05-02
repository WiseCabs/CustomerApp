//
//  BookingList.m
//  WiseCabs
//
//  Created by Nagraj on 31/12/12.
//
//

#import "BookingList.h"
#import "OldJourneyTableViewCell.h"
#import "Common.h"
#import "UserJourney.h"
#import "WebServiceHelper.h"
#import "User.h"
#import "Journey.h"
#import "JourneyHelper.h"
#import "JourneyDetails.h"
#import "WiseCabsAppDelegate.h"
#import "UserJourneyList.h"
#import "LoginPage.h"
#import "BookingDetail.h"
#import "BookingTVC.h"
#import "JourneyNotification.h"


@interface BookingList ()

@end

@implementation BookingList
@synthesize jnyTableView,mainSegmentControl,tabName,myBookingArray,groupedCompletedArray,groupedScheduledArray,uniqueScheduledArray,jnyDict,uniqueCompletedArray,jnysloaded,updatetimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    NSLog(@"SELECTEDTAB:%@",[self tabName]);
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataUpdated:) name:@"DataUpdatedNotification" object:nil];
    //updatetimer = [NSTimer scheduledTimerWithTimeInterval: 60.0 target: self selector:@selector(onTick:) userInfo: nil repeats:YES];
    [self performSelector:@selector(updatejourney) withObject:nil afterDelay:0];
    
    //[NSThread detachNewThreadSelector:@selector(onTick) toTarget:self withObject:nil];

}


- (void)viewDidLoad
{
    jnysloaded=NO;
    self.title=@"My Journeys";
    [super viewDidLoad];
    [mainSegmentControl setFrame:CGRectMake(42.0, 0.0, 241.0, 38.0)];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(showLogoutPage:)  ] autorelease];
	
	
    myBookingArray=[[UserJourneyList Journeys] CompletedJourney];
	NSLog(@"myBookingArray count is: %lu",(unsigned long)[myBookingArray count]);       //64 bit changes
	mainSegmentControl.selectedSegmentIndex=0;
	[self getUpdatedBookingArray];
	       // NSLog(@"reloading tableview");
		//[jnyTableView reloadData];
     
    // Do any additional setup after loading the view from its nib.
}

-(void) updatejourney
{
    [self showUpdate:@"Updating" detailtext:@"Updating Journey"];
}

-(void)showUpdate:(NSString*)lable detailtext:(NSString*)detailsText
{
	if ([Common isNetworkExist] ) {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = lable;
        HUD.detailsLabelText = detailsText;
        HUD.square = YES;
        [HUD showWhileExecuting:@selector(getJny) onTarget:self withObject:nil animated:YES];
	}
	else {
        
            
        }
		//[Common showConnectionAlert];
    
	//[self.mainTableView reloadData];
}

-(void)getJny{
    //JourneyNotification *jnyNotification=[[JourneyNotification alloc] init];
	//[jnyNotification getAllJourneyList];
    
    JourneyHelper *helper=[[JourneyHelper alloc] init];
    [helper getMyBookings];

    [self getUpdatedBookingArray];
    //[HUD hide:YES];
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
    
	[jnyTableView reloadData];
}

-(NSArray *)getUpdatedBookingArray
{
	if (mainSegmentControl.selectedSegmentIndex == 0 )
	{
        NSLog(@"Scheduled journey");
		myBookingArray=[[UserJourneyList Journeys] ScheduledJourney];
        
        NSLog(@"Scheduled Journey list count is %lu",(unsigned long)[myBookingArray count]);    //64 bit changes
        if (myBookingArray!=nil && [self.myBookingArray count]>0) {
            
            
            self.jnyDict= [[[NSMutableDictionary alloc] init] autorelease];
            self.uniqueScheduledArray= [NSMutableArray array];
            NSString *dateString;
            NSMutableSet * mutableSet = [NSMutableSet set];
            for (Journey * jny in myBookingArray) {
                dateString=jny.userJourney.JourneyDate;
                [jnyDict setObject:jny forKey:dateString];
                
                if ([mutableSet containsObject:dateString] == NO) {
                    [self.uniqueScheduledArray addObject:jny];
                    [mutableSet addObject:dateString];
                }
            }
            NSArray *allArray;
            self.groupedScheduledArray=[[[NSMutableArray alloc] init] autorelease];
            for ( int i=0; i<=[uniqueScheduledArray count]-1; i++) {
                allArray=[NSString stringWithFormat:@"allArray%i",i];
                Journey *jny=[uniqueScheduledArray objectAtIndex:i];
                NSString *jnyDate=jny.userJourney.JourneyDate;
                NSLog(@"jnydate is %@",jnyDate);
                NSLog(@"myBookingArray count is %lu",(unsigned long)[myBookingArray count]);        //64 bit changes
                allArray=[self.myBookingArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(JourneyDate == %@)", jnyDate]];
                [self.groupedScheduledArray addObject:allArray];
            }
            
            
            
            NSLog(@"Completed Journey list count is %lu",(unsigned long)[myBookingArray count]);        //64 bit changes
        }

        
        
        
		//[oldJourneyTableView setFrame:CGRectMake(0.0, 0.0,self.view.frame.size.width, self.view.frame.size.height)];
			}
	
	else  {
		NSLog(@"old journey:completed");
		myBookingArray=[[UserJourneyList Journeys] CompletedJourney];
            }
	
    	return myBookingArray;
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

-(IBAction) SegmentedControlChanged
{
		if (mainSegmentControl.selectedSegmentIndex == 0) {
			myBookingArray=[[UserJourneyList Journeys] ScheduledJourney];
			
		}
		else {
            if (!jnysloaded) {
                myBookingArray=[[UserJourneyList Journeys] CompletedJourney];
                //[jnyTableView reloadData];
                if (myBookingArray!=nil && [self.myBookingArray count]>0) {
                    
                    
                    groupedCompletedArray=nil;
                    self.jnyDict= [[[NSMutableDictionary alloc] init] autorelease];
                    NSString *date;
                    self.uniqueCompletedArray= [NSMutableArray array];
                    NSMutableSet * mutableSet = [NSMutableSet set];
                    for (Journey * jny in myBookingArray) {
                        date=jny.JourneyDate;
                        [jnyDict setObject:jny forKey:date];
                        
                        if ([mutableSet containsObject:date] == NO) {
                            [self.uniqueCompletedArray addObject:jny];
                            [mutableSet addObject:date];
                        }
                    }
                    
                    NSArray *allArray;
                    self.groupedCompletedArray=[[[NSMutableArray alloc] init] autorelease];
                    for ( int i=0; i<=[uniqueCompletedArray count]-1; i++) {
                        allArray=[NSString stringWithFormat:@"allArray%i",i];
                        Journey *jny=[uniqueCompletedArray objectAtIndex:i];
                        NSString *jnyDate=jny.JourneyDate;
                        allArray=[self.myBookingArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(JourneyDate == %@)", jnyDate]];
                        [self.groupedCompletedArray addObject:allArray];
                    }
                    
                    
                    
                }
                jnysloaded=YES;
            }
			
        }
	[jnyTableView reloadData];
    
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


-(void)dataUpdated:(NSNotification*)notification{
	NSLog(@"dataUpdated method called");
    
	[self performSelectorOnMainThread:@selector(getJourney) withObject:nil waitUntilDone:YES];
    // [self getJourney];
}
-(void)getJourney{
	[self getUpdatedBookingArray];
    
   
    
	[jnyTableView reloadData];
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	if(mainSegmentControl.selectedSegmentIndex==0){
        return [uniqueScheduledArray count];
    }
    else{
        return [uniqueCompletedArray count];
    }
			
		
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *headerTitle=@"";
    
		if ([myBookingArray count]==0) {
			headerTitle=@"  ";
		}
		else if(mainSegmentControl.selectedSegmentIndex==0){
			Journey *journey=[uniqueScheduledArray objectAtIndex:section];
			headerTitle=journey.userJourney.JourneyDate;
		}
    else if(mainSegmentControl.selectedSegmentIndex==1){
        Journey *journey=[uniqueCompletedArray objectAtIndex:section];
        headerTitle=journey.userJourney.JourneyDate;
    }
    NSLog(@"%@",headerTitle);
	return headerTitle;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger noOfSection=0;
	if (mainSegmentControl.selectedSegmentIndex == 0)
    {
        noOfSection =[[groupedScheduledArray objectAtIndex:section] count];
    }
    else{
        noOfSection =[[groupedCompletedArray objectAtIndex:section] count];
    }
    
	return noOfSection;
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
                if (mainSegmentControl.selectedSegmentIndex == 0)
                {
                    NSArray *jny=[groupedScheduledArray objectAtIndex:indexPath.section];
                    journey=[jny objectAtIndex:indexPath.row];
                }
                
                else if (mainSegmentControl.selectedSegmentIndex == 1)
                {
                    
                    NSArray *jny=[groupedCompletedArray objectAtIndex:indexPath.section];
                    journey=[jny objectAtIndex:indexPath.row];
                    //journey=[travelarray objectAtIndex:[indexPath row]];
                }
				//Journey *jny=[myBookingArray objectAtIndex:indexPath.row];
				
                cell=(BookingTVC *) currentObject;
				cell.fromAddress.text=journey.userJourney.FromAddress.AddressText;
				cell.toAddress.text=journey.userJourney.ToAddress.AddressText;
				NSString *CapitalTime=[journey.userJourney.JourneyTime uppercaseString];
				cell.timeLabel.text=[NSString stringWithFormat:@"%@",CapitalTime];
				
				UIImage *myImage = [UIImage imageNamed:@"telephonic.png"];
				UIImageView *imgView = [[UIImageView alloc] initWithImage:myImage];
				[cell setBackgroundView:imgView];
				[imgView release];
				
				/*if (jny.userJourney.IsFavorite==0) {
					cell.ImageStar.hidden=YES;
				}
				else {
					cell.ImageStar.hidden=NO;
				}*/
				
				break;
			}
			
		}
		
	}
	
	
    
    
	return cell;
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	if ([Common isNetworkExist]>0)
	{
		
			/*JourneyDetails *journeyDetails = [[JourneyDetails alloc] init];
			journeyDetails.journey=[myBookingArray objectAtIndex:indexPath.row];
			[self.navigationController pushViewController:journeyDetails animated:YES];
			self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			[journeyDetails autorelease];*/
        
        BookingDetail *bookingDetails = [[BookingDetail alloc] init];
        NSArray *jny;
        if(mainSegmentControl.selectedSegmentIndex==0){
          jny=[groupedScheduledArray objectAtIndex:indexPath.section];
            bookingDetails.journeyType=@"Scheduled";
        }
        else{
            jny=[groupedCompletedArray objectAtIndex:indexPath.section];
            bookingDetails.journeyType=@"Completed";
        }
        
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
        if(mainSegmentControl.selectedSegmentIndex==0){
            jny=[groupedScheduledArray objectAtIndex:indexPath.section];
        }
        else{
            jny=[groupedCompletedArray objectAtIndex:indexPath.section];
        }
        
        bookingDetails.journey=[jny objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:bookingDetails animated:YES];
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [bookingDetails autorelease];
	    
	}else {
		[Common showNetwokAlert];
	}
}

-(void) viewWillDisAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [HUD hide:YES];
	
}



-(void) dealloc{
    [jnyTableView release];
    [mainSegmentControl release];
    [tabName release];
    [myBookingArray release];
    [groupedCompletedArray release];
    [groupedScheduledArray release];
    [uniqueScheduledArray release];
    [uniqueCompletedArray release];
    [jnyDict release];
    [super dealloc];
}

@end
