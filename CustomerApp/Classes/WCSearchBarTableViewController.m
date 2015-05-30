//
//  WCSearchBarTableViewController.m
//  WiseCabs
//
//  Created by Apoorv Garg on 23/05/15.
//
//

#import "WCSearchBarTableViewController.h"
#import "Places.h"
#import "WiseCabsAppDelegate.h"
#import "UserJourney.h"
#import "Journey.h"
#import "Common.h"
#import "WebServiceHelper.h"
#import "SearchViewController.h"

@interface WCSearchBarTableViewController ()

@property(nonatomic, retain) NSString *searchedCityString;
@property(nonatomic, retain) NSString *placeType;
@property(nonatomic, retain) NSIndexPath *selectedIndexPath;
@property(nonatomic, retain) NSMutableDictionary *placeDict;



@end

@implementation WCSearchBarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = self.myParentIS;
    
    self.filteredListContent = [[[NSMutableArray alloc] init] autorelease];
    self.placeType = @"City";

    [self.addressSearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.addressSearchBar sizeToFit];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"[filteredListContent count] is-- %lu",(unsigned long)[self.filteredListContent count]);     //64 bit changes
    
    return [self.filteredListContent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *  cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];

    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];

    if ([self.placeType isEqualToString:@"City"])
    {
        NSMutableString *addressName= [self.filteredListContent objectAtIndex:indexPath.row];
        
        [addressName replaceOccurrencesOfString:@"-" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [addressName length])];
        
        cell.textLabel.text=[NSString stringWithFormat:@"%@",addressName];
        
        if (self.selectedIndexPath == indexPath) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = [self.filteredListContent objectAtIndex:indexPath.row];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15.0];
    CGSize constraintSize = CGSizeMake(300.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    _placeDict=[[NSMutableDictionary alloc] init];
    if ([self.placeType isEqualToString:@"City"])
    {
        NSMutableString *addressName= [[self.filteredListContent objectAtIndex:indexPath.row]mutableCopy];
        NSLog(@"selected address--- %@",addressName);
        
        [addressName replaceOccurrencesOfString:@"-" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [addressName length])];
        [addressName replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [addressName length])];
        
        NSArray *splitArray = [addressName componentsSeparatedByString:@","];
        NSString *placeName=@"";
        for (int i=1; i<= [splitArray count]-1; i++) {
            
            placeName=[NSString stringWithFormat:@"%@,%@",placeName,[splitArray objectAtIndex:i]];
            NSLog(@"placeName address--- %@",placeName);
        }
        placeName = [placeName substringFromIndex:2];
        
        NSString *postCode=[splitArray objectAtIndex:0];
        
        [self.placeDict setObject:@"0" forKey:@"placeId"];
        [self.placeDict setObject:placeName forKey:@"placeName"];
        [self.placeDict setObject:postCode forKey:@"postCode"];
        [self.placeDict setObject: @"city" forKey:@"placeType"];
        [self.placeDict setObject:placeName forKey:@"truncatedPlaceName"];
        
        if ([self.myParentIS isEqualToString:@"From Address"]){
            [Common setFromAddress:self.placeDict];
        }
        else{
            [Common setToAddress:self.placeDict];
        }
        
    }

    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        self.selectedIndexPath = indexPath;
        [self.addressTableView reloadData];
        [self.searchDisplayController setActive:NO];
    }
    else{
        
    }
    

            
            //        UINavigationController *citySearchNavController=[[[UINavigationController alloc] initWithRootViewController:searchViewController] autorelease];
            //        float rd = 4.00/255.00;
            //        float gr = 152.00/255.00;
            //        float bl = 229.00/255.00;
            //        citySearchNavController.navigationBar.barTintColor =[UIColor colorWithRed:rd green:gr blue:bl alpha:1.0];
            //        [citySearchNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
            //        citySearchNavController.navigationBar.tintColor = [UIColor whiteColor];
            //
            //        citySearchNavController.tabBarItem.image = [UIImage imageNamed:@"city.png"];
            //
            //        WiseCabsAppDelegate* myDelegate = (((WiseCabsAppDelegate*) [UIApplication sharedApplication].delegate));
            //        NSArray *viewControllers = [myDelegate.maintabBarController viewControllers];
            //        NSMutableArray *updatedArray = [NSMutableArray arrayWithArray:viewControllers];
            //
            //        [updatedArray removeObjectAtIndex:0];
            //        [updatedArray insertObject:citySearchNavController atIndex:0];
            //        
            //        [myDelegate.maintabBarController setViewControllers:(NSArray *)updatedArray];
    
        //    if ([self.delegate respondsToSelector:@selector(dismissSearchBarController)]) {
        //        [self.delegate dismissSearchBarController];
        //    }

//    }
    
    
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"self.myParentIS --- %@",self.placeType );
    if ([self.placeType isEqualToString:@"City"]) {
        if ([searchString length]> 1)
        {
            self.searchedCityString=[NSString stringWithFormat:@"%@",searchString];
            NSLog(@"self.searchedCityString--  %@",self.searchedCityString);
            [NSThread detachNewThreadSelector:@selector(getCityAddresses) toTarget:self withObject:nil];
            
        }
    }

    // Return YES to cause the search result table view to be reloaded.
    return YES;

}


-(void)getCityAddresses{
    if(![UIApplication sharedApplication].networkActivityIndicatorVisible)
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
    NSObject *obj=[[NSObject alloc]init];
    servicehelper.objEntity=obj;
    [obj release];
    NSString *supplierID;
    if ([[Common loggedInUser] suppID]==nil) {
        supplierID=@"228";
    }
    else{
        supplierID=[[Common loggedInUser] suppID];
    }
    
    NSArray *sdkeys = [NSArray arrayWithObjects:@"postcde", @"sup_id",nil];
    NSLog(@"self.searchedCityString--  %@",self.searchedCityString);
    NSArray *sdobjects = [NSArray arrayWithObjects:self.searchedCityString,supplierID, nil];
    NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
    
    NSString *URL=[NSString stringWithFormat:@"%@search/autopostcode",[Common webserviceURL]];
    NSLog(@"service method get called");
    NSArray *resultArray=[servicehelper callWebService:URL pms:sdparams];
    
    NSMutableDictionary *userDict=[resultArray objectAtIndex:0];
    [self.filteredListContent removeAllObjects];
    
    if ([userDict objectForKey:@"success"]) {
        self.filteredListContent=[userDict objectForKey:@"city"];
    }
    
    NSLog(@"filteredListContent count is %lu",(unsigned long)[self.filteredListContent count]);

    [self.searchDisplayController.searchResultsTableView reloadData];
    [self.addressTableView reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//    NSLog(@"cancel button tapped");
//    [self.addressTableView reloadData];
//}

- (void)dealloc {
    [_addressSearchBar release];
    [_doneButton release];
    [_addressTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setAddressSearchBar:nil];
    [self setDoneButton:nil];
    [self setAddressTableView:nil];
    [super viewDidUnload];
}
- (IBAction)clickDone:(id)sender {
    if ([self.myParentIS isEqualToString:@"From Address"]){
        WCSearchBarTableViewController *wcSearchBarTableViewController = [[WCSearchBarTableViewController alloc]initWithNibName:@"WCSearchBarTableViewController" bundle:nil];
        wcSearchBarTableViewController.myParentIS = @"To Address";
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
        [self.navigationController pushViewController:wcSearchBarTableViewController animated:YES];
    }
    else{
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
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
        [self.navigationController pushViewController:searchViewController animated:YES];
    }
}

@end
