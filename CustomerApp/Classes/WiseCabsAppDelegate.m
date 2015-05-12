//
//  WiseCabsAppDelegate.m
//  WiseCabs
//
//  Created by Nagraj Gopalakrishnan on 05/12/11.
//  Copyright 2011 TeamDecode Software Private limited. All rights reserved.
//

#import "WiseCabsAppDelegate.h"
#import "SearchViewController.h"
#import "WebServiceHelper.h"
#import "Common.h"
#import "sqlite3.h"
#import "LocationManager.h"
#import "AddressSearchController.h"
#import "BookingList.h"
#import "FavoriteJourneys.h"
#import "LocationTracker.h"

@implementation WiseCabsAppDelegate
@synthesize window,maintabBarController,splashView;
static sqlite3 *database = nil;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	NSLog(@"inside appdidfinishlaunching") ;
	[Common setWebServiceURL:@"http://www.wisecabs.com/"];
	//[Common setWebServiceURL:@"http://192.168.0.8:8081/WiseCabs/"];
	//[Common setWebServiceURL:@"http://localhost/wisecab/"];
	//[Common setWebServiceURL:@"http://192.168.0.19:8080/wisecabs/"];
    //[Common setWebServiceURL:@"http://test.wisecabs.com/"];
	[self copyDatabaseIfNeeded];
	[NSThread detachNewThreadSelector:@selector(updateTable) toTarget:self withObject:nil];
	[self loadTabBarController];
    //[self customizeAppearance];
	
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)customizeAppearance
{   
    
    // Customing the segmented control
    UIImage *segmentSelected =    [[UIImage imageNamed:@"segcontrol_sel.png"]
                                   resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    UIImage *segmentUnselected =    [[UIImage imageNamed:@"segcontrol_uns.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    UIImage *segmentSelectedUnselected =    [UIImage imageNamed:@"segcontrol_sel-uns.png"];
    UIImage *segUnselectedSelected =    [UIImage imageNamed:@"segcontrol_uns-sel.png"];
    UIImage *segmentUnselectedUnselected =    [UIImage imageNamed:@"segcontrol_uns-uns.png"];
    
    [[UISegmentedControl appearance] setBackgroundImage:segmentUnselected
                                               forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setBackgroundImage:segmentSelected
                                               forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setDividerImage:segmentUnselectedUnselected
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:segmentSelectedUnselected
                                 forLeftSegmentState:UIControlStateSelected
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setDividerImage:segUnselectedSelected
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateSelected
                                          barMetrics:UIBarMetricsDefault];
    
   }


-(void)loadTabBarController{	
	//[self isUserloggedIn];
	
	
    // Override point for customization after application launch.
    maintabBarController=[[UITabBarController alloc] init];
	maintabBarController.delegate=self;
	
    BookingList *myBookings= [[[BookingList alloc] init] autorelease];
	myBookings.tabName=@"MyBookings";
    FavoriteJourneys *favoriteJourneys= [[[FavoriteJourneys alloc] init] autorelease];
	favoriteJourneys.tabName=@"FavoriteJourneys";
    LocationTracker *locationTracker= [[[LocationTracker alloc] init] autorelease];
	locationTracker.tabName=@"LocationTracker";
	
    SearchViewController *searchViewController;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            searchViewController= [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
        }
        if(result.height == 568)
        {
            searchViewController= [[SearchViewController alloc] initWithNibName:@"SearchViewController@iPhone5" bundle:nil];
        }
    }
    //=[[[SearchViewController alloc] init] autorelease];
	float rd = 4.00/255.00;
	float gr = 152.00/255.00;
	float bl = 229.00/255.00;
	
	
	
	UINavigationController *myBookingsNavController=[[[UINavigationController alloc] initWithRootViewController:myBookings] autorelease];
    UINavigationController *favoriteJourneysNavController=[[[UINavigationController alloc] initWithRootViewController:favoriteJourneys] autorelease];
    UINavigationController *locationTrackerNavController=[[[UINavigationController alloc] initWithRootViewController:locationTracker] autorelease];
	UINavigationController *citySearchNavController=[[[UINavigationController alloc] initWithRootViewController:searchViewController] autorelease];
   
	
	citySearchNavController.navigationBar.barTintColor =[UIColor colorWithRed:rd green:gr blue:bl alpha:1.0];
	myBookingsNavController.navigationBar.barTintColor =[UIColor colorWithRed:rd green:gr blue:bl alpha:1.0];
    locationTrackerNavController.navigationBar.barTintColor =[UIColor colorWithRed:rd green:gr blue:bl alpha:1.0];
    favoriteJourneysNavController.navigationBar.barTintColor =[UIColor colorWithRed:rd green:gr blue:bl alpha:1.0];
	
    [citySearchNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [myBookingsNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [locationTrackerNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [favoriteJourneysNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    citySearchNavController.navigationBar.tintColor = [UIColor whiteColor];
    myBookingsNavController.navigationBar.tintColor = [UIColor whiteColor];
    locationTrackerNavController.navigationBar.tintColor = [UIColor whiteColor];
    favoriteJourneysNavController.navigationBar.tintColor = [UIColor whiteColor];
    
    maintabBarController.tabBar.barTintColor = [UIColor blackColor];
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:(38.0/255.0) green:(38.0/255.0) blue:(38.0/255.0) alpha:1.0]];
    
	if([[UIApplication sharedApplication] isStatusBarHidden])
        [maintabBarController view].frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
	else
		[maintabBarController view].frame = CGRectMake(0, 20, 320, ([[UIScreen mainScreen] bounds].size.height-20.0));
	
	
	citySearchNavController.tabBarItem.title=@"Quote and Book";
	myBookingsNavController.tabBarItem.title=@"My Journeys";
    favoriteJourneysNavController.tabBarItem.title=@"Favorite Journeys";
	locationTrackerNavController.tabBarItem.title=@"Track Driver";
	
	citySearchNavController.tabBarItem.image = [UIImage imageNamed:@"city.png"];
	favoriteJourneysNavController.tabBarItem.image = [UIImage imageNamed:@"star.png"];
    locationTrackerNavController.tabBarItem.image = [UIImage imageNamed:@"driverlocator1.png"];
	myBookingsNavController.tabBarItem.image = [UIImage imageNamed:@"page.png"];
	
	
	NSArray *tabbarArray=[NSArray arrayWithObjects:citySearchNavController,myBookingsNavController,favoriteJourneysNavController,locationTrackerNavController,nil];
	maintabBarController.viewControllers=tabbarArray;
	
//	[window addSubview:maintabBarController.view];
    [self.window setRootViewController:maintabBarController];

	
	
}
-(void)isUserloggedIn{
	//Checking is user is loggedIn
	NSString *dbpath = [self getDBPath];
	//NSString *selectUserQuery=[NSString stringWithFormat: @"INSERT INTO loggedInUser (UserId,FirstName,LastName,EmailId,MobileNo) VALUES ('%@\', '%@', '%@', '%@', '%@')",@"1",@"1",@"1",@"1",@"1"];
	NSString *selectUserQuery=[NSString stringWithFormat:@"SELECT UserId,FirstName,LastName,EmailId,MobileNo,SupplierId,Password,UserName FROM loggedInUser"];
    NSLog(@"User select query is %@",selectUserQuery);
	sqlite3_stmt *selectStmt;
	
	if(sqlite3_open([dbpath UTF8String], &database) == SQLITE_OK) {
		const char *sql = [selectUserQuery UTF8String];
		
		if(sqlite3_prepare_v2(database, sql, -1, &selectStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating select statement. '%s'", sqlite3_errmsg(database));
		
		if(sqlite3_step(selectStmt) == SQLITE_ROW )
		{
			//NSInteger date= sqlite3_column_int(selectStmt,0);
			//citySearch.CameFromLoginPage=@"";
			[Common setLoggedInUser:nil];
			User *user=[[User alloc] init];
			user.FirstName=[[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(selectStmt, 1)] autorelease];
			user.LastName=[[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(selectStmt, 2)]autorelease];
			user.ID=[[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(selectStmt, 0)]autorelease];
			user.Email=[[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(selectStmt, 3)]autorelease];
			user.MobileNumber=[[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(selectStmt, 4)]autorelease];
			user.suppID=[[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(selectStmt, 5)]autorelease];
            user.password=[[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(selectStmt, 6)]autorelease];
            user.userName=[[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(selectStmt, 7)]autorelease];
			
			[Common setLoggedInUser:user];
			//[user release];
			//citySearchNavController=[[[UINavigationController alloc] initWithRootViewController:citySearch] autorelease];
			//[self presentModalViewController:navigationController animated:YES];
			
		}
		else{
			//citySearchNavController=[[[UINavigationController alloc] initWithRootViewController:loginPage] autorelease];
		}
		sqlite3_reset(selectStmt);
	}
	//sqlite3_finalize(selectStmt);
	sqlite3_close(database);
}



-(void)updateTable{
	//NSString *dbpath = [self getDBPath];
		LocationManager *locManager=[[[LocationManager alloc]initLocationManager] autorelease];
    [locManager updateTables];
	
}
/*
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
 // CitySearch *citySearch=[[[CitySearch alloc] init] autorelease];
 
 if ([tabBarController selectedIndex]==1) {
 NSLog(@"tab 1");
 self.tabName=@"MyBookings";
 }
 if ([tabBarController selectedIndex]==2) {
 tabName=@"OldJourney";
 }
 if ([tabBarController selectedIndex]==3) {
 tabName=@"Favorite";
 }
 }
 
 */



- (void) copyDatabaseIfNeeded {
	
	//Using NSFileManager we can perform many file system operations{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath]; 
	
	if(!success) {
		
		NSLog(@"db doesnt exist");
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"WiseCabsAppDB.sqlite3"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		
		if (!success) 
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
	else
	{
		NSLog(@"db already exist");
	}
}

- (NSString *) getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *docpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [docpaths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"WiseCabsAppDB.sqlite3"];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter]
	 postNotificationName:@"needToUpdateTables"
	 object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
